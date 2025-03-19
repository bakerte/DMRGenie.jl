![DMRGenieLogo](https://github.com/user-attachments/assets/3ad966d4-f302-4ab1-a49f-a1ae1593d050)


# DMRGenie.jl

This project is a graphical user interface (GUI) for the [DMRjulia](https://github.com/bakerte/DMRJtensor.jl) library for entanglement renormalization.

A live implementation is available on [this website](https://dmrgenie.rs.uvic.ca/) with resources hosted by the the Research Computing Services at the University of Victoria.

This guide gives a general overview of the app, and covers how to set up and run DMRGenie.

To deploy this software on our web-based implementation, we ask anyone to follow the instructions in `/guides/DeveloperGuide`

Please note that **Julia version 1.9.x** is required for local use.

Questions? Email [bakerte@uvic.ca](bakerte@uvic.ca)


## Running the App locally

In order to run the app locally, Julia 1.9.x is required.

### The simple way

Go to the `DMRGenie` directory (**Not** `DMRGenie.jl`) and execute the command `./run.sh`.

The app should start and open your browser to the website automatically. If your browser is not opened, then simply go to the URL http://127.0.0.1:8000 

### The in depth way (under the hood)

The app must be activated by running the following from the `DMRGenie` directory

```
] activate .
```

which should give output like:

```
(@v1.8) pkg> activate .
  Activating project at `C:\Users\aaron\repos\DMRGenie.jl\DMRGenie`
```

Make sure that the path ends with `DMRGenie.jl/DMRGenie`, if not then run `cd("<path_to_repo>/DMRGenie.jl/DMRGenie")` from the Julia CLI.

Then exit the Pkg prompt with *backspace*.

Run the following commands

```
using Genie
Genie.loadapp()
```

The output should match the following:

```

 ██████╗ ███████╗███╗   ██╗██╗███████╗    ███████╗
██╔════╝ ██╔════╝████╗  ██║██║██╔════╝    ██╔════╝
██║  ███╗█████╗  ██╔██╗ ██║██║█████╗      ███████╗
██║   ██║██╔══╝  ██║╚██╗██║██║██╔══╝      ╚════██║
╚██████╔╝███████╗██║ ╚████║██║███████╗    ███████║
 ╚═════╝ ╚══════╝╚═╝  ╚═══╝╚═╝╚══════╝    ╚══════╝

| Website  https://genieframework.com
| GitHub   https://github.com/genieframework
| Docs     https://genieframework.com/docs
| Discord  https://discord.com/invite/9zyZbD6J7H
| Twitter  https://twitter.com/essenciary

Active env: DEV

Loading routes┌ Info: 2023-08-10 12:15:08 
└ Web Server starting at http://127.0.0.1:8000 
[ Info: 2023-08-10 12:15:08 Listening on: 127.0.0.1:8000, thread id: 1

Ready! 
```


Then in a browser go to http://127.0.0.1:8000 or whatever the specified port is.

## Exiting the App

To exit the app run

```
Genie.down!()
```

If you want to run the app again you must first exit Julia and start a new session then repeat the **Running the app** section instructions.



## Design notes

There are four main sections of the application as of Aug 10, 2023: the Model input, the Method input, the Measurement output, and the reactive display which shows your current tensor network.

### Model

The *Model* section first takes information about whether or not a default model is to be used, if no default model is used then the user is required to create a custom Hamiltonian.
It then takes information about whether or not correlations should be output, and if true, it asks what the desired operators for the correlation matrices and functions are.
Then it takes symmetry information. If symmetry is checked, then DMRG and the desired correlations will be computed for the symmetry data specified.
The symmetry data taken includes the name of the symmetry, which can be any string; the symmetry operators to be applied, which there can be multiple of; whether or not the symmetries are uniform, and the physical indices.

If the symmetries are specified to be non-uniform, then multiple physical indices can be specified with the range of which dimensions they will be applied over.
**NOTE:** Currently there are only 2 physical dimensions allowed, so the range can only act over 1-2. **Control over the number of physical dimensions is to be allowed in a future update.**

### Method

In the *Method* section the graph type can be specified (currently this is always assumed to be an MPO on the back-end, regardless of the input, **functionality must be added**). Then the number of tensors in the network is specified, increasing this greatly increases the time to run calculations, especially if large correlation functions are to be calculated. The system can be generated randomly, or input by the user in .txt or .csv format, **functionality must be added for systems input by the user**. Then the tensor network method to be run on the system is specified, currently this is not used and is subject to change depending on the requirements of the application.

### Measurements

In the *Measurements* section no input is taken, but after the form is submitted and results are calculated, those results are output to the user. Currently, DMRG with and without symmetries can be output, as well as correlation matrices and correlation functions with and without symmetries. All DMRG calculations are given as a number, and all correlation calculations are given as downloadable text files. So there are currently 6 outputs which can appear to the user.

### Tensor Network Display

The *Display* shows the user what the tensor network to be used in calculations looks like.

## Genie and Model-View-Controller Frameworks

This application uses a Julia package called Genie which allows Julia code to be put on a web server simply.
Genie is a Model-View-Controller (MVC) framework.

A Model in an MVC framework is basically the application's structure. For this application, the main model is the `TensorNetwork` model, which can be seen in `DMRGenie/app/resources/tensornetworks/TensorNetworks.jl`. There may be more models added later depending on what is required.

A View in an MVC framework is what is displayed to the user: the front-end. An application can have many views, one for each page.
The main view of DMRGenie is `DMRGenie/app/resources/tensornetworks/views/DMRGenie.jl.html`, a `.jl.html file`. A `.jl.html` file acts as a normal HTML file with the added benefit of being able to run Julia code and have Julia variables passed in.
This allows data calculated on the back-end to be passed to the front-end and be presented to the user.
Views are linked to through `routes.jl -> specified controller -> specified view`.

Controllers in an MVC framework are the meat and potatoes of the application, the back-end.
In DMRGenie, the controllers calculate all the scientific results given to the user such as DMRG and the correlation matrices for a tensor network.
Julia code is run to obtain data, which is then passed to the view with the `html` function of Genie.

All of this is mediated by `routes.jl`, which directs the traffic of the app and gives any data submitted to the front-end by the user to the back-end.

### Why Genie?

Genie was chosen as the framework for the application because it allows seamless connection between Julia, HTML, and JavaScript without the need for the creation of an application specific API. There is satisfactory documentation on Genie as well, a trait not shared by many other Julia web-app packages at the time of creation. Additionally, on initial application generation much of the necessary components are automatically generated, reducing development time.

Other packages considered were: electron for Julia, which would allow a downloadable GUI to be created, but had bare-bones initial content and little documentation; and many Python GUI packages which would require Julia DMRJtensor functions to be called from Python and the potential for an API to be required.

## Setup

Navigate to the `DMRGenie.jl` directory once the repository has been cloned and then into the `DMRGenie` folder within it.

Install the necessary packages with instantiate.

```
cd("DMRGenie.jl/DMRGenie")
] instantiate
```

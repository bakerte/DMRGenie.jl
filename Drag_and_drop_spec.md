# Drag and Drop Project

The objective of this project is to build an interactive drag and drop tensor network builder for DMRGenie. This specification will include the loose list of goals to be completed, which is subject to change.

## Setup

The project should be stared on a separate branch from the main repository such that it can be merged in once complete to allow for parallel workflows.

To simplify the project at the start, it should be initialized in a separate page of the same format as the main page (i.e. a canvas where the tensor networks can be built). We can decide later how we want to merge the two pages, this gives us options as they will start as distinct components and can be integrated accordingly.

## Front end

The front end will be written in HTML and JavaScript. It will interact with the backend using the Julia Genie package.

The front end components of this project include:

- [ ] Tensor network display
- [ ] User interaction with components (drag and drop)
- [ ] Network building (Build networks using tokens that may be parsed on the backend to form the actual networks with DMRJtensor/TensorPACK)
- [ ] Saving tensor networks as new components which only show the tensor rank.
- [ ] Component validation (Can something be placed?)

Each of these tasks can be further subdivided. For example, to complete the tensor network display component a grid placement system should be made, then each tensor should be designed to fit on it such that any valid combination of tensors fits correctly.

We can probably build the network as a graph structure with some conditions on connectivity. This graph structure can be passed to the back end.

*Avoid using fixed sizes in the code (such as pixel width).* Instead, create an attribute for that component in a new CSS styling file with the desired size and use flexible sizes where possible. This is important for making the application accesible to other devices. How the application will look on another device can be seen in your browser by inspecting the HTML, clicking the device symbol in the top left of the inspector, then selecting the "dimensions" above the webpage. Use Chrome for this. **We should not implement variable sizing for other devices yet, but we create the application such that it is easy to do so later.**

[Here](https://www.w3schools.com/html/html5_draganddrop.asp) is some example code for a drag and drop component. It was the first result when searching "javascript make drag and drop" so there should be plenty of resources online. The main challenge will be to integrate it with the back end in order to create a valid tensor network.

## Back end

The back end of this project will be written in Julia using Genie.

The back end components of this project include:

- [ ] Token parsing (Interpret what is passed in from the front end)
- [ ] Network validation (Will this build a valid tensor network?)
- [ ] Network building as a tensor network struct
- [ ] Network running

More specification from Dr. Baker is needed for this section as to how the networks will be run.

Redefinitions of the current structs in the code will likely be needed.

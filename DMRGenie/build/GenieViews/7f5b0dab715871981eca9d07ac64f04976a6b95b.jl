# app/resources/pages/views/tutorial.jl.html 

function func_7f5b0dab715871981eca9d07ac64f04976a6b95b(;
    context = Genie.Renderer.vars(:context),
)

    [
        Genie.Renderer.Html.meta(charset = "utf-8", htmlsourceindent = "2")
        Genie.Renderer.Html.title(htmlsourceindent = "2") do
            [
                """Home""";
            ]
        end
        Genie.Renderer.Html.div(class = "mainpage", htmlsourceindent = "2") do
            [
                Genie.Renderer.Html.h1(class = "title-text", htmlsourceindent = "3") do
                    [
                        """
                                        Tutorial
                                    """
                    ]
                end
                Genie.Renderer.Html.div(class = "mainpage", htmlsourceindent = "3") do
                    [
                        Genie.Renderer.Html.div(htmlsourceindent = "4") do
                            [
                                """
                                                    The field of theoretical quantum physics is notoriously difficult to grasp, and information about it is often obfuscated in complex rhetoric. Leave that behind with """
                                Genie.Renderer.Html.b(htmlsourceindent = "5") do
                                    [
                                        """DMRGenie""";
                                    ]
                                end
                                """!
                                                """
                            ]
                        end
                        Genie.Renderer.Html.br(htmlsourceindent = "4")
                        Genie.Renderer.Html.div(htmlsourceindent = "4") do
                            [
                                """DMRGenie is intended to be a tool for research and education.""";
                            ]
                        end
                        Genie.Renderer.Html.div(htmlsourceindent = "4") do
                            [
                                """Learn how to use its cutting edge features with this guide.""";
                            ]
                        end
                        Genie.Renderer.Html.img(
                            alt = "Density Matrix Renormalization Group (DMRG)",
                            htmlsourceindent = "4",
                            style = "width:650px; height:auto;",
                            src = "/img/tutorial/DMRG_example.png",
                        )
                        Genie.Renderer.Html.br(htmlsourceindent = "4")
                        Genie.Renderer.Html.div(htmlsourceindent = "4") do
                            [
                                """
                                                    To get up to speed on """
                                Genie.Renderer.Html.b(htmlsourceindent = "5") do
                                    [
                                        """Tensor Networks""";
                                    ]
                                end
                                """ check out these papers:
                                                    """
                                Genie.Renderer.Html.div(
                                    htmlsourceindent = "5",
                                    style = "text-align: left; max-width: 65%; margin-left: auto; margin-right: auto;",
                                ) do
                                    [
                                        Genie.Renderer.Html.ul(htmlsourceindent = "6") do
                                            [
                                                Genie.Renderer.Html.li(
                                                    htmlsourceindent = "7",
                                                ) do
                                                    [
                                                        Genie.Renderer.Html.a(
                                                            htmlsourceindent = "8",
                                                            href = "https://arxiv.org/abs/1911.11566",
                                                            rel = "noopener noreferrer",
                                                            target = "blank",
                                                        ) do
                                                            [
                                                                """
                                                                                                    "Méthodes de calcul avec réseaux de tenseurs (Basic tensor network computations in physics)"
                                                                                                """
                                                            ]
                                                        end
                                                        """
                                                                                        by T.E. Baker, S. Desrosiers, M. Tremblay, and M.P. Thompson, which includes both a """
                                                        Genie.Renderer.Html.em(
                                                            htmlsourceindent = "8",
                                                        ) do
                                                            [
                                                                """French and English""";
                                                            ]
                                                        end
                                                        """ version.
                                                                                    """
                                                    ]
                                                end
                                                Genie.Renderer.Html.li(
                                                    htmlsourceindent = "7",
                                                ) do
                                                    [
                                                        Genie.Renderer.Html.a(
                                                            htmlsourceindent = "8",
                                                            href = "https://www.usherbrooke.ca/physique/fileadmin/sites/physique/documents/Vulgarisation/20182/e2018_Samuel_Desrosiers.pdf",
                                                            rel = "noopener noreferrer",
                                                            target = "blank",
                                                        ) do
                                                            [
                                                                """
                                                                                                    "The basics of tensor networks: An overview of tensors and renormalization"
                                                                                                """
                                                            ]
                                                        end
                                                        """
                                                                                        by S. Desrosiers, G.B. Evenbly, and T.E. Baker, a short paper on the fundamentals of tensor network algorithms.
                                                                                    """
                                                    ]
                                                end
                                            ]
                                        end;
                                    ]
                                end
                            ]
                        end
                        Genie.Renderer.Html.img(
                            alt = "Density Matrix Renormalization Group (DMRG) environment",
                            htmlsourceindent = "4",
                            style = "width:150px; height:auto;",
                            src = "/img/tutorial/DMRG_env.png",
                        )
                    ]
                end
                Genie.Renderer.Html.div(class = "subpage", htmlsourceindent = "3") do
                    [
                        Genie.Renderer.Html.h2(
                            class = "title-text",
                            style = "text-align: center",
                            htmlsourceindent = "4",
                        ) do
                            [
                                """
                                                    Algorithm Runner
                                                """
                            ]
                        end
                        Genie.Renderer.Html.div(htmlsourceindent = "4") do
                            [
                                """
                                                    The """
                                Genie.Renderer.Html.a(
                                    htmlsourceindent = "5",
                                    href = "/runalgs",
                                ) do
                                    [
                                        """Algorithm Runner""";
                                    ]
                                end
                                """ allows you to run known tensor network algorithms without coding knowledge. Currently, the density matrix renormalization group (DMRG) algorithm is the only one available, but more are coming soon.
                                                    """
                                Genie.Renderer.Html.br(htmlsourceindent = "5")
                                Genie.Renderer.Html.br(htmlsourceindent = "5")
                                Genie.Renderer.Html.h3(
                                    class = "title-text",
                                    htmlsourceindent = "5",
                                ) do
                                    [
                                        """
                                                                DMRG
                                                            """
                                    ]
                                end
                                Genie.Renderer.Html.div(
                                    htmlsourceindent = "5",
                                    style = "max-width: 90%; margin-left: auto; margin-right: auto;",
                                ) do
                                    [
                                        Genie.Renderer.Html.div(htmlsourceindent = "6") do
                                            [
                                                """
                                                                            This tutorial will guide you through running DMRG on known and custom models. Let's start by going over the basics of what everything means.
                                                                        """
                                            ]
                                        end
                                        Genie.Renderer.Html.br(htmlsourceindent = "6")
                                        Genie.Renderer.Html.br(htmlsourceindent = "6")
                                        Genie.Renderer.Html.div(htmlsourceindent = "6") do
                                            [
                                                """
                                                                            On the """
                                                Genie.Renderer.Html.a(
                                                    htmlsourceindent = "7",
                                                    href = "/runalgs",
                                                ) do
                                                    [
                                                        """Algorithm Runner""";
                                                    ]
                                                end
                                                """ page you will be met with the following option menu. Each option is as follows:
                                                                        """
                                            ]
                                        end
                                        Genie.Renderer.Html.section(
                                            class = "side_by_side",
                                            htmlsourceindent = "6",
                                        ) do
                                            [
                                                Genie.Renderer.Html.div(
                                                    class = "left_side",
                                                    htmlsourceindent = "7",
                                                ) do
                                                    [
                                                        Genie.Renderer.Html.img(
                                                            alt = "Main menu components",
                                                            class = "side_image",
                                                            style = "width:100%; height:auto; padding-top:3%;",
                                                            src = "/img/tutorial/RunnerMenu.png",
                                                            htmlsourceindent = "8",
                                                        )
                                                    ]
                                                end
                                                Genie.Renderer.Html.div(
                                                    class = "right_side",
                                                    htmlsourceindent = "7",
                                                ) do
                                                    [
                                                        Genie.Renderer.Html.ul(
                                                            htmlsourceindent = "8",
                                                        ) do
                                                            [
                                                                Genie.Renderer.Html.li(
                                                                    htmlsourceindent = "9",
                                                                ) do
                                                                    [
                                                                        Genie.Renderer.Html.b(
                                                                            htmlsourceindent = "10",
                                                                        ) do
                                                                            [
                                                                                """Hamiltonian:""";
                                                                            ]
                                                                        end
                                                                        """ The model which DMRG will be run on in Matrix Product Operator (MPO) form.
                                                                                                            """
                                                                    ]
                                                                end
                                                                Genie.Renderer.Html.li(
                                                                    htmlsourceindent = "9",
                                                                ) do
                                                                    [
                                                                        Genie.Renderer.Html.b(
                                                                            htmlsourceindent = "10",
                                                                        ) do
                                                                            [
                                                                                """Compute Correlations:""";
                                                                            ]
                                                                        end
                                                                        """ Specify operators to be evaluated at each lattice site to receive tensors populated with correlation functions upon computation.
                                                                                                            """
                                                                    ]
                                                                end
                                                                Genie.Renderer.Html.li(
                                                                    htmlsourceindent = "9",
                                                                ) do
                                                                    [
                                                                        Genie.Renderer.Html.b(
                                                                            htmlsourceindent = "10",
                                                                        ) do
                                                                            [
                                                                                """Symmetry:""";
                                                                            ]
                                                                        end
                                                                        """ Enforce quantum symmetries. Selecting this will run DMRG on a separate quantum model as well.
                                                                                                            """
                                                                    ]
                                                                end
                                                                Genie.Renderer.Html.li(
                                                                    htmlsourceindent = "9",
                                                                ) do
                                                                    [
                                                                        Genie.Renderer.Html.b(
                                                                            htmlsourceindent = "10",
                                                                        ) do
                                                                            [
                                                                                """Number of Sites:""";
                                                                            ]
                                                                        end
                                                                        """ MPO terms, with a maximum of 15 allowed.
                                                                                                            """
                                                                    ]
                                                                end
                                                            ]
                                                        end;
                                                    ]
                                                end
                                            ]
                                        end
                                        Genie.Renderer.Html.br(htmlsourceindent = "6")
                                        Genie.Renderer.Html.br(htmlsourceindent = "6")
                                        Genie.Renderer.Html.div(htmlsourceindent = "6") do
                                            [
                                                """
                                                                            With the default options set, clicking """
                                                Genie.Renderer.Html.em(
                                                    htmlsourceindent = "7",
                                                ) do
                                                    [
                                                        """Run Algorithm""";
                                                    ]
                                                end
                                                """ will run DMRG on the given model and the ground state energy will be given, as well as any other specified outputs.
                                                                        """
                                            ]
                                        end
                                        Genie.Renderer.Html.br(htmlsourceindent = "6")
                                        Genie.Renderer.Html.h4(
                                            class = "title-text",
                                            htmlsourceindent = "6",
                                        ) do
                                            [
                                                Genie.Renderer.Html.em(
                                                    htmlsourceindent = "7",
                                                ) do
                                                    [
                                                        """Hamiltonians""";
                                                    ]
                                                end;
                                            ]
                                        end
                                        Genie.Renderer.Html.div(htmlsourceindent = "6") do
                                            [
                                                """
                                                                            The 1-dimensional Ising spin model represents a system of particles with nearest-neighbour interactions along a line. A simple version of it can be expressed
                                                                            """
                                                Genie.Renderer.Html.img(
                                                    alt = "1-dimensional Ising model",
                                                    class = "center_img",
                                                    style = "width:35%; height:auto; padding-top:3%;",
                                                    src = "/img/tutorial/Ising.png",
                                                    htmlsourceindent = "7",
                                                )
                                                """
                                                                            where J is the coupling constant. A magnetic field can be imposed by adding the term with constant h, representing magnetic field strength,
                                                                            """
                                                Genie.Renderer.Html.img(
                                                    alt = "1-dimensional Ising model with magnetic interactions",
                                                    class = "center_img",
                                                    style = "width:40%; height:auto; padding-top:3%;",
                                                    src = "/img/tutorial/IsingMag.png",
                                                    htmlsourceindent = "7",
                                                )
                                                """
                                                                            The 1-dimensional Ising model shares some resemblance to the Heisenberg model, which can be expressed
                                                                            """
                                                Genie.Renderer.Html.img(
                                                    alt = "The Heisenberg model",
                                                    class = "center_img",
                                                    style = "width:75%; height:auto; padding-top:3%;",
                                                    src = "/img/tutorial/Heisenberg.png",
                                                    htmlsourceindent = "7",
                                                )
                                                """
                                                                            A magnetic field term can similarly be added on
                                                                            """
                                                Genie.Renderer.Html.img(
                                                    alt = "The Heisenberg model with magnetic interactions",
                                                    class = "center_img",
                                                    style = "width:75%; height:auto; padding-top:3%;",
                                                    src = "/img/tutorial/HeisenbergMag.png",
                                                    htmlsourceindent = "7",
                                                )
                                                Genie.Renderer.Html.br(
                                                    htmlsourceindent = "7",
                                                )
                                                Genie.Renderer.Html.br(
                                                    htmlsourceindent = "7",
                                                )
                                                """
                                                                            There are three built in models one can select from:
                                                                            """
                                                Genie.Renderer.Html.ul(
                                                    htmlsourceindent = "7",
                                                ) do
                                                    [
                                                        Genie.Renderer.Html.li(
                                                            htmlsourceindent = "8",
                                                        ) do
                                                            [
                                                                """Heisenberg model""";
                                                            ]
                                                        end
                                                        Genie.Renderer.Html.li(
                                                            htmlsourceindent = "8",
                                                        ) do
                                                            [
                                                                """Hubbard model""";
                                                            ]
                                                        end
                                                        Genie.Renderer.Html.li(
                                                            htmlsourceindent = "8",
                                                        ) do
                                                            [
                                                                """t-J model""";
                                                            ]
                                                        end
                                                    ]
                                                end
                                                """
                                                                            Selecting and running one of these will construct them in MPO form then apply DMRG, giving the ground state energy of the system and any other specified information.
                                                                            """
                                                Genie.Renderer.Html.h4(
                                                    class = "title-text",
                                                    htmlsourceindent = "7",
                                                ) do
                                                    [
                                                        Genie.Renderer.Html.em(
                                                            htmlsourceindent = "8",
                                                        ) do
                                                            [
                                                                """Constructing Custom Hamiltonians""";
                                                            ]
                                                        end;
                                                    ]
                                                end
                                                """
                                                                            Custom Hamiltonians can be specified and constructed as well. Let's consider the Hamiltonian of the 1-dimensional Ising model. Begin construction by selecting """
                                                Genie.Renderer.Html.em(
                                                    htmlsourceindent = "7",
                                                ) do
                                                    [
                                                        """Hamiltonian""";
                                                    ]
                                                end
                                                """ -> """
                                                Genie.Renderer.Html.em(
                                                    htmlsourceindent = "7",
                                                ) do
                                                    [
                                                        """Custom""";
                                                    ]
                                                end
                                                Genie.Renderer.Html.section(
                                                    class = "side_by_side",
                                                    htmlsourceindent = "7",
                                                ) do
                                                    [
                                                        Genie.Renderer.Html.div(
                                                            class = "left_side",
                                                            htmlsourceindent = "8",
                                                        ) do
                                                            [
                                                                Genie.Renderer.Html.img(
                                                                    alt = "Model input section",
                                                                    class = "side_image",
                                                                    style = "width:100%; height:auto; padding-top:3%;",
                                                                    src = "/img/tutorial/ModelMenu.png",
                                                                    htmlsourceindent = "9",
                                                                )
                                                            ]
                                                        end
                                                        Genie.Renderer.Html.div(
                                                            class = "right_side",
                                                            htmlsourceindent = "8",
                                                        ) do
                                                            [
                                                                Genie.Renderer.Html.ul(
                                                                    htmlsourceindent = "9",
                                                                ) do
                                                                    [
                                                                        Genie.Renderer.Html.li(
                                                                            htmlsourceindent = "10",
                                                                        ) do
                                                                            [
                                                                                Genie.Renderer.Html.b(
                                                                                    htmlsourceindent = "11",
                                                                                ) do
                                                                                    [
                                                                                        """Physical dimension:""";
                                                                                    ]
                                                                                end
                                                                                """ The dimension of the outward facing indices of MPO terms.
                                                                                                                        """
                                                                            ]
                                                                        end
                                                                        Genie.Renderer.Html.li(
                                                                            htmlsourceindent = "10",
                                                                        ) do
                                                                            [
                                                                                Genie.Renderer.Html.b(
                                                                                    htmlsourceindent = "11",
                                                                                ) do
                                                                                    [
                                                                                        """Hamiltonian constant:""";
                                                                                    ]
                                                                                end
                                                                                """ Multiplicative constant applied to Hamiltonian sum.
                                                                                                                        """
                                                                            ]
                                                                        end
                                                                        Genie.Renderer.Html.li(
                                                                            htmlsourceindent = "10",
                                                                        ) do
                                                                            [
                                                                                Genie.Renderer.Html.b(
                                                                                    htmlsourceindent = "11",
                                                                                ) do
                                                                                    [
                                                                                        """Components:""";
                                                                                    ]
                                                                                end
                                                                                """ Operators specified in Hamiltonian.
                                                                                                                        """
                                                                            ]
                                                                        end
                                                                    ]
                                                                end;
                                                            ]
                                                        end
                                                    ]
                                                end
                                                """
                                                                            The 1-dimensional Ising model with a coupling constant of J=0.5 can be input as
                                                                            """
                                                Genie.Renderer.Html.img(
                                                    alt = "1-dimensional Ising model setup",
                                                    class = "center_img",
                                                    style = "width:50%; height:auto; padding-top:3%;",
                                                    src = "/img/tutorial/IsingModel.png",
                                                    htmlsourceindent = "7",
                                                )
                                                Genie.Renderer.Html.br(
                                                    htmlsourceindent = "7",
                                                )
                                                Genie.Renderer.Html.br(
                                                    htmlsourceindent = "7",
                                                )
                                                """
                                                                            Then an external magnetic field with constants J=0.5 and h=0.05 can be imposed as
                                                                            """
                                                Genie.Renderer.Html.img(
                                                    alt = "1-dimensional Ising model setup with an external magnetic",
                                                    class = "center_img",
                                                    style = "width:50%; height:auto; padding-top:3%;",
                                                    src = "/img/tutorial/IsingMagModel.png",
                                                    htmlsourceindent = "7",
                                                )
                                                Genie.Renderer.Html.br(
                                                    htmlsourceindent = "7",
                                                )
                                                Genie.Renderer.Html.br(
                                                    htmlsourceindent = "7",
                                                )
                                                """
                                                                            Then for the Heisenberg model with J = 0.5 the input would be
                                                                            """
                                                Genie.Renderer.Html.img(
                                                    alt = "1-dimensional Ising model setup with an external magnetic",
                                                    class = "center_img",
                                                    style = "width:50%; height:auto; padding-top:3%;",
                                                    src = "/img/tutorial/HeisenbergModel.png",
                                                    htmlsourceindent = "7",
                                                )
                                            ]
                                        end
                                    ]
                                end
                            ]
                        end
                    ]
                end
                Genie.Renderer.Html.div(
                    class = "subpage",
                    style = "padding-bottom:250px",
                    htmlsourceindent = "3",
                ) do
                    [
                        Genie.Renderer.Html.h2(
                            class = "title-text",
                            style = "text-align: center",
                            htmlsourceindent = "4",
                        ) do
                            [
                                """
                                                    Tensor Network Builder
                                                """
                            ]
                        end
                        Genie.Renderer.Html.div(htmlsourceindent = "4") do
                            [
                                """
                                                    The """
                                Genie.Renderer.Html.a(
                                    htmlsourceindent = "5",
                                    href = "/build",
                                )
                                """Tensor Network Builder allows you to craft novel tensor network algorithms and test your ideas. Effortlessly connect, contract, and decompose tensors on the canvas in seconds!
                                                """
                            ]
                        end
                        Genie.Renderer.Html.br(htmlsourceindent = "4")
                        Genie.Renderer.Html.br(htmlsourceindent = "4")
                        Genie.Renderer.Html.img(
                            alt = "GIF of the tensor network builder",
                            class = "center_img",
                            style = "width: 90%; height: auto",
                            src = "/img/tutorial/builder.gif",
                            htmlsourceindent = "4",
                        )
                        Genie.Renderer.Html.br(htmlsourceindent = "4")
                        Genie.Renderer.Html.br(htmlsourceindent = "4")
                        """
                                        The process boils down into two parts:
                                        """
                        Genie.Renderer.Html.ol(htmlsourceindent = "4") do
                            [
                                Genie.Renderer.Html.li(htmlsourceindent = "5") do
                                    [
                                        """
                                                                Specify all the steps by placing, contracting, and decomposing tensors.
                                                            """
                                    ]
                                end
                                Genie.Renderer.Html.li(htmlsourceindent = "5") do
                                    [
                                        """
                                                                Submit the steps to be run with """
                                        Genie.Renderer.Html.a(
                                            htmlsourceindent = "6",
                                            href = "https://github.com/bakerte/TensorPACK.jl",
                                            rel = "noopener noreferrer",
                                            target = "blank",
                                        ) do
                                            [
                                                """TensorPACK""";
                                            ]
                                        end
                                        """ and receive the output.
                                                            """
                                    ]
                                end
                            ]
                        end
                        Genie.Renderer.Html.br(htmlsourceindent = "4")
                        Genie.Renderer.Html.br(htmlsourceindent = "4")
                        Genie.Renderer.Html.h3(
                            class = "title-text",
                            htmlsourceindent = "4",
                        ) do
                            [
                                """
                                                    Operations
                                                """
                            ]
                        end
                        Genie.Renderer.Html.div(
                            htmlsourceindent = "4",
                            style = "max-width: 90%; margin-left: auto; margin-right: auto;",
                        ) do
                            [
                                """
                                                    Below outlines how to apply each operation and then run the set of steps to obtain an output. 
                                                    """
                                Genie.Renderer.Html.h4(
                                    class = "title-text",
                                    htmlsourceindent = "5",
                                ) do
                                    [
                                        Genie.Renderer.Html.em(htmlsourceindent = "6") do
                                            [
                                                """Creating a Tensor""";
                                            ]
                                        end;
                                    ]
                                end
                                Genie.Renderer.Html.div(htmlsourceindent = "5") do
                                    [
                                        """
                                                                Tensors are created under the Drag and Drop section of the options menu. The rank of the tensor can be specified before the tensor is created. The rank can be from 0 and 4. Tensors made this was are initialized as random unitaries.
                                                            """
                                    ]
                                end
                                Genie.Renderer.Html.br(htmlsourceindent = "5")
                                Genie.Renderer.Html.br(htmlsourceindent = "5")
                                Genie.Renderer.Html.h4(
                                    class = "title-text",
                                    htmlsourceindent = "5",
                                ) do
                                    [
                                        Genie.Renderer.Html.em(htmlsourceindent = "6") do
                                            [
                                                """Uploading a Tensor""";
                                            ]
                                        end;
                                    ]
                                end
                                Genie.Renderer.Html.div(htmlsourceindent = "5") do
                                    [
                                        """
                                                                Tensors can also be uploaded as well. To do this, index names and their corresponding dimensions must be provided. If the sizes are incorrect, then contraction will fail or give undesired results. Only text files are accepted, and their contents must be in Julia array syntax where one set of square braces encloses the tensor elements and semicolons are used to differentiate between indices (e.g. columns). This is the same syntax convention as output tensors are written in. 
                                                                """
                                        Genie.Renderer.Html.br(htmlsourceindent = "6")
                                        Genie.Renderer.Html.br(htmlsourceindent = "6")
                                        """
                                                                For example, a 2 by 3 tensor should be input as
                                                                """
                                        Genie.Renderer.Html.br(htmlsourceindent = "6")
                                        Genie.Renderer.Html.code(htmlsourceindent = "6") do
                                            [
                                                """[6 1 2; 6 4 7]""";
                                            ]
                                        end
                                        Genie.Renderer.Html.br(htmlsourceindent = "6")
                                        Genie.Renderer.Html.br(htmlsourceindent = "6")
                                        """
                                                                Or a 2 by 5 by 3 tensor should be input as
                                                                """
                                        Genie.Renderer.Html.br(htmlsourceindent = "6")
                                        Genie.Renderer.Html.code(htmlsourceindent = "6") do
                                            [
                                                """[9 7 1 9 8; 6 4 4 9 6;;;""";
                                            ]
                                        end
                                        Genie.Renderer.Html.br(htmlsourceindent = "6")
                                        """&nbsp;
                                                                """
                                        Genie.Renderer.Html.code(htmlsourceindent = "6") do
                                            [
                                                """3 5 6 9 8; 4 6 3 9 1;;;""";
                                            ]
                                        end
                                        Genie.Renderer.Html.br(htmlsourceindent = "6")
                                        """&nbsp;
                                                                """
                                        Genie.Renderer.Html.code(htmlsourceindent = "6") do
                                            [
                                                """7 3 3 5 9; 2 4 8 5 8]""";
                                            ]
                                        end
                                        Genie.Renderer.Html.br(htmlsourceindent = "6")
                                        Genie.Renderer.Html.br(htmlsourceindent = "6")
                                        """
                                                                Or a 2 by 3 by 4 by 5 tensor should be input as
                                                                """
                                        Genie.Renderer.Html.br(htmlsourceindent = "6")
                                        Genie.Renderer.Html.code(htmlsourceindent = "6") do
                                            [
                                                """[8 3 9; 5 3 2;;; 5 9 5; 9 8 4;;; 2 7 7; 6 4 3;;;;""";
                                            ]
                                        end
                                        Genie.Renderer.Html.br(htmlsourceindent = "6")
                                        """&nbsp;
                                                                """
                                        Genie.Renderer.Html.code(htmlsourceindent = "6") do
                                            [
                                                """7 1 1; 7 8 4;;; 2 2 3; 3 3 5;;; 6 1 1; 7 6 2;;;;""";
                                            ]
                                        end
                                        Genie.Renderer.Html.br(htmlsourceindent = "6")
                                        """&nbsp;
                                                                """
                                        Genie.Renderer.Html.code(htmlsourceindent = "6") do
                                            [
                                                """3 6 7; 8 6 6;;; 4 9 9; 1 9 7;;; 8 4 1; 3 7 2;;;;""";
                                            ]
                                        end
                                        Genie.Renderer.Html.br(htmlsourceindent = "6")
                                        """&nbsp;
                                                                """
                                        Genie.Renderer.Html.code(htmlsourceindent = "6") do
                                            [
                                                """5 9 9; 4 6 5;;; 2 7 7; 7 2 5;;; 9 2 3; 8 9 8]""";
                                            ]
                                        end
                                        Genie.Renderer.Html.br(htmlsourceindent = "6")
                                        Genie.Renderer.Html.br(htmlsourceindent = "6")
                                        """
                                                                Code such as """
                                        Genie.Renderer.Html.code(htmlsourceindent = "6") do
                                            [
                                                """println(rand(2, 3, 4))""";
                                            ]
                                        end
                                        """ should produce tensors of this format by default.
                                                            """
                                    ]
                                end
                                Genie.Renderer.Html.br(htmlsourceindent = "5")
                                Genie.Renderer.Html.br(htmlsourceindent = "5")
                                Genie.Renderer.Html.h4(
                                    class = "title-text",
                                    htmlsourceindent = "5",
                                ) do
                                    [
                                        Genie.Renderer.Html.em(htmlsourceindent = "6") do
                                            [
                                                """Connecting Tensors""";
                                            ]
                                        end;
                                    ]
                                end
                                Genie.Renderer.Html.div(htmlsourceindent = "5") do
                                    [
                                        """
                                                                Tensors can be connected by dragging between the points on any two tensors. However, there is a maximum of one connection per point. A free index can be created by dragging from a connection point to the network canvas.
                                                            """
                                    ]
                                end
                                Genie.Renderer.Html.br(htmlsourceindent = "5")
                                Genie.Renderer.Html.br(htmlsourceindent = "5")
                                Genie.Renderer.Html.h4(
                                    class = "title-text",
                                    htmlsourceindent = "5",
                                ) do
                                    [
                                        Genie.Renderer.Html.em(htmlsourceindent = "6") do
                                            [
                                                """Contract""";
                                            ]
                                        end;
                                    ]
                                end
                                Genie.Renderer.Html.div(htmlsourceindent = "5") do
                                    [
                                        """
                                                                The Contract option accepts two tensor IDs and contracts them into one. Tensors can be contracted if they are connected to each other by an edge, or if each has a free index with a common name and dimension. If there are no common indices between two tensors then they cannot be contracted.
                                                            """
                                    ]
                                end
                                Genie.Renderer.Html.br(htmlsourceindent = "5")
                                Genie.Renderer.Html.br(htmlsourceindent = "5")
                                Genie.Renderer.Html.h4(
                                    class = "title-text",
                                    htmlsourceindent = "5",
                                ) do
                                    [
                                        Genie.Renderer.Html.em(htmlsourceindent = "6") do
                                            [
                                                """Singular Value Decomposition (SVD)""";
                                            ]
                                        end;
                                    ]
                                end
                                Genie.Renderer.Html.div(htmlsourceindent = "5") do
                                    [
                                        """
                                                                The SVD option accepts the ID of a tensor and the desired grouping of indices. The operation will decompose tensor A as A = UDV, where D is a diagonal matrix and U and V are unitaries. The resulting tensors will be labelled accordingly.
                                                            """
                                    ]
                                end
                                Genie.Renderer.Html.br(htmlsourceindent = "5")
                                Genie.Renderer.Html.br(htmlsourceindent = "5")
                                Genie.Renderer.Html.h4(
                                    class = "title-text",
                                    htmlsourceindent = "5",
                                ) do
                                    [
                                        Genie.Renderer.Html.em(htmlsourceindent = "6") do
                                            [
                                                """QR and LQ Decompositions""";
                                            ]
                                        end;
                                    ]
                                end
                                Genie.Renderer.Html.div(htmlsourceindent = "5") do
                                    [
                                        """
                                                                The QR decomposition accepts the ID of a tensor and the desired grouping of indices. The operation will decompose A as A = QR, where Q is orthogonal and R is an upper triangular when reshaped into a matrix.
                                                                """
                                        Genie.Renderer.Html.br(htmlsourceindent = "6")
                                        Genie.Renderer.Html.br(htmlsourceindent = "6")
                                        """
                                                                The LQ decomposition is similar, except it decomposes as A = LQ where L is lower triangular when reshaped as a matrix.
                                                            """
                                    ]
                                end
                                Genie.Renderer.Html.br(htmlsourceindent = "5")
                                Genie.Renderer.Html.br(htmlsourceindent = "5")
                                Genie.Renderer.Html.h4(
                                    class = "title-text",
                                    htmlsourceindent = "5",
                                ) do
                                    [
                                        Genie.Renderer.Html.em(htmlsourceindent = "6") do
                                            [
                                                """Eigenvalue Decomposition""";
                                            ]
                                        end;
                                    ]
                                end
                                Genie.Renderer.Html.div(htmlsourceindent = "5") do
                                    [
                                        """
                                                                The Eigenvalue decomposition accepts just the ID of a tensor. The tensor must be able to be reshaped into a square matrix. The result of the operation will result in a tensor of eigenvectors, its dual, and a diagonal tensor of eigenvalues.
                                                            """
                                    ]
                                end
                                Genie.Renderer.Html.br(htmlsourceindent = "5")
                                Genie.Renderer.Html.br(htmlsourceindent = "5")
                                Genie.Renderer.Html.h4(
                                    class = "title-text",
                                    htmlsourceindent = "5",
                                ) do
                                    [
                                        Genie.Renderer.Html.em(htmlsourceindent = "6") do
                                            [
                                                """Split Index and Connect Index""";
                                            ]
                                        end;
                                    ]
                                end
                                Genie.Renderer.Html.div(htmlsourceindent = "5") do
                                    [
                                        """
                                                                Split Index accepts the name of an index. If two tensors are connected, then the connection will be turned into a free index for each tensor.
                                                                """
                                        Genie.Renderer.Html.br(htmlsourceindent = "6")
                                        Genie.Renderer.Html.br(htmlsourceindent = "6")
                                        """
                                                                Connect Index accepts the name of two indices and connects them directly. The dimensions of the indices must match.
                                                            """
                                    ]
                                end
                                Genie.Renderer.Html.br(htmlsourceindent = "5")
                                Genie.Renderer.Html.br(htmlsourceindent = "5")
                                Genie.Renderer.Html.h4(
                                    class = "title-text",
                                    htmlsourceindent = "5",
                                ) do
                                    [
                                        Genie.Renderer.Html.em(htmlsourceindent = "6") do
                                            [
                                                """Run Network Steps""";
                                            ]
                                        end;
                                    ]
                                end
                                Genie.Renderer.Html.div(htmlsourceindent = "5") do
                                    [
                                        """
                                                                All the steps for the network will be run and the tensors resulting from the final step will be given in Julia array syntax in a text downloadable file.
                                                            """
                                    ]
                                end
                            ]
                        end
                    ]
                end
            ]
        end
    ]
end

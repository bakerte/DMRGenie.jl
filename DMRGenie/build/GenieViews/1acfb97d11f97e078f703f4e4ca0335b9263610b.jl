# app/resources/pages/views/home.jl.html 

function func_1acfb97d11f97e078f703f4e4ca0335b9263610b(;
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
                                        Access and Create the most powerful tools in modern physics
                                    """
                    ]
                end
                Genie.Renderer.Html.div(class = "mainpage", htmlsourceindent = "3") do
                    [
                        """
                                        Tensor networks algorithms allow physicists to model and analyze complex systems of particles
                                        """
                        Genie.Renderer.Html.br(htmlsourceindent = "4")
                        Genie.Renderer.Html.br(htmlsourceindent = "4")
                        Genie.Renderer.Html.img(
                            alt = "Projected entangled pair states (PEPS)",
                            htmlsourceindent = "4",
                            style = "width:220px; height:auto;",
                            src = "/img/home/PEPS.png",
                        )
                        Genie.Renderer.Html.img(
                            alt = "Multiscale entanglement renormalization ansatz (MERA)",
                            htmlsourceindent = "4",
                            style = "width:180px; height:auto; padding-left:20px;",
                            src = "/img/home/MERA.png",
                        )
                        Genie.Renderer.Html.img(
                            alt = "Tensor renormalization group (TRG)",
                            htmlsourceindent = "4",
                            style = "width:150px; height:auto; padding-left:20px;",
                            src = "/img/home/TRG.png",
                        )
                        Genie.Renderer.Html.br(htmlsourceindent = "4")
                        Genie.Renderer.Html.br(htmlsourceindent = "4")
                        """
                                        All computations are performed with the """
                        Genie.Renderer.Html.a(
                            htmlsourceindent = "4",
                            href = "https://github.com/bakerte/DMRJtensor.jl",
                            rel = "noopener noreferrer",
                            target = "blank",
                        ) do
                            [
                                """DMRJtensor""";
                            ]
                        end
                        """ and """
                        Genie.Renderer.Html.a(
                            htmlsourceindent = "4",
                            href = "https://github.com/bakerte/TensorPACK.jl",
                            rel = "noopener noreferrer",
                            target = "blank",
                        ) do
                            [
                                """TensorPACK""";
                            ]
                        end
                        """ Julia libraries
                                        """
                        Genie.Renderer.Html.br(htmlsourceindent = "4")
                        Genie.Renderer.Html.br(htmlsourceindent = "4")
                        """
                                        With this website, you can run state-of-the-art tensor network algorithms and even create your own!
                                    """
                    ]
                end
                Genie.Renderer.Html.h1(
                    class = "title-text",
                    style = "padding-top:60px",
                    htmlsourceindent = "3",
                ) do
                    [
                        """
                                        What's included?
                                    """
                    ]
                end
                Genie.Renderer.Html.div(class = "mainpage", htmlsourceindent = "3") do
                    [
                        """
                                        Go to the """
                        Genie.Renderer.Html.a(htmlsourceindent = "4", href = "runalgs") do
                            [
                                """Run Algorithms""";
                            ]
                        end
                        """ page to do just that! Currently, DMRG can be run to find the ground state energy and correlations of a given system. A default Hamiltonain, such as the Heisenberg model, or a custom Hamiltonian can be supplied as the system. 
                                        """
                        Genie.Renderer.Html.br(htmlsourceindent = "4")
                        """
                                        ( """
                        Genie.Renderer.Html.em(htmlsourceindent = "4") do
                            [
                                """TRG, PEPS, and MERA coming soon""";
                            ]
                        end
                        """ )
                                        """
                        Genie.Renderer.Html.br(htmlsourceindent = "4")
                        Genie.Renderer.Html.br(htmlsourceindent = "4")
                        Genie.Renderer.Html.img(
                            alt = "Density matrix renormalization group (DMRG)",
                            htmlsourceindent = "4",
                            style = "width:300px; height:auto;",
                            src = "/img/home/DMRG_frame.jpg",
                        )
                        Genie.Renderer.Html.br(htmlsourceindent = "4")
                        Genie.Renderer.Html.br(htmlsourceindent = "4")
                        Genie.Renderer.Html.br(htmlsourceindent = "4")
                        """
                                        Contract and decompose tensors effortlessly with the """
                        Genie.Renderer.Html.a(htmlsourceindent = "4", href = "build") do
                            [
                                """Build a Tensor Network""";
                            ]
                        end
                        """ page to design your own custom tensor network algorithms. Educate yourself on tensor network operations or test out new ideas for algorithms without the hassle of coding.
                                        """
                        Genie.Renderer.Html.br(htmlsourceindent = "4")
                        Genie.Renderer.Html.br(htmlsourceindent = "4")
                        Genie.Renderer.Html.img(
                            alt = "Example photo for the 'Build a Tensor Network' feature",
                            htmlsourceindent = "4",
                            style = "width:500px; height:auto;",
                            src = "/img/home/Build_frame.png",
                        )
                    ]
                end
                Genie.Renderer.Html.h1(
                    class = "title-text",
                    style = "padding-top:60px",
                    htmlsourceindent = "3",
                ) do
                    [
                        """
                                        Getting Started
                                    """
                    ]
                end
                Genie.Renderer.Html.div(
                    class = "mainpage",
                    style = "padding-bottom:250px",
                    htmlsourceindent = "3",
                ) do
                    [
                        """
                                        To learn more about our tools, check out the """
                        Genie.Renderer.Html.a(htmlsourceindent = "4", href = "tutorial") do
                            [
                                """Tutorial""";
                            ]
                        end
                        Genie.Renderer.Html.br(htmlsourceindent = "4")
                        Genie.Renderer.Html.br(htmlsourceindent = "4")
                        """
                                        For the """
                        Genie.Renderer.Html.a(htmlsourceindent = "4", href = "runalgs") do
                            [
                                """Algorithm Runner""";
                            ]
                        end
                        """, you will be shown how define a model, run DMRG on it, and interpret the output
                                        """
                        Genie.Renderer.Html.br(htmlsourceindent = "4")
                        Genie.Renderer.Html.br(htmlsourceindent = "4")
                        """
                                        For the """
                        Genie.Renderer.Html.a(htmlsourceindent = "4", href = "build") do
                            [
                                """Tensor Network Builder""";
                            ]
                        end
                        """, you will be shown how to use each basic operation to perform tensor network computations
                                    """
                    ]
                end
            ]
        end
    ]
end

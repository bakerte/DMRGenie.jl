# app/layouts/app.jl.html 

function func_6d24108598879434afe1f68882d60a4534007eda(;
    context = Genie.Renderer.vars(:context),
    outputPath = Genie.Renderer.vars(:outputPath),
    error = Genie.Renderer.vars(:error),
)

    [
        Genie.Renderer.Html.doctype()
        Genie.Renderer.Html.html(htmlsourceindent = "0", lang = "en") do
            [
                Genie.Renderer.Html.head(htmlsourceindent = "1") do
                    [
                        Genie.Renderer.Html.meta(
                            charset = "utf-8",
                            content = "width=device-width, initial-scale=1.0",
                            htmlsourceindent = "2",
                        )
                        Genie.Renderer.Html.title(htmlsourceindent = "2") do
                            [
                                """DMRGenie""";
                            ]
                        end
                        Genie.Renderer.Html.link(
                            htmlsourceindent = "2",
                            rel = "icon",
                            href = "/img/home/DMRGenieLogo.png",
                        )
                        Genie.Renderer.Html.link(
                            htmlsourceindent = "2",
                            href = "/css/style.css",
                            rel = "stylesheet",
                        )
                        Genie.Renderer.Html.link(
                            htmlsourceindent = "2",
                            href = "/css/builder.css",
                            rel = "stylesheet",
                        )
                    ]
                end
                Genie.Renderer.Html.body(htmlsourceindent = "1") do
                    [
                        Genie.Renderer.Html.header(
                            htmlsourceindent = "2",
                            style = "padding-top: 6px;",
                        ) do
                            [
                                Genie.Renderer.Html.a(
                                    htmlsourceindent = "3",
                                    href = "/",
                                ) do
                                    [
                                        Genie.Renderer.Html.img(
                                            alt = "DRMGenie Logo",
                                            htmlsourceindent = "4",
                                            style = "width:55px; height:auto; padding-left:4px; padding-top:5px",
                                            src = "/img/home/DMRGenieLogo.png",
                                        )
                                    ]
                                end
                                Genie.Renderer.Html.h1(
                                    htmlsourceindent = "3",
                                    style = "text-align:center; padding-left:10px;",
                                ) do
                                    [
                                        Genie.Renderer.Html.a(
                                            class = "title",
                                            href = "/",
                                            htmlsourceindent = "4",
                                        ) do
                                            [
                                                """DMRGenie""";
                                            ]
                                        end;
                                    ]
                                end
                                Genie.Renderer.Html.div(
                                    class = "subtitle",
                                    htmlsourceindent = "3",
                                ) do
                                    [
                                        Genie.Renderer.Html.p(htmlsourceindent = "4") do
                                            [
                                                """Tensor Networks Made Easy""";
                                            ]
                                        end;
                                    ]
                                end
                                Genie.Renderer.Html.div(
                                    class = "dropdown",
                                    htmlsourceindent = "3",
                                ) do
                                    [
                                        Genie.Renderer.Html.button(
                                            class = "dropbtn",
                                            htmlsourceindent = "4",
                                        ) do
                                            [
                                                """Menu""";
                                            ]
                                        end
                                        Genie.Renderer.Html.div(
                                            class = "dropdown-content",
                                            htmlsourceindent = "4",
                                        ) do
                                            [
                                                Genie.Renderer.Html.a(
                                                    htmlsourceindent = "5",
                                                    href = "/",
                                                ) do
                                                    [
                                                        """Home""";
                                                    ]
                                                end
                                                Genie.Renderer.Html.a(
                                                    htmlsourceindent = "5",
                                                    href = "tutorial",
                                                ) do
                                                    [
                                                        """Tutorial""";
                                                    ]
                                                end
                                                Genie.Renderer.Html.a(
                                                    htmlsourceindent = "5",
                                                    href = "runalgs",
                                                ) do
                                                    [
                                                        """Run Algorithms""";
                                                    ]
                                                end
                                                Genie.Renderer.Html.a(
                                                    htmlsourceindent = "5",
                                                    href = "build",
                                                ) do
                                                    [
                                                        """Build a Tensor Network""";
                                                    ]
                                                end
                                                Genie.Renderer.Html.a(
                                                    htmlsourceindent = "5",
                                                    href = "https://sites.google.com/view/bakerte/home/research",
                                                    rel = "noopener noreferrer",
                                                    target = "blank",
                                                ) do
                                                    [
                                                        """Our Research""";
                                                    ]
                                                end
                                            ]
                                        end
                                    ]
                                end
                            ]
                        end
                        Genie.Renderer.Html.hr(
                            htmlsourceindent = "2",
                            style = "position:relative; margin: 0px; margin-top:10px;",
                        )
                        """<!--  <br>  -->"""
                        @yield
                    ]
                end
                Genie.Renderer.Html.footer(
                    htmlsourceindent = "1",
                    style = "color: #1F6E93; background-color: #F5F4F6;",
                ) do
                    [
                        Genie.Renderer.Html.p(
                            htmlsourceindent = "2",
                            style = "padding-right:25px; font-size:2vmin; color: #1F6E93;",
                        ) do
                            [
                                Genie.Renderer.Html.b(htmlsourceindent = "3") do
                                    [
                                        """DMRGenie""";
                                    ]
                                end;
                            ]
                        end;
                    ]
                end
            ]
        end
    ]
end

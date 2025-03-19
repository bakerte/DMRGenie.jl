# app/resources/tensornetworks/views/DMRGenie.jl.html 

function func_c6e4cd882861547e7afdb7b84b6c3c5751b17861(;
    tensor_network = Genie.Renderer.vars(:tensor_network),
    quantum_measurement = Genie.Renderer.vars(:quantum_measurement),
    symmetry_rho_path = Genie.Renderer.vars(:symmetry_rho_path),
    symmetry_correlation_path = Genie.Renderer.vars(:symmetry_correlation_path),
    hamiltonain_measurement = Genie.Renderer.vars(:hamiltonain_measurement),
    dense_correlation_path = Genie.Renderer.vars(:dense_correlation_path),
    context = Genie.Renderer.vars(:context),
    alert_message = Genie.Renderer.vars(:alert_message),
    dense_rho_path = Genie.Renderer.vars(:dense_rho_path),
)

    [
        Genie.Renderer.Html.title(htmlsourceindent = "2") do
            [
                """Run Algorithms""";
            ]
        end
        Genie.Renderer.Html.script(htmlsourceindent = "2", src = "/js/DMRGenie/Drawing.js")
        Genie.Renderer.Html.script(
            htmlsourceindent = "2",
            src = "/js/DMRGenie/HamiltonianForm.js",
        )
        Genie.Renderer.Html.script(
            htmlsourceindent = "2",
            src = "/js/DMRGenie/ModelFields.js",
        )
        Genie.Renderer.Html.script(
            htmlsourceindent = "2",
            src = "/js/DMRGenie/MethodFields.js",
        )
        Genie.Renderer.Html.script(
            htmlsourceindent = "2",
            src = "/js/DMRGenie/MeasurementFields.js",
        )
        Genie.Renderer.Html.script(htmlsourceindent = "2") do
            [
                """
                        window.onload = function() {
                            // Initialize
                            SystemChange()
                            HideOrShowModelOptions()
                            ShowRequiredOutputs()
                            // Draw
                            update();
                            // Send an alert if there was bad input (Non urgent - let everything else load first)
                            alert_message = document.getElementById("alert_message").value;
                            if (alert_message) {
                                alert(alert_message)
                            }
                        };
                    """
            ]
        end
        Genie.Renderer.Html.div(class = "flex-container1", htmlsourceindent = "2") do
            [
                Genie.Renderer.Html.div(
                    class = "flex-container2",
                    htmlsourceindent = "3",
                ) do
                    [
                        Genie.Renderer.Html.form(
                            method = "POST",
                            enctype = "multipart/form-data",
                            action = "/runalgs",
                            onsubmit = "btnSubmit.disabled = true; loading(); return true;",
                            htmlsourceindent = "4",
                        ) do
                            [
                                """<!--  Hidden input containing alert message to be accessed by java script  -->"""
                                Genie.Renderer.Html.input(
                                    name = "alert_message",
                                    htmlsourceindent = "5",
                                    style = "display:none;",
                                    id = "alert_message",
                                    value = "$(alert_message)",
                                    type = "text",
                                )
                                """<!-- ------- -->"""
                                """<!--  Model  -->"""
                                """<!-- ------- -->"""
                                Genie.Renderer.Html.h3(
                                    class = "menu-section-label",
                                    style = "text-align:center",
                                    htmlsourceindent = "5",
                                ) do
                                    [
                                        """Model""";
                                    ]
                                end
                                Genie.Renderer.Html.div(
                                    class = "main-text",
                                    style = "text-align:left; padding-right:50px; padding-left:10px; padding-top:20px",
                                    htmlsourceindent = "5",
                                ) do
                                    [
                                        Genie.Renderer.Html.label(
                                            htmlsourceindent = "6",
                                            ;
                                            NamedTuple{(:for,)}(("default_model",))...,
                                        ) do
                                            [
                                                """Hamiltonian""";
                                            ]
                                        end
                                        Genie.Renderer.Html.select(
                                            name = "default_model",
                                            htmlsourceindent = "6",
                                            id = "default_model",
                                            onchange = "HideOrShowModelOptions();",
                                        ) do
                                            [
                                                Genie.Renderer.Html.option(
                                                    selected = "$(tensor_network.default_model=="none")",
                                                    htmlsourceindent = "7",
                                                    value = "none",
                                                ) do
                                                    [
                                                        """
                                                                                    Custom
                                                                                """
                                                    ]
                                                end
                                                Genie.Renderer.Html.option(
                                                    selected = "$(tensor_network.default_model=="heisenbergMPO")",
                                                    htmlsourceindent = "7",
                                                    value = "heisenbergMPO",
                                                ) do
                                                    [
                                                        """
                                                                                    Heisenberg
                                                                                """
                                                    ]
                                                end
                                                Genie.Renderer.Html.option(
                                                    selected = "$(tensor_network.default_model=="hubbardMPO")",
                                                    htmlsourceindent = "7",
                                                    value = "hubbardMPO",
                                                ) do
                                                    [
                                                        """
                                                                                    Hubbard
                                                                                """
                                                    ]
                                                end
                                                Genie.Renderer.Html.option(
                                                    selected = "$(tensor_network.default_model=="tjMPO")",
                                                    htmlsourceindent = "7",
                                                    value = "tjMPO",
                                                ) do
                                                    [
                                                        """
                                                                                    t-J
                                                                                """
                                                    ]
                                                end
                                            ]
                                        end
                                        Genie.Renderer.Html.div(
                                            class = "hover-text",
                                            htmlsourceindent = "6",
                                        ) do
                                            [
                                                Genie.Renderer.Html.img(
                                                    htmlsourceindent = "7",
                                                    style = "width:15px; height:auto;",
                                                    src = "/img/runner/hint.png",
                                                )
                                                Genie.Renderer.Html.span(
                                                    class = "tooltip-text",
                                                    id = "right",
                                                    htmlsourceindent = "7",
                                                ) do
                                                    [
                                                        """
                                                                                    Choose the Hamiltonian system to analyze
                                                                                """
                                                    ]
                                                end
                                            ]
                                        end
                                    ]
                                end
                                Genie.Renderer.Html.div(
                                    name = "non_default_model_options",
                                    class = "main-text",
                                    id = "non_default_model_options",
                                    style = "padding-right:50px",
                                    htmlsourceindent = "5",
                                ) do
                                    [
                                        Genie.Renderer.Html.div(
                                            htmlsourceindent = "6",
                                            style = "text-align:left; padding-top: 25px; padding-left:10px",
                                        ) do
                                            [
                                                Genie.Renderer.Html.label(
                                                    htmlsourceindent = "7",
                                                    ;
                                                    NamedTuple{(:for,)}((
                                                        "physical_dimension",
                                                    ))...,
                                                ) do
                                                    [
                                                        """Physical Dimension""";
                                                    ]
                                                end
                                                Genie.Renderer.Html.input(
                                                    name = "physical_dimension",
                                                    max = "200",
                                                    min = "2",
                                                    htmlsourceindent = "7",
                                                    id = "physical_dimension",
                                                    value = "2",
                                                    type = "number",
                                                )
                                                Genie.Renderer.Html.div(
                                                    class = "hover-text",
                                                    htmlsourceindent = "7",
                                                ) do
                                                    [
                                                        Genie.Renderer.Html.img(
                                                            htmlsourceindent = "8",
                                                            style = "width:15px; height:auto;",
                                                            src = "/img/runner/hint.png",
                                                        )
                                                        Genie.Renderer.Html.span(
                                                            class = "tooltip-text",
                                                            id = "right",
                                                            htmlsourceindent = "8",
                                                        ) do
                                                            [
                                                                """
                                                                                                Dimension of upward and downward facing indices of MPO tensors
                                                                                            """
                                                            ]
                                                        end
                                                    ]
                                                end
                                            ]
                                        end
                                        Genie.Renderer.Html.div(
                                            htmlsourceindent = "6",
                                            style = "text-align:left; padding-top: 25px; padding-bottom: 25px; padding-left:10px",
                                        ) do
                                            [
                                                Genie.Renderer.Html.label(
                                                    htmlsourceindent = "7",
                                                    ;
                                                    NamedTuple{(:for,)}((
                                                        "hamiltonian_constant",
                                                    ))...,
                                                ) do
                                                    [
                                                        """Hamiltonian Constant""";
                                                    ]
                                                end
                                                Genie.Renderer.Html.input(
                                                    name = "hamiltonian_constant",
                                                    step = "any",
                                                    htmlsourceindent = "7",
                                                    id = "hamiltonian_constant",
                                                    value = "1",
                                                    type = "number",
                                                )
                                                Genie.Renderer.Html.div(
                                                    class = "hover-text",
                                                    htmlsourceindent = "7",
                                                ) do
                                                    [
                                                        Genie.Renderer.Html.img(
                                                            htmlsourceindent = "8",
                                                            style = "width:15px; height:auto;",
                                                            src = "/img/runner/hint.png",
                                                        )
                                                        Genie.Renderer.Html.span(
                                                            class = "tooltip-text",
                                                            id = "right",
                                                            htmlsourceindent = "8",
                                                        ) do
                                                            [
                                                                """
                                                                                                Multiplicative constant factor, denoted J often
                                                                                            """
                                                            ]
                                                        end
                                                    ]
                                                end
                                            ]
                                        end
                                        Genie.Renderer.Html.div(
                                            name = "hamiltonian_border_div",
                                            htmlsourceindent = "6",
                                            id = "hamiltonian_border_div",
                                            style = "text-align:left; padding:10px; border-radius:10px",
                                        ) do
                                            [
                                                Genie.Renderer.Html.label(
                                                    htmlsourceindent = "7",
                                                    ;
                                                    NamedTuple{(:for,)}((
                                                        "num_hamiltonian_components",
                                                    ))...,
                                                ) do
                                                    [
                                                        """Number of Components""";
                                                    ]
                                                end
                                                Genie.Renderer.Html.input(
                                                    name = "num_hamiltonian_components",
                                                    max = "12",
                                                    min = "1",
                                                    htmlsourceindent = "7",
                                                    id = "num_hamiltonian_components",
                                                    onkeyup = "BuildFormFields(parseInt(this.value, 10))",
                                                    value = "1",
                                                    onmouseup = "BuildFormFields(parseInt(this.value, 10))",
                                                    type = "number",
                                                )
                                                Genie.Renderer.Html.div(
                                                    class = "hover-text",
                                                    htmlsourceindent = "7",
                                                ) do
                                                    [
                                                        Genie.Renderer.Html.img(
                                                            htmlsourceindent = "8",
                                                            style = "width:15px; height:auto;",
                                                            src = "/img/runner/hint.png",
                                                        )
                                                        Genie.Renderer.Html.span(
                                                            class = "tooltip-text",
                                                            id = "right",
                                                            htmlsourceindent = "8",
                                                        ) do
                                                            [
                                                                """
                                                                                                    Select interacting terms of your Hamiltonian sum
                                                                                                """
                                                            ]
                                                        end
                                                    ]
                                                end
                                                Genie.Renderer.Html.div(
                                                    htmlsourceindent = "7",
                                                    id = "hamiltonian_components",
                                                )
                                            ]
                                        end
                                    ]
                                end
                                Genie.Renderer.Html.div(
                                    class = "main-text",
                                    style = "text-align:left; padding-top: 25px; padding-right:50px;",
                                    htmlsourceindent = "5",
                                ) do
                                    [
                                        Genie.Renderer.Html.div(
                                            name = "correlation_border_div",
                                            htmlsourceindent = "6",
                                            id = "correlation_border_div",
                                            style = "padding:10px; border-radius:10px",
                                        ) do
                                            [
                                                Genie.Renderer.Html.label(
                                                    htmlsourceindent = "7",
                                                    ;
                                                    NamedTuple{(:for,)}((
                                                        "correlation_box",
                                                    ))...,
                                                ) do
                                                    [
                                                        """Compute Correlations""";
                                                    ]
                                                end
                                                Genie.Renderer.Html.input(
                                                    onclick = "HideOrShowCorrelationOptions()",
                                                    name = "correlation_box",
                                                    htmlsourceindent = "7",
                                                    id = "correlation_box",
                                                    type = "checkbox",
                                                )
                                                Genie.Renderer.Html.div(
                                                    class = "hover-text",
                                                    htmlsourceindent = "7",
                                                ) do
                                                    [
                                                        Genie.Renderer.Html.img(
                                                            htmlsourceindent = "8",
                                                            style = "width:15px; height:auto;",
                                                            src = "/img/runner/hint.png",
                                                        )
                                                        Genie.Renderer.Html.span(
                                                            class = "tooltip-text",
                                                            id = "right",
                                                            htmlsourceindent = "8",
                                                        ) do
                                                            [
                                                                """
                                                                                                Specify operators and correlation functions to be evaluated at all positions on the lattice
                                                                                            """
                                                            ]
                                                        end
                                                    ]
                                                end
                                                Genie.Renderer.Html.div(
                                                    name = "correlation_content",
                                                    class = "init-hidden",
                                                    id = "correlation_content",
                                                    htmlsourceindent = "7",
                                                ) do
                                                    [
                                                        Genie.Renderer.Html.div(
                                                            htmlsourceindent = "8",
                                                            style = "text-align:left; padding-top: 25px; white-space:nowrap;",
                                                        ) do
                                                            [
                                                                Genie.Renderer.Html.label(
                                                                    htmlsourceindent = "9",
                                                                    ;
                                                                    NamedTuple{(:for,)}((
                                                                        "correlation_matrix_op[1]",
                                                                    ))...,
                                                                ) do
                                                                    [
                                                                        """Correlation Matrix Operators""";
                                                                    ]
                                                                end
                                                                Genie.Renderer.Html.br(
                                                                    htmlsourceindent = "9",
                                                                )
                                                                Genie.Renderer.Html.select(
                                                                    name = "correlation_matrix_op[1]",
                                                                    htmlsourceindent = "9",
                                                                    id = "correlation_matrix_op[1]",
                                                                ) do
                                                                    [
                                                                        Genie.Renderer.Html.option(
                                                                            selected = "$(tensor_network.correlation_matrix_operators[1]=="Id")",
                                                                            htmlsourceindent = "10",
                                                                            value = "Id",
                                                                        ) do
                                                                            [
                                                                                """
                                                                                                                        Id
                                                                                                                    """
                                                                            ]
                                                                        end
                                                                        Genie.Renderer.Html.option(
                                                                            selected = "$(tensor_network.correlation_matrix_operators[1]=="Sp")",
                                                                            htmlsourceindent = "10",
                                                                            value = "Sp",
                                                                        ) do
                                                                            [
                                                                                """
                                                                                                                        Sp
                                                                                                                    """
                                                                            ]
                                                                        end
                                                                        Genie.Renderer.Html.option(
                                                                            selected = "$(tensor_network.correlation_matrix_operators[1]=="Sm")",
                                                                            htmlsourceindent = "10",
                                                                            value = "Sm",
                                                                        ) do
                                                                            [
                                                                                """
                                                                                                                        Sm
                                                                                                                    """
                                                                            ]
                                                                        end
                                                                        Genie.Renderer.Html.option(
                                                                            selected = "$(tensor_network.correlation_matrix_operators[1]=="Sx")",
                                                                            htmlsourceindent = "10",
                                                                            value = "Sx",
                                                                        ) do
                                                                            [
                                                                                """
                                                                                                                        Sx
                                                                                                                    """
                                                                            ]
                                                                        end
                                                                        Genie.Renderer.Html.option(
                                                                            selected = "$(tensor_network.correlation_matrix_operators[1]=="Sy")",
                                                                            htmlsourceindent = "10",
                                                                            value = "Sy",
                                                                        ) do
                                                                            [
                                                                                """
                                                                                                                        Sy
                                                                                                                    """
                                                                            ]
                                                                        end
                                                                        Genie.Renderer.Html.option(
                                                                            selected = "$(tensor_network.correlation_matrix_operators[1]=="Sz")",
                                                                            htmlsourceindent = "10",
                                                                            value = "Sz",
                                                                        ) do
                                                                            [
                                                                                """
                                                                                                                        Sz
                                                                                                                    """
                                                                            ]
                                                                        end
                                                                        Genie.Renderer.Html.option(
                                                                            selected = "$(tensor_network.correlation_matrix_operators[1]=="O")",
                                                                            htmlsourceindent = "10",
                                                                            value = "O",
                                                                        ) do
                                                                            [
                                                                                """
                                                                                                                        Zeros
                                                                                                                    """
                                                                            ]
                                                                        end
                                                                    ]
                                                                end
                                                                Genie.Renderer.Html.select(
                                                                    name = "correlation_matrix_op[2]",
                                                                    htmlsourceindent = "9",
                                                                    id = "correlation_matrix_op[2]",
                                                                ) do
                                                                    [
                                                                        Genie.Renderer.Html.option(
                                                                            selected = "$(tensor_network.correlation_matrix_operators[2]=="Id")",
                                                                            htmlsourceindent = "10",
                                                                            value = "Id",
                                                                        ) do
                                                                            [
                                                                                """
                                                                                                                        Id
                                                                                                                    """
                                                                            ]
                                                                        end
                                                                        Genie.Renderer.Html.option(
                                                                            selected = "$(tensor_network.correlation_matrix_operators[2]=="Sp")",
                                                                            htmlsourceindent = "10",
                                                                            value = "Sp",
                                                                        ) do
                                                                            [
                                                                                """
                                                                                                                        Sp
                                                                                                                    """
                                                                            ]
                                                                        end
                                                                        Genie.Renderer.Html.option(
                                                                            selected = "$(tensor_network.correlation_matrix_operators[2]=="Sm")",
                                                                            htmlsourceindent = "10",
                                                                            value = "Sm",
                                                                        ) do
                                                                            [
                                                                                """
                                                                                                                        Sm
                                                                                                                    """
                                                                            ]
                                                                        end
                                                                        Genie.Renderer.Html.option(
                                                                            selected = "$(tensor_network.correlation_matrix_operators[2]=="Sx")",
                                                                            htmlsourceindent = "10",
                                                                            value = "Sx",
                                                                        ) do
                                                                            [
                                                                                """
                                                                                                                        Sx
                                                                                                                    """
                                                                            ]
                                                                        end
                                                                        Genie.Renderer.Html.option(
                                                                            selected = "$(tensor_network.correlation_matrix_operators[2]=="Sy")",
                                                                            htmlsourceindent = "10",
                                                                            value = "Sy",
                                                                        ) do
                                                                            [
                                                                                """
                                                                                                                        Sy
                                                                                                                    """
                                                                            ]
                                                                        end
                                                                        Genie.Renderer.Html.option(
                                                                            selected = "$(tensor_network.correlation_matrix_operators[2]=="Sz")",
                                                                            htmlsourceindent = "10",
                                                                            value = "Sz",
                                                                        ) do
                                                                            [
                                                                                """
                                                                                                                        Sz
                                                                                                                    """
                                                                            ]
                                                                        end
                                                                        Genie.Renderer.Html.option(
                                                                            selected = "$(tensor_network.correlation_matrix_operators[2]=="O")",
                                                                            htmlsourceindent = "10",
                                                                            value = "O",
                                                                        ) do
                                                                            [
                                                                                """
                                                                                                                        Zeros
                                                                                                                    """
                                                                            ]
                                                                        end
                                                                    ]
                                                                end
                                                            ]
                                                        end
                                                        Genie.Renderer.Html.div(
                                                            htmlsourceindent = "8",
                                                            style = "text-align:left; padding-top: 25px; white-space:nowrap;",
                                                        ) do
                                                            [
                                                                Genie.Renderer.Html.label(
                                                                    htmlsourceindent = "9",
                                                                    ;
                                                                    NamedTuple{(:for,)}((
                                                                        "correlation_function_op[1]",
                                                                    ))...,
                                                                ) do
                                                                    [
                                                                        """Correlation Function Operators""";
                                                                    ]
                                                                end
                                                                Genie.Renderer.Html.br(
                                                                    htmlsourceindent = "9",
                                                                )
                                                                Genie.Renderer.Html.select(
                                                                    name = "correlation_function_op[1]",
                                                                    htmlsourceindent = "9",
                                                                    id = "correlation_function_op[1]",
                                                                ) do
                                                                    [
                                                                        Genie.Renderer.Html.option(
                                                                            selected = "$(tensor_network.correlation_function_operators[1]=="Id")",
                                                                            htmlsourceindent = "10",
                                                                            value = "Id",
                                                                        ) do
                                                                            [
                                                                                """
                                                                                                                        Id
                                                                                                                    """
                                                                            ]
                                                                        end
                                                                        Genie.Renderer.Html.option(
                                                                            selected = "$(tensor_network.correlation_function_operators[1]=="Sp")",
                                                                            htmlsourceindent = "10",
                                                                            value = "Sp",
                                                                        ) do
                                                                            [
                                                                                """
                                                                                                                        Sp
                                                                                                                    """
                                                                            ]
                                                                        end
                                                                        Genie.Renderer.Html.option(
                                                                            selected = "$(tensor_network.correlation_function_operators[1]=="Sm")",
                                                                            htmlsourceindent = "10",
                                                                            value = "Sm",
                                                                        ) do
                                                                            [
                                                                                """
                                                                                                                        Sm
                                                                                                                    """
                                                                            ]
                                                                        end
                                                                        Genie.Renderer.Html.option(
                                                                            selected = "$(tensor_network.correlation_function_operators[1]=="Sx")",
                                                                            htmlsourceindent = "10",
                                                                            value = "Sx",
                                                                        ) do
                                                                            [
                                                                                """
                                                                                                                        Sx
                                                                                                                    """
                                                                            ]
                                                                        end
                                                                        Genie.Renderer.Html.option(
                                                                            selected = "$(tensor_network.correlation_function_operators[1]=="Sy")",
                                                                            htmlsourceindent = "10",
                                                                            value = "Sy",
                                                                        ) do
                                                                            [
                                                                                """
                                                                                                                        Sy
                                                                                                                    """
                                                                            ]
                                                                        end
                                                                        Genie.Renderer.Html.option(
                                                                            selected = "$(tensor_network.correlation_function_operators[1]=="Sz")",
                                                                            htmlsourceindent = "10",
                                                                            value = "Sz",
                                                                        ) do
                                                                            [
                                                                                """
                                                                                                                        Sz
                                                                                                                    """
                                                                            ]
                                                                        end
                                                                        Genie.Renderer.Html.option(
                                                                            selected = "$(tensor_network.correlation_function_operators[1]=="O")",
                                                                            htmlsourceindent = "10",
                                                                            value = "O",
                                                                        ) do
                                                                            [
                                                                                """
                                                                                                                        Zeros
                                                                                                                    """
                                                                            ]
                                                                        end
                                                                    ]
                                                                end
                                                                Genie.Renderer.Html.button(
                                                                    onclick = "CreateNewCorrelationFunctionInput()",
                                                                    name = "additional_op_button",
                                                                    htmlsourceindent = "9",
                                                                    type = "button",
                                                                ) do
                                                                    [
                                                                        """
                                                                                                            +
                                                                                                        """
                                                                    ]
                                                                end
                                                                Genie.Renderer.Html.div(
                                                                    name = "additional_ops",
                                                                    htmlsourceindent = "9",
                                                                    id = "additional_ops",
                                                                )
                                                            ]
                                                        end
                                                    ]
                                                end
                                            ]
                                        end;
                                    ]
                                end
                                Genie.Renderer.Html.div(
                                    class = "main-text",
                                    style = "text-align:left; padding-right:50px; padding-top: 15px;",
                                    htmlsourceindent = "5",
                                ) do
                                    [
                                        Genie.Renderer.Html.div(
                                            name = "symmetry_border_div",
                                            htmlsourceindent = "6",
                                            id = "symmetry_border_div",
                                            style = "padding:10px; border-radius:10px",
                                        ) do
                                            [
                                                Genie.Renderer.Html.label(
                                                    htmlsourceindent = "7",
                                                    ;
                                                    NamedTuple{(:for,)}((
                                                        "symmetry_box",
                                                    ))...,
                                                ) do
                                                    [
                                                        """Symmetry""";
                                                    ]
                                                end
                                                Genie.Renderer.Html.input(
                                                    onclick = "HideOrShowSymmetryElements()",
                                                    name = "symmetry_box",
                                                    htmlsourceindent = "7",
                                                    id = "symmetry_box",
                                                    type = "checkbox",
                                                )
                                                Genie.Renderer.Html.div(
                                                    class = "hover-text",
                                                    htmlsourceindent = "7",
                                                ) do
                                                    [
                                                        Genie.Renderer.Html.img(
                                                            htmlsourceindent = "8",
                                                            style = "width:15px; height:auto;",
                                                            src = "/img/runner/hint.png",
                                                        )
                                                        Genie.Renderer.Html.span(
                                                            class = "tooltip-text",
                                                            id = "right",
                                                            htmlsourceindent = "8",
                                                        ) do
                                                            [
                                                                """
                                                                                                Enforce a U1 or Zn symmetry on the quantum problem
                                                                                            """
                                                            ]
                                                        end
                                                    ]
                                                end
                                                Genie.Renderer.Html.div(
                                                    name = "symmetry_content",
                                                    class = "init-hidden",
                                                    id = "symmetry_content",
                                                    style = "margin:3px",
                                                    htmlsourceindent = "7",
                                                ) do
                                                    [
                                                        Genie.Renderer.Html.div(
                                                            htmlsourceindent = "8",
                                                        ) do
                                                            [
                                                                Genie.Renderer.Html.div(
                                                                    htmlsourceindent = "9",
                                                                    style = "text-align:left; padding-top: 25px; white-space:nowrap;",
                                                                ) do
                                                                    [
                                                                        Genie.Renderer.Html.label(
                                                                            htmlsourceindent = "10",
                                                                            ;
                                                                            NamedTuple{(
                                                                                :for,
                                                                            )}((
                                                                                "sym_name",
                                                                            ))...,
                                                                        ) do
                                                                            [
                                                                                """Name""";
                                                                            ]
                                                                        end
                                                                        Genie.Renderer.Html.input(
                                                                            name = "sym_name",
                                                                            pattern = "[A-Za-z0-9]{1,20}",
                                                                            required = "required",
                                                                            id = "sym_name",
                                                                            htmlsourceindent = "10",
                                                                            value = "Spin",
                                                                            placeholder = "eg. Spin",
                                                                            type = "text",
                                                                        )
                                                                    ]
                                                                end
                                                                Genie.Renderer.Html.div(
                                                                    htmlsourceindent = "9",
                                                                    style = "text-align:left; padding-top: 25px; white-space:nowrap;",
                                                                ) do
                                                                    [
                                                                        Genie.Renderer.Html.label(
                                                                            htmlsourceindent = "10",
                                                                            ;
                                                                            NamedTuple{(
                                                                                :for,
                                                                            )}((
                                                                                "sym[1]",
                                                                            ))...,
                                                                        ) do
                                                                            [
                                                                                """Symmetries""";
                                                                            ]
                                                                        end
                                                                        Genie.Renderer.Html.br(
                                                                            htmlsourceindent = "10",
                                                                        )
                                                                        Genie.Renderer.Html.select(
                                                                            name = "sym[1]",
                                                                            htmlsourceindent = "10",
                                                                            id = "sym[1]",
                                                                            onchange = "ZnChange(1)",
                                                                        ) do
                                                                            [
                                                                                Genie.Renderer.Html.option(
                                                                                    htmlsourceindent = "11",
                                                                                    value = "U1",
                                                                                ) do
                                                                                    [
                                                                                        """
                                                                                                                                    U1
                                                                                                                                """
                                                                                    ]
                                                                                end
                                                                                Genie.Renderer.Html.option(
                                                                                    htmlsourceindent = "11",
                                                                                    value = "Zn",
                                                                                ) do
                                                                                    [
                                                                                        """
                                                                                                                                    Zn
                                                                                                                                """
                                                                                    ]
                                                                                end
                                                                            ]
                                                                        end
                                                                        Genie.Renderer.Html.span(
                                                                            name = "Zn[1]",
                                                                            class = "init-hidden",
                                                                            id = "Zn[1]",
                                                                            htmlsourceindent = "10",
                                                                        ) do
                                                                            [
                                                                                Genie.Renderer.Html.input(
                                                                                    name = "Zn_val[1]",
                                                                                    htmlsourceindent = "11",
                                                                                    id = "Zn_val[1]",
                                                                                    type = "number",
                                                                                )
                                                                            ]
                                                                        end
                                                                        Genie.Renderer.Html.button(
                                                                            onclick = "CreateNewSymmetrySelect('additional_symmetries'); CreatePhysicalIndexNumberInputs();",
                                                                            name = "sym_button",
                                                                            htmlsourceindent = "10",
                                                                            type = "button",
                                                                        ) do
                                                                            [
                                                                                """
                                                                                                                        +
                                                                                                                    """
                                                                            ]
                                                                        end
                                                                    ]
                                                                end
                                                                Genie.Renderer.Html.div(
                                                                    htmlsourceindent = "9",
                                                                    id = "additional_symmetries",
                                                                )
                                                            ]
                                                        end
                                                        Genie.Renderer.Html.div(
                                                            htmlsourceindent = "8",
                                                            style = "text-align:left; padding-top: 25px; white-space:nowrap;",
                                                        ) do
                                                            [
                                                                Genie.Renderer.Html.label(
                                                                    htmlsourceindent = "9",
                                                                    ;
                                                                    NamedTuple{(:for,)}((
                                                                        "non_uniform_box",
                                                                    ))...,
                                                                ) do
                                                                    [
                                                                        """Non-Uniform""";
                                                                    ]
                                                                end
                                                                Genie.Renderer.Html.input(
                                                                    onclick = "HideOrShowNonUniformElements()",
                                                                    name = "non_uniform_box",
                                                                    htmlsourceindent = "9",
                                                                    id = "non_uniform_box",
                                                                    type = "checkbox",
                                                                )
                                                                Genie.Renderer.Html.br(
                                                                    htmlsourceindent = "9",
                                                                )
                                                                Genie.Renderer.Html.span(
                                                                    name = "non_uniform_span",
                                                                    class = "init-hidden",
                                                                    id = "non_uniform_span",
                                                                    style = "white-space:nowrap;",
                                                                    htmlsourceindent = "9",
                                                                ) do
                                                                    [
                                                                        Genie.Renderer.Html.label(
                                                                            htmlsourceindent = "10",
                                                                        ) do
                                                                            [
                                                                                """Add New Physical Index""";
                                                                            ]
                                                                        end
                                                                        Genie.Renderer.Html.button(
                                                                            onclick = "CreateNewPhysicalIndex(); CreatePhysicalIndexNumberInputs()",
                                                                            name = "non_uniform_button",
                                                                            htmlsourceindent = "10",
                                                                            id = "non_uniform_button",
                                                                            type = "button",
                                                                        ) do
                                                                            [
                                                                                """
                                                                                                                        +
                                                                                                                    """
                                                                            ]
                                                                        end
                                                                    ]
                                                                end
                                                                Genie.Renderer.Html.br(
                                                                    htmlsourceindent = "9",
                                                                )
                                                                Genie.Renderer.Html.input(
                                                                    hidden = "",
                                                                    name = "num_physical_indeces",
                                                                    htmlsourceindent = "9",
                                                                    id = "num_physical_indeces",
                                                                    value = "1",
                                                                    type = "number",
                                                                )
                                                                Genie.Renderer.Html.span(
                                                                    name = "phys_idx_span[1]",
                                                                    htmlsourceindent = "9",
                                                                    id = "phys_idx_span[1]",
                                                                ) do
                                                                    [
                                                                        Genie.Renderer.Html.label(
                                                                            htmlsourceindent = "10",
                                                                        ) do
                                                                            [
                                                                                """Physical Index 1""";
                                                                            ]
                                                                        end
                                                                        Genie.Renderer.Html.br(
                                                                            htmlsourceindent = "10",
                                                                        )
                                                                        Genie.Renderer.Html.input(
                                                                            name = "physical_index[1][1]",
                                                                            htmlsourceindent = "10",
                                                                            id = "physical_index[1][1]",
                                                                            type = "number",
                                                                        )
                                                                    ]
                                                                end
                                                                Genie.Renderer.Html.span(
                                                                    name = "range_span[1]",
                                                                    class = "init-hidden",
                                                                    id = "range_span[1]",
                                                                    style = "margin-top:2px",
                                                                    htmlsourceindent = "9",
                                                                ) do
                                                                    [
                                                                        Genie.Renderer.Html.label(
                                                                            htmlsourceindent = "10",
                                                                            ;
                                                                            NamedTuple{(
                                                                                :for,
                                                                            )}((
                                                                                "range_start[1]",
                                                                            ))...,
                                                                        ) do
                                                                            [
                                                                                """Range 1""";
                                                                            ]
                                                                        end
                                                                        Genie.Renderer.Html.br(
                                                                            htmlsourceindent = "10",
                                                                        )
                                                                        Genie.Renderer.Html.input(
                                                                            name = "range_start[1]",
                                                                            min = "1",
                                                                            htmlsourceindent = "10",
                                                                            id = "range_start[1]",
                                                                            type = "number",
                                                                        )
                                                                        Genie.Renderer.Html.input(
                                                                            name = "range_stop[1]",
                                                                            min = "1",
                                                                            htmlsourceindent = "10",
                                                                            id = "range_stop[1]",
                                                                            type = "number",
                                                                        )
                                                                    ]
                                                                end
                                                                Genie.Renderer.Html.div(
                                                                    name = "non_uniform_content",
                                                                    class = "init-hidden",
                                                                    id = "non_uniform_content",
                                                                    style = "white-space:nowrap;",
                                                                    htmlsourceindent = "9",
                                                                ) do
                                                                    []
                                                                end
                                                            ]
                                                        end
                                                    ]
                                                end
                                            ]
                                        end;
                                    ]
                                end
                                Genie.Renderer.Html.div(
                                    class = "main-text",
                                    style = "text-align:left; padding-right:50px; padding-top: 25px; padding-left: 10px; white-space:nowrap;",
                                    htmlsourceindent = "5",
                                ) do
                                    [
                                        Genie.Renderer.Html.label(
                                            htmlsourceindent = "6",
                                            ;
                                            NamedTuple{(:for,)}(("num_tensors",))...,
                                        ) do
                                            [
                                                """Number of Sites:""";
                                            ]
                                        end
                                        Genie.Renderer.Html.input(
                                            name = "num_tensors",
                                            min = "3",
                                            htmlsourceindent = "6",
                                            id = "num_tensors",
                                            onkeyup = "update(); uncheckCorrelationCheckboxIfTooLarge(); uncheckSymmetryCheckboxIfTooLarge();",
                                            value = "$(tensor_network.num_tensors)",
                                            size = "5",
                                            type = "number",
                                            onmouseup = "update(); uncheckCorrelationCheckboxIfTooLarge(); uncheckSymmetryCheckboxIfTooLarge();",
                                        )
                                    ]
                                end
                                """<!--  !!!!  TODO  !!!!! Implement this or remove it !!!!  -->"""
                                """<!--                display:none for now                  -->"""
                                """<!-- -------- -->"""
                                """<!--  Method  -->"""
                                """<!-- -------- -->"""
                                Genie.Renderer.Html.h3(
                                    htmlsourceindent = "5",
                                    style = "
            display:none;
            text-align:center",
                                ) do
                                    [
                                        """
                                                            Method
                                                        """
                                    ]
                                end
                                """<!--  !!!!  TODO  !!!!! Implement this or remove it !!!!  -->"""
                                """<!--                display:none for now                  -->"""
                                Genie.Renderer.Html.div(
                                    htmlsourceindent = "5",
                                    style = "
           display:none;
           text-align:left; padding-right:50px; white-space:nowrap;",
                                ) do
                                    [
                                        Genie.Renderer.Html.label(
                                            htmlsourceindent = "6",
                                            ;
                                            NamedTuple{(:for,)}(("graph_type",))...,
                                        ) do
                                            [
                                                """Graph Type:
                                                                    """
                                                Genie.Renderer.Html.select(
                                                    name = "graph_type",
                                                    htmlsourceindent = "7",
                                                    id = "graph_type",
                                                    onchange = "update();",
                                                ) do
                                                    [
                                                        Genie.Renderer.Html.option(
                                                            selected = "$(tensor_network.graph_type=="scalar")",
                                                            htmlsourceindent = "8",
                                                            value = "scalar",
                                                        ) do
                                                            [
                                                                """
                                                                                            Scalar
                                                                                        """
                                                            ]
                                                        end
                                                        Genie.Renderer.Html.option(
                                                            selected = "$(tensor_network.graph_type=="vector")",
                                                            htmlsourceindent = "8",
                                                            value = "vector",
                                                        ) do
                                                            [
                                                                """
                                                                                            Vector
                                                                                        """
                                                            ]
                                                        end
                                                        Genie.Renderer.Html.option(
                                                            selected = "$(tensor_network.graph_type=="matrix")",
                                                            htmlsourceindent = "8",
                                                            value = "matrix",
                                                        ) do
                                                            [
                                                                """
                                                                                            Matrix
                                                                                        """
                                                            ]
                                                        end
                                                        Genie.Renderer.Html.option(
                                                            selected = "$(tensor_network.graph_type=="mps")",
                                                            htmlsourceindent = "8",
                                                            value = "mps",
                                                        ) do
                                                            [
                                                                """
                                                                                            MPS
                                                                                        """
                                                            ]
                                                        end
                                                        Genie.Renderer.Html.option(
                                                            selected = "$(tensor_network.graph_type=="mpo")",
                                                            htmlsourceindent = "8",
                                                            value = "mpo",
                                                        ) do
                                                            [
                                                                """
                                                                                            MPO
                                                                                        """
                                                            ]
                                                        end
                                                        Genie.Renderer.Html.option(
                                                            selected = "$(tensor_network.graph_type=="peps")",
                                                            htmlsourceindent = "8",
                                                            value = "peps",
                                                        ) do
                                                            [
                                                                """
                                                                                            PEPS
                                                                                        """
                                                            ]
                                                        end
                                                        Genie.Renderer.Html.option(
                                                            selected = "$(tensor_network.graph_type=="mera")",
                                                            htmlsourceindent = "8",
                                                            value = "mera",
                                                        ) do
                                                            [
                                                                """
                                                                                            MERA
                                                                                        """
                                                            ]
                                                        end
                                                    ]
                                                end
                                            ]
                                        end;
                                    ]
                                end
                                """<!--  !!!!  TODO  !!!!! Implement this or remove it !!!!  -->"""
                                """<!--                display:none for now                  -->"""
                                Genie.Renderer.Html.div(
                                    htmlsourceindent = "5",
                                    style = "display:none;
           text-align:left; padding-right:50px; padding-top:25px",
                                ) do
                                    [
                                        Genie.Renderer.Html.label(
                                            htmlsourceindent = "6",
                                            ;
                                            NamedTuple{(:for,)}(("system",))...,
                                        ) do
                                            [
                                                """System:
                                                                    """
                                                Genie.Renderer.Html.select(
                                                    name = "system",
                                                    htmlsourceindent = "7",
                                                    id = "system",
                                                    onchange = "SystemChange()",
                                                ) do
                                                    [
                                                        Genie.Renderer.Html.option(
                                                            selected = "$(tensor_network.system=="random")",
                                                            htmlsourceindent = "8",
                                                            value = "random",
                                                        ) do
                                                            [
                                                                """
                                                                                            Random
                                                                                        """
                                                            ]
                                                        end
                                                        Genie.Renderer.Html.option(
                                                            selected = "$(tensor_network.system=="input")",
                                                            htmlsourceindent = "8",
                                                            value = "input",
                                                        ) do
                                                            [
                                                                """
                                                                                            Input File
                                                                                        """
                                                            ]
                                                        end
                                                    ]
                                                end
                                                """<!--  https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types  -->"""
                                                Genie.Renderer.Html.input(
                                                    name = "system_input_file",
                                                    accept = ".txt, .jl",
                                                    class = "init-hidden",
                                                    id = "system_input_file",
                                                    htmlsourceindent = "7",
                                                    onchange = "SizeCheck()",
                                                    type = "file",
                                                )
                                            ]
                                        end;
                                    ]
                                end
                                """<!--  !!!!  TODO  !!!!! Implement this or remove it !!!!  -->"""
                                """<!--                display:none for now                  -->"""
                                Genie.Renderer.Html.div(
                                    htmlsourceindent = "5",
                                    style = "
           display:none;
           text-align:left; padding-right:50px; padding-top:25px; white-space:nowrap;",
                                ) do
                                    [
                                        Genie.Renderer.Html.label(
                                            htmlsourceindent = "6",
                                            ;
                                            NamedTuple{(:for,)}(("method",))...,
                                        ) do
                                            [
                                                """Method:
                                                                    """
                                                Genie.Renderer.Html.select(
                                                    name = "method",
                                                    htmlsourceindent = "7",
                                                    id = "method",
                                                ) do
                                                    [
                                                        Genie.Renderer.Html.option(
                                                            selected = "$(tensor_network.method=="multiply")",
                                                            htmlsourceindent = "8",
                                                            value = "multiply",
                                                        ) do
                                                            [
                                                                """
                                                                                            Multiply
                                                                                        """
                                                            ]
                                                        end
                                                        Genie.Renderer.Html.option(
                                                            selected = "$(tensor_network.method=="contract")",
                                                            htmlsourceindent = "8",
                                                            value = "contract",
                                                        ) do
                                                            [
                                                                """
                                                                                            Contract
                                                                                        """
                                                            ]
                                                        end
                                                        Genie.Renderer.Html.option(
                                                            selected = "$(tensor_network.method=="svd")",
                                                            htmlsourceindent = "8",
                                                            value = "svd",
                                                        ) do
                                                            [
                                                                """
                                                                                            SVD
                                                                                        """
                                                            ]
                                                        end
                                                    ]
                                                end
                                            ]
                                        end;
                                    ]
                                end
                                Genie.Renderer.Html.div(
                                    htmlsourceindent = "5",
                                    style = "text-align:left; padding-left:25px; padding-right:25px; padding-top:25px; margin-left:auto; margin-right:auto;",
                                ) do
                                    [
                                        Genie.Renderer.Html.input(
                                            name = "btnSubmit",
                                            class = "final-submit",
                                            id = "btnSubmit",
                                            htmlsourceindent = "6",
                                            value = "Run Algorithm",
                                            type = "submit",
                                        )
                                    ]
                                end
                            ]
                        end
                        """<!-- -------- -->"""
                        """<!--  Output  -->"""
                        """<!-- -------- -->"""
                        Genie.Renderer.Html.div(
                            name = "measurements",
                            htmlsourceindent = "4",
                            id = "measurements",
                            style = "display:none; text-align:left; padding-right:50px; padding-top: 25px",
                        ) do
                            [
                                Genie.Renderer.Html.h3(
                                    htmlsourceindent = "5",
                                    style = "text-align:center",
                                ) do
                                    [
                                        """Measurements""";
                                    ]
                                end
                                Genie.Renderer.Html.div(
                                    name = "hamiltonian_dmrg",
                                    htmlsourceindent = "5",
                                    id = "hamiltonian_dmrg",
                                    style = "display:none;",
                                    value = "$(hamiltonain_measurement)",
                                ) do
                                    [
                                        Genie.Renderer.Html.h4(htmlsourceindent = "6") do
                                            [
                                                """Hamiltonian DMRG""";
                                            ]
                                        end
                                        hamiltonain_measurement
                                    ]
                                end
                                Genie.Renderer.Html.div(
                                    name = "dense_correlation_matrix",
                                    htmlsourceindent = "5",
                                    id = "dense_correlation_matrix",
                                    style = "display:none;",
                                    value = "$(dense_rho_path)",
                                ) do
                                    [
                                        Genie.Renderer.Html.h4(htmlsourceindent = "6") do
                                            [
                                                """Dense Correlation Matrix""";
                                            ]
                                        end
                                        Genie.Renderer.Html.a(
                                            htmlsourceindent = "6",
                                            href = "$(dense_rho_path)",
                                            download = "",
                                        ) do
                                            [
                                                Genie.Renderer.Html.p(
                                                    htmlsourceindent = "7",
                                                ) do
                                                    [
                                                        """Download Output""";
                                                    ]
                                                end;
                                            ]
                                        end
                                    ]
                                end
                                Genie.Renderer.Html.div(
                                    name = "dense_correlation_function",
                                    htmlsourceindent = "5",
                                    id = "dense_correlation_function",
                                    style = "display:none;",
                                    value = "$(dense_correlation_path)",
                                ) do
                                    [
                                        Genie.Renderer.Html.h4(htmlsourceindent = "6") do
                                            [
                                                """Dense Correlation Function""";
                                            ]
                                        end
                                        Genie.Renderer.Html.a(
                                            htmlsourceindent = "6",
                                            href = "$(dense_correlation_path)",
                                            download = "",
                                        ) do
                                            [
                                                Genie.Renderer.Html.p(
                                                    htmlsourceindent = "7",
                                                ) do
                                                    [
                                                        """Download Output""";
                                                    ]
                                                end;
                                            ]
                                        end
                                    ]
                                end
                                Genie.Renderer.Html.div(
                                    name = "dmrg_with_symmetries",
                                    htmlsourceindent = "5",
                                    id = "dmrg_with_symmetries",
                                    style = "display:none;",
                                    value = "$(quantum_measurement)",
                                ) do
                                    [
                                        Genie.Renderer.Html.h4(htmlsourceindent = "6") do
                                            [
                                                """DMRG with Symmetries""";
                                            ]
                                        end
                                        quantum_measurement
                                    ]
                                end
                                Genie.Renderer.Html.div(
                                    name = "symmetry_correlation_matrix",
                                    htmlsourceindent = "5",
                                    id = "symmetry_correlation_matrix",
                                    style = "display:none;",
                                    value = "$(symmetry_rho_path)",
                                ) do
                                    [
                                        Genie.Renderer.Html.h4(htmlsourceindent = "6") do
                                            [
                                                """Symmetry Correlation Matrix""";
                                            ]
                                        end
                                        Genie.Renderer.Html.a(
                                            htmlsourceindent = "6",
                                            href = "$(symmetry_rho_path)",
                                            download = "",
                                        ) do
                                            [
                                                Genie.Renderer.Html.p(
                                                    htmlsourceindent = "7",
                                                ) do
                                                    [
                                                        """Download Output""";
                                                    ]
                                                end;
                                            ]
                                        end
                                    ]
                                end
                                Genie.Renderer.Html.div(
                                    name = "symmetry_correlation_function",
                                    htmlsourceindent = "5",
                                    id = "symmetry_correlation_function",
                                    style = "display:none;",
                                    value = "$(symmetry_correlation_path)",
                                ) do
                                    [
                                        Genie.Renderer.Html.h4(htmlsourceindent = "6") do
                                            [
                                                """Symmetry Correlation Function""";
                                            ]
                                        end
                                        Genie.Renderer.Html.a(
                                            htmlsourceindent = "6",
                                            href = "$(symmetry_correlation_path)",
                                            download = "",
                                        ) do
                                            [
                                                Genie.Renderer.Html.p(
                                                    htmlsourceindent = "7",
                                                ) do
                                                    [
                                                        """Download Output""";
                                                    ]
                                                end;
                                            ]
                                        end
                                    ]
                                end
                            ]
                        end
                    ]
                end
                Genie.Renderer.Html.div(
                    class = "container_div",
                    style = "height: 650px; padding-left: 15px; position:relative; justify-content:center; display:flex; align-items:center; background-color: white;",
                    htmlsourceindent = "3",
                ) do
                    [
                        Genie.Renderer.Html.div(
                            class = "init-hidden",
                            id = "loading_div",
                            style = "text-align:center; position:absolute; z-index:2",
                            htmlsourceindent = "4",
                        ) do
                            [
                                Genie.Renderer.Html.img(
                                    class = "loading_gif",
                                    htmlsourceindent = "5",
                                    src = "/img/runner/DMRG.gif",
                                )
                            ]
                        end
                        Genie.Renderer.Html.canvas(
                            height = "650",
                            htmlsourceindent = "4",
                            id = "pictures",
                            style = "border:1px solid",
                            width = "1000",
                        )
                        Genie.Renderer.Html.div(htmlsourceindent = "4") do
                            []
                        end
                    ]
                end
            ]
        end
        """<!--  Add some spacing  -->"""
        Genie.Renderer.Html.br(htmlsourceindent = "1")
        Genie.Renderer.Html.br(htmlsourceindent = "1")
        Genie.Renderer.Html.br(htmlsourceindent = "1")
        Genie.Renderer.Html.br(htmlsourceindent = "1")
    ]
end

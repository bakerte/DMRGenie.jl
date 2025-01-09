# app/resources/tensornetworkbuilders/views/buildnetwork.jl.html 

function func_85854f8b058f4ea0de81a24459686113f37a1eef(;
    context = Genie.Renderer.vars(:context),
    outputPath = Genie.Renderer.vars(:outputPath),
    error = Genie.Renderer.vars(:error),
)

    [
        Genie.Renderer.Html.title(htmlsourceindent = "2") do
            [
                """Network Builder""";
            ]
        end
        """<!--  JS Packages  -->"""
        Genie.Renderer.Html.script(
            htmlsourceindent = "2",
            src = "/js/Packages/React_v18_3_0.js",
        )
        Genie.Renderer.Html.script(
            htmlsourceindent = "2",
            src = "/js/Packages/ReactDom_v18_3_0.js",
        )
        Genie.Renderer.Html.script(
            htmlsourceindent = "2",
            src = "/js/Packages/Babel_v7_26_4.js",
        )
        Genie.Renderer.Html.script(
            htmlsourceindent = "2",
            src = "/js/Packages/ReactFlow_v11_11_4.js",
        )
        """<!-- 
        		FROM ONLINE - NOT SAFE!!!!
        	  	The frozen packages correspond to these versions
        	 -->"""
        """<!--  <script
        		src="https://www.unpkg.com/react@18.3.0/umd/react.production.min.js"
        		crossorigin
        	></script>
        	<script
        		src="https://unpkg.com/react-dom@18.3.0/umd/react-dom.production.min.js"
        		crossorigin
        	></script>
        	<script
        		src="https://unpkg.com/@babel/standalone@7.26.4/babel.min.js"
        		crossorigin
        	></script>
        	<script
        		src="https://unpkg.com/reactflow@11.11.4/dist/umd/index.js"
        		crossorigin
        	></script>  -->"""
        """<!--  Our JS Code  -->"""
        Genie.Renderer.Html.script(
            htmlsourceindent = "2",
            src = "/js/Builder/TensorNode.js",
            type = "text/babel",
        )
        Genie.Renderer.Html.script(
            htmlsourceindent = "2",
            src = "/js/Builder/InvisibleNode.js",
            type = "text/babel",
        )
        Genie.Renderer.Html.script(
            htmlsourceindent = "2",
            src = "/js/Builder/DimensionEdge.js",
            type = "text/babel",
        )
        Genie.Renderer.Html.script(
            htmlsourceindent = "2",
            src = "/js/Builder/UploadOption.js",
            type = "text/babel",
        )
        Genie.Renderer.Html.script(
            htmlsourceindent = "2",
            src = "/js/Builder/ContractOption.js",
            type = "text/babel",
        )
        Genie.Renderer.Html.script(
            htmlsourceindent = "2",
            src = "/js/Builder/SVDOption.js",
            type = "text/babel",
        )
        Genie.Renderer.Html.script(
            htmlsourceindent = "2",
            src = "/js/Builder/SplitEdges.js",
            type = "text/babel",
        )
        Genie.Renderer.Html.script(
            htmlsourceindent = "2",
            src = "/js/Builder/ConnectEdges.js",
            type = "text/babel",
        )
        Genie.Renderer.Html.script(
            htmlsourceindent = "2",
            src = "/js/Builder/Copy.js",
            type = "text/babel",
        )
        Genie.Renderer.Html.script(
            htmlsourceindent = "2",
            src = "/js/Builder/Paste.js",
            type = "text/babel",
        )
        Genie.Renderer.Html.script(
            htmlsourceindent = "2",
            src = "/js/Builder/Undo.js",
            type = "text/babel",
        )
        Genie.Renderer.Html.script(
            htmlsourceindent = "2",
            src = "/js/Builder/Redo.js",
            type = "text/babel",
        )
        Genie.Renderer.Html.script(
            htmlsourceindent = "2",
            src = "/js/Builder/QROption.js",
            type = "text/babel",
        )
        Genie.Renderer.Html.script(
            htmlsourceindent = "2",
            src = "/js/Builder/LQOption.js",
            type = "text/babel",
        )
        Genie.Renderer.Html.script(
            htmlsourceindent = "2",
            src = "/js/Builder/EigenvalueOption.js",
            type = "text/babel",
        )
        Genie.Renderer.Html.script(
            htmlsourceindent = "2",
            src = "/js/Builder/Lanczos.js",
            type = "text/babel",
        )
        Genie.Renderer.Html.script(
            htmlsourceindent = "2",
            src = "/js/Builder/DNDMenu.js",
            type = "text/babel",
        )
        Genie.Renderer.Html.script(
            htmlsourceindent = "2",
            src = "/js/Builder/ColorMenu.js",
            type = "text/babel",
        )
        Genie.Renderer.Html.script(
            htmlsourceindent = "2",
            src = "/js/Builder/NetworkBuilder.js",
            type = "text/babel",
        )
        Genie.Renderer.Html.div(class = "flex-container1", htmlsourceindent = "2") do
            [
                """<!--  Disgusting Hack! But it should work  -->"""
                Genie.Renderer.Html.div(
                    name = "outputPath",
                    htmlsourceindent = "3",
                    id = "outputPath",
                    value = "$(outputPath)",
                )
                Genie.Renderer.Html.div(
                    name = "backendError",
                    htmlsourceindent = "3",
                    id = "backendError",
                    value = "$(error)",
                )
                Genie.Renderer.Html.div(htmlsourceindent = "3", id = "networkDisplay")
            ]
        end
    ]
end

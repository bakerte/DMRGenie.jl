module Pages
    using Genie.Renderer.Html

    function home()
        html(:pages, :home)
    end

    function tutorial()
        html(:pages, :tutorial)
    end
end
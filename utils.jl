using Dates
"""
    {{addTab "Name" "file.md" "altText" "div-class"}}
"""
function hfun_addTab(params::Vector{String}=String[])
    name = params[1]
    file = params[2]
    ext = file[findlast(isequal('.'),file):end]
    altText = length(params) > 2 ? params[3] : ""
    div_class = length(params) > 3 ? params[4] : ""
    content
    if isfile(file)
        if lowercase(ext) == ".md"
            conent = fd2html(read(file, String); internal=true)
        else
            code_type = ""
            (lowercase(ext) == ".jl") && (code_type="julia")
            (lowercase(ext) == ".py") && (code_type="python")
            (lowercase(ext) == ".m") && (code_type="matlab")
            (lowercase(ext) == ".c") && (code_type="c")
            (lowercase(ext) == ".cpp") && (code_type="cpp")
            content = fd2html("""```$(code_type)
                $(read(file, String))
                ```""")
        end
    else
        conent = fd2html(altText; internal=true)
    end
    entry = Dict("Content" => content, "Name" => name, "Class"=>div_class)
    if isnothing(locvar("manifolds_tabs"))
        Franklin.LOCAL_VARS["manifold_tabs"] = Franklin.dpair([entry])
    else
        manifold_tabs = Franklin.locvar("manifold_tabs")
        push!(manifold_tabs, entry)
        Franklin.set_var!(Franklin.LOCAL_VARS, "manifold_tabs", manifold_tabs)
    end
end
function hfun_printTabs()
    manifold_tabs = Franklin.locvar("manifold_tabs")
    heads = "";
    # heads
    first = true;
    for entry in manifold_tabs
        class_entry = get(entry,"Class","")
        heads = """$heads
            <li class="nav item">
                <a class="nav-link $(first ? "active" : "") $(class_entry)" data-toggle="tab" href="#$(entry["Name"])">$(entry["name"])</a>
            </li>
            """
        first = false
    end
    heads = """<ul class="nav nav-tabs">
        $(heads)
        </ul>
        """
    tabs = ""
    first = true
    for entry in manifold_tabs
        class_entry = get(entry,"Class","")
        tabs = """$(tabs)
        <div class="tab-pane fade $(first ? "active show" : "") $(class_entry)" id="home">

        </div>
        """
        first = false
    end
    tabs = """<div class="tab-content">
        $(tabs)
    </div>
    """
    # clear entries
    Franklin.set_var!(Franklin.LOCAL_VARS, "manifold_tabs", empty(manifold_tabs))
    return """<div class="bs-component">
        $(heads)
        $(tabs)
        </div>"""
end
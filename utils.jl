using Dates
"""
    {{addTab "Name" "file.md" "altText" "label"}}
"""
function hfun_addtab(params)
    name = params[1]
    file = params[2]
    ext = file[findlast(isequal('.'),file):end]
    altText = length(params) > 2 ? params[3] : ""
    label = length(params) > 3 ? params[4] : name
    content = ""
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
            content = """<code class="hightlight-$(code_type)">
                $(read(file, String))
                </code>"""
        end
    else
       conent = fd2html(altText; internal=true)
   end
    entry = Dict("Content" => content, "Name" => name, "Label" => label)
    if isnothing(locvar("manifold_tabs"))
        Franklin.LOCAL_VARS["manifold_tabs"] = Franklin.dpair([entry])
    else
        manifold_tabs = Franklin.locvar("manifold_tabs")
        push!(manifold_tabs, entry)
        Franklin.set_var!(Franklin.LOCAL_VARS, "manifold_tabs", manifold_tabs)
    end
    return ""
end

function hfun_printtabs()
    manifold_tabs = Franklin.locvar("manifold_tabs")
    num = 0
    if !isnothing(Franklin.locvar("manifold_numtab"))
        num = Franklin.locvar("manifold_numtab")+1
        Franklin.set_var!(Franklin.LOCAL_VARS, "manifold_numtab", num)
    else
        Franklin.LOCAL_VARS["manifold_numtab"] = Franklin.dpair(num)
    end
    heads = "";
    # heads
    first = true;
    for entry in manifold_tabs
        class_entry = get(entry,"Class","")
        heads = """$heads
            <li class="nav-item">
                <a class="nav-link$(first ? " active" : "")" data-toggle="tab" href="#$(entry["Label"])$(num)" aria-selected="$(first)">$(entry["Name"])</a>
            </li>
            """
        first = false
    end
    heads = """<ul class="nav nav-tabs" id="ManifoldTab$(num)" role="tablist">
        $(heads)
        </ul>
        """
    tabs = ""
    first = true
    for entry in manifold_tabs
        class_entry = get(entry,"Class","")
        tabs = """$(tabs)
        <div class="tab-pane fade$(first ? " show active" : "")$(class_entry)" id="$(entry["Label"])$(num)" role="tabpanel">
            $(entry["Content"])
        </div>
        """
        first = false
    end
    tabs = """<div class="tab-content" id="ManifoldConent$(num)">
        $(tabs)
    </div>
    """
    # clear entries
    Franklin.set_var!(Franklin.LOCAL_VARS, "manifold_tabs", empty(manifold_tabs))
    return """<div class="bs-component">
        $(heads)
        $(tabs)
        </div>"""
    return ""
end

function hfun_startcolumns(params)
    col_class = length(params) > 0 ? params[1] : ""
    return """<div class="row">
    <div class="col-sm$(length(col_class)>0 ? " " : "")$(col_class)">
    """
end
hfun_startcolumns() = hfun_startcolumns([""])
function hfun_newcolumn(params)
    col_class = length(params) > 0 ? params[1] : ""
    return """</div>
    <div class="col-sm$(length(col_class)>0 ? " " : "")$(col_class)">
    """
end
hfun_newcolumn() = hfun_newcolumn([""])
function hfun_endcolumns()
    return """</div>
    </div>
    """
end
using Dates

function hfun_tabbed(params)
    file_prefix = params[1]
    # (1) Text column and add markdown if it exists
    html = """
        <div class="row">
          <div class="col-sm">
        """
    md_file = string("_code/$(file_prefix).md")
    if isfile(md_file)
        html = """
               $(html)
               $(Franklin.fd2html(read(md_file, String); internal=true))
               """
    end
    html = """
           $(html)
           </div>  <!--end md column -->
           """
    # (2) code tabs
    heads = ""
    tabs = ""
    for (file, logos) in [
        ("$(file_prefix).jl", ["julia_src"]),
        ("$(file_prefix).m", ["matlab_src"]),
        ("$(file_prefix).py", ["python_src"]),
        ("$(file_prefix)_pt.py", ["python_src", "pytorch_src"]),
        ("$(file_prefix)_tf.py", ["python_src", "tensorflow_src"]),
    ]
        t, c = code_column(file, logos)
        heads = "$(heads)\n$(t)"
        tabs = "$(tabs)\n$(c)"
    end
    html = """$html
        ~~~
        <div class="col-sm">
        <div class="bs-component">
        <ul class="nav nav-tabs" id="ManifoldTab$(file_prefix)" role="tablist">
        $(heads)
        </ul>
        <div class="tab-content" id="ManifoldConent$(file_prefix)">
        $(tabs)
        </div>
        </div>
        </div><!-- end row -->
        </div><!-- end rows -->
        """
    return html
end

# A code tab if $file exists, print $logos and/or $text in tab title
function code_column(file, logos=String[], text="", subfolder="")
    full_file = "_code/$subfolder$file"
    ext = file[findlast(isequal('.'),file):end]
    ext = ext[2:end] # remove dot
    pre = file[1:findlast(isequal('.'),file)]
    pre = pre[1:end-1]
    code_type = ""
    (lowercase(ext) == "jl") && (code_type="julia")
    (lowercase(ext) == "py") && (code_type="python")
    (lowercase(ext) == "m") && (code_type="matlab")
    (lowercase(ext) == "c") && (code_type="c")
    (lowercase(ext) == "cpp") && (code_type="cpp")
    content = "";
    if isfile(full_file)
        content = """<div class="tab-pane fade" id="$(pre)$(ext)" role="tabpanel">
            <pre><code class="hightlight-$(code_type)">
            $(read(full_file, String))
            </code></pre>
            </div>
            """
        logos = string(["""<img class='icon' src='../assets/icons/$(logo).png' alt='$(logo)'/>""" for logo in logos]...)
        tab = """<li class="nav-item">
            <a class="nav-link" data-toggle="tab" href="#$(pre)$(ext)" aria-selected="false">
                $(logos)$(text)
            </a>
            </li>
            """
        return tab, content
    end
    return "", ""
end
"""
    {{addTab "Name" "file.md" "icon" "label"}}
"""
function hfun_addtab(params)
    name = params[1]
    file = params[2]
    ext = file[findlast(isequal('.'),file):end]
    icon = length(params) > 2 ? params[3] : ""
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
            content = """<pre><code class="hightlight-$(code_type)">
                $(read(file, String))
                </code></pre>"""
        end
    else
        @warn "Entry $(file) ignored, since the file seems to be missing"
   end
    entry = Dict("Content" => content, "Name" => name, "Label" => label, "Icon" => icon)
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
        icon_html = get(entry,"Icon", "") == 0 ? "" : """<img class='icon' src='assets/icons/$(entry["Icon"]).png'/>"""
        heads = """$heads
            <li class="nav-item">
                <a class="nav-link$(first ? " active" : "")" data-toggle="tab" href="#$(entry["Label"])$(num)" aria-selected="$(first)">
                $(icon_html)$(entry["Name"])
                </a>
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

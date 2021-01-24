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
               $(fd2html(read(md_file, String); internal=true))
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
        content = """<div class="tab-pane fade" id="$(pre)$(ext)" role="tabpanel">""" *
                  fd2html("""
                         ```$(code_type)
                         $(read(full_file, String))
                         ```
                         """, internal=true) *
                "</div>"
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

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
            <div class="pt-3 text-center tab-pane fade active show" id="info-code-$(file_prefix)" role="tabpanel">
                Select your favourite code tab above or choose a global preference in the menu <i class="fa fa-language"/></i>.
            </div>
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
    subInd = findfirst(isequal('_'),file)
    suffixInd = findlast(isequal('.'),file)
    suffix = file[suffixInd+1:end]
    ext = ""
    pre = ""
    if !isnothing(subInd) # sub version
        ext = file[subInd+1:end]
        ext = replace(replace(ext, "_" => "-"), "." => "-")
        pre = file[1:subInd-1]
    else
        ext = file[findlast(isequal('.'),file)+1:end]
        pre = file[1:suffixInd-1]
    end
    code_type = ""
    title = ""
    if lowercase(suffix) == "jl"
        code_type="julia"
        title = "Julia"
    end
    if lowercase(suffix) == "py"
        code_type="python"
        title = "Python"
        (startswith(lowercase(ext),"tf")) && (title = "$title & Tensorflow")
        (startswith(lowercase(ext),"pt")) && (title = "$title & PyTorch")
    end
    if lowercase(suffix) == "m"
        code_type="matlab"
        title = "Matlab"
    end
    if lowercase(suffix) == "c"
        code_type="c"
        title = "C"
    end
    if lowercase(suffix) == "cpp"
        code_type="cpp"
        title = "C++"
    end
    content = "";
    if isfile(full_file)
        content = """<div class="tab-pane fade" id="$(pre)-$(ext)" role="tabpanel">""" *
                  fd2html("""
                         ```$(code_type)
                         $(read(full_file, String))
                         ```
                         """, internal=true) *
                "</div>"
        logos = string(["""<img class='icon' src="/assets/icons/$(logo).png"/>""" for logo in logos]...)
        tab = """<li class="nav-item">
            <a class="nav-link code-tab-$(ext)" data-toggle="tab" href="#$(pre)-$(ext)" title="$title" aria-selected="false">
                $(logos)$(text)
            </a>
            </li>
            """
        return tab, content
    end
    return "", ""
end

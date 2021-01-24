@@ -0,0 +1,28 @@
<!--
Add here global page variables to use throughout your
website.
The website_* must be defined for the RSS to work
-->
@def website_title = "Manifold Tutorials"
@def website_descr = "Examples for numerical methods involving manifold"
@def website_url   = "https://ronnybergmann.net/ManifoldTutorials/"

@def author = "Ronny Bergmann"

@def mintoclevel = 2

<!--
Add here files or directories that should be ignored by Franklin, otherwise
these files might be copied and, if markdown, processed by Franklin which
you might not want. Indicate directories by ending the name with a `/`.
-->
@def ignore = ["node_modules/", "franklin", "franklin.pub", "_code/"]

<!--
Add here global latex commands to use throughout your
pages. It can be math commands but does not need to be.
For instance:
* \newcommand{\phrase}{This is a long phrase to copy.}
-->
\newcommand{\R}{\mathbb R}
\newcommand{\scal}[1]{\langle #1 \rangle}
\newcommand{\cM}{\mathcal M}
\newcommand{\transp}{\mathrm{T}}

\newcommand{\bootstrapbox}[2]{
~~~
<div class="alert alert-dismissible alert-primary">
  <strong>#1</strong>#2
</div>
~~~
}
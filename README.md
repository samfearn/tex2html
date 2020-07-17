# tex2html
This repository contains files to be used with pandoc for converting from tex to html.

This is currently work in progress and only really intended for private use.

## Usage

The idea is to create a simple process for creating html lecture notes from tex source. [Pandoc] is used to do the conversion, all that is being added is a filter for handling some named environments, javascript for customising the numbering of environments and references to these and some configuration defaults. The resulting html is styled using a slightly modified version of [latex-css].

To convert `source.tex` into html (with a default filename of `pandoc_converted.html`) the contents of this repository should first be cloned into the working directory, alongside `source.tex` (Using `git clone https://github.com/samfearn/tex2html.git`). Pandoc is then run using the command

~~~
pandoc source.tex -d tex2html
~~~

## Configuration ##

I like to use `\graphicspath{{./Images/}}` in latex, to load images from a subfolder called `Images` relative to the source `.tex` file. In order to replicate this with Pandoc, the html template loads a script which relabels the urls. This is controlled by a variable in `tex2html.yml` called `imageDir`; rename this if you would like to store your images in a different directory, or set it to be the empty string if you'd prefer your images to be in the same folder as your source `.tex` file.

[latex-css]:https://latex.now.sh
[Pandoc]:https://pandoc.org/MANUAL.html
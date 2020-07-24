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

I like to use `\graphicspath{{./Images/}}` in latex, to load images from a subfolder called `Images` relative to the source `.tex` file. In order to replicate this with Pandoc, the html template loads a script which relabels the urls. This is controlled by a variable in `tex2html.yaml` called `imageDir`; rename this if you would like to store your images in a different directory, or leave this line of the configuration file commented out if you'd prefer your images to be in the same folder as your source `.tex` file.

The html template automatically loads a script which numbers the supported environments in the html. In `tex2html.yaml`, there is a variable called `numberWithinLevel` which controls which level of heading the environments are numbered with respect to (default: 1, corresponding to within Section). There is also a variable called `environmentCounters` that controls which environments share a counter. By default, all named supported environments (theorem, lemma, example, definition) share the same counter, but you may multiple counters here following the format used for `counter1` -- the name of the counter is unimportant (but all counter names should be unique).

[latex-css]:https://latex.now.sh
[Pandoc]:https://pandoc.org/MANUAL.html
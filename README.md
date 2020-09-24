# tex2html
This repository contains files to be used with pandoc for converting from tex to html.

This is work in progress - please report any issues using the github issue tracker.

## Usage

The idea is to create a simple process for creating html lecture notes from tex source. [Pandoc] is used to do the conversion, all that is being added is a filter for handling some named environments, javascript for customising the numbering of environments and references to these and some configuration defaults. The resulting html is styled using a slightly modified version of [latex-css].

One of the features added to pandoc with the filters in this repository is support for additional latex environments, namely `theorem, proof, lemma, proposition, corollary, definition, example, remark, framed` and `center`. In order for these to work, specific definitions for these environments need to be added to the end of the head of your latex file. Each of these should be of the form:
~~~
\newenvironment{theorem}
	{\begin{verse}
	Theorem:
	}
	{\end{verse}}
~~~
A full set of definitions is provided in [this gist][latexgist]; these can simply be copied to the end of the head of your latex file.

**Note:** You will probably want to comment out these lines from your latex file if you want to run `pdflatex` on your file after adding these definitions. If you have already defined environments with the same name as any of these above environments, you can either comment out your previous definitions before using pandoc, or use `\renewenvironment` rather than `\newenvironment` as appropriate.

To convert `source.tex` into html (with a default filename of `pandoc_converted.html`) the contents of this repository should first be cloned into the working directory, alongside `source.tex` (Using `git clone https://github.com/samfearn/tex2html.git`). Pandoc is then run using the command

~~~
pandoc source.tex -d tex2html
~~~

An example latex file, along with the corresponding images, is available from [this repository]. This example also shows how to add the required latex environment definitions.

## Configuration ##

I like to use `\graphicspath{{./Images/}}` in latex, to load images from a subfolder called `Images` relative to the source `.tex` file. In order to replicate this with Pandoc, the html template loads a script which relabels the urls. This is controlled by a variable in `tex2html.yaml` called `imageDir`; rename this if you would like to store your images in a different directory, or leave this line of the configuration file commented out if you'd prefer your images to be in the same folder as your source `.tex` file.

The html template automatically loads a script which numbers the supported environments in the html. In `tex2html.yaml`, there is a variable called `numberWithinLevel` which controls which level of heading the environments are numbered with respect to (default: 1, corresponding to within Section). There is also a variable called `environmentCounters` that controls which environments share a counter. By default, all named supported environments (theorem, lemma, example, definition, proposition) share the same counter, but `tex2html.yaml` contains a commented-out example showing how to use a separate counter for different environments.

The template loads a stylesheet based on [latex-css] which is available from [here][latex.min.css]. If you would like to add additional custom css, there is an option within the configuration file for specifying a local css file. The local css file is loaded after the external stylesheet, so can be used to overwrite any styles defined in the external stylesheet. 

[this repository]:https://github.com/annetaormina/Latex-code-and-images
[latexgist]:https://gist.github.com/samfearn/3b50a5c579920084e4d1fa7c51eba0c5
[latex.min.css]:http://samfearn.github.io/latex.min.css
[latex-css]:https://latex.now.sh
[Pandoc]:https://pandoc.org/MANUAL.html
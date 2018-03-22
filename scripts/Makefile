# This is a Makefile script file to convert tm file writen by Texmacs to tex file that can be
# compiled by Latex to obtain final PDF file.
SRC	=	main
all:	tm sub tex
tm:
	texmacs -c $(SRC).tm $(SRC).tex -q # -q: quit Texmacs, -c: command line
sub:
	sed -i  -e 's/\\documentclass\[\([^]]*\)\]{\([^}]*\)}/\\documentclass[english,aps,pra,showpacs,superscriptaddress,reprint,twocolumns]{\2}/' \
		-e '/\\begin{thebibliography}/,/\\end{thebibliography}/{/\\end{thebibliography}/ s/.*/\\bibliographystyle{apsrev4-1}\n\\bibliography{main}/; t; d}' \
		-e '/{\\figure\*{\\begin{figure}\[h\]/,/\\end{figure}}}/{s/{\\figure\*{\\begin{figure}\[h\]/\\begin{figure\*}/; s/\\end{figure}}}/\\end{figure\*}/}' \
		-e 's/\\resizebox{[[:digit:]]\+px}{!}{\\includegraphics{\([^}]*\)}}/\\includegraphics[width=0.5\\textwidth]{\1}/' \
		-e 's/``\([^\x27]*\)\x27\x27/"\1"/' \
		-e '/%%%%%%%%%% Start TeXmacs macros/,/%%%%%%%%%% End TeXmacs macros/d' \
		-e 's/\\tmmathbf/\\boldsymbol/' \
		-e 's/^\\geometry.*//' \
		-e '/\\begin{tabular}{l|l}/,/\\end{tabular}/{/\\end{tabular}/ s/.*/\\begin{widetext}/; t; d}' \
		-e '/\\begin{tabular}{ll}/,/\\end{tabular}/{/\\end{tabular}/ s/.*/\\end{widetext}/; t; d}' \
		-e 's/\\usepackage{\([^}]*\)}/% \\usepackage[T1]{fontenc}\n% \\usepackage[latin9]{inputenc}\n\\usepackage{euler,amsmath,amssymb,graphicx,mathrsfs,xcolor,babel,textcomp,esint}\n\\usepackage[unicode=true,pdfusetitle,bookmarks=true,bookmarksnumbered=false,bookmarksopen=false,breaklinks=true,pdfborder={0 0 0},backref=false,colorlinks=true]{hyperref}\n\\makeatletter\n\\makeatother/' $(SRC).tex
tex:
	pdflatex $(SRC).tex
	bibtex $(SRC)
	pdflatex $(SRC).tex
	pdflatex $(SRC).tex
clean:
	rm -f $(SRC).aux
	rm -f $(SRC).blg
	rm -f $(SRC).log
	rm -f $(SRC)Notes.bib

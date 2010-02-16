.SUFFIXES: .latex .tex .dvi .ps .pdf .idx .ind .eps .jpg .ly .png .svg

.tex.idx :
	latex $<
.tex.dvi :
	latex $<
.dvi.ps : %.dvi
	cd `dirname $<` && dvips -Ppdf -o `basename $@` `basename $<`
.tex.pdf:
	pdflatex $<
.ps.pdf :
	ps2pdf $<
.svg.eps:
	inkscape --export-area-drawing --export-eps $@ $<
.idx.ind :
	makeindex $<
.ly.eps :
	cd `dirname $<` && lilypond -b eps `basename $<`
.eps.pdf :
	epstopdf --outfile=$@ $<

.jpg.eps:
	convert $< $@
.png.eps:
	convert $< $@

ALL_FIGURES=

LESS_CANONICAL_FIGURES= $(patsubst %.gp,%.eps, \
			$(patsubst %.svg,%.eps, \
                        $(patsubst %.xgr,%.eps, \
                        $(patsubst %.pl,%.eps, $(ALL_FIGURES)))))
FIGURES=$(patsubst %.jpg,%.eps, \
        $(patsubst %.png,%.eps,$(LESS_CANONICAL_FIGURES)))
PDF_FIGURES=$(patsubst %.eps,%.pdf, \
                        $(LESS_CANONICAL_FIGURES))

all: formula_si.pdf formula_gaussian.pdf

formula_si.tex: formula_sheet.tex
	cat < $< > $@

formula_gaussian.tex: formula_sheet.tex
	perl -pe 's/#1} % SI/#2} % gaussian/' < $< > $@

clean:
	rm -f *.dvi *.toc *.aux *.latex *.mix *.log *.ps *.pdf

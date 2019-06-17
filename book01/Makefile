MAIN = book01.pdf
SRC = chapter01.tex chapter02.tex chapter03.tex chapter04.tex chapter05.tex chapter06.tex appendix01.tex

DVI = $(SRC:.tex=.dvi)
PDF = $(SRC:.tex=.pdf)

.SUFFIXES : .tex .dvi .pdf

all: $(MAIN)

$(MAIN): $(PDF)

.tex.dvi:
	platex $<
	platex $<

.dvi.pdf:
	dvipdfmx $<

.PHONY : clean
clean:
	-rm -f $(PDF)
	-rm -f $(DVI)
	-rm -f *.aux
	-rm -f *.log
	-rm -f *~
	-rm -f $(MAIN)
	-rm -f $(MAIN:.pdf=.dvi)

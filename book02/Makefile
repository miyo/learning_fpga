MAIN = book02.pdf
SRC = chapter07.tex chapter08.tex chapter09.tex chapter10.tex

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

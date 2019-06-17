SRC = chapter11.tex chapter12.tex chapter13.tex chapter14.tex

DVI = $(SRC:.tex=.dvi)
PDF = $(SRC:.tex=.pdf)

.SUFFIXES : .tex .dvi .pdf

all: $(PDF)

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

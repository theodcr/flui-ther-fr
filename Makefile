# pdflatex with makeindex for nomenclature
# first compilation : 'make nomenclature' then 'make once'
# then 'make once' is enough


# continuously recompiles using latexmk
# or just run make once.

LATEX = pdflatex
#LATEX = xelatex
LATEXOPT = --shell-escape
NONSTOP = --interaction=nonstopmode

LATEXMK = latexmk
LATEXMKOPT = -pdf -synctex=1  # -synctex=1 if nomenclature
CONTINUOUS = -pvc

MAIN = main
SOURCES = $(MAIN).tex Makefile files/*  # yourothertexfiles
FIGURES := $(shell find figures/* images/* -type f)

all:    $(MAIN).pdf

.refresh:
	touch .refresh

$(MAIN).pdf: $(MAIN).tex .refresh $(SOURCES) $(FIGURES)
	$(LATEXMK) $(LATEXMKOPT) $(CONTINUOUS) \
	-pdflatex="$(LATEX) $(LATEXOPT) $(NONSTOP) %O %S" $(MAIN)

force:
	touch .refresh
	rm $(MAIN).pdf
	$(LATEXMK) $(LATEXMKOPT) $(CONTINUOUS) \
	-pdflatex="$(LATEX) $(LATEXOPT) %O %S" $(MAIN)

# clean : option -C deletes .div and .pdf, -c doesnt

clean:
	$(LATEXMK) -c $(MAIN)
	rm -f $(MAIN).pdfsync
	rm -rf *~ *.tmp
	rm -f *.bbl *.blg *.aux *.end *.fls *.log *.nlg *.nls *.out *.fdb_latexmk *.nav *.snm *.synctex.gz
# *.synctex.gz

once:
	$(LATEXMK) $(LATEXMKOPT) -pdflatex="$(LATEX) $(LATEXOPT) %O %S" $(MAIN)

nomenclature:
	makeindex $(MAIN).nlo -s nomencl.ist -o $(MAIN).nls -t $(MAIN).nlg

debug:
	$(LATEX) $(LATEXOPT) $(MAIN)

.PHONY: clean force once nomenclature all

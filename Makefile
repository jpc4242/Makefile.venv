#
# PELICAN RULES
#

STORAGE?=$(CURDIR)

PELICAN=pelican
INPUTDIR=$(STORAGE)/demo-input
OUTPUTDIR=$(STORAGE)/demo-output
CONFIG=pelican_demo.py
PORT=8000
EXTRAS=


.PHONY: demo
demo: venv
	[ -d "$(INPUTDIR)" ] || mkdir -p "$(INPUTDIR)"
	$(VENV)/$(PELICAN) $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFIG) $(EXTRAS)


.PHONY: test
test: venv
	$(VENV)/python -m unittest


.PHONY: clean
clean:
	[ ! -d $(OUTPUTDIR) ] || rm -rf $(OUTPUTDIR)


.PHONY: serve
serve: venv
	cd $(OUTPUTDIR) && $(VENV)/python -m pelican.server $(PORT)


#
# VIRTUAL ENVIRONMENT RULES
#


PY?=python3
VENVDIR=$(STORAGE)/.venv


ifdef OS
	VENV=$(VENVDIR)/Scripts
	EXE=.exe
else
	VENV=$(VENVDIR)/bin
	EXE=
endif


$(VENV)/activate: setup.py
	$(PY) -m venv $(VENVDIR)
	$(VENV)/python -m pip install --upgrade pip
	$(VENV)/pip install -e .
	touch $(VENVDIR)/activate


.PHONY: venv
venv: $(VENV)/activate


$(VENV)/ipython$(EXE): $(VENV)/activate
	$(VENV)/pip install --upgrade ipython
	touch $(VENV)/ipython$(EXE)


.PHONY: ipython
ipython: $(VENV)/ipython$(EXE)
	$(VENV)/ipython


.PHONY: python
python: venv
	$(VENV)/python

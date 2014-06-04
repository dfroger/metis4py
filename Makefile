default: ext

ext:
	python setup.py build_ext --inplace

test:
	python main.py

METIS_DIR = /local/froger/opt/metis/5.1.0-debug
#METIS_DIR = /local/froger/opt/metis/5.1.0

main: main.o
	gcc -g -o $@ $< -L$(METIS_DIR)/lib -Wl,-R$(METIS_DIR)/lib -lmetis

main.o: main.c
	gcc -g -c $< -I$(METIS_DIR)/include

clean:
	rm -rf build metis4py_wrap.cpp metis4py.py metis4py.pyc _metis4py.so main.o main

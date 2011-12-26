CC   = gcc
COPT = -std=c99 -Wall -O3 -msse2 -finline-functions -fomit-frame-pointer \
       -fno-strict-aliasing --param max-inline-insns-single=1800 \
       -Wmissing-prototypes --param inline-unit-growth=500 \
       --param large-function-growth=900 -DHAVE_SSE2 -DDSFMT_MEXP=19937 \
       -march=native -DNDEBUG

dSFMTDIR = ../dSFMT-src-2.1

all: test_c1 test_c2 test_ocaml test_ocaml_random

../dSFMT_c.o: 
	cd .. ; make

test_c1: test_c1.c ../dSFMT_c.o
	$(CC) $(COPT) -I$(dSFMTDIR) -o $@ $^

test_c2: test_c2.c ../dSFMT_c.o
	$(CC) $(COPT) -I$(dSFMTDIR) -o $@ $^

../libdsfmt.a:
	cd .. ; make

../dsfmt.cmx:
	cd .. ; make

test_ocaml: ../libdsfmt.a ../dsfmt.cmx test_ocaml.ml
	ocamlopt -inline 2 -I .. $^ -o $@

test_ocaml_random: test_ocaml_random.ml
	ocamlopt -inline 2 $< -o $@

clean:
	rm test_c1 test_c2 test_ocaml test_ocaml.cmi test_ocaml.o \
           test_ocaml.cmx test_ocaml_random test_ocaml_random.cmi \
           test_ocaml_random.o test_ocaml_random.cmx

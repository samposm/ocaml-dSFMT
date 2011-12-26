OCAMLPATH = /usr/lib/ocaml

CC   = gcc
COPT = -std=c99 -Wall -O3 -msse2 -finline-functions -fomit-frame-pointer \
       -fno-strict-aliasing --param max-inline-insns-single=1800 \
       -Wmissing-prototypes --param inline-unit-growth=500 -DNDEBUG \
       --param large-function-growth=900 -DHAVE_SSE2 -DDSFMT_MEXP=19937 \
       -march=native

dSFMTDIR = dSFMT-src-2.1

all: dsfmt.cmi dsfmt.cmo dsfmt.cma dlldsfmt.so \
     dsfmt.o dsfmt.cmx dsfmt.a dsfmt.cmxa libdsfmt.a

dSFMT-src-2.1.tar.gz:
	wget http://www.math.sci.hiroshima-u.ac.jp/~m-mat/bin/dl/dl.cgi?SFMT:dSFMT-src-2.1.tar.gz \
	-O $@

dSFMT-src-2.1: dSFMT-src-2.1.tar.gz
	tar zxf $<

$(dSFMTDIR)/dSFMT.c: dSFMT-src-2.1
$(dSFMTDIR)/dSFMT.h: dSFMT-src-2.1

# name dSFMT_c.o instead of dSFMT.o if someone has non-case-sensitive system
dSFMT_c.o: $(dSFMTDIR)/dSFMT.c $(dSFMTDIR)/dSFMT.h \
           $(dSFMTDIR)/dSFMT-params.h $(dSFMTDIR)/dSFMT-params19937.h 
	$(CC) $(COPT) -c $< -o $@

dsfmt-wrap.o: dsfmt-wrap.c $(dSFMTDIR)/dSFMT.h
	$(CC) $(COPT) -I$(OCAMLPATH) -I$(dSFMTDIR) -c $<

dsfmt.cmi dlldsfmt.so dsfmt.cmo dsfmt.cma libdsfmt.a dsfmt.o dsfmt.cmx \
dsfmt.a dsfmt.cmxa: dsfmt.ml dsfmt-wrap.o dSFMT_c.o
	ocamlmklib -v -ocamlopt "ocamlopt -inline 2" -o dsfmt $^

# other possible optimization options:
# ocamlopt -linkall -nodynlink -unsafe -noassert

clean:
	rm dsfmt-wrap.o dSFMT_c.o \
           dsfmt.cmi dsfmt.cmo dsfmt.cma dlldsfmt.so \
           dsfmt.o dsfmt.cmx dsfmt.a dsfmt.cmxa libdsfmt.a

OCAMLC=ocamlc
OCAMLOPT=ocamlopt
OCAMLDEP=ocamldep
INCLUDES=                 # all relevant -I options here
OCAMLFLAGS=$(INCLUDES)    # add other options for ocamlc here
OCAMLOPTFLAGS=$(INCLUDES) # add other options for ocamlopt here

# prog1 should be compiled to bytecode, and is composed of three
# units: mod1, mod2 and mod3.

OBJS=Puzzle.cmo Solve.cmo main.cmo
OBJSX=Puzzle.cmx Solve.cmx main.cmx

main: $(OBJS)
	$(OCAMLC) -o main $(OCAMLFLAGS) $(OBJS)

main.opt: $(OBJSX)
	$(OCAMLOPT) -o main.opt $(OCAMLOPTFLAGS) $(OBJSX)

# Common rules
.SUFFIXES: .ml .mli .cmo .cmi .cmx

.ml.cmo:
	$(OCAMLC) $(OCAMLFLAGS) -c $<

.mli.cmi:
	$(OCAMLC) $(OCAMLFLAGS) -c $<

.ml.cmx:
	$(OCAMLOPT) $(OCAMLOPTFLAGS) -c $<

# Clean up
clean:
	rm -f main main.opt
	rm -f *.cm[iox] *.o

include depend

DC=dmd
DFLAGS=-g
OBJECTS = $(patsubst %.d, %.o, $(wildcard *.d))

libscp.so: *.d
	@$(DC) -I../ $(DFLAGS) -shared -of$@ *.d

%.o : %.d
	@$(DC) -c $(DFLAGS) $< -of $@

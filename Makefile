AS=yasm
ASFLAGS=-f elf64 -m amd64 -g dwarf2

SOURCE=$(wildcard src/*.asm)
OBJECT=$(SOURCE:.asm=.o)

euler: $(OBJECT)
	ld -o euler $^

%.o: %.asm
	$(AS) $(ASFLAGS) -o $@ $<

clean:
	rm -f $(OBJECT)
	rm -f *~ src/*~
	rm -f euler
.PHONY: clean

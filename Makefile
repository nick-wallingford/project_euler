AS := yasm
ASFLAGS := -f elf64 -m amd64 -g dwarf2

SOURCE := $(wildcard src/*.asm)
OBJECT := $(SOURCE:.asm=.o)

TEST_SRC := $(wildcard src/test/*.c)
TEST_OBJ := $(TEST_SRC:.c=.o)

CFLAGS += -std=gnu11

euler: $(OBJECT)
	ld -o euler $^

test: $(TEST_OBJ) $(filter-out src/main.o,$(OBJECT))
	$(CC) $(CFLAGS) -o $@ $^

%.o: %.asm
	$(AS) $(ASFLAGS) -o $@ $<

clean:
	rm -f $(TEST_OBJ)
	rm -f $(OBJECT)
	rm -f *~ src/*~
	rm -f euler
.PHONY: clean

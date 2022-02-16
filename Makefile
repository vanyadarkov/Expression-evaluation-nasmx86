CC=gcc
CFLAGS=-m32 -fno-pie -no-pie
ASM=nasm
ASMFLAGS=-f elf32

build: checker

check:
	./check.sh

checker: checker.o expr.o
	$(CC) $(CFLAGS) -o $@ $^

checker.o: checker.c
	$(CC) -c $(CFLAGS) -o $@ $^

expr.o: expr.asm
	$(ASM) $(ASMFLAGS) $< -o $@

copy:
	if [ -f ../../task4.asm ]; then cp ../../task4.asm .; else cp ../task4.asm .; fi

clean:
	rm *.o checker

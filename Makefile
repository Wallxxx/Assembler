all:
	nasm -f elf $(file).asm
	ld -m elf_i386 -s -o $(file) $(file).o
	rm $(file).o
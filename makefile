all: bootlaoder

bootlaoder:
	nasm boot/boot.asm -f bin -o boot/bin/boot.bin
	nasm boot/kernel_entry.asm -f elf -o boot/bin/kernel_entry.bin

	gcc -m32 

clear:
	rm -f boot/boot.img

run:
	qemu-system-x86_64 -L "C:/Program Files/qemu" -m 64 -fda ./boot/boot.img
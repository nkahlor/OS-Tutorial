# Automatically generate lists of sources using wildcards
C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h)

# TODO make sources depend on all header files

# Convert the *.c filenames to *.o to give a list of object files to build
OBJ = ${C_SOURCES:.c=.o}

# Default build target
all: os-image

# Run qemu to simulate booting of code
run: all
	qemu-system-x86_64 -fda os-image

# This is the disk image that the computer loads, which is a combination
# of the compiled bootsector and kernel
os-image: boot/boot_sect.bin kernel.bin
	cat $^ > os-image

# This builds the binary of our kernel from two obj files:
# - the kernel_entry, which jumps to main() in our kernel
# - the compiled C kernel
kernel.bin: boot/kernel_entry.o ${OBJ}
	ld -m elf_i386 -s -o $@ -Ttext 0x1000 $^ --oformat binary

# Generic rule for compiling C code to an obj file
%.o: %.c ${HEADERS}
	gcc -m32 -ffreestanding -c $< -o $@

# Assemble the kernel_entry
%.o: %.asm
	nasm $< -f elf32 -o $@

%.bin: %.asm
	nasm $< -f bin -I './boot/' -o $@

clean:
	rm -fr *.bin *.dis *.o os-image
	rm -fr kernel/*.o boot/*.bin drivers/*.o boot/*.o

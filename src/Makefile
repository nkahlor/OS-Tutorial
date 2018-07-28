# Automatically generate lists of sources using wildcards
C_SOURCES = $(wildcard kernel/*.c drivers/*.c cpu/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h cpu/*.h)

# TODO make sources depend on all header files

# Convert the *.c filenames to *.o to give a list of object files to build
OBJ = ${C_SOURCES:.c=.o cpu/interrupt.o}

# Default build target
all: os-image.img

# Run qemu to simulate booting of code
run: all
	qemu-system-i386 -fda os-image.img

# This is the disk image that the computer loads, which is a combination
# of the compiled bootsector and kernel
os-image.img: boot/boot_sect.bin kernel.bin
	cat $^ > os-image.img

# This builds the binary of our kernel from two obj files:
# - the kernel_entry, which jumps to main() in our kernel
# - the compiled C kernel
kernel.bin: boot/kernel_entry.o ${OBJ}
	i686-elf-ld -o $@ -Ttext 0x1000 $^ --oformat binary

kernel.elf: boot/kernel_entry.o ${OBJ}
	i686-elf-ld -o $@ -Ttext 0x1000 $^

debug: os-image.img kernel.elf
	qemu-system-i386 -s -fda os-image.img &
	${GDB} -ex "target remote localhost:1234" -ex "symbol-file kernel.elf"

# Generic rule for compiling C code to an obj file
%.o: %.c ${HEADERS}
	i686-elf-gcc -m32 -ffreestanding -c $< -o $@

# Assemble the kernel_entry
%.o: %.asm
	nasm $< -f elf32 -o $@

%.bin: %.asm
	nasm $< -f bin -I './boot/' -o $@

clean:
	rm -fr *.bin *.dis *.o os-image.img
	rm -fr kernel/*.o boot/*.bin drivers/*.o boot/*.o

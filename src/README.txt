NOTE THAT THESE COMMANDS ARE ONLY GUARANTEED TO WORK ON A LINUX MACHINE

Assemble .asm code to binary format
$nasm <file.asm> -f bin -o <file.bin>

Assemble .asm code to object format
$nasm <file.asm> -f elf -o <file.o>

Link .o code into .bin code
$ld -o <file.bin> -Ttext 0x1000 <1 or more .o files> --oformat binary

Construct kernal image file
cat boot_sect.bin kernel.bin > os-image

Run Code on qemu
$qemu-system-x86_64 -fda <file.bin>

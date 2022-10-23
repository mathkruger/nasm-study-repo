nasm -f elf64 ./src/$1.asm -o ./dist/$1.o
ld ./dist/$1.o -o ./dist/$1
./dist/$1
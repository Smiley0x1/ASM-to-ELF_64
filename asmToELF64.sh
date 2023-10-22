#!/bin/bash

# Check if an argument is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <input.asm>"
    exit 1
fi

# Get the input ASM file from the first argument
input_asm="$1"

# Check if the input file exists
if [ ! -e "$input_asm" ]; then
    echo "Input file '$input_asm' does not exist."
    exit 1
fi

# Extract the base name (without extension) of the input file
base_name="${input_asm%.*}"

# Assemble the input ASM file using NASM with the "elf64" format
nasm -f elf64 "$input_asm" -o "${base_name}.o"

# Check if the object file was successfully created
if [ -e "${base_name}.o" ]; then
    # Link the object file into an ELF executable using the GNU linker (ld)
    ld -m elf_x86_64 "${base_name}.o" -o "${base_name}"
 
   # Check if the ELF file was successfully created
    if [ -e "${base_name}" ]; then
        echo "Conversion successful. ELF64 file '${base_name}' created."
        rm "${base_name}.o"
    else
        echo "Linking failed. Check the input file and assembly code."
    fi
else
    echo "Assembly failed. Check the input file and assembly code."
fi


import argparse

def split_instruction(instruction):
    """Split a 32-bit instruction into four 8-bit bytes."""
    return [
        (instruction >> 0) & 0xFF,
        (instruction >> 8) & 0xFF,
        (instruction >> 16) & 0xFF,
        (instruction >> 24) & 0xFF
    ]

def assemble_to_mem(input_file, output_file, testcase_description, hex_dump_file=None, mem_depth=64):
    with open(input_file, 'r') as infile, open(output_file, 'w') as outfile:
        hex_outfile = open(hex_dump_file, 'w') if hex_dump_file else None

        # Write the testcase description with formatting
           
        outfile.write("`include \"system_param.vh\"\n")
        outfile.write("//***************************************************************\n")
        outfile.write(f"//  T e s t c a s e : {testcase_description}\n")
        outfile.write("//***************************************************************\n\n")
        outfile.write("initial begin \n");

        # Initialize memory address counter
        mem_counter = 0
        
        for line in infile:
            parts = line.split()
            if len(parts) < 2 or len(parts[1]) != 10:
                continue

            code = int(parts[1], 16)
            bytes_list = split_instruction(code)

            outfile.write(f"// {' '.join(parts[2:])}\n")

            for i, byte in enumerate(bytes_list):
                if mem_counter >= mem_depth:
                    break  # Stop writing if memory limit reached
                outfile.write(f"Mem[{mem_counter}] = 8'h{byte:02x};\n")
                
                if hex_outfile:
                    hex_outfile.write(f"{byte:02x}\n")
                
                mem_counter += 1

            outfile.write("\n")
            if mem_counter >= mem_depth:
                break  # Stop processing if memory limit reached

        # Fill up remaining memory locations until mem_depth if not reached
        if mem_counter < mem_depth:
            outfile.write(f"\nfor(i={mem_counter}; i<{mem_depth}; i=i+1) begin\n")
            outfile.write("    Mem[i] = i;  // Fill up to specified depth\n")
            outfile.write("end\n")
               
        outfile.write("end\n")

        # Fill remaining hex dump locations with 00 if hex_outfile was provided
        if hex_outfile:
            while mem_counter < mem_depth:
                hex_outfile.write("00\n")
                mem_counter += 1
            hex_outfile.close()

# Parse command-line arguments
def parse_arguments():
    parser = argparse.ArgumentParser(description="Convert RISC-V assembly to memory format.")
    parser.add_argument('-i', '--input', required=True, help='Input file containing assembly code')
    parser.add_argument('-o', '--output', required=True, help='Output file to store memory instructions')
    parser.add_argument('-t', '--testcase', required=True, help='Test case description to be included in the output')
    parser.add_argument('--hexdump', help='Optional output file for hex dump (used with readmemh)')
    parser.add_argument('--mem_depth', type=int, default=64, help='Memory address depth limit (default: 64)')
    
    return parser.parse_args()

if __name__ == '__main__':
    args = parse_arguments()
    assemble_to_mem(args.input, args.output, args.testcase, args.hexdump, args.mem_depth)

    print(f"Memory assembly complete. Check the output file: {args.output}")
    if args.hexdump:
        print(f"Hex dump generated: {args.hexdump}")


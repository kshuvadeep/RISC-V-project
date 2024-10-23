import argparse

def split_instruction(instruction):
    """Split a 32-bit instruction into four 8-bit bytes."""
    return [
        (instruction >> 0) & 0xFF,
        (instruction >> 8) & 0xFF,
        (instruction >> 16) & 0xFF,
        (instruction >> 24) & 0xFF
    ]

def assemble_to_mem(input_file, output_file, testcase_description, hex_dump_file=None):
    with open(input_file, 'r') as infile, open(output_file, 'w') as outfile:
        # If hex dump option is provided, open hex dump file
        hex_outfile = open(hex_dump_file, 'w') if hex_dump_file else None

        # Write the testcase description with formatting
        outfile.write("//***************************************************************\n")
        outfile.write(f"//  T e s t c a s e : {testcase_description}\n")
        outfile.write("//***************************************************************\n\n")

        # Initialize memory address counter
        mem_counter = 0
        
        for line in infile:
            # Split each line by whitespace
            parts = line.split()
            if len(parts) < 2 or len(parts[1]) != 10:
                continue  # Skip empty, invalid, or non-instruction lines

            # Extract the machine code (hex part)
            code = int(parts[1], 16)  # Convert hex string to integer

            # Split the 32-bit instruction into four 8-bit bytes
            bytes_list = split_instruction(code)

            # Write the instruction comment (e.g., "// addi x5,x0,1 4 // li t0 1")
            outfile.write(f"// {' '.join(parts[2:])}\n")

            # Write each byte into separate memory locations
            for i, byte in enumerate(bytes_list):
                outfile.write(f"Mem[{mem_counter}] = 8'h{byte:02x};\n")
                
                # If hex dump is enabled, write to hex dump file in hex format
                if hex_outfile:
                    hex_outfile.write(f"{byte:02x}\n")
                
                mem_counter += 1

            # Add an empty line between instructions for readability
            outfile.write("\n")

        # Add the test case initialization
        outfile.write(f"\nfor(i={mem_counter}; i<MEM_DEPTH; i=i+1) begin\n")
        outfile.write(f"    Mem[i] = i;  // Just for creating a test case\n")
        outfile.write(f"end\n")
        
        # Set data_valid_reg
        outfile.write(f"\ndata_valid_reg = 1'b0;\n")

        # Close the hex dump file if it was opened
        if hex_outfile:
            hex_outfile.close()

# Parse command-line arguments
def parse_arguments():
    parser = argparse.ArgumentParser(description="Convert RISC-V assembly to memory format.")
    parser.add_argument('-i', '--input', required=True, help='Input file containing assembly code')
    parser.add_argument('-o', '--output', required=True, help='Output file to store memory instructions')
    parser.add_argument('-t', '--testcase', required=True, help='Test case description to be included in the output')
    parser.add_argument('--hexdump', help='Optional output file for hex dump (used with readmemh)')
    
    return parser.parse_args()

if __name__ == '__main__':
    # Get command-line arguments
    args = parse_arguments()

    # Call the function to process the file
    assemble_to_mem(args.input, args.output, args.testcase, args.hexdump)

    print(f"Memory assembly complete. Check the output file: {args.output}")
    if args.hexdump:
        print(f"Hex dump generated: {args.hexdump}")


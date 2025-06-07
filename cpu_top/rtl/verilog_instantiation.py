import argparse

def generate_verilog_instantiation_from_file(file_path):
    try:
        with open(file_path, 'r') as file:
            lines = file.readlines()

        module_name = ""
        ports = []

        for line in lines:
            line = line.strip()
            if line.startswith("module "):
                module_name = line.split()[1].split("(")[0]
            elif line.endswith(");"):
                # End of the module definition, break
                break
            elif line.endswith(","):
                # Strip the comma and add to ports
                ports.append(line[:-1].strip())
            elif line and not line.startswith("//"):
                # For ports that do not end with a comma
                ports.append(line.strip())

        # Generate the instantiation
        instantiation = f"{module_name} {module_name.lower()}_inst ("
        port_mappings = [f".{port.split()[0]}({port.split()[-1]})" for port in ports]
        instantiation += ",\n    ".join(port_mappings) + "\n);"

        print(instantiation)

    except FileNotFoundError:
        print(f"Error: File '{file_path}' not found.")
    except Exception as e:
        print(f"An error occurred: {e}")

def main():
    parser = argparse.ArgumentParser(description='Generate Verilog module instantiation.')
    parser.add_argument('-i', '--input', required=True, help='Path to the Verilog file.')
    args = parser.parse_args()

    generate_verilog_instantiation_from_file(args.input)

if __name__ == "__main__":
    main()


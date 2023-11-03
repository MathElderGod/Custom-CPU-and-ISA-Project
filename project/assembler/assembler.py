import argparse

"""
Instruction            | Type | Opcode | rs   | rt   | rd   | imm    | target
-----------------------|------|--------|------|------|------|--------|-------
xor                    |  R   | 000    | XXX  | XXX  | -    | -      | -
beq                    |  I   | 001    | X    | -    | -    | XXXX   | -
addi                   |  I   | 010    | XXX  | -    | -    | XXX    | -
andi                   |  I   | 011    | XXX  | -    | -    | XXX    | -
ls                     |  I   | 100    | XXX  | -    | -    | XXX    | -
ld                     |  R   | 101    | XXX  | XXX  | -    | -      | -
st                     |  R   | 110    | XXX  | XXX  | -    | -      | -
j                      |  J   | 111    | -    | -    | -    | -      | XXXXXX
"""

INSTRUCTION_FORMAT = {
    "xor":  {"type": "R", "opcode": "000", "width": 3},
    "beq":  {"type": "I", "opcode": "001", "width": 4},
    "addi": {"type": "I", "opcode": "010", "width": 3},
    "andi": {"type": "I", "opcode": "011", "width": 3},
    "ls":   {"type": "I", "opcode": "100", "width": 3},
    "ld":   {"type": "I", "opcode": "101", "width": 3},
    "st":   {"type": "I", "opcode": "110", "width": 3},
    "j":    {"type": "J", "opcode": "111", "width": 6}
}

TWOS_COMP = {
    '0':  '000',
    '1':  '001',
    '2':  '010',
    '3':  '011',
    '-3': '101',
    '-2': '110',
    '-1': '111'
}

# Clean up instruction
def tokenize_instruction(instruction):
    return instruction.replace(",", "").split()

# Convert register or imm into binary
def decode_value(value, width):
    try:
        if value.startswith("r"): value = value.replace("r", "")
        bin_value = format(int(value), f'0{width}b')
        
        if len(bin_value) > width:
            raise ValueError(f"Value '{value}' too large for specified width of {width}.")
        
        return bin_value
    
    except ValueError as ve:
        raise ValueError(f"Failed to decode value '{value}': {str(ve)}")

# Process R-Type
def assemble_r_type(tokens, opcode, width):
    rs, rt = tokens[1], tokens[2]
    return opcode + decode_value(rs, width) + decode_value(rt, width)

# Process the two types of I-Type instructions
def assemble_i_type(tokens, opcode, width):
    instruction, rs = tokens[0], tokens[1]
    
    if len(tokens) == 4:
        if instruction == "beq":
            imm = tokens[3]
            return opcode + decode_value(rs, 1) + "0" + decode_value(imm, width)
            
        else:
            rd, imm = tokens[2], tokens[3]
            return opcode + decode_value(rs, width) + decode_value(rd, width) + decode_value(imm, width)
    else:
        imm = tokens[2]
        if (instruction == "ls") | (instruction == "addi"):
            try: return opcode + decode_value(rs, width) + TWOS_COMP[imm]
            except: return opcode + decode_value(rs, width) + '000'
            
        else:
            return opcode + decode_value(rs, width) + decode_value(imm, width)

# Process J-Type
def assemble_j_type(tokens, opcode, width):
    target = tokens[1]
    return opcode + decode_value(target, width)

# Convert assembly into machine code
def assemble_instruction(instruction):
    try:
        tokens = tokenize_instruction(instruction)
        op_info = INSTRUCTION_FORMAT.get(tokens[0])
        if not op_info: raise ValueError(f"Invalid instruction '{tokens[0]}'.")
        
        opcode = op_info["opcode"]
        width = op_info["width"]
    
        if op_info["type"] == "R": return assemble_r_type(tokens, opcode, width)
        elif op_info["type"] == "I": return assemble_i_type(tokens, opcode, width)
        else: return assemble_j_type(tokens, opcode, width)
        
    except Exception as e:
        raise ValueError(f"Failed to assemble instruction '{instruction}': {str(e)}")


# To perform tests, run `python3 assembler.py -t`
def test_assembler():
    test_data = [
        ("xor r0 r1", "000000001"),
        ("beq r1 0 15", "001101111"),
        ("addi r0 1", "010000001"),
        ("andi r0 1", "011000001"),
        ("ls r0 -4", "100000000"),
        ("ls r0 -3", "100000101"),
        ("ls r0 -2", "100000110"),
        ("ls r0 -1", "100000111"),
        ("ls r0 0", "100000000"),
        ("ls r0 1", "100000001"),
        ("ls r0 2", "100000010"),
        ("ls r0 3", "100000011"),
        ("ld r0 r1", "101000001"),
        ("st r0 r1", "110000001"),
        ("j 000000", "111000000"),
        ("j 20", "111010100")
    ]

    for instr, expected in test_data:
        result = assemble_instruction(instr)
        assert result == expected, f"Test failed for instruction '{instr}'. Expected: '{expected}' and got: '{result}'"

    print("All tests passed.")

"""
Input - A file called `assembly.txt` with the assembly instr. separated by newline
Output - A file called `mach_code.txt` with the corresponding machine code
"""
def process_file(input_filename, output_filename):
    try:
        with open(input_filename, 'r') as infile:
            instructions = infile.readlines()
    
        machine_codes = [assemble_instruction(instr.strip()) for instr in instructions]
    
        with open(output_filename, 'w') as outfile:
            for code, instr in zip(machine_codes, instructions):
                outfile.write(f"{code} \t// {instr.strip()}\n")
                
    except FileNotFoundError:
        print(f"Error: File '{input_filename}' not found.")
        
    except Exception as e:
        print(f"Error: {str(e)}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Assembler script.")
    parser.add_argument("-t", "--test", action="store_true", help="Run the assembler tests.")
    args = parser.parse_args()

    if args.test:
        try: test_assembler()
        except AssertionError as e: print(f"Test Failed: {str(e)}")
    else: 
        process_file("assembly.txt", "mach_code.txt")

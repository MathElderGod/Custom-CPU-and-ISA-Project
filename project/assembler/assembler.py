"""
Instruction            | Type | Opcode | rs   | rt   | rd   | imm    | target
-----------------------|------|--------|------|------|------|--------|-------
xor                    |  R   | 000    | XXX  | XXX  | -    | -      | -
beq                    |  I   | 001    | XX   | -    | XX   | XX     | -
add                    |  I   | 010    | XXX  | -    | -    | XXX    | -
lsl                    |  I   | 100    | XXX  | -    | -    | XXX    | -
ld                     |  I   | 101    | XX   | -    | XX   | XX     | -
st                     |  I   | 110    | XX   | -    | XX   | XX     | -
j                      |  J   | 111    | -    | -    | -    | -      | XXXXXX
"""

def assemble(instr):
    r_types = set(["xor"])
    i_types = set(["beq", "add", "lsl", "ld", "st"])
    j_types = set(["j"])
    
    # Get the operation of the current instruction
    tokens = instr.replace(",", "").split()
    op = tokens[0]

    # R-Type Instruction
    if op in r_types:
        # Parse rs and rt
        rs, rt = tokens[1], tokens[2]
        # Form instruction
        return get_opcode(op) + get_code(rs, 3) + get_code(rt, 3)
    
    # I-Type Instructions
    elif op in i_types:
        # 2-bit imm case
        if op in ["beq", "ld", "st"]:
            width = 2
            rs, rd, imm = tokens[1], tokens[2], tokens[3]
            return get_opcode(op) + get_code(rs, width) + get_code(rd, width) + get_code(imm, width)
        
        # 3 bit imm case
        else:
            width = 3
            rs, imm = tokens[1], tokens[2]
            return get_opcode(op) + get_code(rs, width) + get_code(imm, width)
    
    # J-type 
    else:
        width = 6
        target = tokens[1]
        return get_opcode(op) + target

"""
Maps opcode to binary representation
"""
def get_opcode(operation):
    hmap = {
        "xor": "000",
        "beq": "001",
        "add": "010",
        "lsl": "011",
        "ld": "101",
        "st": "110",
        "j": "111"
    }
    return hmap[operation]

"""
Supports decoding of registers and immediate values.
"""
def get_code(val, width):
    if val.startswith("r"):
        val = val.replace("r", "")
    return format(int(val), f'0{width}b')
    

def test_assembler():
    # R-Type
    assert assemble("xor r0 r1") == "000000001"
    
    # I-Type
    assert assemble("beq r1 r0 2") == "001010010"
    assert assemble("add r0 1") == "010000001"
    assert assemble("lsl r0 2") == "011000010"
    assert assemble("ld r0 r1 0") == "101000100"
    assert assemble("st r0 r1 0") == "110000100"
    
    # J-Type
    assert assemble("j 000000") == "111000000"
    assert assemble("j 111111") == "111111111"
    
    print("All tests passed.")
    
test_assembler()
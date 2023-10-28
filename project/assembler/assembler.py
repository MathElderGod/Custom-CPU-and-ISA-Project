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

INSTRUCTION_FORMAT = {
    "xor": {"type": "R", "opcode": "000", "width": 3},
    "beq": {"type": "I", "opcode": "001", "width": 2},
    "add": {"type": "I", "opcode": "010", "width": 3},
    "lsl": {"type": "I", "opcode": "011", "width": 3},
    "ld":  {"type": "I", "opcode": "101", "width": 2},
    "st":  {"type": "I", "opcode": "110", "width": 2},
    "j":   {"type": "J", "opcode": "111", "width": 6}
}

def assemble(instr):
    tokens = instr.replace(",", "").split()
    op = tokens[0]
    opcode = INSTRUCTION_FORMAT[op]["opcode"]
    width = INSTRUCTION_FORMAT[op]["width"]
    
    # R-Type Instruction
    if INSTRUCTION_FORMAT[op]["type"] == "R":
        rs, rt = tokens[1], tokens[2]
        return opcode + get_code(rs, width) + get_code(rt, width)
    
    # I-Type Instructions
    elif INSTRUCTION_FORMAT[op]["type"] == "I":
        if op in ["beq", "ld", "st"]:
            rs, rd, imm = tokens[1], tokens[2], tokens[3]
            return opcode + get_code(rs, width) + get_code(rd, width) + get_code(imm, width)
        else:
            rs, imm = tokens[1], tokens[2]
            return opcode + get_code(rs, width) + get_code(imm, width)
    
    # J-type 
    else:
        target = tokens[1]
        return opcode + target

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
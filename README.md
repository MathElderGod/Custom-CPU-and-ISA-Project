# The Super Simple Architecture

## Overview
This project encompasses a set of SystemVerilog files designed for a hardware design and verification project. These files contribute to various aspects of a digital system, including logic operations, control mechanisms, memory management, and testing.

## File Descriptions for CPU Directory

### `alu.sv`
- **Purpose:** Implements the Arithmetic Logic Unit (ALU) of the system, responsible for performing arithmetic and logical operations.
- **Key Functions:** Basic arithmetic operations (add, subtract), bitwise operations (AND, OR, XOR), and shift operations.

### `control.sv`
- **Purpose:** Defines the control unit of a processor or digital system, managing the flow of data and instructions.
- **Key Functions:** Instruction decoding, generating control signals for other components.

### `data_mem.sv`
- **Purpose:** Manages data memory operations within the system.
- **Key Functions:** Data storage, read and write operations, addressing and data retrieval mechanisms.

### `instruction_rom.sv`
- **Purpose:** Handles the instruction read-only memory (ROM), storing the set of instructions for the system.
- **Key Functions:** Instruction storage, sequential access, and management.

### `pc.sv`
- **Purpose:** Represents the Program Counter, keeping track of the instruction sequence.
- **Key Functions:** Incrementing to point to the next instruction, jump and branch operations.

### `prog1_tb.sv`, `prog2_tb.sv`, `prog3_tb.sv`
- **Purpose:** Serve as testbenches for verifying the functionality of the system or its components.
- **Key Functions:** Simulating different scenarios, checking the correctness of outputs, stress testing for three specified programs. 

### `reg_file.sv`
- **Purpose:** Manages the register file of the system, a key component in processor design.
- **Key Functions:** Storage of temporary data, facilitating register read and write operations.

### `top_level.sv`
- **Purpose:** Acts as the top-level module, integrating various components of the system.
- **Key Functions:** Orchestrating interactions between modules, ensuring coherent data flow and control.

## Usage
To use these files, load them into a SystemVerilog-compatible simulation or synthesis tool. Ensure all dependencies and environment settings are correctly configured. Compile and run simulations as per the tool's instructions. MAKE SURE YOU EDIT THE TOP-LEVEL FILE AND THE INSTRUCTION ROM BEFORE USE. Some done flags are commented out due to interference with other programs. Also, ensure the instruction ROM is reading from the correct file and the correct pathway. MAKE SURE YOU HAVE THE CORRECT DONE FLAG SET FOR THE SPECIFIED PROGRAM YOU WISH TO RUN, OR YOU WILL RUN INTO UNEXPECTED BEHAVIOR!

## Overview
This section of the project includes various files related to assembly language programming and machine code generation. These files may be used for writing, assembling, and testing assembly language programs.

## File Descriptions for ASSEMBLER Directory

### `assembler.py`
- **Purpose:** A Python script for assembling assembly language programs into machine code.
- **Key Functions:** Parsing assembly instructions, converting them into machine code, error checking.

### `assembly.txt`
- **Purpose:** Contains assembly language instructions for a specific program or function.
- **Key Functions:** Serves as an input file for the assembler script.

### `mach_code.txt`, `prog1_mach_code.txt`, `prog2_mach_code.txt`, `prog3_mach_code.txt`
- **Purpose:** These files contain the machine code output generated from assembly language programs.
- **Key Functions:** Can be used for loading into a simulator or a hardware system for execution.

### `program1.txt`, `program2.txt`, `program3.txt`
- **Purpose:** These text files likely contain assembly language programs or related data.
- **Key Functions:** Provide source code for assembly language programs that can be assembled using `assembler.py`.

## Usage
To use these files, run `assembler.py` with the assembly language files (like `program1.txt`) as input to generate machine code.

## Contributors
- Alexander G. Arias
- Tyler Le
- Aiko Coanaya

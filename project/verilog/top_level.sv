module top_level(
                            input   clk, 
                                    reset,
                                    start,
                    output logic    done
);

parameter D = 10,   // program counter width
          A = 3,    // ALU width
          pw = 3,
          opwidth = 3,
          mcodebits = 3;

wire jumpEn;
wire[D-1:0] targetAddress,  // target address used for jumping or branching
            programCounter; // current programCounter

wire[8:0] currentInstruction;    // the current machine instruction outputted by the instruction ROM

wire branchSignal;
wire memToRegSignal;
wire memWriteSignal;
wire aluSrcSignal;
wire regWriteSignal;

wire[2:0] aluOpSignal;
wire[2:0] readAddress1, readAddress2; 

// [8 : 6]           [5 : 3]          [2 : 0]
// opcode          reg 1          reg 2 or imm
assign readAddress1 = currentInstruction[5:3];
assign readAddress2 = currentInstruction[2:0];

wire[7:0] regData1, regData2;
wire[7:0] dataMemoryOutput;

reg[7:0] immediate;
wire[7:0] immOrRegMuxResult;

wire[7:0] aluResult;
wire zeroFlag;

localparam xorIns  = 3'b000;
localparam beqIns  = 3'b001;
localparam addiIns = 3'b010;
localparam andiIns = 3'b011;
localparam lsIns  = 3'b100;
localparam ldIns = 3'b101;
localparam stIns = 3'b110;
localparam jIns = 3'b111;

always @(*) begin
    case (aluOpSignal)    
        beqIns:  immediate = currentInstruction[3:0];
        addiIns: immediate = currentInstruction[2:0];   
        andiIns: immediate = currentInstruction[2:0];
        lsIns:   immediate = currentInstruction[2:0];
        ldIns:   immediate = currentInstruction[1:0];
        stIns:   immediate = currentInstruction[1:0];
        jIns:    immediate = currentInstruction[5:0];
        default: immediate = 8'b00000000;   
    endcase
end

assign jumpEn = (zeroFlag && (aluOpSignal == 3'b001)) || (aluOpSignal == 3'b111);

// program counter module // D sets program counter width
pc #(.D(D)) pc1(
                .reset(reset),                      // input
                .clk(clk),                          // input
                .jumpEn(jumpEn),                    // input
                .target(targetAddress),             // input
                .programCounter(programCounter)     // output, the current program counter
);

// instruction read only memory module
instruction_rom #(.D(D)) ir1(
                            .programCounter(programCounter), // input, the current program counter
                            .machineCode(currentInstruction) // output - current machine code instruction 
);

// control module. 
control #(.opwidth(opwidth), .mcodebits(mcodebits)) ctrl1(
                                                        .instruction(currentInstruction),   // input
                                                        .branch(branchSignal),              // output
                                                        .memToReg(memToRegSignal),          // output
                                                        .memWrite(memWriteSignal),          // output
                                                        .aluSrc(aluSrcSignal),              // output
                                                        .regWrite(regWriteSignal),          // output
                                                        .aluOp(aluOpSignal)                 // output
);

// register file module
reg_file #(.pw(pw)) rf1(
                        .dataInput(dataMemoryOutput),   // input result from data memory
                        .clk(clk),                      // input
                        .reset(reset),                  // input
                        .writeEn(memToRegSignal),       // input
                        .writeAddress(readAddress1),    // input
                        .readAddress1(readAddress1),    // input
                        .readAddress2(readAddress2),    // input
                        .dataOutput1(regData1),         // output
                        .dataOutput2(regData2)          // output
);

// our mux for using either an immediate or a register
assign immOrRegMuxResult = aluSrcSignal? immediate : regData2;

// alu module
alu alu1(
        .instruction(aluOpSignal),          // input
        .input1(regData1),                  // input
        .input2(immOrRegMuxResult),         // input
        .result(aluResult),                 // output, alu arithmetic result
        .zero(zeroFlag)                     // output, zero flag
);

data_mem dm1 (
                .dataInput(aluResult),          // input
                .clk(clk),                      // input
                .reset(reset),                  // input
                .writeEn(memWriteSignal),       // input
                .address(regData1),             // input - register must have integer value of memory address we wish to store value in
                .dataOutput(dataMemoryOutput)   // output

);
  // can be a ternary string assign done = (programCounter == program1size) ? 1 : ((programCounter == program2size ? 1: (programCounter == program2size) ? 1: 0);
  assign done =  (programCounter == 400) ? 1 : ( (programCounter == 800) ? 1 : ((programCounter == 450) ? 1: 0));
endmodule

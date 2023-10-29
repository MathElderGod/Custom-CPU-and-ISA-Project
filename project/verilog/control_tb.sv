module control_tb();
    // Parameters
    parameter opwidth = 3;
    parameter mcodebits = 3;

    // Signals
    reg [mcodebits-1:0] instruction;
    wire branch, memToReg, memWrite, aluSrc, regWrite;
    wire [opwidth-1:0] aluOp;

    // Instantiate the control module
    control #(opwidth, mcodebits) test (
        .instruction(instruction),
        .branch(branch),
        .memToReg(memToReg),
        .memWrite(memWrite),
        .aluSrc(aluSrc),
        .regWrite(regWrite),
        .aluOp(aluOp)
    );

    integer i;
    // Test sequence
    initial begin
        $display("Testing control unit...");
        
        // Iterate through all possible instruction values
        for (i = 0; i < 8; i++) begin
            $display("-------------------------------------------------------");
            instruction = i;
            #5;  // Small delay for clarity
            $display("Instruction: %b\n", instruction);
            $display("\tbranch: %b\n\tmemToReg: %b\n\tmemWrite: %b\n\taluSrc: %b\n\tregWrite: %b\n\taluOp: %b\n",
                     branch, 
                     memToReg, 
                     memWrite, 
                     aluSrc, 
                     regWrite, 
                     aluOp);
            $display("-------------------------------------------------------");
        end
        $finish;
    end
endmodule
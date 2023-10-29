module instruction_rom_tb();

    // Parameters
    parameter D = 12;
    
    // Signals
    reg [D-1:0] programCounter;
    wire [8:0]  machineCode;
    
    // Instantiate the instruction_rom module
    instruction_rom #(D) rom_instance (
        .programCounter(programCounter),
        .machineCode(machineCode)
    );

    // Test sequence
    initial begin
        $display("Program Counter | Machine Code\n");
        $display("----------------|-------------\n");
        
        // Loop through some addresses
        for (programCounter = 0; programCounter < 9; programCounter++) begin
            #10; // Introduce delay for simulation clarity
            $display("PC %d:      | %9b\n", programCounter, machineCode);
        end
        $finish; // Finish the simulation
    end
endmodule
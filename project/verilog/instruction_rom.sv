// lookup table
// deep 
// 9 bits wide; as deep as you wish
module instruction_rom #(parameter D=12)(
                                          input[D-1:0]        programCounter,    // programCounter	  address pointer
                                          output logic[8:0]   machineCode
);

  logic[8:0] core[2**D];
  initial							    // load the program
    // replace machine code path according to your machine
    $readmemb("C:/Users/alexa/OneDrive/Documents/CSE 141L/milestone2-instruction_rom/mach_code.txt", core);

  always_comb  machineCode = core[programCounter];

endmodule


/*
sample mach_code.txt:

001111110		 // ADD r0 r1 r0
001100110
001111010
111011110
101111110
001101110
001000010
111011110
*/
// lookup table
// deep 
// 9 bits wide; as deep as you wish
module instruction_rom #(parameter D=12)(
                                          input[D-1:0]        programCounter,    // programCounter	  address pointer
                                          input               start,
                                          output logic[8:0]   machineCode
);

  logic[8:0] core[2**D];
  reg machCodeLoaded;

  initial begin
    machCodeLoaded = 0; // Initialize to not loaded
  end

  always @(posedge start) begin
    if (machCodeLoaded == 0) begin
      // Load the program when the start signal is asserted and machine code is not loaded
      $readmemb("C:/Users/alexa/OneDrive/Documents/CSE 141L/cpu/prog3_mach_code.txt", core);
      machCodeLoaded = 1; // Set the loaded flag
    end
  end

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
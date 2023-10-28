module pc_tb;

  // Parameters
  parameter D = 6;

  // Signals
  reg          reset;
  reg          clk;
  reg          jump_en;
  reg  [D-1:0] target;
  wire [D-1:0] prog_ctr;

  // Instantiate the PC
  pc #(D) test(.reset(reset), .clk(clk), .jump_en(jump_en), .target(target), .prog_ctr(prog_ctr));

  // Clock generator
  always begin
    #5 clk = ~clk;
  end

  // Test procedure
  initial begin
    // Initialize signals
    clk = 1;
    reset = 1;
    jump_en = 0;
    target = 0;
    #10;
    
    // Release reset
    reset = 0;
    #10;

    // Count for a few cycles
    #40;

    // Enable jump
    jump_en = 1;
    target = 5;
    #10;

    // Disable jump and count
    jump_en = 0;

    #30;

    // Finish simulation
    $finish;
  end

endmodule
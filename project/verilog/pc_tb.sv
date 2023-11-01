module pc_tb;

  // Parameters
  parameter D = 10;

  // Signals
  reg          reset;
  reg          clk;
  reg          jumpEn;
  reg  [D-1:0] target;
  wire [D-1:0] programCounter;

  // Instantiate the PC
  pc #(D) test(.reset(reset), .clk(clk), .jumpEn(jumpEn), .target(target), .programCounter(programCounter));

  // Clock generator
  always begin
    #5 clk = ~clk;
  end

  // Test procedure
  initial begin
    // Initialize signals
    clk = 1;
    reset = 1;
    jumpEn = 0;
    target = 0;
    #10;
    
    // Release reset
    reset = 0;
    #10;

    // Count for a few cycles
    #40;

    // Enable jump
    jumpEn = 1;
    target = 11;
    #10;

    // Disable jump and count
    jumpEn = 0;

    #30;

    // Finish simulation
    $finish;
  end

endmodule

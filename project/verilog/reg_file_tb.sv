module reg_file_tb;
  // Parameters
  parameter pw = 3;

  // Signals
  reg [7:0] dataInput;
  reg clk;
  reg reset;
  reg writeEn;
  reg [pw-1:0] writeAddress;
  reg [pw-1:0] readAddress1;
  reg [pw-1:0] readAddress2;
  wire [7:0] dataOutput1;
  wire [7:0] dataOutput2;

  // Instantiate the register file
  reg_file #(pw) test (
                        .dataInput(dataInput),
                        .clk(clk),
                        .reset(reset),
                        .writeEn(writeEn),
                        .writeAddress(writeAddress),
                        .readAddress1(readAddress1),
                        .readAddress2(readAddress2),
                        .dataOutput1(dataOutput1),
                        .dataOutput2(dataOutput2)
  );

  // Clock Generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Test sequence
  initial begin
    // Initialization
    reset = 1;
    writeEn = 0;
    #10;
    reset = 0;
    // on reset, all registers should be empty //////////////////////////////
    readAddress1 = 3'b000;
    readAddress2 = 3'b001;
    if(dataOutput1 != 8'h00) begin
        $display("Error: Mismatch on dataOutput1: line 45");
        $finish;
    end
    if(dataOutput2 != 8'h00) begin
        $display("Error: Mismatch on dataOutput2: line 46"); 
        $finish;
    end
    #10;
    readAddress1 = 3'b010;
    readAddress2 = 3'b011;
    if(dataOutput1 != 8'h00) begin 
        $display("Error: Mismatch on dataOutput1: line 50"); 
        $finish;
    end
    if(dataOutput2 != 8'h00) begin
        $display("Error: Mismatch on dataOutput2: line 51"); 
        $finish;
    end
    #10;
    readAddress1 = 3'b100;
    readAddress2 = 3'b101;
    if(dataOutput1 != 8'h00) begin
        $display("Error: Mismatch on dataOutput1: line 55"); 
        $finish;
    end
    if(dataOutput2 != 8'h00) begin
        $display("Error: Mismatch on dataOutput2: line 56"); 
        $finish;
    end
    #10;
    readAddress1 = 3'b110;
    readAddress2 = 3'b111;
    if(dataOutput1 != 8'h00) begin
        $display("Error: Mismatch on dataOutput1: line 60"); 
        $finish;
    end
    if(dataOutput2 != 8'h00) begin
        $display("Error: Mismatch on dataOutput2: line 61"); 
        $finish;
    end
    $display("PASS: REG FILE IS ZEROED OUT");
    //////////////////////////////////////////////////////////////////////////
    readAddress1 = 3'b000;
    readAddress2 = 3'b000;
    
    #10;
    // Write some data to registers
    dataInput = 8'hA5;
    writeAddress = 3'b000;
    writeEn = 1;
    
    #10;
    if(dataOutput1 != 8'hA5) begin 
        $display("Error: Mismatch on dataOutput1: line 99");
        $finish;
    end
    
    #10;
    writeEn = 0;
    #10;

    readAddress1 = 3'b001;
    dataInput = 8'h5A;
    writeAddress = 3'b001;
    writeEn = 1;
    #10;

    if(dataOutput1 != 8'h5A) begin 
        $display("Error: Mismatch on dataOutput1: line 114");
        $finish;
    end
    
    #10;
    readAddress1 = 3'b010;
    readAddress2 = 3'b001;
    dataInput = 8'hAA;
    writeAddress = 3'b010;
    writeEn = 1;
    #10

    if(dataOutput1 != 8'hAA) begin 
        $display("Error: Mismatch on dataOutput1: line 127");
        $finish;
    end
    if(dataOutput2 != 8'h5A) begin 
        $display("Error: Mismatch on dataOutput2: line 131");
        $finish;
    end
    
    #10;
    writeEn = 0;
    #10;
    readAddress1 = 3'b011;
    readAddress2 = 3'b010;
    dataInput = 8'hAB;
    writeAddress = 3'b011;
    writeEn = 1;
    #10;

    if(dataOutput1 != 8'hAB) begin 
        $display("Error: Mismatch on dataOutput1: line 146");
        $finish;
    end
    if(dataOutput2 != 8'hAA) begin 
        $display("Error: Mismatch on dataOutput2: line 150");
        $finish;
    end
    #10;
    writeEn = 0;
    #10;
    readAddress1 = 3'b100;
    readAddress2 = 3'b011;
    dataInput = 8'hAC;
    writeAddress = 3'b100;
    writeEn = 1;
    #10;

    if(dataOutput1 != 8'hAC) begin 
        $display("Error: Mismatch on dataOutput1: line 164");
        $finish;
    end
    if(dataOutput2 != 8'hAB) begin 
        $display("Error: Mismatch on dataOutput2: line 168");
        $finish;
    end
    #10;
    writeEn = 0;
    #10;
    readAddress1 = 3'b101;
    readAddress2 = 3'b100;
    dataInput = 8'hAD;
    writeAddress = 3'b101;
    writeEn = 1;
    #10;
    if(dataOutput1 != 8'hAD) begin 
        $display("Error: Mismatch on dataOutput1: line 181");
        $finish;
    end
    if(dataOutput2 != 8'hAC) begin 
        $display("Error: Mismatch on dataOutput2: line 184");
        $finish;
    end
    #10;
    writeEn = 0;
    #10;
    readAddress1 = 3'b110;
    readAddress2 = 3'b101;
    dataInput = 8'hAE;
    writeAddress = 3'b110;
    writeEn = 1;
    #10;
    if(dataOutput1 != 8'hAE) begin 
        $display("Error: Mismatch on dataOutput1: line 198");
        $finish;
    end
    if(dataOutput2 != 8'hAD) begin 
        $display("Error: Mismatch on dataOutput2: line 201");
        $finish;
    end
    #10;
    writeEn = 0;
    #10;
    readAddress1 = 3'b111;
    readAddress2 = 3'b110;
    dataInput = 8'hAF;
    writeAddress = 3'b111;
    writeEn = 1;
    #10;
    if(dataOutput1 != 8'hAF) begin 
        $display("Error: Mismatch on dataOutput1: line 215");
        $finish;
    end
    if(dataOutput2 != 8'hAE) begin 
        $display("Error: Mismatch on dataOutput2: line 219");
        $finish;
    end
    $display("PASS: REG FILE CORRECTLY LOADED AND STORED DATA");
    #10;
    writeEn = 0;
    #10;
    readAddress1 = 3'b000;
    readAddress2 = 3'b000;
    reset = 1;
    #10;
    reset = 0;
    #10;
    // on reset, all registers should be empty //////////////////////////////
    readAddress1 = 3'b000;
    readAddress2 = 3'b001;
    if(dataOutput1 != 8'h00) begin
        $display("Error: Mismatch on dataOutput1: line 236");
        $finish;
    end
    if(dataOutput2 != 8'h00) begin
        $display("Error: Mismatch on dataOutput2: line 240"); 
        $finish;
    end
    #10;
    readAddress1 = 3'b010;
    readAddress2 = 3'b011;
    if(dataOutput1 != 8'h00) begin 
        $display("Error: Mismatch on dataOutput1: line 247"); 
        $finish;
    end
    if(dataOutput2 != 8'h00) begin
        $display("Error: Mismatch on dataOutput2: line 251"); 
        $finish;
    end
    #10;
    readAddress1 = 3'b100;
    readAddress2 = 3'b101;
    if(dataOutput1 != 8'h00) begin
        $display("Error: Mismatch on dataOutput1: line 258"); 
        $finish;
    end
    if(dataOutput2 != 8'h00) begin
        $display("Error: Mismatch on dataOutput2: line 262"); 
        $finish;
    end
    #10;
    readAddress1 = 3'b110;
    readAddress2 = 3'b111;
    if(dataOutput1 != 8'h00) begin
        $display("Error: Mismatch on dataOutput1: line 269"); 
        $finish;
    end
    if(dataOutput2 != 8'h00) begin
        $display("Error: Mismatch on dataOutput2: line 273"); 
        $finish;
    end
    $display("PASS: REG FILE IS ZEROED OUT AGAIN");
    //////////////////////////////////////////////////////////////////////////
    #10;
    readAddress1 = 3'b000;
    readAddress2 = 3'b000;
    #10;
    $finish;
  end

endmodule
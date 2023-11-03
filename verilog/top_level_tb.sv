`timescale 1ns/1ps
module top_level_tb;

    // Parameters
    parameter D = 10;

    // Signals
    reg clk;
    reg reset;
    reg start;
    wire done;

    // Instantiate the top-level module
    top_level test (
        .clk(clk),
        .reset(reset),
        .start(start),
        .done(done)
    );

    // Clock generation
    always begin
        #5 clk = ~clk;
    end

    initial begin
        // Initialize signals
        // Apply reset
        // Start the computation after some cycles
        clk = 1;
        // clk is high, send the important signals
        start = 1;
        reset = 1;
        #5 // off
        start = 0;
        reset = 0;
        #5 // on
        start = 0;
        reset = 0;
        // wait for the done flag from the registers
        wait((done) || ($time >= 50));
        
        if(test.dm1.core[0] != 2) begin
            $display("Error: core[0] from data memory does not have the value 2. It has %d", test.dm1.core[0]);
        end else begin
            $display("PASS: core[0] from data memory does have the value %d.", test.dm1.core[0]);
        end 

        if(test.dm1.core[192] != 3) begin
            $display("Error: core[192] from data memory does not have the value 3. It has %d", test.dm1.core[192]);
        end else begin
            $display("PASS: core[192] from data memory does have the value %d.", test.dm1.core[192]);
        end 

        if(test.dm1.core[195] != 2) begin
            $display("Error: core[195] from data memory does not have the value 2. It has %d", test.dm1.core[195]);
        end else begin
            $display("PASS: core[195] from data memory does have the value %d.", test.dm1.core[195]);
        end 
         
        // End simulation
        $finish;
    end

    // Monitor the done signal
    always @(posedge done) begin
        $display("Computation completed at time %t", $time);
    end

endmodule

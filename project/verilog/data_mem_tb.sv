module data_mem_tb();
    // Signals
    reg [7:0]     dataInput;
    reg           clk;
    reg           reset;
    reg           writeEn;
    reg [7:0]     address;
    wire [7:0]    dataOutput;

    integer i;

    // Instantiate the dat_mem module
    data_mem test (
                .dataInput(dataInput),
                .clk(clk),
                .reset(reset),
                .writeEn(writeEn),
                .address(address),
                .dataOutput(dataOutput)
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
        #10
        reset = 0;

        // Check all memory locations
        for (i = 0; i < 256; i++) begin
            address = i;
            #10; // Allow a clock cycle for memory output to update
            if (dataOutput !== 8'h00) begin
                $display("Error at address %h: Expected 00, Got %h", address, dataOutput);
                $finish;
            end 
        end
        $display("PASS: All memory is zeroed out! :)");
        // initialize all memory locations
        for (i = 0; i < 256; i++) begin
            #10
            address = i;
            dataInput = i;
            writeEn = 1;
            #10
            writeEn = 0;
            #10; // Allow a clock cycle for memory output to update
            if (dataOutput !== i) begin
                $display("Error at address %h: Expected %h, Got %h", address, i, dataOutput);
                $finish;
            end 
        end
        $display("PASS: All memory is initialized correctly! :)");
        #10
        // clearing
        reset = 1;
        writeEn = 0;
        #10
        reset = 0;

        // Check all memory locations
        for (i = 0; i < 256; i++) begin
            address = i;
            #10; // Allow a clock cycle for memory output to update
            if (dataOutput !== 8'h00) begin
                $display("Error at address %h: Expected 00, Got %h", address, dataOutput);
                $finish;
            end 
        end
        $display("PASS: All memory is zeroed out again!! :)");

        $finish; // Finish the simulation
    end
  endmodule
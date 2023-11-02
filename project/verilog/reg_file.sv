// cache memory/register file
// This module provides a register file with 8 registers, each 8-bits wide.
module reg_file #(parameter pw=3)(
  									input[7:0] 			dataInput,
  									input      			clk,
									input				reset, 
  									input      			writeEn,        // write enable
  									input[pw-1:0] 		writeAddress,	// write address pointer
              											readAddress1,	// read address pointers
			  										  	readAddress2,
  									output logic[7:0] 	dataOutput1, 	// read data
                    									dataOutput2
);
logic[7:0] core[2**pw];    // 2-dim array  8 wide  8 deep

// read address should be 3 bits, meaning we can only access registers 0 - 7. 
// thus we have a total of 8 possible register accesses.
assign dataOutput1 = core[readAddress1];
assign dataOutput2 = core[readAddress2];

// writes are sequential (clocked)
always_ff @(posedge clk)
	// if the reset signal is high
	if(reset)
		// then set every element in the core array to zero
		// thus on reset, all registers are clear
		core <= '{default: 8'b00000000};
	// else if the write enable signal is high
	else if(writeEn)				   // anything but stores or no ops
		// then write the data input into the specified register
    		core[writeAddress] <= dataInput; 
endmodule

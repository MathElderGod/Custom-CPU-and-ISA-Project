// 8-bit wide, 256-word (byte) deep memory array
module data_mem (
                input[7:0]        dataInput,
                input             clk,
                input             reset,
                input             writeEn,	    // write enable
                input[7:0]        address,		  // address pointer
                output logic[7:0] dataOutput
);

logic[7:0] core[256];       // 2-dim array  8 wide  256 deep

// reads are combinational; no enable or clock required
// address between 0 and 255 at all times. 8'b00000000 - 8'b11111111
assign dataOutput = core[address];

// writes are sequential (clocked) -- occur on stores or pushes 
always_ff @(posedge clk)
  // on reset
  if(reset)
    // zero out all memory
    core <= '{default: 8'b00000000};
  // else if the write en signal is high
  else if(writeEn)
    // write the data input into memory		
    core[address] <= dataInput; 

endmodule
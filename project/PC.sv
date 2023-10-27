// Program Counter

module PC #(parameter D=6)(
  input reset,					           // synchronous reset
        clk,
        jump_en,				           // abs. jump enable
  input        [D-1:0] target,	   // where to jump  
  output logic [D-1:0] prog_ctr
);

  always_ff @(posedge clk)

    if (reset)
	    prog_ctr <= 'b0;
    else if (jump_en)
      prog_ctr <= target;
    else
      prog_ctr <= prog_ctr + 'b1;

endmodule
// Program Counter

module pc #(parameter D=10)(
                            input                 reset,		 // synchronous reset
                                                  clk,       
                                                  jumpEn,   // abs. jump enable
                            input        [D-1:0]  target,	   // where to jump  
                            output logic [D-1:0]  programCounter
);
  always_ff @(posedge clk)
    if (reset)
      programCounter <= 'b0;
    else if (jumpEn)
      programCounter <= target;
    else
      programCounter <= programCounter + 'b1;
endmodule

// Program Counter

module pc #(parameter D=10)(
                            input                 reset,		 // synchronous reset
                                                  start,
                                                  clk,       
                                                  jumpEn,     // abs. jump enable
                            input        [D-1:0]  target,	   // where to jump  
                            input        [2:0]    instruction,
                            output logic [D-1:0]  programCounter
);
  always_ff @(posedge clk)
    if (reset || start)
      programCounter <= 'b0;
    else if (jumpEn && (instruction == 3'b111))
      programCounter <= target;
    else if (jumpEn && (instruction == 3'b001))
      programCounter <= programCounter + target;
    else
      programCounter <= programCounter + 'b1;
endmodule

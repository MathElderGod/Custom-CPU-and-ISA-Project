// control decoder
module control #(parameter opwidth = 3, mcodebits = 3)(
                  input [mcodebits-1:0]     instruction,    // actual opcode
                  output logic              branch, 
                                            memToReg, 
                                            memWrite, 
                                            aluSrc, 
                                            regWrite,
                  output logic[opwidth-1:0] aluOp
  );	   // for up to 8 ALU operations
  // constants predefined with our insturction set 
  localparam xorIns  = 3'b000;
  localparam beqIns  = 3'b001;
  localparam addiIns = 3'b010;
  localparam andiIns = 3'b011;
  localparam lsIns  = 3'b100;
  localparam ldIns   = 3'b101;
  localparam stIns   = 3'b110;
  localparam jIns    = 3'b111;

  always_comb begin
    // defaults
    branch 	  = 'b0;   // 1: branch (jump)
    memToReg  =	'b0;   // 1: load -- route memory instead of ALU to reg_file data in
    memWrite  =	'b0;   // 1: store to memory
    aluSrc 	  =	'b0;   // 1: immediate  0: second reg file output
    regWrite  =	'b1;   // 0: for store or no op  1: most other operations 
    aluOp	    = instruction;  
    // sample values only -- use what you need
    case(instruction)    // override defaults with exceptions
      beqIns:  begin					// branch op
        branch 	  = 'b1;   // 1: branch (jump)
        aluSrc 	  =	'b1;   // 1: immediate  0: second reg file output
        regWrite  =	'b0;   // 0: for store or no op  1: most other operations 
      end
      addiIns:  begin					// addi op
        aluSrc 	  =	'b1;   // 1: immediate  0: second reg file output 
      end
      andiIns:  begin					// andi op
        aluSrc 	  =	'b1;   // 1: immediate  0: second reg file output 
      end
      lsIns:  begin					// ls op
        aluSrc 	  =	'b1;   // 1: immediate  0: second reg file output 
      end
      ldIns:  begin					// ld op
        memToReg  =	'b1;   // 1: load -- route memory instead of ALU to reg_file data in 
      end
      stIns:  begin					// st op
        memWrite  =	'b1;   // 1: store to memory
        regWrite  =	'b0;   // 0: for store or no op  1: most other operations 
      end
      jIns:  begin					// j op
        branch 	  = 'b1;   // 1: branch (jump)
        regWrite  =	'b0;   // 0: for store or no op  1: most other operations 
      end
    endcase
  end
endmodule

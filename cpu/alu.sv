// combinational -- no clock
// sample -- change as desired
module alu(
            input[2:0]          instruction,           // ALU instructions
            input signed[7:0]   input1, input2,	       // 8-bit wide data path
            output logic[7:0]   result,
            output logic        zero                   // NOR (output)
);
    // constants predefined with our insturction set 
    localparam xorIns  = 3'b000;
    localparam beqIns  = 3'b001;
    localparam addiIns = 3'b010;
    localparam andiIns = 3'b011;
    localparam lsIns  = 3'b100;
    localparam ldIns = 3'b101;
    localparam stIns = 3'b110;
    localparam jIns = 3'b111;
    always_comb begin
        case(instruction)
            // bitwise xor
            xorIns: begin
                result = input1 ^ input2;
                zero = 'b0;
            end
            // branch if equal
            beqIns: begin
                result = (input1 == input2) ? 8'b00000000: 8'b00000001;
                zero = !result;
            end
            // add immediate
            addiIns: begin
                result = input1 + input2;
                zero = 'b0;
            end
            // bitwise and
            andiIns: begin
                result = input1 & input2;
                zero = 'b0;
            end
            // logical shift
            lsIns: begin
                zero = 'b0;
                case(input2[2:0]) // considering only 3 LSBs of input2
                    3'b001: result = input1 >> 1;    // 1-bit shift-right
                    3'b010: result = input1 >> 2;    // 2-bit shift-right
                    3'b011: result = input1 >> 3;    // 3-bit shift-right
                    3'b101: result = input1 << 3;    // 3-bit shift-left
                    3'b110: result = input1 << 2;    // 2-bit shift-left
                    3'b111: result = input1 << 1;    // 1-bit shift-left
                    default:
                        result = input1;    // unsupported logical shift
                endcase
            end
            // the instruction is not supported
            stIns: begin
                result = input1;
                zero = 'b0;
            end
            default: begin
                result = 8'b11111111;
                zero = 'b0;
            end
        endcase
    end
endmodule

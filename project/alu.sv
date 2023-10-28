// combinational -- no clock
// sample -- change as desired
module alu(
            input[2:0]          instruction,           // ALU instructions
            input[7:0]          input1, input2,	       // 8-bit wide data path
            output logic[7:0]   result,
            output logic        zero                   // NOR (output)
);

    // constants predefined with our insturction set 
    localparam xorIns  = 3'b000;
    localparam beqIns  = 3'b001;
    localparam addiIns = 3'b010;
    localparam andiIns = 3'b011;
    localparam rlsIns  = 3'b100;

    always_comb begin 
        result = 8'b0;              
        zero   = (result == 8'b00000000);
        case(instruction)
        // bitwise xor
        xorIns: 
            result = input1 ^ input2;
        // branch if equal
        beqIns:
            result = (input1 == input2) ? 8'b00000000: 8'b00000001;
        // add immediate
        addiIns:
            result = input1 + input2;
        // bitwise and
        andiIns:
            result = input1 & input2;
        // rotate left shift, (will rotate the bits, meaning no loss of data)
        rlsIns:
            case(input2[2:0]) // considering only 3 LSBs of input2 for rotation amount
                3'b001: result = {input1[6:0], input1[7]};      // 1-bit rotate-left
                3'b010: result = {input1[5:0], input1[7:6]};    // 2-bit rotate-left
                3'b011: result = {input1[4:0], input1[7:5]};    // 3-bit rotate-left
                3'b100: result = {input1[3:0], input1[7:4]};    // 4-bit rotate-left
                3'b101: result = {input1[2:0], input1[7:3]};    // 5-bit rotate-left
                3'b110: result = {input1[1:0], input1[7:2]};    // 6-bit rotate-left
                3'b111: result = {input1[0],   input1[7:1]};    // 7-bit rotate-left
                default:
                    result = input1;
                
            endcase
        // the instruction is not supported
        default:
                result = 8'b11111111;
        endcase
    end
endmodule

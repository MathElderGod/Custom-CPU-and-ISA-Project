module alu_tb;  // this is a testbench
	reg[2:0] instruction;
	reg[7:0] input1;
	reg[7:0] input2;
	wire[7:0] result;	// reg is a synonym for logic
	wire zero;

	alu test(.instruction(instruction), .input1(input1), .input2(input2), .result(result), .zero(zero));
	
	initial begin
		// test the bitwise XOR ins
		instruction = 3'b000;
		input1 		= 8'b10101010;
		input2      = 8'b01010101;
		// result should be 8'b11111111
		// zero flag should be low

		#100; // waits for 100 time units

		// test the BEQ ins
		instruction = 3'b001;
		input1 		= 8'b10101010;
		input2      = 8'b01010101;
		// zero flag should be low

		#100; // waits for 100 time units

		// test the BEQ ins
		instruction = 3'b001;
		input1 		= 8'b11111111;
		input2      = 8'b11111111;
		// zero flag should be high

		#100; // waits for 100 time units

		// test the ADD ins
		instruction = 3'b010;
		input1 		= 8'b00000001;
		input2      = 8'b00000001;
		// zero flag should be low
		// result should hold 8'b00000010 (1+1=2)

		#100; // waits for 100 time units

		// test the ADD ins
		instruction = 3'b010;
		input1 		= 8'b11111111;
		input2      = 8'b00000010;
		// zero flag should be low
		// result should hold 8'b00000001, as it decremented by -1. (-1 + 2 = 1)

		#100; // waits for 100 time units

		// test the AND ins
		instruction = 3'b011;
		input1 		= 8'b00100111;
		input2      = 8'b00000001;
		// zero flag should be low
		// result should hold 8'b00000001, as it isolates the msb

		#100; // waits for 100 time units

		// test the AND ins
		instruction = 3'b011;
		input1 		= 8'b00100110;
		input2      = 8'b00000001;
		// zero flag should be low
		// result should hold 8'b00000000, as it isolates the msb

		#100; // waits for 100 time units

		// test the LS ins
		instruction = 3'b100;
		input1 		= 8'b10010001;
		input2      = 8'b00000111;
		// zero flag should be low
		// result should hold 8'b00100010, as you shift 1 time to the left

		#100; // waits for 100 time units

		// test the LS ins
		instruction = 3'b100;
		input1 		= 8'b10010001;
		input2      = 8'b00000110;
		// zero flag should be low
		// result should hold 8'b01000100, as you shifted 2 times to the left

		#100; // waits for 100 time units

		// test the LS ins
		instruction = 3'b100;
		input1 		= 8'b10010001;
		input2      = 8'b00000101;
		// zero flag should be low
		// result should hold 8'b10001000, as you shifted 3 times to the left

		#100; // waits for 100 time units

		// test the LS ins
		instruction = 3'b100;
		input1 		= 8'b10010001;
		input2      = 8'b00000100;
		// zero flag should be low
		// result should hold 8'b10010001, as it is unsupported

		#100; // waits for 100 time units

		// test the LS ins
		instruction = 3'b100;
		input1 		= 8'b10010001;
		input2      = 8'b00000011;
		// zero flag should be low
		// result should hold 8'b00010010, as you shifted 3 times to the right

		#100; // waits for 100 time units
		// test the LS ins
		instruction = 3'b100;
		input1 		= 8'b10010001;
		input2      = 8'b00000010;
		// zero flag should be low
		// result should hold 8'b00100100, as you shifted 2 times to the right

		#100; // waits for 100 time units
		// test the LS ins
		instruction = 3'b100;
		input1 		= 8'b10010001;
		input2      = 8'b00000001;
		// zero flag should be low
		// result should hold 8'b01001000, as you shifted 1 time to the right

		#100; // waits for 100 time units
		// test the LS ins
		instruction = 3'b100;
		input1 		= 8'b10010001;
		input2      = 8'b00000000;
		// zero flag should be low
		// result should hold 8'b10010001, as it is unsupported

		#100; // waits for 100 time units
		// test unsupported instructions
		instruction = 3'b101;
		input1 		= 8'b10010001;
		input2      = 8'b00000000;
		// zero flag should be low
		// result should hold 8'b11111111, as it is unsupported

		#100; // waits for 100 time units
		// test unsupported instructions
		instruction = 3'b110;
		input1 		= 8'b10010001;
		input2      = 8'b00000000;
		// zero flag should be low
		// result should hold 8'b11111111, as it is unsupported

		#100; // waits for 100 time units
		// test unsupported instructions
		instruction = 3'b111;
		input1 		= 8'b10010001;
		input2      = 8'b00000000;
		// zero flag should be low
		// result should hold 8'b11111111, as it is unsupported

		#100; // waits for 100 time units

	end
endmodule 
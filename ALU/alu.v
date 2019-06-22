module alu#(parameter WORD_LENGTH =32)
          ( input [31:0] in_1,
	    input [31:0] in_2,
	    input cin,
	    input [3:0] op_mux_ctrl,
	    output [31:0] alu_out,
	    output carry_out,
	    output reg zero,
	    output sign
          );
	  wire [31:0] in_2_int, carry;
	  wire [31:0] result[8:0];

	  assign in_2_int = cin ? ~(in_2) : in_2;  // Input change for subtraction using cin

	  assign sign = alu_out[31];  // Sign bit

	  assign carry_out = carry[31]; //carry out

	  assign result[3] = in_1 < in_2_int ? 1 : 0; // unsigned comparison(sltu)

	  assign result[1] = in_1 << in_2_int[4:0]; // left shift

	  assign result[5] = in_1 >> in_2_int[4:0]; // right shift

	  assign result[6] = in_1 >>> in_2_int[4:0]; // arithmetic right shift1

	  assign result[2] = $signed(in_1) < $signed(in_2_int) ? 1 : 0; // signed comparison slt

	  assign alu_out = result[op_mux_ctrl]; // function selection

	  full_adder alu_adder_1(in_1[0],in_2_int[0],cin,result[0][0],carry[0]); // first full adder
	  genvar j;
	  generate for(j=1;j<32;j=j+1)
		  begin
			  full_adder alu_adder(in_1[j],in_2_int[j],carry[j-1],result[0][j],carry[j]); // remaining full adders
		  end
	  endgenerate
	  generate for(j=0;j<32;j=j+1)
		  begin
			  and alu_and(result[8][j],in_1[j],in_2_int[j]); // and logic
			  or alu_or(result[7][j],in_1[j],in_2_int[j]); // or logic
			  xor alu_xor(result[4][j],in_1[j],in_2_int[j]); // xor logic
		  end
	  endgenerate
           
	  // zero flag logic

	  always @(alu_out)
	  begin
		  if(!(alu_out))
		  begin
			  zero = 1'b 1;
		  end
		  else
		  begin
			  zero = 1'b 0;
		  end
	  end
endmodule

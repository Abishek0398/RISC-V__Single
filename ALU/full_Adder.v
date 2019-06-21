module full_adder( input a,
	           input b,
		   input cin,
		   output sum,
		   output carry);
	   wire w[2:0];
	   xor sum_gate_1(w[0],a,b);
	   xor sum_gate_2(sum,w[0],cin);
	   and carry_gate_1(w[1],a,b);
	   and carry_gate_2(w[2],w[0],cin);
	   or carry_gate_3(carry,w[1],w[2]);
endmodule




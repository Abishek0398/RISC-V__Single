module risc_v #(parameter WORD_LENGTH =32)
               (input clk,
		input reset
	       );
	       reg [WORD_LENGTH-1:0] pc;
	       wire [WORD_LENGTH-1:0] instr; //instruction

	       wire [WORD_LENGTH-1 :0] alu_out; //output of alu

	       wire reg_write_en; // control_signal(register write)

	       wire sub_signal; //control_signal(carry in)

	       wire [3:0] alu_ctrl; //control_signal(alu_op)

	       wire carry_out,zero,sign; // status signals from alu

	       wire is_I_type; // control_signal(i type specifier)

	       wire [WORD_LENGTH -1 :0] alu_ip2; // second input to alu;

	       wire [WORD_LENGTH-1 :0] reg_op1,reg_op2; // outputs of registerfile

               memory instruction_mem (.address(pc),.write_add(0),.write_data(0),.write_enable(1'b 0),.read_enable(1'b 1),.data_out(instr)); // instantiating instruction memory 

               register_file r_file (.add_rs1(instr[19:15]),.add_rs2(instr [24:20]),.write_add(instr [11:7]),.write_data(alu_out),.write_enable(reg_write_en),.clk(clk),.rst(1'b 1),.data_1(reg_op1),.data_2(reg_op2));// r_file 

               alu risc_alu (.in_1(reg_op1),.in_2(alu_ip2),.cin(sub_signal),.op_mux_ctrl(alu_ctrl),.alu_out(alu_out),.carry_out(carry_out),.zero(zero),.sign(sign)); // alu instantiation

	       risc_v_control control_unit (.opcode(instr[6:0]),.funct3(instr [14:12]),.funct7(instr[30]),.alu_op(alu_ctrl),.cin(sub_signal),.reg_write_en(reg_write_en),.is_I_type(is_I_type)); // control unit

	       assign alu_ip2 = is_I_type ? instr[31:20] : reg_op2; //alu input selection

	       always @(posedge(clk))
	       begin
		       pc=pc+4;
	       end

endmodule



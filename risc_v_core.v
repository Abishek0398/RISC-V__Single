module risc_v #(parameter WORD_LENGTH =32)
               (input clk,
		input reset
	       );
	       reg [WORD_LENGTH-1:0] pc; // program counter

	       wire [WORD_LENGTH-1:0] instr; //instruction

	       wire [WORD_LENGTH-1 :0] alu_out; //output of alu

	       wire reg_write_en; // control_signal(register write)

	       wire sub_signal; //control_signal(carry in)

	       wire [3:0] alu_ctrl; //control_signal(alu_op)

	       wire carry_out,zero,sign; // status signals from alu

	       wire [WORD_LENGTH-1:0] sign_extended_out; // Sign extended immediate value

	       wire is_I_type; // control_signal(i type specifier)

	       wire is_L_type; // control signal for load type

	       wire is_S_type; //  control signal for store type

	       wire is_J_type; // control signal for jal

	       wire is_JR_type; // control signal for jalr
 
   	       wire is_B_type; // coontrol signal for branch type

	       wire [2:0] pc_cont; // pc_control signals from control unit

	       wire [2:0] mem_write_en; // write enable for each byte in a word

	       wire mem_read_enable; // read enable for data memory

	       wire [2:0] b_cond; // branch condition helper

	       reg [31:0]reg_write_data; // data to be written in register

	       wire [31:0] mem_out_data; // temporary output from datamemory

	       wire [31:0] mem_data_processed; // after checking funct for type of load;

	       wire [WORD_LENGTH -1 :0] alu_ip2; // second input to alu;

	       wire [WORD_LENGTH-1 :0] reg_op1,reg_op2; // outputs of registerfile

	       reg B_enable; // Branch_enable signal

               memory instruction_mem (.address(pc),.write_data(0),.write_enable(3'b 0),.read_enable(1'b 1),.clk(clk),.rst(1'b 1),.data_out(instr)); // instantiating instruction memory 

	       memory data_memory (.address(alu_out),.write_data(reg_op2),.write_enable(mem_write_en),.read_enable(mem_read_en),.clk(clk),.rst(1'b1),.data_out(mem_out_data)); //data memory

               register_file r_file (.add_rs1(instr[19:15]),.add_rs2(instr [24:20]),.write_add(instr [11:7]),.write_data(reg_write_data),.write_enable(reg_write_en),.clk(clk),.rst(1'b1),.data_1(reg_op1),.data_2(reg_op2));// r_file 

               alu risc_alu (.in_1(reg_op1),.in_2(alu_ip2),.cin(sub_signal),.op_mux_ctrl(alu_ctrl),.alu_out(alu_out),.carry_out(carry_out),.zero(zero),.sign(sign)); // alu instantiation

	       risc_v_control control_unit (.opcode(instr[6:0]),.funct3(instr [14:12]),.funct7(instr[30]),.alu_op(alu_ctrl),.cin(sub_signal),.reg_write_en(reg_write_en),.is_I_type(is_I_type),.is_L_type(is_L_type),.is_S_type(is_S_type),.is_J_type(is_J_type),.is_JR_type(is_JR_type),.is_B_type(is_B_type),.b_cond(b_cond),.mem_read_en(mem_read_en),.mem_write_en(mem_write_en)); // control unit

	       sign_extender sign_ext (instr[31:7] , {is_I_type,is_L_type,is_S_type},sign_extended_out); // sign extendr for immediate values

	       memory_helper mem_help(.ip_value(mem_out_data),.func(instr[14:12]),.op_value(mem_data_processed)); // memory output helper

	       assign alu_ip2 = (is_I_type || is_S_type || is_L_type) ? sign_extended_out : reg_op2; //alu input selection

	       always @(posedge(clk))
	       begin
		       if(is_J_type)
		       begin
			       pc<= pc + ($signed({instr[31],instr[19:12],instr[20],instr[30:21]})<<1);
		       end
		       else if(is_JR_type)
		       begin
			       pc <= pc+ (alu_out & {{31{1'b1}} ,1'b0});
		       end
		       else if(B_enable && is_B_type)
		       begin
			       pc <= pc+ $signed({instr[31],instr[7],instr[30:25],instr[11:8]}) << 1;
		       end
		       else
		       begin
			       pc <= pc+4;
		       end
	       end

	       always @(*)
	       begin
		       if(b_cond == 0)
		       begin
			       B_enable = zero;
		       end
		       else if(b_cond == 1)
		       begin
			       B_enable = ~zero;
		       end
		       else if(b_cond ==2)
		       begin
			       B_enable = alu_out[0];
		       end
		       else if(b_cond == 3)
		       begin
			       B_enable = ~alu_out[0] | zero;
		       end
		       else
		       begin
			       B_enable = 0;
		       end
	       end

	       always @(*)
	       begin
		       if(is_L_type)
		       begin
			       reg_write_data = mem_data_processed;
		       end
		       else if(is_J_type || is_JR_type)
		       begin
			       reg_write_data = pc+4;
		       end
		       else
		       begin
			       reg_write_data = alu_out;
		       end
	       end

endmodule



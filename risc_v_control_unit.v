module risc_v_control #(parameter WORD_LENGTH =32)
                       (input [6:0] opcode,
	                input [2:0] funct3,
		        inout funct7,
			output reg [3:0] alu_op,
			output reg cin,
			output reg is_I_type,
			output reg reg_write_en
		        );
always @(opcode,funct3,funct7)
	case(opcode)
		7'b 0010011: begin
			          is_I_type=1;
				  reg_write_en=1;
				  casex({funct7,funct3})
					  4'b X000 : alu_op = 0;
	                                  4'b X001 : alu_op = 1;
                                          4'b X010 : alu_op = 2;
	                                  4'b X011 : alu_op = 3;
                                       	  4'b X100 : alu_op = 4;
	                                  4'b 0101 : alu_op = 5;
	                                  4'b 1101 : alu_op = 6;
	                                  4'b X110 : alu_op = 8; 
	                                  4'b X111 : alu_op = 7;
					  default : begin
						         alu_op=0;
							 cin=0;
						    end
				  endcase
			     end
					
                7'b 0110011: begin
			          is_I_type=0;
				  reg_write_en=1;
				  casex({funct7,funct3})
					  4'b 0000 : alu_op = 0;
					  4'b 1000 : begin
						          alu_op = 0;
							  cin=1;
						     end
	                                  4'b X001 : alu_op = 1;
                                          4'b X010 : alu_op = 2;
	                                  4'b X011 : alu_op = 3;
                                       	  4'b X100 : alu_op = 4;
	                                  4'b 0101 : alu_op = 5;
	                                  4'b 1101 : alu_op = 6;
	                                  4'b X110 : alu_op = 8; 
	                                  4'b X111 : alu_op = 7;
					  default : begin 
					                 alu_op=0;
							 cin=0;
						    end
				  endcase
			     end
	          default: begin
			        is_I_type = 0;
		                reg_write_en = 0;
			   end
	endcase
endmodule	


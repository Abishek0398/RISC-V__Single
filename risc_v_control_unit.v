module risc_v_control #(parameter WORD_LENGTH =32)
                       (input [6:0] opcode,
	                input [2:0] funct3,
		        input funct7,
			output reg [3:0] alu_op,
			output reg cin,
			output reg is_I_type,
			output reg is_L_type,
			output reg is_S_type,
			output reg is_B_type,
			output reg is_J_type,
			output reg is_JR_type,
			output reg [2:0] b_cond,
			output reg reg_write_en,
			output reg mem_read_en,
			output reg [2:0] mem_write_en
		        );
always @(opcode,funct3,funct7)
begin
	is_I_type = 0;
	is_L_type = 0;
	is_S_type = 0;
	reg_write_en = 0;
        alu_op = 0;
	mem_read_en=0;
	mem_write_en =0;
	cin =0;
	is_J_type =0;
	is_JR_type =0;
	is_B_type =0;
	b_cond=0;
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
	        7'b 0000011: begin
				  is_L_type = 1;
				  alu_op = 0;
				  mem_read_en =1;
				  reg_write_en =1;
			     end
	        7'b 0100011: begin
		                   is_S_type=1;
		                   alu_op=0;
				   mem_write_en = 1;
				   case(funct3)
					   3'b 000: mem_write_en = 1;
					   3'b 001: mem_write_en = 3;
					   3'b 010: mem_write_en = 7;
					   default: mem_write_en = 0;
				   endcase
		             end		   
	        7'b 1101111: begin
                                   is_J_type =1;
	                           reg_write_en =1;
	                     end
	        7'b 1100111: begin
                                   is_JR_type = 1;
	                           reg_write_en =1;
		             end
	        7'b 1100011: begin
			           is_B_type = 1;
                                   case(funct3)
					   3'b 000: begin
						          alu_op =0;
		                                          cin =1;
			                                  b_cond =0;
			                            end
		                           3'b 001: begin
	                                                  alu_op =0;
	                                                  cin =1;
	                                                  b_cond =1;
	                                            end
                                           3'b 100: begin
                                                          alu_op = 2;
                                                          b_cond =2;
					            end
				           3'b 101: begin
			                                  alu_op =2;
			                                  b_cond =3;
						    end
		                           3'b 110: begin
	                                                  alu_op = 3;
	                                                  b_cond = 2;
						    end
                                           3'b 111: begin
                                                          alu_op = 3;
                                                          b_cond = 3;
                                                    end
					   default: begin
						         b_cond =0;
				                         alu_op =0;
				                         cin =0;
						    end 			 
				   endcase
			     end				   

	          default: begin
			        is_I_type = 0;
				is_L_type = 0;
				is_S_type = 0;
		                reg_write_en = 0;
				alu_op = 0;
				mem_read_en=0;
				mem_write_en =0;
				cin =0;
				is_J_type =0;
				is_JR_type =0;
				is_B_type =0;
				b_cond=0;
			   end
	endcase
end
endmodule	


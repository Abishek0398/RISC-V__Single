module memory_helper #(parameter WORD_LENGTH = 32)
                      ( input [WORD_LENGTH-1:0] ip_value,
	                input [2:0] func,
			output reg [WORD_LENGTH-1 : 0] op_value
		      );
		always@(*)
		begin
		          case(func)
	               	  3'b 000: op_value = $signed(ip_value[7:0]);
	                  3'b 001: op_value = $signed(ip_value[15:0]);
	                  3'b 010: op_value = ip_value;
	                  3'b 100: op_value = $unsigned(ip_value[7:0]);
	                  3'b 101: op_value = $unsigned(ip_value[15:0]);
	                  default: op_value = ip_value;
	                  endcase;
                end
		endmodule	

module register_file#(parameter WORD_LENGTH = 32)
	             (input [4:0] add_rs1,
	              input [4:0] add_rs2,
		      input [4:0] write_add,
	              input [WORD_LENGTH-1:0] write_data,
		      input write_enable,
		      input clk,
		      input rst,
		      output [WORD_LENGTH-1:0] data_1,
		      output [WORD_LENGTH-1:0] data_2
	             );
integer i;		     
reg [31:0] register[31:0];
always @(posedge(clk))
begin
	if(!rst)
	begin
		for(i=0;i<32;i=i+1)
		begin
			register[i]<=0;
		end
	end
	else if(write_enable && write_add !=0)
	begin
		register[write_add] <= write_data;
	end
end
assign data_1 = (add_rs1==0)? 0:register[add_rs1];
assign data_2 = (add_rs2==0)? 0:register[add_rs2];
endmodule

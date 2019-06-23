module memory#(parameter WORD_LENGTH = 32,
			 MEMORY_SIZE = 32
	      )
             ( input [MEMORY_SIZE-1:0] address,
	       input [MEMORY_SIZE-1:0] write_add,
	       input [WORD_LENGTH-1:0] write_data,
	       input write_enable,
	       input read_enable,
               input clk,
               input rst,
	       output [WORD_LENGTH-1:0] data_out
	      );
integer i;
reg [WORD_LENGTH-1:0] word_line[MEMORY_SIZE-1:0];
always @(posedge(clk) or negedge(rst))
begin
	if(!rst)
	begin
		for(i=0;i< MEMORY_SIZE;i=i+1)
		begin
			word_line[i] <= 0;
		end
	end
	else if(write_enable)
	begin
		word_line[write_add] <= write_data;
	end
end
assign data_out = (read_enable) ? word_line[address]:0;
endmodule

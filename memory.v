module memory#(parameter WORD_LENGTH = 32,
			 MEMORY_SIZE = 32
	      )
             ( input [MEMORY_SIZE-1:0] address,
	       input [WORD_LENGTH-1:0] write_data,
	       input [2:0] write_enable,
	       input read_enable,
               input clk,
               input rst,
	       output [WORD_LENGTH-1:0] data_out
	      );
integer i;
reg [7:0] word_line[MEMORY_SIZE-1:0];
always @(posedge(clk))
begin
	if(!rst)
	begin
		for(i=0;i< MEMORY_SIZE;i=i+1)
		begin
			word_line[i] <= 0;
		end
	end
	else if(write_enable == 4'b001)
	begin
		word_line[address] <= write_data[7:0];
	end
	else if(write_enable == 4'b011)
	begin
		word_line[address] <= write_data[7:0];
		word_line[address+1] <= write_data[15:8];
	end
	else if(write_enable == 4'b111)
	begin
		word_line[address] <= write_data[7:0];
		word_line[address+1] <= write_data[15:8];
		word_line[address+2] <= write_data[23:16];
		word_line[address+3] <= write_data[31:24];
	end
end
assign data_out = (read_enable) ? {word_line[address+3], word_line[address+2], word_line[address+1], word_line[address] }:0;
endmodule

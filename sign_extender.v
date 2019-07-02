module sign_extender#(parameter WORD_LENGTH =32)
	            ( input [24:0] instr_part,
		      input [2:0] cntrl,	    
	              output reg [WORD_LENGTH-1:0] data_out
		    );
		    always @(*)
		    begin
			    if(cntrl == 3'b 100 || cntrl == 3'b 010)
			    begin
				    data_out = $signed(instr_part[24:13]);
			    end

			    else if(cntrl == 3'b 001)
			    begin
				    data_out = $signed({instr_part[24:18],instr_part[4:0]});
			    end

			    else
			    begin
				    data_out = 0;
			    end
		    end
endmodule

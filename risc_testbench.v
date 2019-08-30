module testbench();
reg clk,rst;
risc_v dut_core (.clk(clk),.reset(rst));
/*initial
begin
	$dumpvars(1,testbench.dut_core.r_file);
	$dumpfile("registers.vcd");
end*/
initial
begin
	$readmemh("register_init.mem",testbench.dut_core.r_file.register,2);
        $readmemb("instruction_mem.mem",testbench.dut_core.instruction_mem.word_line);
	testbench.dut_core.pc =0;
	rst =1;
	#100 clk=0;
	#400 $finish;
end
always @(clk) 
begin
	#100 clk <= ~clk;
	//$display($time,"Register 1 value is: %b %b",testbench.dut_core.is_B_type,testbench.dut_core.B_enable);
	$display($time,"Register 1 value is: %b",testbench.dut_core.r_file.register[1]);
	//$display($time,"Register 1 value is: %b",testbench.dut_core.pc);
end
endmodule


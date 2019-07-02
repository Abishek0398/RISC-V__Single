module testbench();
reg clk,rst;
risc_v_core dut_core (.clk(clk),.rst(rst));
initial
begin
	$dumpvars(1,testbench.dut_core.r_file);
	$dumpfile("registers.vcd");
end
initial
begin
	testbench.dut_core.pc =0;
        rst =0;
	#15 rst =1;
	clk=1;
	#1000 $finish;
end
always @(clk) 
begin
	#5 clk <= ~clk;
end


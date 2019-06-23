module testbench();
reg clk,rst;
risc_v_core dut_core (.clk(clk),.rst(rst)
initial
begin
	testbench.dut_core.pc =0;
        rst =0;
	#15 rst =1;
	clk=1;
end
always @(clk) 
begin
	#5 clk <= ~clk;
end


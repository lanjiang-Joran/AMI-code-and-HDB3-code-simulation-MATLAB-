`timescale 1ns/1ps
module AMI_code_tb();

reg 		sys_clk;
reg 		sys_rst_n;
reg [15:0]	data_i;
wire signed	data_o_liner;

initial begin
	sys_clk = 1'b0;
	sys_rst_n = 1'b0;
	data_i = 16'hAAAA;
	#10
	sys_rst_n = 1'b1;
end

always #10 sys_clk = ~sys_clk;

AMI_code AMI_code_tb
(
.sys_clk(sys_clk),
.sys_rst_n(sys_rst_n),
.data_i(data_i),
.data_o_liner(data_o_liner)
	);

endmodule
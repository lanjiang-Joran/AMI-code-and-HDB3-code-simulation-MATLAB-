`timescale 1ns/1ps
module HDB3_code_tb();

reg 		sys_clk;
reg 		sys_rst_n;
reg [21:0]	data_i;
wire[2:0]	data_o[0:21];

initial begin
	sys_clk <= 1'b0;
	sys_rst_n <= 1'b0;
	data_i <= [1 0 0 0 0 1 0 0 0 0 1 1 0 0 0 0 0 0 0 0 1 1];
	#10
	sys_rst_n <= 1'b1;
end


always #10 sys_clk = ~sys_clk;

HDB3_code u_HDB3_code(

.sys_clk(sys_clk),
.sys_rst_n(sys_rst_n),
.data_i(data_i),
.data_o(data_o)

	);







endmodule
module AMI_code(
//global
input 				sys_clk,
input 				sys_rst_n,
input               en,
//
input 			[15:0] 	data_i,
output reg signed[1:0]	data_o_liner//	�?要将0�?1转化�?1�?-1
);
reg  [15:0]data_i_reg;
wire  data_i_liner;//并行数据转化为串行数�?
reg  cnt_oddoreven;

//�?->�?
always @(posedge sys_clk or negedge sys_rst_n) begin
	if (!sys_rst_n) begin
		data_i_reg <= 15'b0;
	end
	else if(!en)begin
		data_i_reg <= data_i;	
	end
	else if(en)
	   data_i_reg <= data_i_reg>>1;
end
assign  data_i_liner = data_i_reg[0];
//因为编码后需要正负交替出�?1�?-1，所以需要一位计数器

always @(posedge sys_clk or negedge sys_rst_n) begin
	if (!sys_rst_n) begin
		cnt_oddoreven <= 1'b0;
	end
	else if (data_i_liner == 1'b1)
		cnt_oddoreven <= cnt_oddoreven + 1'b1;
end



//
always @(posedge sys_clk or negedge sys_rst_n) begin
	if (!sys_rst_n) begin
		data_o_liner <= 1'b0;
	end
	else if(data_i_liner == 1'b0) 
		data_o_liner <= 2'b00;
	else if(data_o_liner == 1'b1 && cnt_oddoreven == 1'b0)
		data_o_liner <= 2'b01;
	else if(data_o_liner == 1'b1 && cnt_oddoreven == 1'b1)
		data_o_liner <= 2'b11;
	else 
		data_o_liner <= 2'b00;
end




endmodule
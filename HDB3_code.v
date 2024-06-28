module HDB3_code(
//global
input sys_clk,
input sys_rst_n,
input AMI_flag,
//
input 				[DATA_WIDTH-1:0]	data_in,
output reg signed	[2:0]			data_o[0:21]
	);

parameter 		DATA_WIDTH = 22;


reg signed	[1:0]	data_AMI[0:21];
reg 				cnt_oddoreven;
reg 		[4:0]	cnt_data_AMI; //给编码的码元个数计数，便于产生标志位
reg					AMI_end_flag; //AMI编码结束标志位


reg signed	[2:0] 	data_copewithzeros[0:21];
reg 		[1:0]	cnt_zeros;
reg 		[4:0]	cnt_data_copewithzeros;//给编码的码元个数计数，便于产生标志位
reg 				copewithzeros_end_flag;//结束标志位


reg signed	[2:0] 	data_copewithV[0:21];
reg			[1:0]	V_signminus_flag;
reg			[1:0]	V_signplus_flag;
reg			[4:0]	cnt_data_copewithV;//给编码的码元个数计数，便于产生标志位
reg					copewithV_end_flag;//结束标志位




//AMI编码
integer i;

always @(posedge sys_clk or negedge sys_rst_n) begin
	if (!sys_rst_n) begin
		for (i = 0 ; i < DATA_WIDTH ; i = i + 1) begin
			data_AMI[i] <= 2'b00;
		end
		cnt_oddoreven <= 1'b0;
		cnt_data_AMI <= 31'd0;
		AMI_end_flag <= 1'b0;
	end
	else if (AMI_flag == 1'b1) begin
		for (i = 0 ; i < DATA_WIDTH ; i = i + 1) begin
			if (data_in[i] == 1'b1) begin
				cnt_oddoreven <= cnt_oddoreven + 1'b1;
			end
			else if (data_in[i] == 1'b0)begin
				data_AMI[i] <= 2'b00
			end
			if (cnt_oddoreven == 1'b1) begin
				data_AMI[i] <= 2'b11;
			end
			else begin
				data_AMI[i] <= 2'b01;
			end
			cnt_data_AMI <= cnt_data_AMI + 1'b1;
		end
		if (cnt_data_AMI == DATA_WIDTH-1) begin
			AMI_end_flag<= 1'b1;
		end
	end
	else begin
		for (i = 0 ; i < DATA_WIDTH ; i = i + 1) begin
			data_AMI[i] <= 2'b00;
		end
	end
end




//在AMI编码完成之后对AMI码进行连0处理（需要将AMI编码完成的标志位加入敏感列表）

integer m;
always @(posedge sys_clk or negedge sys_rst_n) begin
	if (!sys_rst_n) begin
		for (m = 0 ; m < DATA_WIDTH ; m = m + 1) begin
			data_copewithzeros[m] <= 2'b00;
		end
		cnt_zeros <= 2'b00;
		cnt_data_copewithzeros <= 5'd0;
		copewithzeros_end_flag <= 1'b0;
	end
	else if (AMI_end_flag) begin
		for (m = 0 ; m < DATA_WIDTH ; m = m + 1) begin
			data_copewithzeros[m] <= data_AMI[m];
		end
		for (m = 1 ; m < DATA_WIDTH ; m = m + 1) begin
			if (data_AMI[m] || data_AMI[m-1] == 2'b00) begin
				cnt_zeros <= cnt_zeros + 1'b1;
			end
			else begin
				cnt_zeros <= 2'b00;
			end
			if (cnt_zeros == 2'd2) begin
				if (data_AMI[m-4][0] == 1‘b1) begin
					data_copewithzeros <= 3'b110; 
				end
				else begin
				 	data_copewithzeros <= 3'b010;
				end
			end
			cnt_data_copewithzeros <= cnt_data_copewithzeros + 1'b1;
		end
		if (cnt_data_copewithzeros == DATA_WIDTH - 1'b1) begin
			copewithzeros_end_flag <= 1'b1;
		end
	end

end






integer n;

//检查V的极性是否交替（需要将连0处理之后的标志位加入敏感列表）
always @(posedge sys_clk or negedge sys_rst_n) begin
	if (!sys_rst_n) begin
		for(n = 0 ; n < DATA_WIDTH ; n = n + 1)	begin
			data_copewithV[n] <= 2'b00;
		end
		V_signplus_flag <= 2'b00;
		V_signminus_flag<= 2'b00;
		cnt_data_copewithV <= 5'd0;
		copewithV_end_flag <= 1'b0;
	end
	else if (copewithzeros_end_flag) begin
		for(n = 0 ; n < DATA_WIDTH ; n = n + 1)	begin
			data_copewithV[n] <= data_copewithzeros;
		end
		for(n = 0 ; n < DATA_WIDTH ; n = n + 1)	begin
			if (data_copewithV == 3'b010) begin
				V_signplus_flag <= V_signplus_flag + 1'b1;
				V_signminus_flag<= 2'b00;
				if (V_signplus_flag == 2'b10) begin
					data_copewithV[n] <= 3'b110;
					data_copewithV[n-3] <= 3'b101;
					V_signplus_flag <= 2'b00;
				end
			end
			else if (data_copewithV == 3'b110) begin
				V_signminus_flag <= V_signminus_flag + 1;
				V_signplus_flag <= 2'b00;
				if (data_copewithV == 3'b110) begin
					data_copewithV[n] <= 3'b010;
					data_copewithV[n-3] <= 001;
					V_signminus_flag <= 2'b00;
				end
			end
			cnt_data_copewithV <= cnt_data_copewithV + 1'b1;
		end
		if (cnt_data_copewithV == DATA_WIDTH) begin
			copewithV_end_flag <= 1'b1;
		end
	end
end

//最后对3位的数据变为模值为1
integer p;

always @(posedge sys_clk or negedge sys_rst_n) begin
	if (!sys_rst_n) begin
		for (p = 0 ; p < DATA_WIDTH ; p = p + 1) begin
			data_o[p] <= 3'b00;
		end
	end
	else if (copewithV_end_flag) begin
		for (p = 0 ; p < DATA_WIDTH ; p = p + 1) begin
			if (data_copewithV == 3'b010) begin
				data_o[p] <= 3'b001;
			end
			else if (data_copewithV == 3'b110) begin
				data_o[p] <== 3'b101;
			end
		end
	end
end


endmodule
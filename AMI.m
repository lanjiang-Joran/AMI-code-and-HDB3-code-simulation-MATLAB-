clc;
clear all;
data_i = [1 0 1 0 1 0 1 1 0 0 0 0 1 0 0 0];
data_o = zeros(1,16);
cnt_oddoreven = 0;


for i = 1 : 16
	if data_i(i) == 1
		cnt_oddoreven = cnt_oddoreven + 1;
	else if data_i(i) == 0
		data_o(i) = 0;
        end
    end
        
	if mod(cnt_oddoreven,2) == 0 && data_i(i) == 1
		data_o(i) = 1;
	else if mod(cnt_oddoreven,2) == 1 && data_i(i) == 1
		data_o(i) = -1;
        end  
    end
end
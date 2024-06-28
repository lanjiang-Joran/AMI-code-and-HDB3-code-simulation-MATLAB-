clc;
clear all;

data_i = [1 0 0 0 0 1 0 0 0 0 1 1 0 0 0 0 0 0 0 0 1 1];
data_o = zeros(1,22);
cnt_zeros = 0;%%0计数
zeros_reg = zeros(1,4); %%临时存放分组的4个0
V_signplus_flag = 0;
V_signminus_flag = 0;
cnt_oddoreven = 0;
%%先对信息序列做AMI编码
for i = 1 : 22
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

%%对AMI编码做连0的处理

% switch abs(data_o(1))							%%判断序列第一个是否为1或-1，若是则从序列第二位开始处理？
% 	case 0
% 		for n = 2 :22
% 			if data_o(n) | data_o(n-1) == 0
% 				cnt_zeros = cnt_zeros + 1;
% 			else 
% 				cnt_zeros = 0;
% 			end
% 			if cnt_zeros == 3
% 				if data_i(n-4) < 0
% 					data_o(n) = -2 ;
% 				else 
% 					data_o(n) = 2;
% 				end
% 			end
% 		end
% 	otherwise
% 		for n = 1 :22
% 			if data_o(n) | data_o(n-1) == 0
% 				cnt_zeros = cnt_zeros + 1;
% 			else 
% 				cnt_zeros = 0;
% 			end
% 			if cnt_zeros == 3
% 				if data_o(n-4) < 0
% 					data_o(n) = -2 ;
% 				else 
% 					data_o(n) = 2;
% 				end
% 			end
% 		end
% end


for n = 2 :22
			if data_o(n) || data_o(n-1) == 0
				cnt_zeros = cnt_zeros + 1;
			else 
				cnt_zeros = 0;
			end
			if cnt_zeros == 3
				if data_o(n-4) < 0
					data_o(n) = -2 ; %将理论中连0最后的V赋值为2或者-2方便后续检查V的极性是否交替，此时符号由前一个有符号正负1决定
				else 
					data_o(n) = 2;
				end
			end
end



%检查V的极性是否交替，若出现一个2，则V_sign_flag加1，出现一个-2，V_sign_flag减1。
%理论上标志位不该出现绝对值大于1的情况，若出现说明V的极性没有交替，此时将V取反，并将000V中的第一个0取为和V极性相同的1

for m = 1: 22
	if data_o(m) == 2
		V_signplus_flag = V_signplus_flag + 1;
        V_signminus_flag = 0;
		if V_signplus_flag == 2
			data_o(m) = -2;
			data_o(m-3) = -1;
            V_signplus_flag = 0;
		end
	else if data_o(m) == -2
        V_signminus_flag = V_signminus_flag - 1;
        V_signplus_flag = 0;
		if V_signminus_flag == -2
			data_o(m) = 2;
			data_o(m-3) = 1;
            V_signminus_flag =0;
        end
        end
    end
end


%最后将所有码字变为1

for i = 1: 22
	if data_o(i) == 2
		data_o(i) = 1;
    else if data_o(i) == -2
            data_o(i) = -1;
        end
	end
end




























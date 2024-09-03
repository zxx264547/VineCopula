clear
close all
clc
load initialize_噪声
% fig
x1 = Data(:,1);
x2 = Data(:,2);%电流
x2=x1.*x2;%功率
x3 = Data(:,3);%温度
x4 = Data(:,4);%辐照度
% 利用核密度估计进行概率积分变换 ，把变量转换为[0,1]区间上的均匀分布，即将变量转换为边缘分布形式
u2 = ksdensity(x2,x2,'function','cdf');
u3 = ksdensity(x3,x3,'function','cdf');
u4 = ksdensity(x4,x4,'function','cdf');
% 控制u范围在0,1之间
u2(u2>=1) = 0.999;
u3(u3>=1) = 0.999;
u4(u4>=1) = 0.999;
% 置信水平上下限
beta1=0.98;
beta2=0.06;
u2_34_up = beta1*ones(length(u4),1);
u2_34_low = beta2*ones(length(u4),1);
%% 选择优copula
V = Cvine_select2(u2,u3,u4);
%% 获取置信区间
u2_up = Inv_Cvine2(u3,u4,u2_34_up,V);
u2_low = Inv_Cvine2(u3,u4,u2_34_low,V);
u2_up(u2_up>=1) = 0.999;
u2_low(u2_low>=1) = 0.999;

x2_up = ksdensity(x2,u2_up,'Function','icdf');
x2_low = ksdensity(x2,u2_low,'Function','icdf');
%% 数据清洗
%% 数据清洗
Dif_low = x2-x2_low;
Dif_up = x2_up-x2;
list_low = find(Dif_low<0);
list_up = find(Dif_up<0);
%第一步清理后的正常数据
DataClean_I = Data;
DataClean_I([list_low;list_up],:) = [];%第一步清洗后的电流数据
DataOut_I = Data([list_low;list_up],:);%离群数据
i_recog_out_list =sort(DataOut_I(:,5));%离群数据索引
i_recog_norm_list =sort(setdiff(list,i_recog_out_list));%正常数据索引

%% 计算识别率
recog_out_list= [i_recog_out_list];%算法识别出的离群值的索引
recog_norm_list= setdiff(list,recog_out_list);
%识别率
C = intersect(real_out_list,recog_out_list);
accuracy=length(C)/length(real_out_list);
% 误识别率
C = intersect(real_norm_list,recog_out_list);
error=length(C)/length(real_norm_list);

%out1的识别率
list_out1_recog_correct = intersect(out1_list,recog_out_list);%算法识别出来的out1的数据索引
acc_1=length(list_out1_recog_correct)/length(out1_list);

%out2的识别率
list_out2_recog_correct = intersect(out2_list,recog_out_list);%算法识别出来的out1的数据索引
acc_2=length(list_out2_recog_correct)/length(out2_list);

%out3的识别率
list_out3_recog_correct = intersect(out3_list,recog_out_list);%算法识别出来的out1的数据索引
acc_3=length(list_out3_recog_correct)/length(out3_list);

%out4的识别率
list_out4_recog_correct = intersect(out4_list,recog_out_list);%算法识别出来的out1的数据索引
acc_4=length(list_out4_recog_correct)/length(out4_list);

figure('Name','最终结果')
scatter(Data(recog_norm_list,4),Data(recog_norm_list,2),13,'b.')
hold on
scatter(Data(recog_out_list,4),Data(recog_out_list,2),13,'r.')
xlabel('辐照度(W/m^2)')
ylabel('电流(A)')

list_out_one_step=recog_out_list;
%save('F:\MATLAB\两步copula\识别出的异常值索引\list_out_one_step.mat', 'list_out_one_step');
%save('F:\MATLAB\两步copula\结果\one_step.mat');
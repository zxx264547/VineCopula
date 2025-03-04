clear
close all
clc
%% 数据初始化
% 训练样本相关数据
% 数据集分别对应V、I、T、Ir
load real_data
% 预处理数据
data= preprocess(data);
list=[1:length(data)]';
data=[data,list];
[out1_list,out2_list,out3_list,out4_list,Data]=error_data_process(data);
%给数据添加索引，方便后面计算识别率
real_out_list=sort([out1_list;out2_list;out3_list;out4_list]);
real_norm_list= sort(setdiff(list,real_out_list));
% save('F:\MATLAB\两步copula\initialize_噪声.mat');
% save('F:\MATLAB\两步copula\initialize_无噪声.mat');

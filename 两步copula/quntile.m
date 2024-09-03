clear
close all
clc
load initialize_噪声
%% 电流数据识别
list_abnorm_i=[];
list_upthreshold_i=[];
list_lowthreshold_i=[];
n=1090;
T=10;
for i=0:T:n
    list0=find(Data(:,4) >= i & Data(:,4) < i+T);
    DAT=Data(list0,:);
    % 按电流值从小到大排序
    sorted_data = sortrows(DAT, 2);
    % 找到Q1、Q2（中位数）、Q3
    Q1 = prctile(sorted_data(:, 2), 25);
    Q2 = prctile(sorted_data(:, 2), 50);
    Q3 = prctile(sorted_data(:, 2), 75);
    % 计算IQR
    IQR = Q3 - Q1;
    % 计算上下阈值
    lower_threshold = Q1 - 1.5 * IQR;
    upper_threshold = Q3 + 1.5 * IQR;
    %数据识别
    Dif_low = DAT(:,2)-lower_threshold;
    Dif_up = upper_threshold-DAT(:,2);
    list_low = find(Dif_low<0);
    list_up = find(Dif_up<0);
    list_abnorm_i = [list_abnorm_i;DAT(list_low,5);DAT(list_up,5)];%离群数据索引
    list_upthreshold_i=[list_upthreshold_i;lower_threshold*ones(T,1)];
    list_lowthreshold_i=[list_lowthreshold_i;upper_threshold*ones(T,1)];
end

%% 可视化
figure(1)
list_norm = setdiff(list,list_abnorm_i);%正常数据索引
scatter(Data(list_abnorm_i,4),Data(list_abnorm_i,2),13,'r.');
hold on
scatter(Data(list_norm,4),Data(list_norm,2),13,'b.');
plot(0:length(list_upthreshold_i)-1,list_upthreshold_i,'g');
hold on
plot(0:length(list_lowthreshold_i)-1,list_lowthreshold_i,'g');
hold on
xlabel('辐照度');
ylabel('电流');
legend('正常值','异常值','上、下边界')
data_1=Data;
data_1(list_abnorm_i,:)=[];
%% 电压数据清洗
list_abnorm_v=[];
list_upthreshold_v=[];
list_lowthreshold_v=[];
T=0.5;
for i=-9:T:24
    list0=find(data_1(:,3) >= i & data_1(:,3) < i+T);
    DAT=data_1(list0,:);
    % 按电压值从小到大排序
    sorted_data = sortrows(DAT, 1);
    % 找到Q1、Q2（中位数）、Q3
    Q1 = prctile(sorted_data(:, 1), 25);
    Q2 = prctile(sorted_data(:, 1), 50);
    Q3 = prctile(sorted_data(:, 1), 75);
    % 计算IQR
    IQR = Q3 - Q1;
    % 计算上下阈值
    lower_threshold = Q1 - 1.5 * IQR;
    upper_threshold = Q3 + 1.5 * IQR;
    %数据识别
    Dif_low = DAT(:,1)-lower_threshold;
    Dif_up = upper_threshold-DAT(:,1);
    list_low = find(Dif_low<0);
    list_up = find(Dif_up<0);
    list_abnorm_v = [list_abnorm_v;DAT(list_low,5);DAT(list_up,5)];%离群数据索引
    list_upthreshold_v=[list_upthreshold_v;lower_threshold];
    list_lowthreshold_v=[list_lowthreshold_v;upper_threshold];
end
%% 可视化
figure(2)
list_norm = setdiff(data_1(:,5),list_abnorm_v);%正常数据索引
scatter(Data(list_abnorm_v,3),Data(list_abnorm_v,1),13,'r.');
hold on
scatter(Data(list_norm,3),Data(list_norm,1),13,'b.');
plot(-9:T:24,list_upthreshold_v,'g');
hold on
plot(-9:T:24,list_lowthreshold_v,'g');
hold on
xlabel('辐照度');
ylabel('电压');
legend('正常值','异常值','上、下边界')

% %% 计算识别率
% list_norm_real=[1:length(data_norm)]';
% list_out_real=[length(data_norm)+1:length([data_norm;error_data])]';%真实的错误数据索引
% list_out_recog = [list_abnorm_i;list_abnorm_v];%算法识别出的离群值的索引
%% 计算识别率
recog_out_list = [list_abnorm_i;list_abnorm_v];%算法识别出的离群值的索引
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
list_out_quantile=recog_out_list;
%save('F:\MATLAB\两步copula\识别出的异常值索引\list_out_quantile.mat', 'list_out_quantile');
%save('F:\MATLAB\两步copula\结果\quantile.mat');
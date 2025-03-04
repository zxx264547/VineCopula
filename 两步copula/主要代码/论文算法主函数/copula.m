clear
close all
clc
load initialize_无噪声
% 变量顺序
x2 = Data(:,2);%电流
x4 = Data(:,4);%辐照度
% 利用核密度估计进行概率积分变换 ，把变量转换为[0,1]区间上的均匀分布，即将变量转换为边缘分布形式
u2 = ksdensity(x2,x2,'function','cdf');
u4 = ksdensity(x4,x4,'function','cdf');
% 控制u范围在0,1之间
u2(u2>=1) = 0.999;
u4(u4>=1) = 0.999;
% 置信水平上下限
beta1=0.98;
beta2=0.04;
u2_4_up = beta1*ones(length(u4),1);
u2_4_low = beta2*ones(length(u4),1);
%% 选择优copula
C24 = Copula_selcet(u2,u4);
%% 获取置信区间
u2_up=Inv_Copula(C24 , u2_4_up , u4);
u2_low=Inv_Copula(C24 , u2_4_low , u4);
u2_up(u2_up>=1) = 0.999;
u2_low(u2_low>=1) = 0.999;
x2_up = ksdensity(x2,u2_up,'Function','icdf');
x2_low = ksdensity(x2,u2_low,'Function','icdf');
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
%% 可视化
%%%图一:电流—辐照度
figure('NAME','辐照度—电流')
scatter(x4(i_recog_norm_list ),x2(i_recog_norm_list ),13,'b.');
hold on
scatter(x4(i_recog_out_list ),x2(i_recog_out_list ),13,'r.');
% 光伏电流曲线置信边界（辐照度—电流）
hold on
[x4_2,I] = sort(x4);
plot(x4_2,x2_up(I),'g');
hold on
plot(x4_2,x2_low(I),'g');
hold off
xlabel('辐照度')
ylabel('电流')
% %%图二：光伏电流曲线置信区间（时序）
figure('Name','电流置信区间')
plot([1:length(x2)],x2,'b');
hold on
plot([1:length(x2)],x2_low,'r--');
plot([1:length(x2)],x2_up,'r--');
xlabel('采样点序号')
ylabel('电流(I)')
legend('采样点电流','上、下边界')
hold off
% %%图三：异常分布真实情况
figure('Name','辐照度-电流-真实')
scatter(Data(real_norm_list,4),Data(real_norm_list,2),'b.')
hold on
scatter(Data(real_out_list,4),Data(real_out_list,2),'r.')
xlabel('辐照度')
ylabel('电流')
%% 删除阈值之外的数据后，清洗电压数据
x1 = DataClean_I(:,1);%电压
x3 = DataClean_I(:,3);%温度
u1 = ksdensity(x1,x1,'function','cdf');
u3 = ksdensity(x3,x3,'function','cdf');
u1(u1>=1) = 0.999;
u3(u3>=1) = 0.999;
%设置置信概率

u1_3_up = beta1*ones(length(u3),1);
u1_3_low = beta2*ones(length(u3),1);
C13 = Copula_selcet(u1,u3);
u1_up=Inv_Copula(C13 , u1_3_up , u3);
u1_low=Inv_Copula(C13 , u1_3_low , u3);
u1_up(u1_up>=1) = 0.999;
u1_low(u1_low>=1) = 0.999;
x1_up = ksdensity(x1,u1_up,'Function','icdf');
x1_low = ksdensity(x1,u1_low,'Function','icdf');
%% 数据清理
Dif_low = x1-x1_low;
Dif_up = x1_up-x1;
list_low = find(Dif_low<0);
list_up = find(Dif_up<0);
DataOut_V = DataClean_I([list_low;list_up],:);%离群数据
v_recog_out_list =sort(DataOut_V(:,5) );%离群数据索引
v_recog_norm_list =sort(setdiff(DataClean_I(:,5),v_recog_out_list));%正常数据索引
%% 可视化
% 清洗前后数据对比
figure('Name','温度-电压-清洗后')
scatter(Data(v_recog_norm_list,3),Data(v_recog_norm_list,1),13,'b.');
hold on;
scatter(Data(v_recog_out_list,3),Data(v_recog_out_list,1),13,'r.');
% 光伏电流曲线置信区间（温度—电压）
hold on
[x3_2,I] = sort(x3);
plot(x3_2,x1_up(I),'g');
hold on
plot(x3_2,x1_low(I),'g');
hold off
xlabel('温度')
ylabel('电压')
legend('正常值','异常值','上、下边界')
% 光伏电压曲线置信区间（时序）
figure('Name','电压置信区间')
plot([1:length(x1)],x1,'b');
hold on
plot([1:length(x1)],x1_low,'r--');
plot([1:length(x1)],x1_up,'r--');
xlabel('采样点序号')
ylabel('电压(V)')
legend('采样点电压','上、下边界')
hold off
% 异常分布真实情况
figure('Name','辐照度-电压-真实')
scatter(Data(real_norm_list,4),Data(real_norm_list,1),'b.')
hold on
scatter(Data(real_out_list,4),Data(real_out_list,1),'r.')
xlabel('辐照度')
ylabel('电流')
%% 计算识别率
recog_out_list= [i_recog_out_list;v_recog_out_list];%算法识别出的离群值的索引
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

list_out_copula=recog_out_list;
% save('F:\MATLAB\两步copula\识别出的异常值索引\list_out_copula.mat', 'list_out_copula');
% save('F:\MATLAB\两步copula\结果\copula.mat');
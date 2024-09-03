clear
close all
clc
% load initialize_噪声
% load initialize_无噪声
load real_data
list=(1:length(data))';
Data=[data,list];
x2 = Data(:,2);%电流
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
beta1=0.99;
beta2=0.02;
u2_34_up = beta1*ones(length(Data),1);
u2_34_low = beta2*ones(length(Data),1);
%% 选择优copula
V_i= Cvine_select3(u2,u3,u4);
VINE = Cvine2(u2,u3,u4,V_i);
%% 获取置信区间
u2_up = Inv_Cvine2(u3,u4,u2_34_up,V_i);
u2_low = Inv_Cvine2(u3,u4,u2_34_low,V_i);
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
% 清洗前后数据对比
figure('NAME','电流——辐照度')
scatter3(x3(i_recog_norm_list),x4(i_recog_norm_list),x2(i_recog_norm_list),13,'b.')
hold on
scatter3(x3(i_recog_out_list),x4(i_recog_out_list),x2(i_recog_out_list),13,'r.')
hold on
% 光伏电流曲线置信区间（温度—电压）
% 定义用于绘制曲面图的网格密度
density = 100;
% 创建用于绘制曲面图的网格点
x_grid = linspace(min(x3), max(x3), density);
y_grid = linspace(min(x4), max(x4), density);
[X, Y] = meshgrid(x_grid, y_grid);
% 插值 z 值，以适应网格
Z = griddata(x3,x4, x2_up, X, Y, 'linear');
s=0.8;
surf(X, Y, Z,'FaceAlpha',s);
hold on
Z = griddata(x3, x4, x2_low, X, Y, 'linear');
surf(X, Y, Z,'FaceAlpha',s);
shading interp
legend('正常值','异常值','上、下边界')
xlabel('温度(℃)')
ylabel('辐照度(W/m^2)')
zlabel('电流(A)')
% 光伏电流曲线置信区间（时序）
figure('Name','置信区间')
plot([1:length(x2)],x2,'b');
hold on
plot([1:length(x2)],x2_low,'r--');
plot([1:length(x2)],x2_up,'r--');
xlabel('采样点序号')
ylabel('电流(I)')
legend('采样点电流','上、下边界')
hold off
% 异常分布真实情况
figure('Name','辐照度-电流-真实')
scatter3(Data(real_norm_list,4),Data(real_norm_list,3),Data(real_norm_list,2),13,'b.');
hold on
scatter3(Data(real_out_list,4),Data(real_out_list,3),Data(real_out_list,2),13,'r.');
xlabel('温度(℃)')
ylabel('辐照度(W/m^2)')
zlabel('电流(A)')
legend('正常值','异常值')
%% 第二步
x1 = DataClean_I(:,1);%电压
x3 = DataClean_I(:,3);%温度
x4 = DataClean_I(:,4);%辐照度
u1 = ksdensity(x1,x1,'function','cdf');
u3 = ksdensity(x3,x3,'function','cdf');
u4 = ksdensity(x4,x4,'function','cdf');
u1(u1>=1) = 0.999;
u3(u3>=1) = 0.999;
u4(u4>=1) = 0.999;
u1_34_up = 0.99*ones(length(u3),1);
u1_34_low = 0.01*ones(length(u3),1);
%% 利用训练样本生成Dvine
V_v = Cvine_select2(u1,u3,u4);
%% 获取置信区间
u1_up = Inv_Cvine2(u3,u4,u1_34_up,V_v);
u1_low = Inv_Cvine2(u3,u4,u1_34_low,V_v);
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
figure('Name','温度-电压-清洗后')
scatter3(Data(v_recog_norm_list,3),Data(v_recog_norm_list,4),Data(v_recog_norm_list,1),13,'b.')
hold on
scatter3(Data(v_recog_out_list,3),Data(v_recog_out_list,4),Data(v_recog_out_list,1),13,'r.')
hold on
% 光伏电流曲线置信区间（温度—电压）
% 创建用于绘制曲面图的网格点
x_grid = linspace(min(x3), max(x3), density);
y_grid = linspace(min(x4), max(x4), density);
[X, Y] = meshgrid(x_grid, y_grid);
% 插值 z 值，以适应网格
Z = griddata(x3, x4, x1_up, X, Y, 'linear');
surf(X, Y, Z,'FaceAlpha',s);
hold on
Z = griddata(x3, x4, x1_low, X, Y, 'linear');
surf(X, Y, Z,'FaceAlpha',s);
shading interp
legend('正常值','异常值','上、下边界')
xlabel('温度(℃)')
ylabel('辐照度(W/m^2)')
zlabel('电压(V)')
% 光伏电压曲线置信区间（时序）
figure('Name','置信区间')
plot(1:length(x1),x1,'b');
hold on
plot(1:length(x1),x1_low,'r--');
plot(1:length(x1),x1_up,'r--');
xlabel('采样点序号')
ylabel('电压(V)')
legend('采样点电压','上、下边界')
hold off
% 异常分布真实情况
figure('Name','温度-电压-真实')
scatter3(Data(real_norm_list,4),Data(real_norm_list,3),Data(real_norm_list,1),13,'b.');
hold on
scatter3(Data(real_out_list,4),Data(real_out_list,3),Data(real_out_list,1),13,'r.');
xlabel('温度(℃)')
ylabel('辐照度(W/m^2)')
zlabel('电压(V)')
legend('正常值','异常值')
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
list_out_vine_copula=recog_out_list;
% save('F:\MATLAB\两步copula\识别出的异常值索引\list_out_vine_copula.mat', 'list_out_vine_copula');
% save('F:\MATLAB\两步copula\结果\vine_copula.mat');
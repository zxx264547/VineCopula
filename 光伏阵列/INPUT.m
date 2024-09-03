clear
clc
close all
load data
% input=[I,T];
% input=input(5201:6700,:);
% input(:,1) = fillmissing(input(:,1),'previous');
% input(:,2) = fillmissing(input(:,2),'previous');
% input(:,2)=ones(100,1)*10;
% input(:,1)=(1:10:1000)';
input(:,1)=ones(41,1)*1000;
input(:,2)=(-20:20)';
% input=input(1:4500,:);
%仿真时间
T=10;
%仿真步长
h=T/length(input);
%时间序列
time=0:h:T;
% 将数据转换为 MATLAB timeseries 对象
E = timeseries(input(:, 1), time(1:length(input)), 'Name', 'I');
T = timeseries(input(:, 2), time(1:length(input)), 'Name', 'T');
%data=[out.V_PV,out.I_PV,out.temperature,out.irradiance];



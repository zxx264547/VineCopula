clear
clc
close all
load data
E=I(1:1000);
T=T(1:1000);
time=1:1000;
% 光伏电池参数
Voc = 0.6; % 开路电压 (Volts)
Isc = 5;  % 短路电流 (Amperes)
n = 1.2;  % 理想因子
K = 0.1;  % 温度系数
Ns = 36;  % 电池电池芯片数
Tref = 25; % 参考温度 (摄氏度)

% 初始化输出变量
current = zeros(size(time));
voltage = zeros(size(time));

% 模拟光伏电池的输出电流和电压
for i = 1:length(time)
    T = T(i);
    G = E(i);
    
    % 计算电流和电压
    Tcell = T + (Tref - 25); % 考虑温度对性能的影响
    Iph = Ns * G / 1000; % 光生电流
    [I, V] = pv_model(Voc, Isc, n, K, Tcell, Iph);
    
    current(i) = I;
    voltage(i) = V;
end

% 绘制电流和电压随时间变化的图
subplot(2, 1, 1);
plot(time, current);
xlabel('时间 (小时)');
ylabel('电流 (Amperes)');
title('光伏电池输出电流');

subplot(2, 1, 2);
plot(time, voltage);
xlabel('时间 (小时)');
ylabel('电压 (Volts)');
title('光伏电池输出电压');

% 单二极管模型函数
function [I, V] = pv_model(Voc, Isc, n, K, T, Iph)
    % 定义常数
    q = 1.602176634e-19; % 电子电荷
    k = 1.380649e-23; % 玻尔兹曼常数

    % 初始化变量
    V = 0;
    I = 0;

    % 数值求解电流和电压
    options = optimset('Display', 'off');
    fun = @(x) Iph - Isc + (Isc - x(1)) * (exp((x(2) * (T - 25)) / (n * k * 273.15 + T)) - 1) - (x(1) - x(2));
    x0 = [Isc, Voc];
    sol = fsolve(fun, x0, options);
    if sol(1) >= 0 && sol(2) >= 0
        I = sol(1);
        V = sol(2);
    end
end

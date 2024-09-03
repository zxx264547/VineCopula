clc
clear
close all
load current
load predicted_current_copula
load predicted_current_one_step
load predicted_current_quantile
load predicted_current_vine_copula
load predicted_current_original
list=1:length(current);
linewidth=1;


% plot(list,predicted_current_quantile,'g','LineWidth',linewidth);
% hold on
% plot(list,predicted_current_one_step,'c','LineWidth',linewidth);
% hold on
% plot(list,predicted_current_copula,'y','LineWidth',linewidth);
% hold on
plot(list,predicted_current_vine_copula,'r','LineWidth',linewidth);
hold on
plot(list,predicted_current_original,'k','LineWidth',linewidth);
hold on
plot(list,current,'b','LineWidth',linewidth);
hold off
xlabel('采样点序号')
% ylabel('电流(A)')
ylabel('发电量(kWh)')
% legend('quantile','one-step','copula','vine-copula','未处理','原始值')
legend('N2','N1','实际')

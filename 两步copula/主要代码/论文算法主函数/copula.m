clear
close all
clc
load initialize_������
% ����˳��
x2 = Data(:,2);%����
x4 = Data(:,4);%���ն�
% ���ú��ܶȹ��ƽ��и��ʻ��ֱ任 ���ѱ���ת��Ϊ[0,1]�����ϵľ��ȷֲ�����������ת��Ϊ��Ե�ֲ���ʽ
u2 = ksdensity(x2,x2,'function','cdf');
u4 = ksdensity(x4,x4,'function','cdf');
% ����u��Χ��0,1֮��
u2(u2>=1) = 0.999;
u4(u4>=1) = 0.999;
% ����ˮƽ������
beta1=0.98;
beta2=0.04;
u2_4_up = beta1*ones(length(u4),1);
u2_4_low = beta2*ones(length(u4),1);
%% ѡ����copula
C24 = Copula_selcet(u2,u4);
%% ��ȡ��������
u2_up=Inv_Copula(C24 , u2_4_up , u4);
u2_low=Inv_Copula(C24 , u2_4_low , u4);
u2_up(u2_up>=1) = 0.999;
u2_low(u2_low>=1) = 0.999;
x2_up = ksdensity(x2,u2_up,'Function','icdf');
x2_low = ksdensity(x2,u2_low,'Function','icdf');
%% ������ϴ
Dif_low = x2-x2_low;
Dif_up = x2_up-x2;
list_low = find(Dif_low<0);
list_up = find(Dif_up<0);
%��һ����������������
DataClean_I = Data;
DataClean_I([list_low;list_up],:) = [];%��һ����ϴ��ĵ�������
DataOut_I = Data([list_low;list_up],:);%��Ⱥ����
i_recog_out_list =sort(DataOut_I(:,5));%��Ⱥ��������
i_recog_norm_list =sort(setdiff(list,i_recog_out_list));%������������
%% ���ӻ�
%%%ͼһ:���������ն�
figure('NAME','���նȡ�����')
scatter(x4(i_recog_norm_list ),x2(i_recog_norm_list ),13,'b.');
hold on
scatter(x4(i_recog_out_list ),x2(i_recog_out_list ),13,'r.');
% ��������������ű߽磨���նȡ�������
hold on
[x4_2,I] = sort(x4);
plot(x4_2,x2_up(I),'g');
hold on
plot(x4_2,x2_low(I),'g');
hold off
xlabel('���ն�')
ylabel('����')
% %%ͼ����������������������䣨ʱ��
figure('Name','������������')
plot([1:length(x2)],x2,'b');
hold on
plot([1:length(x2)],x2_low,'r--');
plot([1:length(x2)],x2_up,'r--');
xlabel('���������')
ylabel('����(I)')
legend('���������','�ϡ��±߽�')
hold off
% %%ͼ�����쳣�ֲ���ʵ���
figure('Name','���ն�-����-��ʵ')
scatter(Data(real_norm_list,4),Data(real_norm_list,2),'b.')
hold on
scatter(Data(real_out_list,4),Data(real_out_list,2),'r.')
xlabel('���ն�')
ylabel('����')
%% ɾ����ֵ֮������ݺ���ϴ��ѹ����
x1 = DataClean_I(:,1);%��ѹ
x3 = DataClean_I(:,3);%�¶�
u1 = ksdensity(x1,x1,'function','cdf');
u3 = ksdensity(x3,x3,'function','cdf');
u1(u1>=1) = 0.999;
u3(u3>=1) = 0.999;
%�������Ÿ���

u1_3_up = beta1*ones(length(u3),1);
u1_3_low = beta2*ones(length(u3),1);
C13 = Copula_selcet(u1,u3);
u1_up=Inv_Copula(C13 , u1_3_up , u3);
u1_low=Inv_Copula(C13 , u1_3_low , u3);
u1_up(u1_up>=1) = 0.999;
u1_low(u1_low>=1) = 0.999;
x1_up = ksdensity(x1,u1_up,'Function','icdf');
x1_low = ksdensity(x1,u1_low,'Function','icdf');
%% ��������
Dif_low = x1-x1_low;
Dif_up = x1_up-x1;
list_low = find(Dif_low<0);
list_up = find(Dif_up<0);
DataOut_V = DataClean_I([list_low;list_up],:);%��Ⱥ����
v_recog_out_list =sort(DataOut_V(:,5) );%��Ⱥ��������
v_recog_norm_list =sort(setdiff(DataClean_I(:,5),v_recog_out_list));%������������
%% ���ӻ�
% ��ϴǰ�����ݶԱ�
figure('Name','�¶�-��ѹ-��ϴ��')
scatter(Data(v_recog_norm_list,3),Data(v_recog_norm_list,1),13,'b.');
hold on;
scatter(Data(v_recog_out_list,3),Data(v_recog_out_list,1),13,'r.');
% ������������������䣨�¶ȡ���ѹ��
hold on
[x3_2,I] = sort(x3);
plot(x3_2,x1_up(I),'g');
hold on
plot(x3_2,x1_low(I),'g');
hold off
xlabel('�¶�')
ylabel('��ѹ')
legend('����ֵ','�쳣ֵ','�ϡ��±߽�')
% �����ѹ�����������䣨ʱ��
figure('Name','��ѹ��������')
plot([1:length(x1)],x1,'b');
hold on
plot([1:length(x1)],x1_low,'r--');
plot([1:length(x1)],x1_up,'r--');
xlabel('���������')
ylabel('��ѹ(V)')
legend('�������ѹ','�ϡ��±߽�')
hold off
% �쳣�ֲ���ʵ���
figure('Name','���ն�-��ѹ-��ʵ')
scatter(Data(real_norm_list,4),Data(real_norm_list,1),'b.')
hold on
scatter(Data(real_out_list,4),Data(real_out_list,1),'r.')
xlabel('���ն�')
ylabel('����')
%% ����ʶ����
recog_out_list= [i_recog_out_list;v_recog_out_list];%�㷨ʶ�������Ⱥֵ������
recog_norm_list= setdiff(list,recog_out_list);
%ʶ����
C = intersect(real_out_list,recog_out_list);
accuracy=length(C)/length(real_out_list);
% ��ʶ����
C = intersect(real_norm_list,recog_out_list);
error=length(C)/length(real_norm_list);

%out1��ʶ����
list_out1_recog_correct = intersect(out1_list,recog_out_list);%�㷨ʶ�������out1����������
acc_1=length(list_out1_recog_correct)/length(out1_list);

%out2��ʶ����
list_out2_recog_correct = intersect(out2_list,recog_out_list);%�㷨ʶ�������out1����������
acc_2=length(list_out2_recog_correct)/length(out2_list);

%out3��ʶ����
list_out3_recog_correct = intersect(out3_list,recog_out_list);%�㷨ʶ�������out1����������
acc_3=length(list_out3_recog_correct)/length(out3_list);

%out4��ʶ����
list_out4_recog_correct = intersect(out4_list,recog_out_list);%�㷨ʶ�������out1����������
acc_4=length(list_out4_recog_correct)/length(out4_list);

figure('Name','���ս��')
scatter(Data(recog_norm_list,4),Data(recog_norm_list,2),13,'b.')
hold on
scatter(Data(recog_out_list,4),Data(recog_out_list,2),13,'r.')
xlabel('���ն�(W/m^2)')
ylabel('����(A)')

list_out_copula=recog_out_list;
% save('F:\MATLAB\����copula\ʶ������쳣ֵ����\list_out_copula.mat', 'list_out_copula');
% save('F:\MATLAB\����copula\���\copula.mat');
clear
clc
%% Dvine���˵��
% ����Dvine�ṹ
% x1:���ն�
% x2:�¶�
% x3:ʪ��
% x4:����

%% ���ݳ�ʼ��
% ѵ�������������
% ���ݼ��ֱ��ӦP��I��T��H
% load Data_norm
load Data-GSGF4
load out_2 %λ�ڶ�άɢ��ͼ�Ϸ�
load out_3 %���ղ�Ϊ�㹦��Ϊ��
load out_4 %λ�ڶ�άɢ��ͼ�ڲ�
load out_5 %λ�ڶ�άɢ��ͼ�·�
load norm_4 %out_4��ԭʼ����

% Ԥ��������
Data_norm = preprocess(Data);

out=[out_2;out_4;out_5];
% �޸��¶ȡ�ʪ��ֵ
% out(:,3)=-10;
% out(:,4)=-90;

Data=[Data_norm;out];
P=1;I=2;T=3;H=4;
% ����˳��
% S=[H T I P];
% S=[H I T P];
% S=[T I H P];
S=[I H T P];
x1 = Data(:,S(1));
x2 = Data(:,S(2));
x3 = Data(:,S(3));
x4 = Data(:,S(4));
% ���ú��ܶȹ��ƽ��и��ʻ��ֱ任
u1 = ksdensity(x1,x1,'function','cdf','Bandwidth',0.1);% �ѱ���ת��Ϊ[0,1]�����ϵľ��ȷֲ�
u2 = ksdensity(x2,x2,'function','cdf','Bandwidth',0.1);
u3 = ksdensity(x3,x3,'function','cdf','Bandwidth',0.1);
u4 = ksdensity(x4,x4,'function','cdf','Bandwidth',0.1);
% ����u��Χ��0,1֮��
u1(u1==1) = 0.999;
u2(u2==1) = 0.999;
u3(u3==1) = 0.999;
u4(u4==1) = 0.999;
% ����ˮƽ������
u4_123_up = 0.98*ones(length(u1),1);
u4_123_low = 0.02*ones(length(u1),1);

%% ����ѵ����������Dvine
V = Cvine_select(u1,u2,u3,u4);

%% ��ȡ��������
% �����������飬����ѭ����ÿ�����ݽ������
U4_up = Inv_Cvine(u1,u2,u3,u4_123_up,V);
U4_low = Inv_Cvine(u1,u2,u3,u4_123_low,V);
up =  U4_up;
low = U4_low;
up(up>=1) = 0.999;
low(low>=1) = 0.999;
X4_up = ksdensity(x4,up,'Function','icdf','Bandwidth',0.1);
X4_low = ksdensity(x4,low,'Function','icdf','Bandwidth',0.1);

x_P_up = X4_up;
x_P_low = X4_low; 
x_P = Data(:,P);
x_I = Data(:,I);

%% ����ʶ����
list_norm=[1:length(Data_norm)]';
list_out2=[length(Data_norm)+1:length([Data_norm;out_2])]';
list_out4=[length([Data_norm;out_2])+1:length([Data_norm;out_2;out_4])]';
list_out5=[length([Data_norm;out_2;out_4])+1:length([Data_norm;out_2;out_4;out_5])]';

list_id = Identify(x_P,x_P_low,x_P_up);

% out_2ʶ��׼ȷ�ʣ�����һ
C = intersect(list_out2,list_id);
accuracy_out2=length(C)/length(list_out2);
% out_4ʶ��׼ȷ��
C = intersect(list_out4,list_id);
accuracy_out4=length(C)/length(list_out4);
% out_5ʶ��׼ȷ�ʣ����Ͷ�
C = intersect(list_out5,list_id);
accuracy_out5=length(C)/length(list_out5);
% ��ʶ����
C = intersect([list_out2;list_out4;list_out5],list_id);
accuracy_total=(200+length(C))/(length([list_out2;list_out4;list_out5])+200);%����������ʶ����
% ��ʶ����
C = intersect(list_norm,list_id);
error=length(C)/length(list_norm);

%% ��ϴ�����ӻ�
Clean2

%% �쳣�ֲ���ʵ���
figure('Name','���ն�-����-��ʵ')
group = ones(length(x_I),1);
gscatter(x_I,x_P,group,[0 0 1],[],6)
hold on
group = ones(length(out),1);
gscatter(out(:,2),out(:,1),group,[1 0 0],[],6)
axis square
xlabel('���ն�')
ylabel('����')



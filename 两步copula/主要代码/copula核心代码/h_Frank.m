function y = h_Frank(u1,u2,p)

%% ����Frank Copula��h������F(u1|u2)
% syms C(u,v) h(u,v)
% % ԭFrank Copula���ʽ
% C(u,v)=(-1/p)*log(1+(exp(-p*u)-1)*(exp(-p*v)-1)/(exp(-p)-1));
% % ��v�󵼺�Ļ��h�������ʽ
% h(u,v)=diff(C(u,v),v);
% % �����ʽתΪ�������
% h=matlabFunction(h,'Vars',[u v]);

%% ������
% y=arrayfun(h,u1,u2);

%% ���ý������ʽ1���м���
% x1=exp(-p*u1)-1;
% x2=exp(-p*u2);
% C=exp(-p)-1;
% up=x1.*x2;
% low=C+x1.*(x2-1);
% y2=up./low;

%% ���ý������ʽ2���м���
a=exp(p*(1-u1-u2));
b=exp(p*(1-u2));
c=exp(p*(1-u1));
y=(a-b)./(1+a-b-c);
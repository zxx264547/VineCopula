function y = h_Gumbel(u1,u2,p)

%% ����Gumbel Copula��h������F(u1|u2)
% syms C(u,v) h(u,v)
% % ԭGumbel Copula���ʽ
% C(u,v)=exp(-((-log(u))^(1/p)+(-log(v))^(1/p))^p);
% % ��v�󵼺�Ļ��h�������ʽ
% h(u,v)=diff(C(u,v),v);
% % �����ʽתΪ�������
% h=matlabFunction(h,'Vars',[u v]);

%% ������
% y=arrayfun(h,u1,u2);

%% 
C1=exp(-((-log(u1)).^(p)+(-log(u2)).^(p)).^(1/p));
C2=(-log(u2)).^(p-1);
C3=((-log(u1)).^(p)+(-log(u2)).^(p)).^(1/p-1);
y=C1.*(1./u2).*C2.*C3;
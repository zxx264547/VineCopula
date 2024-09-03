function y = h_Clayton(u1,u2,p)

%% ����Clayton Copula��h������F(u1|u2)
% syms C(u,v) h(u,v)
% % ԭClayton Copula���ʽ
% C(u,v)=(u^(-p)+v^(-p)-1)^(-1/p);
% % ��v�󵼺�Ļ��h�������ʽ
% h(u,v)=diff(C(u,v),v);
% % �����ʽתΪ�������
% h=matlabFunction(h,'Vars',[u v]);

%% ����h����������
% y=double(h(x1,x2,pp));
% y=arrayfun(h,u1,u2);

%%
a=(u1.^(-p)+u2.^(-p)-1).^(-1-1/p);
y=(u2.^(-p-1)).*a;


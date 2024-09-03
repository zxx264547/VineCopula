function u1 = Inv_Clayton(y,u2,p)
% y=F(u1|u2),u1=F(x1),u2=F(x2)

%% ����Clayton Copula��h������F(u1|u2)
% L=length(y);
% u1=zeros(L,1);
% syms u v
% % ԭClayton Copula���ʽ
% C=(u^(-p)+v^(-p)-1)^(-1/p);
% % ��v�󵼺�Ļ��h�������ʽ
% h=diff(C,v);

%% �ⷽ��-����y��u2���u1
% for i=1:L
% %     i
%     % �ѷ���v�滻Ϊ��ֵu2(i)
%     h2=subs(h,v,u2(i));
%     % �ⷽ��
%     eqns=h2==y(i);
%     x=solve(eqns,u,'Real',true);
%     % ������
%     x=double(x);
%     u1(i)=x(x>0);
% end

%%
a=(y.*(u2.^(p+1))).^(-p/(p+1));
u1=(a+1-u2.^(-p)).^(-1/p);

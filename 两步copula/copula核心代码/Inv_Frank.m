function u1 = Inv_Frank(y,u2,p)
% y=F(u1|u2),u1=F(x1),u2=F(x2)

%% ����Frank Copula��h������F(u1|u2)
% L=length(y);
% u1=zeros(L,1);
% syms C(u,v) h(u,v)
% % ԭFrank Copula���ʽ
% C(u,v)=(-1/p)*log(1+(exp(-p*u)-1)*(exp(-p*v)-1)/(exp(-p)-1));
% % ��v�󵼺�Ļ��h�������ʽ
% h(u,v)=diff(C(u,v),v);

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
% ����ǰ
% a=(exp(-p)-1)*y;
% b=exp(-p*u2);
% x=a./(y+b-y.*b);
% u1=log(x+1)/(-p);
% ���κ�
% a=(1-exp(p))*y;
% b=exp(p*(1-u2));
% x=a./(y*exp(p)+b-y.*b);
% u1=log(x+1)/(-p);
% ����
a=(1-exp(p))*y;
b=exp(p*(1-u2));
% x=a./(y*exp(p)+b-y.*b);
fenzi = a+y*exp(p)+b-y.*b;
fenmu = y*exp(p)+b-y.*b;
u1 = (log(fenzi)-log(fenmu))/(-p);
% u1 = u1;

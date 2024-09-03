function u1 = Inv_Gumbel(y,u2,p)
% y=F(u1|u2),u1=F(x1),u2=F(x2)

%% ����Gumbel Copula��h������F(u1|u2)
L=length(y);
u1=zeros(L,1);
for i=1:L
    v=u2(i);
    myfun=@(uu)exp(-((-log(uu))^(p)+(-log(v))^(p))^(1/p))*...
        (1/v)*(-log(v))^(p-1)*...
        ((-log(uu))^(p)+(-log(v))^(p))^(1/p-1)-y(i);
    u1(i)=fzero(myfun,[0,1]);
end
% L=length(y);
% u1=zeros(L,1);
% for i=1:L
%     i
%     syms h(u)
%     v=u2(i);
%     h(u)=exp(-((-log(u))^(p)+(-log(v))^(p))^(1/p))*...
%         (1/v)*(-log(v))^(p-1)*...
%         ((-log(u))^(p)+(-log(v))^(p))^(1/p-1);
%     eqns=h(u)==y(i);
%     x=vpasolve(eqns,u);
%     x=double(x);
%     u1(i)=double(x);
% end

% v=u2;
%     function F = myfun(x)
%         F = exp(-((-log(x))^(p)+(-log(v))^(p))^(1/p))*...
%             (1/v)*(-log(v))^(p-1)*...
%             ((-log(x))^(p)+(-log(v))^(p))^(1/p-1)-y;
%     end
%
% x=fsolve(@myfun,1);
% u1=x;


%% �ⷽ��-����y��u2���u1
% h2=subs(h,v,2)
% for i=1:L
%     i
%     % �ѷ���v�滻Ϊ��ֵu2(i)
%     h2=subs(h,v,u2(i));
%     % �ⷽ��
%     eqns=h2==y(i);
%     x=solve(eqns,u,'Real',true);
%     % ������
%     x=double(x);
%     u1(i)=x(x>0);
% end
end

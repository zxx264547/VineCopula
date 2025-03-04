function y = h_t(u1,u2,r,nu)

%% ����t-Copula��h������F(u1|u2)
x1=tinv(u1,nu);
x2=tinv(u2,nu);
A=sqrt((nu+x2.^2)*(1-r^2)/(nu+1));
x=(x1-r*x2)./A;

%% ������
y=tcdf(x,nu+1);
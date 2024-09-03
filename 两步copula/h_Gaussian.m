function y = h_Gaussian(u1,u2,r)

%% ����Gaussian Copula��h������F(u1|u2)
x1=norminv(u1);
x2=norminv(u2);
x=(x1-r*x2)/(sqrt(1-r^2));

%% ������
y=normcdf(x);

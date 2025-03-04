function [BestCopula,GOF_AIC] = Copula_selcet(u1,u2)
%UNTITLED6 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

%% �����������copula�����۲���GOF
Name={'type','mle','BIC','AIC','P1','P2'};%copula������������Ȼֵ��BICָ�꣬AICָ�꣬���Ʋ���ֵ
GOF(1,:)=string(Name);
Ns=length(u1);

% Clayton copula
clt = copulafit('Clayton',[u1 u2]);%copula��������ֵ
y = copulapdf('Clayton',[u1 u2],clt);%�����ܶ�
mle_clt=sum(log(y));
BIC_clt=1*log(Ns)-2*mle_clt;
AIC_clt=2*1-2*mle_clt;
GOF(2,:)=string({'Clayton',mle_clt,BIC_clt,AIC_clt,clt,'-'});

% Frank copula
fr = copulafit('Frank',[u1 u2]);
y = copulapdf('Frank',[u1 u2],fr);
mle_fr=sum(log(y));
BIC_fr=1*log(Ns)-2*mle_fr;
AIC_fr=2*1-2*mle_fr;
GOF(3,:)=string({'Frank',mle_fr,BIC_fr,AIC_fr,fr,'-'});

% Gaussian copula
gauss = copulafit('Gaussian',[u1 u2]);
y = copulapdf('Gaussian',[u1 u2],gauss);
mle_gauss=sum(log(y));
BIC_gauss=1*log(Ns)-2*mle_gauss;
AIC_gauss=2*1-2*mle_gauss;
GOF(4,:)=string({'Gaussian',mle_gauss,BIC_gauss,AIC_gauss,gauss(1,2),'-'});

% t copula
[tr,tn] = copulafit('t',[u1 u2]);
y = copulapdf('t',[u1 u2],tr,tn);
mle_t=sum(log(y));
BIC_t=2*log(Ns)-2*mle_t;
AIC_t=2*2-2*mle_t;
GOF(5,:)=string({'t',mle_t,BIC_t,AIC_t,tr(1,2),tn});

% Gumbel copula
gb = copulafit('Gumbel',[u1 u2]);
y = copulapdf('Gumbel',[u1 u2],gb);
mle_gb=sum(log(y));
BIC_gb=1*log(Ns)-2*mle_gb;
AIC_gb=2*1-2*mle_gb;
GOF(6,:)=string({'Gumbel',mle_gb,BIC_gb,AIC_gb,gb,'-'});

%% �����۽����������ɸѡ
% �����ȻֵmleԽ��Խ��
% mle=double(GOF(2:6,2));
% [~,Ind]=sort(mle,'descend' );
% GOF_mle=GOF(Ind+1,:);
% GOF_mle=[Name;GOF_mle];

% ��Ҷ˹��Ϣ׼��BICԽСԽ��
% BIC=double(GOF(2:6,3));
% [~,Ind]=sort(BIC,'ascend');
% GOF_BIC=GOF(Ind+1,:);
% GOF_BIC=[Name;GOF_BIC];

% �����Ϣ׼��AIC(�����)��ԽСԽ��
AIC=double(GOF(2:end,4));
[~,Ind]=sort(AIC,'ascend');
GOF_AIC=GOF(Ind+1,:);
GOF_AIC=[Name;GOF_AIC];

% ����Copula
BestCopula=GOF_AIC(2,:);

end


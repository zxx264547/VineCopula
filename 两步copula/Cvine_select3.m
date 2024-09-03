function C = Cvine_select3(u1,u2,u3)
%% ��һ��
%ѡ�����Žṹ(�������֮������ϵ��)
tau_23= corr(u2, u3, 'type', 'kendall');
tau_12=corr(u1, u2, 'type', 'kendall');
tau_13=corr(u1, u3, 'type', 'kendall');
%��������������Ľṹ(u1������Ϊ���ڵ�)
if tau_23+tau_12> tau_23+tau_13
    tau_max=tau_23+tau_12;
    root=2;%1-2-3
else
    tau_max=tau_23+tau_13;
    root=3;%1-3-2
end

if root==2
    % ѡ������copula
    C1 = Copula_selcet(u1,u2);%ѡȡ��һ���ߵ�copula����(TE)
    C2 = Copula_selcet(u2,u3);%ѡȡ�ڶ����ߵ�copula����
    % ��������copula��������cdfֵ
    u_12 = Get_Ccdf(C1,u1,u2);%��һ���ߵ�����cdfֵ
    u_23 = Get_Ccdf(C2,u2,u3);%�ڶ����ߵ�����cdfֵ
    u_12(u_12>=1)=0.999;
    u_23(u_23>=1)=0.999;
    % �ڶ���
    % ѡ������copula
    C3 = Copula_selcet(u_12,u_23);
    tau_123= corr(u_12, u_23, 'type', 'kendall');
    
elseif root == 3
    % ѡ������copula
    C1 = Copula_selcet(u2,u3);%ѡȡ��һ���ߵ�copula����(TE)
    C2 = Copula_selcet(u1,u3);%ѡȡ�ڶ����ߵ�copula����
    % ��������copula��������cdfֵ
    u_13 = Get_Ccdf(C1,u2,u3);%��һ���ߵ�����cdfֵ
    u_23 = Get_Ccdf(C2,u1,u3);%�ڶ����ߵ�����cdfֵ
    u_13(u_13>=1)=0.999;
    u_23(u_23>=1)=0.999;
    % �ڶ���
    % ѡ������copula
    C3 = Copula_selcet(u_13,u_23);
    tau_123= corr(u_13, u_23, 'type', 'kendall');
end
C = {C1;C2;C3};

end


function list_out = Identify(x,x_low,x_up)
%���ܣ�ʶ�����Ⱥֵ
%���룺ԭʼ���ݺ����±߽�
%�������Ⱥֵ������
%% �쳣����ʶ��
Dif_low = x-x_low;
Dif_up = x_up-x;
list_low = find(Dif_low<0);
list_up = find(Dif_up<0);
list_out = [list_low;list_up];

end


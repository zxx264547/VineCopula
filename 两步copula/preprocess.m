function Data = preprocess(Data)
%UNTITLED2 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
x_V = Data(:,1);
x_I = Data(:,2);
x_T = Data(:,3);
x_E = Data(:,4);
%���ȱʧֵ
x_V = fillmissing(x_V,'previous');
x_T = fillmissing(x_T,'previous');
x_I = fillmissing(x_I,'previous');
x_E = fillmissing(x_E,'previous');

Data = [x_V,x_I,x_T,x_E];
% Data(Data(:,4)>=1000,:) =0;
% Data(Data(:,4)==0,:) =[];

%�������������
%��������
% 
% a=0.98;
% num=fix(a*length(Data));
% list=randperm(length(Data),num);
% % % b=0.04;
% % % Data_norm(list,1)=abs((1+b*randn(num,1)).*Data_norm(list,1));
% % % Data_norm(list,2)=abs((1+b*randn(num,1)).*Data_norm(list,2));
% % 
% for i=1:length(list)
% %     if Data(list(i),4)>100
% %     Data(list(i),1)=abs(normrnd(Data(list(i),1), (25-(0.01*Data(list(i),4)-5)^2)*5, 1, 1));
% %     Data(list(i),2)=abs(normrnd(Data(list(i),2), (25-(0.01*Data(list(i),4)-5)^2)*0.5, 1, 1));
% %     else 
%     Data(list(i),1)=abs(normrnd(Data(list(i),1), (25-(0.01*Data(list(i),4)-5)^2)*2, 1, 1));
%     Data(list(i),2)=abs(normrnd(Data(list(i),2), (25-(0.01*Data(list(i),4)-5)^2)*0.2, 1, 1));
% %     end
%     Data(list(i),3)=normrnd(Data(list(i),3), 1, 1, 1);
%     Data(list(i),4)=abs(normrnd(Data(list(i),4), 5, 1, 1));
% 
% end
% 
% 
% % Data_norm(list,3)=(1+0.03*randn(num,1)).*Data_norm(list,3);
% % Data_norm(list,4)=abs((1+0.03*randn(num,1)).*Data_norm(list,4));
% % Data_norm(Data_norm(:,1)==0|Data_norm(:,2)==0|Data_norm(:,4)==0,:)=[];
% Data(Data(:,1)==0|Data(:,2)==0,:)=[];
% % Data_norm(Data_norm(:,4)==0,:)=[];
% 
% 
% 
% % ����Ҫɾ��������
% rows_to_delete = round(0.3 * sum(Data(:, 4) >= 0 & Data(:, 4) <= 200));
% 
% % ���ɷ��Ϸ�Χ�������е������б�
% valid_indices = find(Data(:, 4) >= 0 & Data(:, 4) <= 200);
% 
% % ���ѡ��Ҫɾ�����е�����
% random_indices = randsample(valid_indices, rows_to_delete);
% 
% % �����������ɾ����Ӧ����
% Data(random_indices, :) = [];
% 
% % ���ڣ�data �а�����ɾ��20%�������



end


   %% ��ջ�������
clc
clear

%% ѵ������Ԥ��������ȡ����һ��
%��������
A=xlsread('GFSJy.xlsx','ԭʼ����','B13887:N14606');
A(find(A(:,1)==0),:)=[];
B=A(:,2:end);
C=A(:,1)';
%�������
k=rand(1,450);
[m,n]=sort(k);

%�ҳ�ѵ�����ݺ�Ԥ������
input_train=B(n(1:450),:)';
output_train=C(n(1:450));
input_test=B((451:466),:)';
output_test=C(:,(451:466));

%ѡ����������������ݹ�һ��
[inputn,inputps]=mapminmax(input_train);
[outputn,outputps]=mapminmax(output_train);

%% BP����ѵ��
% %��ʼ������ṹ
net=newff(inputn,outputn,11);

net.trainParam.epochs=50;  %ѵ������Ϊ100��
net.trainParam.lr=0.01;  %ѧϰ����Ϊ0.1
net.trainParam.goal=0.01;  %ѵ��Ŀ����С������Ϊ0.01

%����ѵ��
net=train(net,inputn,outputn);

%% BP����Ԥ��
%Ԥ�����ݹ�һ��
inputn_test=mapminmax('apply',input_test,inputps);
 
%����Ԥ�����
an=sim(net,inputn_test);
 
%�����������һ��
BPoutput=mapminmax('reverse',an,outputps);

%% �������

figure(1)
plot(BPoutput)
hold on
plot(output_test);
legend('Ԥ��ֵ','��ʵֵ')
title('BP����Ԥ�����','fontsize',12)
ylabel('������ֵ','fontsize',12)
xlabel('����','fontsize',12)
%Ԥ�����
error=BPoutput-output_test;


figure(2)
plot(error)
title('BP����Ԥ�����','fontsize',12)
ylabel('���','fontsize',12)
xlabel('����','fontsize',12)

figure(3)
plot((output_test-BPoutput)./BPoutput);
title('BP����Ԥ�����ٷֱ�')

errorsum=sum(abs(error))
mse = sum((BPoutput-output_test).^2)./16
mae = sum(abs(BPoutput-output_test))/16
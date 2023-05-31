%����ֵ��[0-255]֮�������ź����У�����50��%
signal=generate_signal(50) 

%����MATLAB���źŽ��������ֱ���%
lossless_differ=lossless_code(signal)
%����MATLAB���źŽ��������ֽ���%
lossless_result=lossless_decode(signal(1),lossless_differ)


%����MATLAB���źŽ��������ֱ���% 
lossy_differ=lossy_code(signal)
%����MATLAB���źŽ��������ֽ���%
lossy_result=lossy_decode(signal(1),lossy_differ)

%����ԭ�źź����ֽ��뻹ԭ���ź�ͼ��%

i=1:50
plot(i,signal(i),i,lossless_result(i))
j=1:50
plot(j,signal(j),j,lossy_result(j))


% ����������ֵ��[0-255]֮�������ź����У�����50��%
function[signal]=generate_signal(num)
signal=round(rand(1,num)*255);
end

%����������MATLAB���źŽ��������ֱ���%
 function[differ]=lossless_code(signal)
 predict=generate_signal(50)
 differ=generate_signal(50)
 
%�������ݺ󣬶��źŵ�ǰ�������������ݽ����������%
predict(1)=signal(1)
predict(2)=signal(1)
differ(2)=signal(2)-signal(1)
%����ѭ���ṹ���źŵ�ʣ�����������������%
n=3
while n<=50
    predict(n)=round((signal(n-2)+signal(n-1))/2)
    differ(n)=signal(n)-predict(n)
    n=n+1
end
 end

%����������MATLAB���źŽ��������ֽ���%
function[result]=lossless_decode(signal0,differ)
 predict=generate_signal(50)
 result=generate_signal(50)
%����ԭ�ź���ֵ�����źŵ�ǰ�������������ݽ����������%
 result(1)=signal0
 result(2)=signal0+differ(2)

%����ѭ���ṹ���źŵ�ʣ�����������������%
n=3
while n<=50
    predict(n)=round((result(n-2)+result(n-1))/2)
    result(n)=differ(n)+predict(n)
    n=n+1
end
 end


%����������MATLAB���źŽ��������ֱ���%
function[differ_b]=lossy_code(signal)
 predict_a=generate_signal(50)
 predict_b=generate_signal(50)
 differ_b=generate_signal(50)
 differ_a=generate_signal(50)
 

%�������ݺ󣬶��źŵ�ǰ�������������ݽ����������%
predict_a(1)=signal(1)
differ_a(1)=signal(1)-predict_a(1)
differ_b(1)=16*round((255+differ_a(1))/16)-256+8
predict_b(1)=predict_a(1)+differ_b(1)
 
predict_a(2)=round((signal(1)+predict_b(1))/2)
differ_a(2)=signal(2)-predict_a(2)
differ_b(2)=16*round((255+differ_a(2))/16)-256+8
predict_b(2)=predict_a(2)+differ_b(2)
 
%����ѭ���ṹ���źŵ�ʣ�����������������%
n=3;
while n<=50
    predict_a(n)=round((predict_b(n-1)+predict_b(n-2))/2)
    differ_a(n)=signal(n)-predict_a(n)
    differ_b(n)=16*round((255+differ_a(n))/16)-256+8
    predict_b(n)=predict_a(n)+differ_b(n)
    n=n+1
end 
end

%����������MATLAB���źŽ��������ֽ���%

function[result]=lossy_decode(signal_0,differ)
predict=generate_signal(50)
result=generate_signal(50)

%����ԭ�ź���ֵ�����źŵ�ǰ�������������ݽ����������%
predict(1)=signal_0
result(1)=predict(1)
 
predict(2)=round((result(1)+signal_0)/2)
result(2)=predict(2)+differ(2)

%����ѭ���ṹ���źŵ�ʣ�����������������%
n=3
while n<=50
    predict(n)=round((result(n-1)+result(n-2))/2)
    result(n)=predict(n)+differ(n)
    n=n+1
end
end


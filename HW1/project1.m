%生成值在[0-255]之间的随机信号序列，长度50。%
signal=generate_signal(50) 

%利用MATLAB对信号进行无损差分编码%
lossless_differ=lossless_code(signal)
%利用MATLAB对信号进行无损差分解码%
lossless_result=lossless_decode(signal(1),lossless_differ)


%利用MATLAB对信号进行有损差分编码% 
lossy_differ=lossy_code(signal)
%利用MATLAB对信号进行有损差分解码%
lossy_result=lossy_decode(signal(1),lossy_differ)

%绘制原信号和两种解码还原的信号图像%

i=1:50
plot(i,signal(i),i,lossless_result(i))
j=1:50
plot(j,signal(j),j,lossy_result(j))


% 函数：生成值在[0-255]之间的随机信号序列，长度50。%
function[signal]=generate_signal(num)
signal=round(rand(1,num)*255);
end

%函数：利用MATLAB对信号进行无损差分编码%
 function[differ]=lossless_code(signal)
 predict=generate_signal(50)
 differ=generate_signal(50)
 
%补充数据后，对信号的前两个采样点数据进行无损编码%
predict(1)=signal(1)
predict(2)=signal(1)
differ(2)=signal(2)-signal(1)
%利用循环结构对信号的剩余采样点进行无损编码%
n=3
while n<=50
    predict(n)=round((signal(n-2)+signal(n-1))/2)
    differ(n)=signal(n)-predict(n)
    n=n+1
end
 end

%函数：利用MATLAB对信号进行无损差分解码%
function[result]=lossless_decode(signal0,differ)
 predict=generate_signal(50)
 result=generate_signal(50)
%根据原信号首值，对信号的前两个采样点数据进行无损解码%
 result(1)=signal0
 result(2)=signal0+differ(2)

%利用循环结构对信号的剩余采样点进行无损解码%
n=3
while n<=50
    predict(n)=round((result(n-2)+result(n-1))/2)
    result(n)=differ(n)+predict(n)
    n=n+1
end
 end


%函数：利用MATLAB对信号进行有损差分编码%
function[differ_b]=lossy_code(signal)
 predict_a=generate_signal(50)
 predict_b=generate_signal(50)
 differ_b=generate_signal(50)
 differ_a=generate_signal(50)
 

%补充数据后，对信号的前两个采样点数据进行有损编码%
predict_a(1)=signal(1)
differ_a(1)=signal(1)-predict_a(1)
differ_b(1)=16*round((255+differ_a(1))/16)-256+8
predict_b(1)=predict_a(1)+differ_b(1)
 
predict_a(2)=round((signal(1)+predict_b(1))/2)
differ_a(2)=signal(2)-predict_a(2)
differ_b(2)=16*round((255+differ_a(2))/16)-256+8
predict_b(2)=predict_a(2)+differ_b(2)
 
%利用循环结构对信号的剩余采样点进行有损编码%
n=3;
while n<=50
    predict_a(n)=round((predict_b(n-1)+predict_b(n-2))/2)
    differ_a(n)=signal(n)-predict_a(n)
    differ_b(n)=16*round((255+differ_a(n))/16)-256+8
    predict_b(n)=predict_a(n)+differ_b(n)
    n=n+1
end 
end

%函数：利用MATLAB对信号进行有损差分解码%

function[result]=lossy_decode(signal_0,differ)
predict=generate_signal(50)
result=generate_signal(50)

%根据原信号首值，对信号的前两个采样点数据进行有损解码%
predict(1)=signal_0
result(1)=predict(1)
 
predict(2)=round((result(1)+signal_0)/2)
result(2)=predict(2)+differ(2)

%利用循环结构对信号的剩余采样点进行有损编码%
n=3
while n<=50
    predict(n)=round((result(n-1)+result(n-2))/2)
    result(n)=predict(n)+differ(n)
    n=n+1
end
end


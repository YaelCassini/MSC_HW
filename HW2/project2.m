%生成长度为8的随机信号序列
signal=round(rand(1,8)*255)
%用自编代码实现对信号的一维离散余弦变换
mydct_signal=my_dct(signal)
%用matlab内嵌的函数实现对信号的一维余弦变换
dct_signal=dct(signal)
%用自编代码实现对信号的一维离散余弦反变换，恢复原始信号
idct_signal=idct(dct_signal)
%用matlab内嵌的函数实现对信号的一维离散余弦反变换，恢复原始信号
myidct_signal=my_idct(dct_signal)
%生成包含一定噪声的正弦随机信号
x = (1:100) + 50*cos((1:100)*2*pi/40)
n = 5*randn(1,100)
x=x+n
%对该信号进行dct变换，去噪后反变换
x_dct=my_dct(x)
x_dct(21:100) = 0
x2=my_idct(x_dct)



%对长度为n的一维随机信号实现dct变换的自编函数
function [F]= my_dct(f)
[~,N]=size(f)
C=zeros(1,N)
S=zeros(1,N)
F=zeros(1,N)

%利用双重循环结构，按照公式对信号采样点的值进行dct变换
for u=1:N
if u==1
C(u)=sqrt(1/N);
else
C(u)=sqrt(2/N);
end

for i=1:N
    S(u)=S(u)+cos((i-0.5)*pi/N*(u-1))*f(i)

end
F(u)=C(u)*S(u)

end

end

%对长度为n的一维随机信号实现dct反变换的自编函数
function [F]=my_idct(f)
[~,N]=size(f)
C=zeros(1,N)
F=zeros(1,N)


%利用双重循环结构，按照公式对信号采样点的值进行dct变换
for i=1:N

for u=1:N
    if u==1
    C(u)=sqrt(1/N);
    else
    C(u)=sqrt(2/N);
    end
    F(i)=F(i)+C(u)*cos((i-0.5)*pi/N*(u-1))*f(u)
end

end

end

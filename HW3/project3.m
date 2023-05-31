%生成8*8随机数矩阵并画图显示
signal=round(rand(8,8)*255);
subplot(2,3,1);
imshow(uint8(signal)),title('原信号');
%对随机矩阵用自编代码进行dct变换并画图显示
dct_signal=my_dctplus(signal);
subplot(2,3,2);
imshow(uint8(dct_signal)),title('自编代码实现dct');
%对随机矩阵用自编代码进行反dct变换并画图显示
idct_signal=my_idctplus(dct_signal);
subplot(2,3,3);
imshow(uint8(idct_signal)),title('自编代码实现idct');
%画图显示原信号
subplot(2,3,4);
imshow(uint8(signal)),title('原信号');
%对随机矩阵用内嵌函数进行dct变换并画图显示
dct=dct2(signal);
subplot(2,3,5);
imshow(uint8(dct)),title('内嵌函数实现dct');
%对随机矩阵用内嵌函数进行反dct变换并画图显示
idct=idct2(dct);
subplot(2,3,6);
imshow(uint8(idct)),title('内嵌函数实现idct');

%读入一个bmp图像
signalplus=imread('C:/lena.bmp');
signalplus=double(signalplus);

%显示原图像
%subplot(1,3,1);
%imshow(uint8(signalplus)),title('原图像');

%生成随机噪声并显示随机噪声
y=wgn(M,N,20);
y=abs(y);
%subplot(2,3,2);
%imshow(uint8(y)),title('噪声图像');

%将噪声叠加到原图像上并显示
signalplus=signalplus+y;
%subplot(1,3,2);
imshow(uint8(signalplus)),title('叠加噪声后的图像');

%对叠加噪声后的图像进行dct变换并显示
signala=my_dctplus(signalplus);
%subplot(2,3,4);
%imshow(uint8(signala)),title('DCT变换');

%对dct变换后的图像进行降噪并显示
signalb=my_denoise(signala);
%subplot(2,3,5);
%imshow(uint8(signalb)),title('DCT变换去噪');

%对去噪后的图像进行反dct变换并显示
signalc=my_idctplus(signalb);
%subplot(1,3,3);
%imshow(uint8(signalc)),title('去噪后图像');



%去噪函数
function [g]=my_denoise(g)
%获得图像矩阵的长宽
[M,N]=size(g);

%利用二重循环，分别舍去除左上角1/4部分之外的信息，将其值归为零
for i=1:M/2
    for j=N/2:N
        g(i,j)=0;
    end
end
for i=M/2:M
    for j=1:N
        g(i,j)=0;   
    end
end

end




%在自编一维dct变换的函数基础上实现二维信号的离散余弦变换
function [f]=my_dctplus(f)
%获取矩阵长宽
[M,N]=size(f);
%对每行元素进行dct变换
for i=1:M
    f(i,:)=my_dct(f(i,:),1);
    
end
%对每列元素进行dct变换
for j=1:N
    f(:,j)=my_dct(f(:,j),0);
end

end
%在自编一维反dct变换的函数基础上实现二维信号的离散余弦反变换
function [f]=my_idctplus(f)
[M,N]=size(f);
%对每行元素进行反dct变换
for i=1:M
    f(i,:)=my_idct(f(i,:),1);   
end
%对每列元素进行反dct变化
for j=1:N
    f(:,j)=my_idct(f(:,j),0);
end

end

function [F]= my_dct(f,flag)
if(flag)
[~,N]=size(f);
C=zeros(1,N);
S=zeros(1,N);
F=zeros(1,N);
else
[N,~]=size(f);
C=zeros(N,1);
S=zeros(N,1);
F=zeros(N,1);
end

for u=1:N
if u==1
C(u)=sqrt(1/N);
else
C(u)=sqrt(2/N);
end

for i=1:N
    S(u)=S(u)+cos((i-0.5)*pi/N*(u-1))*f(i);

end
F(u)=C(u)*S(u);

end

end

function [F]=my_idct(f,flag)
if(flag)
[~,N]=size(f);
C=zeros(1,N);
S=zeros(1,N);
F=zeros(1,N);
else
[N,~]=size(f);
C=zeros(N,1);
S=zeros(N,1);
F=zeros(N,1);
end

for i=1:N

for u=1:N
    if u==1
    C(u)=sqrt(1/N);
    else
    C(u)=sqrt(2/N);
    end
    
    F(i)=F(i)+C(u)*cos((i-0.5)*pi/N*(u-1))*f(u);

end

end

end
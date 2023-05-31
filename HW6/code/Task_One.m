%产生一维随机信号
signal=randn(1,8)*8;
%对一维信号进行haar小波dwt变换
dwtx=my_dwt(signal,1);
%对一维信号进行haar小波dwt反变换
idwtx=my_idwt(dwtx,1);


%函数：对一维信号做haar小波的dwt变换
function dwtsig=my_dwt(signal,flag)
[M,N]=size(signal);
%flag为控制变量
%控制一维信号的横纵
if flag==1
    u=N;
    dwtsig=zeros(1,N);
else
    u=M;
    dwtsig=zeros(M,1);
end
for i=1:u/2
    dwtsig(i)=(signal(i*2-1)+signal(i*2))*0.5;
    dwtsig(i+u/2)=(signal(i*2-1)-signal(i*2))*0.5;
end

end

%函数：对一维信号做haar小波的反dwt变换
function idwtsig=my_idwt(signal,flag)
[M,N]=size(signal);
%flag为控制变量
%控制一维信号的横纵
if flag==1
    u=N;
    idwtsig=zeros(1,N);
else
    u=M;
    idwtsig=zeros(M,1);
end
for i=1:u/2
    idwtsig(i*2-1)=signal(i)+signal(i+u/2);
    idwtsig(i*2)=signal(i)-signal(i+u/2);

end

end


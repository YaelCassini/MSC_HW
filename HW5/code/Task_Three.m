%信号长度
N = 1024;

%生成周期性信号
t = 0:1/(N-1):1;
fs= N-1; 
n = N; 
signal0 = 50*cos(2*pi*20*t);

%生成噪声
no = 30*rand(1,1024); 
signal = signal0 + no; 
signal = signal'; 

%利用FFT变换对信号做频谱分析
y1 = fft(signal); 
%将横坐标移动到0刻度在正中间
y2 = fftshift(y1); 
f = (0:N-1)*fs/n-fs/2; 
%plot(f,abs(y2));

%对信号做实数形式的DFT变换
cb=cosbase(N);
sb=sinbase(N);
ReX=zeros(N/2+1,1);
ImX=zeros(N/2+1,1);

for i=1:N/2+1
    ReX(i)=cb(i,:)*signal;
    ImX(i)=sb(i,:)*signal;
end

%除去高频部分的噪声

for i=1:30
    if(ReX(i)<1)ReX(i)=0;
    end
    if(ImX(i)<1)ImX(i)=0;
    end
end
ReX(30:513)=0;
Imx(30:513)=0;

%对去噪后的信号进行实数形式的反DFT变换
Re=zeros(N/2+1,1);
Im=zeros(N/2+1,1);

for i=1:N/2+1
    Re(i)=ReX(i)/(N/2);
    Im(i)=ImX(i)/(N/2);
end

Re(1)=ReX(1)/N;
Re(N/2+1)=ReX(N/2+1)/N;

y=zeros(1,N);

for i=1:N/2+1
    y=y+Re(i)*cb(i,:)+Im(i)*sb(i,:);
end

y=y';

f2=(1:N);
plot(f2,signal,f2,y);

y3 = fft(y); 
y4 = fftshift(y3); 
f = (0:N-1)*fs/n-fs/2; 

%plot(f,abs(y2),f,abs(y4));


%生成实数形式的DFT变换余弦基函数
function cb=cosbase(N)
%预先分配空间
cb=zeros(N/2+1,N);
for i=1:N/2+1
    for j=1:N
        cb(i,j)=cos(2*pi*(i-1)*(j-1)/N);
    end
end

end

%生成实数形式的DFT变换余弦基函数
function sb=sinbase(N)
%预先分配空间
sb=zeros(N/2+1,N);
for i=1:N/2+1
    for j=1:N
        sb(i,j)=sin(2*pi*(i-1)*(j-1)/N);
    end
end

end


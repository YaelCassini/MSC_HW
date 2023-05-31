%�źų���
N = 1024;

%�����������ź�
t = 0:1/(N-1):1;
fs= N-1; 
n = N; 
signal0 = 50*cos(2*pi*20*t);

%��������
no = 30*rand(1,1024); 
signal = signal0 + no; 
signal = signal'; 

%����FFT�任���ź���Ƶ�׷���
y1 = fft(signal); 
%���������ƶ���0�̶������м�
y2 = fftshift(y1); 
f = (0:N-1)*fs/n-fs/2; 
%plot(f,abs(y2));

%���ź���ʵ����ʽ��DFT�任
cb=cosbase(N);
sb=sinbase(N);
ReX=zeros(N/2+1,1);
ImX=zeros(N/2+1,1);

for i=1:N/2+1
    ReX(i)=cb(i,:)*signal;
    ImX(i)=sb(i,:)*signal;
end

%��ȥ��Ƶ���ֵ�����

for i=1:30
    if(ReX(i)<1)ReX(i)=0;
    end
    if(ImX(i)<1)ImX(i)=0;
    end
end
ReX(30:513)=0;
Imx(30:513)=0;

%��ȥ�����źŽ���ʵ����ʽ�ķ�DFT�任
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


%����ʵ����ʽ��DFT�任���һ�����
function cb=cosbase(N)
%Ԥ�ȷ���ռ�
cb=zeros(N/2+1,N);
for i=1:N/2+1
    for j=1:N
        cb(i,j)=cos(2*pi*(i-1)*(j-1)/N);
    end
end

end

%����ʵ����ʽ��DFT�任���һ�����
function sb=sinbase(N)
%Ԥ�ȷ���ռ�
sb=zeros(N/2+1,N);
for i=1:N/2+1
    for j=1:N
        sb(i,j)=sin(2*pi*(i-1)*(j-1)/N);
    end
end

end


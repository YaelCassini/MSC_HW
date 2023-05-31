%�źų���
N=16;
%��������ź�
x=round(10*rand(N,1));

%����ʵ����ʽ��ɢ����Ҷ�任�Ļ�����
cb=cosbase(N);
sb=sinbase(N);

%���ɴ���ʵ����ʽDFT�任����ĺ���
ReX=zeros(N/2+1,1);
ImX=zeros(N/2+1,1);

%����ʵ����ʽDFT�任���
for i=1:N/2+1
    ReX(i)=cb(i,:)*x;
    ImX(i)=sb(i,:)*x;
end

%���ɴ���ʵ����ʽDFT��任��������
Re=zeros(N/2+1,1);
Im=zeros(N/2+1,1);

for i=1:N/2+1
    
    Re(i)=ReX(i)/(N/2);
    Im(i)=ImX(i)/(N/2);
    
end

Re(1)=ReX(1)/N;
Re(N/2+1)=ReX(N/2+1)/N;


%���ɴ���ʵ����ʽDFT��任�Ľ��������
y=zeros(1,N);

%����ʵ����ʽ�ķ�DFT�任
for j=1:N
    for i=1:N/2+1  
        y(j)=y(j)+Re(i)*cb(i,j)+Im(i)*sb(i,j);
    end
end

y=reshape(y,N,1);
f=(1:N);
plot(f,abs(x),f,abs(y));


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

%信号长度
N=16;
%随机生成信号
x=round(10*rand(N,1));

%生成实数形式离散傅里叶变换的基函数
cb=cosbase(N);
sb=sinbase(N);

%生成储存实数形式DFT变换结果的函数
ReX=zeros(N/2+1,1);
ImX=zeros(N/2+1,1);

%生成实数形式DFT变换结果
for i=1:N/2+1
    ReX(i)=cb(i,:)*x;
    ImX(i)=sb(i,:)*x;
end

%生成储存实数形式DFT逆变换所用数据
Re=zeros(N/2+1,1);
Im=zeros(N/2+1,1);

for i=1:N/2+1
    
    Re(i)=ReX(i)/(N/2);
    Im(i)=ImX(i)/(N/2);
    
end

Re(1)=ReX(1)/N;
Re(N/2+1)=ReX(N/2+1)/N;


%生成储存实数形式DFT逆变换的结果的数组
y=zeros(1,N);

%进行实数形式的反DFT变换
for j=1:N
    for i=1:N/2+1  
        y(j)=y(j)+Re(i)*cb(i,j)+Im(i)*sb(i,j);
    end
end

y=reshape(y,N,1);
f=(1:N);
plot(f,abs(x),f,abs(y));


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

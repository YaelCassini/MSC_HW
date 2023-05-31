%信号长度
N=16;
%生成随机信号序列
signal=round(10*rand(N,1));
%生成复数形式的DFT变换的基函数
dftbs=dftbase(N);
%预先分配内存
rdft=zeros(N,1);

%进行复数形式的DFT变换
for k=1:N
    rdft(k)=sum(dftbs(k,:)*signal);
end

%预先分配内存
idft=zeros(N,1);

%生成复数形式的反DFT变换的基函数
idftbs=idftbase(N);

%进行复数形式的反DFT变换
for k=1:N
    idft(k)=sum(idftbs(k,:)*rdft)/N;
end


f=(1:N);
plot(f,abs(signal),f,abs(idft));

%plot(f,abs(idft));

%函数：生成复数形式的DFT变换的基函数
function dftbs=dftbase(N)
dftbs=zeros(N,N);
for j=1:N
    for k=1:N
        dftbs(j,k)=cos(2*pi*(j-1)*(k-1)/N)-sin(2*pi*(j-1)*(k-1)/N)*i;
    end
end
end


%函数：生成复数形式的反DFT变换的基函数
function idftbs=idftbase(N)
idftbs=zeros(N,N);
for j=1:N
    for k=1:N
        idftbs(j,k)=cos(2*pi*(j-1)*(k-1)/N)+sin(2*pi*(j-1)*(k-1)/N)*i;
    end
end
end



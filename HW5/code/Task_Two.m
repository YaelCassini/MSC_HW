%�źų���
N=16;
%��������ź�����
signal=round(10*rand(N,1));
%���ɸ�����ʽ��DFT�任�Ļ�����
dftbs=dftbase(N);
%Ԥ�ȷ����ڴ�
rdft=zeros(N,1);

%���и�����ʽ��DFT�任
for k=1:N
    rdft(k)=sum(dftbs(k,:)*signal);
end

%Ԥ�ȷ����ڴ�
idft=zeros(N,1);

%���ɸ�����ʽ�ķ�DFT�任�Ļ�����
idftbs=idftbase(N);

%���и�����ʽ�ķ�DFT�任
for k=1:N
    idft(k)=sum(idftbs(k,:)*rdft)/N;
end


f=(1:N);
plot(f,abs(signal),f,abs(idft));

%plot(f,abs(idft));

%���������ɸ�����ʽ��DFT�任�Ļ�����
function dftbs=dftbase(N)
dftbs=zeros(N,N);
for j=1:N
    for k=1:N
        dftbs(j,k)=cos(2*pi*(j-1)*(k-1)/N)-sin(2*pi*(j-1)*(k-1)/N)*i;
    end
end
end


%���������ɸ�����ʽ�ķ�DFT�任�Ļ�����
function idftbs=idftbase(N)
idftbs=zeros(N,N);
for j=1:N
    for k=1:N
        idftbs(j,k)=cos(2*pi*(j-1)*(k-1)/N)+sin(2*pi*(j-1)*(k-1)/N)*i;
    end
end
end



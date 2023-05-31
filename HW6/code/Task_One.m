%����һά����ź�
signal=randn(1,8)*8;
%��һά�źŽ���haarС��dwt�任
dwtx=my_dwt(signal,1);
%��һά�źŽ���haarС��dwt���任
idwtx=my_idwt(dwtx,1);


%��������һά�ź���haarС����dwt�任
function dwtsig=my_dwt(signal,flag)
[M,N]=size(signal);
%flagΪ���Ʊ���
%����һά�źŵĺ���
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

%��������һά�ź���haarС���ķ�dwt�任
function idwtsig=my_idwt(signal,flag)
[M,N]=size(signal);
%flagΪ���Ʊ���
%����һά�źŵĺ���
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


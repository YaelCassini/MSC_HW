%����8*8��������󲢻�ͼ��ʾ
signal=round(rand(8,8)*255);
subplot(2,3,1);
imshow(uint8(signal)),title('ԭ�ź�');
%������������Ա�������dct�任����ͼ��ʾ
dct_signal=my_dctplus(signal);
subplot(2,3,2);
imshow(uint8(dct_signal)),title('�Ա����ʵ��dct');
%������������Ա������з�dct�任����ͼ��ʾ
idct_signal=my_idctplus(dct_signal);
subplot(2,3,3);
imshow(uint8(idct_signal)),title('�Ա����ʵ��idct');
%��ͼ��ʾԭ�ź�
subplot(2,3,4);
imshow(uint8(signal)),title('ԭ�ź�');
%�������������Ƕ��������dct�任����ͼ��ʾ
dct=dct2(signal);
subplot(2,3,5);
imshow(uint8(dct)),title('��Ƕ����ʵ��dct');
%�������������Ƕ�������з�dct�任����ͼ��ʾ
idct=idct2(dct);
subplot(2,3,6);
imshow(uint8(idct)),title('��Ƕ����ʵ��idct');

%����һ��bmpͼ��
signalplus=imread('C:/lena.bmp');
signalplus=double(signalplus);

%��ʾԭͼ��
%subplot(1,3,1);
%imshow(uint8(signalplus)),title('ԭͼ��');

%���������������ʾ�������
y=wgn(M,N,20);
y=abs(y);
%subplot(2,3,2);
%imshow(uint8(y)),title('����ͼ��');

%���������ӵ�ԭͼ���ϲ���ʾ
signalplus=signalplus+y;
%subplot(1,3,2);
imshow(uint8(signalplus)),title('�����������ͼ��');

%�Ե����������ͼ�����dct�任����ʾ
signala=my_dctplus(signalplus);
%subplot(2,3,4);
%imshow(uint8(signala)),title('DCT�任');

%��dct�任���ͼ����н��벢��ʾ
signalb=my_denoise(signala);
%subplot(2,3,5);
%imshow(uint8(signalb)),title('DCT�任ȥ��');

%��ȥ����ͼ����з�dct�任����ʾ
signalc=my_idctplus(signalb);
%subplot(1,3,3);
%imshow(uint8(signalc)),title('ȥ���ͼ��');



%ȥ�뺯��
function [g]=my_denoise(g)
%���ͼ�����ĳ���
[M,N]=size(g);

%���ö���ѭ�����ֱ���ȥ�����Ͻ�1/4����֮�����Ϣ������ֵ��Ϊ��
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




%���Ա�һάdct�任�ĺ���������ʵ�ֶ�ά�źŵ���ɢ���ұ任
function [f]=my_dctplus(f)
%��ȡ���󳤿�
[M,N]=size(f);
%��ÿ��Ԫ�ؽ���dct�任
for i=1:M
    f(i,:)=my_dct(f(i,:),1);
    
end
%��ÿ��Ԫ�ؽ���dct�任
for j=1:N
    f(:,j)=my_dct(f(:,j),0);
end

end
%���Ա�һά��dct�任�ĺ���������ʵ�ֶ�ά�źŵ���ɢ���ҷ��任
function [f]=my_idctplus(f)
[M,N]=size(f);
%��ÿ��Ԫ�ؽ��з�dct�任
for i=1:M
    f(i,:)=my_idct(f(i,:),1);   
end
%��ÿ��Ԫ�ؽ��з�dct�仯
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
%���ɳ���Ϊ8������ź�����
signal=round(rand(1,8)*255)
%���Ա����ʵ�ֶ��źŵ�һά��ɢ���ұ任
mydct_signal=my_dct(signal)
%��matlab��Ƕ�ĺ���ʵ�ֶ��źŵ�һά���ұ任
dct_signal=dct(signal)
%���Ա����ʵ�ֶ��źŵ�һά��ɢ���ҷ��任���ָ�ԭʼ�ź�
idct_signal=idct(dct_signal)
%��matlab��Ƕ�ĺ���ʵ�ֶ��źŵ�һά��ɢ���ҷ��任���ָ�ԭʼ�ź�
myidct_signal=my_idct(dct_signal)
%���ɰ���һ����������������ź�
x = (1:100) + 50*cos((1:100)*2*pi/40)
n = 5*randn(1,100)
x=x+n
%�Ը��źŽ���dct�任��ȥ��󷴱任
x_dct=my_dct(x)
x_dct(21:100) = 0
x2=my_idct(x_dct)



%�Գ���Ϊn��һά����ź�ʵ��dct�任���Աຯ��
function [F]= my_dct(f)
[~,N]=size(f)
C=zeros(1,N)
S=zeros(1,N)
F=zeros(1,N)

%����˫��ѭ���ṹ�����չ�ʽ���źŲ������ֵ����dct�任
for u=1:N
if u==1
C(u)=sqrt(1/N);
else
C(u)=sqrt(2/N);
end

for i=1:N
    S(u)=S(u)+cos((i-0.5)*pi/N*(u-1))*f(i)

end
F(u)=C(u)*S(u)

end

end

%�Գ���Ϊn��һά����ź�ʵ��dct���任���Աຯ��
function [F]=my_idct(f)
[~,N]=size(f)
C=zeros(1,N)
F=zeros(1,N)


%����˫��ѭ���ṹ�����չ�ʽ���źŲ������ֵ����dct�任
for i=1:N

for u=1:N
    if u==1
    C(u)=sqrt(1/N);
    else
    C(u)=sqrt(2/N);
    end
    F(i)=F(i)+C(u)*cos((i-0.5)*pi/N*(u-1))*f(u)
end

end

end

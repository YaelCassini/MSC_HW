%���ļ��ж�������
load('savedata.mat');
%��������
qY=[
    16 11 10 16 24 40 51 61;
    12 12 14 19 26 58 60 55;
    14 13 16 24 40 57 69 56;
    14 17 22 29 51 87 80 62;
    18 22 37 56 68 109 103 77;
    24 35 55 64 81 104 113 92;
    49 64 78 87 103 121 120 101;
    72 92 95 98 112 100 103 99;
];
qU=[
    17 18 24 47 99 99 99 99;
    18 21 26 66 99 99 99 99;
    24 26 56 99 99 99 99 99;
    47 66 99 99 99 99 99 99;
    99 99 99 99 99 99 99 99;
    99 99 99 99 99 99 99 99;
    99 99 99 99 99 99 99 99;
    99 99 99 99 99 99 99 99;
];
qV=[
    17 18 24 47 99 99 99 99;
    18 21 26 66 99 99 99 99;
    24 26 56 99 99 99 99 99;
    47 66 99 99 99 99 99 99;
    99 99 99 99 99 99 99 99;
    99 99 99 99 99 99 99 99;
    99 99 99 99 99 99 99 99;
    99 99 99 99 99 99 99 99;
];

%����Huffman����
Ydc_deco=huffmandeco(Y_dc,Ydc_diction);
Yac_deco=huffmandeco(Y_ac,Yac_diction);
Udc_deco=huffmandeco(U_dc,Udc_diction);
Uac_deco=huffmandeco(U_ac,Uac_diction);
Vdc_deco=huffmandeco(V_dc,Vdc_diction);
Vac_deco=huffmandeco(V_ac,Vac_diction);

%��DCֵ����DPCM����
Y_dc_deco=dpcm_deco(Ydc_deco);
U_dc_deco=dpcm_deco(Udc_deco);
V_dc_deco=dpcm_deco(Vdc_deco);

%��ACֵ����rlc����
Y_ac_deco=rc_rlc_deco(Yac_deco,rr,cc);
U_ac_deco=rc_rlc_deco(Uac_deco,rr/2,cc/2);
V_ac_deco=rc_rlc_deco(Vac_deco,rr/2,cc/2);


%�����ݽ��з�zigzagչ�����任�ؾ���
Y_re=izigzag(Y_ac_deco,rr,cc,Y_dc_deco);
U_re=izigzag(U_ac_deco,rr/2,cc/2,U_dc_deco);
V_re=izigzag(V_ac_deco,rr/2,cc/2,V_dc_deco);

%�����ݽ��з�����
Y_re=iquantiza(Y_re,qY);
U_re=iquantiza(U_re,qU);
V_re=iquantiza(V_re,qV);

%�����ݽ��з�dct�任
[Y_idct,U_idct,V_idct]=img_idct(Y_re,U_re,V_re);

%��YUV�����ϳ�һ��ͼ
YUVimg=recover(Y_idct,U_idct,V_idct);

%�г�����ı�Ե����
YUVimg2=YUVimg(1:r,1:c,1:3);
%YUVתRGB
RGBimg=yuvtorgb(YUVimg2);
%��ʾͼƬ
imshow(uint8(RGBimg));


%DPCM���뺯��
function dc=dc_dpcm(zigzag)
[n,~]=size(zigzag);

dc=zeros(1,n);

for i=1:n
    dc(1,i)=zigzag(i,1);
end

dc=dpcm_code(dc,n);

end

%YUVתRGB����
function rgb=yuvtorgb(yuv)
Y=yuv(:,:,1);
U=yuv(:,:,2);
V=yuv(:,:,3);

R=Y+1.14*V;
G=Y-0.395*U-0.581*V;
B=Y+2.032*U;

%R=Y+1.402*(U-128);
%G=Y-0.34414*(U-128)-0.71414*(V-128);
%B=Y+1.77200*(U-128);

rgb=cat(3,R,G,B);

end


%����ɫ�²������з��������ָ������С
function YUVimg=recover(Y_re,U_re,V_re)
[rr,cc]=size(Y_re);
Y_reco=Y_re;
U_reco=zeros(rr,cc);
V_reco=zeros(rr,cc);

for i=1:rr
    for j=1:cc
        U_reco(i,j)=U_re(floor((i+1)/2),floor((j+1)/2));
        V_reco(i,j)=V_re(floor((i+1)/2),floor((j+1)/2));
      
    end
end

YUVimg=cat(3,Y_reco,U_reco,V_reco);
end

%����������
function [iquanY]=iquantiza(Y,qY)

iquanY=blkproc(Y,[8,8],'round(x.*P1)',qY);

end

%��YUV�������з�dct�任
function [idctY,idctU,idctV]=img_idct(Y,U,V)

idctY=blkproc(Y,[8,8],'idct2(x)');
idctU=blkproc(U,[8,8],'idct2(x)');
idctV=blkproc(V,[8,8],'idct2(x)');

end

%����һ�����ȵ����У�����DPCM��
function[signal]=generate_signal(num)
signal=round(rand(1,num)*255);
end

%DPCM���Լ���д
%����������MATLAB���źŽ��������ֽ���%
function[result]=dpcm_deco(differ)
[~,length]=size(differ);
signal_0=differ(1);
predict=generate_signal(length);
result=generate_signal(length);

%����ԭ�ź���ֵ�����źŵ�ǰ�������������ݽ����������%
predict(1)=signal_0;
result(1)=predict(1);
 
if(length>=2)
predict(2)=round((result(1)+signal_0)/2);
result(2)=predict(2)+differ(2);
end

if(length>=3)
%����ѭ���ṹ���źŵ�ʣ�����������������%
n=3;
while n<=length
    predict(n)=round((result(n-1)+result(n-2))/2);
    result(n)=predict(n)+differ(n);
    n=n+1;
end
end
end

%�ر���Ľ��뺯��
function cout=rc_rlc_deco(cin,rr,cc)
[M,N]=size(cin);
cin=reshape(cin,M*N/2,2);
cout=zeros(rr*cc/64,64);

k=1;%�����п��Ʊ���
i=1;%�п��Ʊ���
j=1;%�п��Ʊ���

   while((i<=rr*cc/64)&(j<=M*N/2))
    a=cin(j,1);
    b=cin(j,2);
    if((a==0)&(b==0))
        i=i+1;
        k=1;
        j=j+1;
        continue;
    else 
        for p=1:a
            cout(i,k)=0;
            k=k+1;
            %p=p+1;
        end
        cout(i,k)=b;
        k=k+1;
        j=j+1;
        continue;
   
    end
   end

   cout=reshape(cout,rr*cc/64,64);

end

%�Կ���з�zigzag�任
function block=izigzag_block(line,dcnumber)

izigzag_table=[
    1,2,6,7,15,16,28,29,...
    3,5,8,14,17,27,30,43,...
    4,9,13,18,26,31,42,44,...
    10,12,19,25,32,41,45,54,...
    11,20,24,33,40,46,53,55,...
    21,23,34,39,47,52,56,61,...
    22,35,38,48,51,57,60,62,...
    36,37,49,50,58,59,63,64];

line=line(izigzag_table);
line(1)=dcnumber;
block=reshape(line,8,8);
end

%��zigzag�任
function i_zigzag=izigzag(signal,rr,cc,dc)

[r,c]=size(signal);
num=r*c/64;
%[w,u]=size(dc);
%Ϊʲô����ֱ�����ú���
%fun=@izigzag_block;

signal=reshape(signal,num,64);
i_zigzag=zeros(rr,cc);

for i=1:rr/8
    for j=1:cc/8
    i_zigzag(i*8-7:i*8,j*8-7:j*8)=izigzag_block(signal((i-1)*cc/8+j,:),dc((i-1)*cc/8+j));
        
    end    
end

end



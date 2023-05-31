%Y��U��V������������
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


%main����
%����
rgb=imread('reddd.jpg');
%תdouble
rgb=double(rgb);
%��ȡԭʼͼƬ����
[r,c,~]=size(rgb);
%�������
%R=rgb(:,:,1);
%G=rgb(:,:,2);
%B=rgb(:,:,3);

%RGBתYUV
yuv=rgbtoyuv(double(rgb));
%��ͼƬ���Ϊ8*8�����������
complete_img=completion(yuv);
[rr,cc,~]=size(complete_img);
%��ɫ�²���
[Y,U,V]=downsample(complete_img);
%dct�任
[dctY,dctU,dctV]=imgdct(Y,U,V);
%��������
[qdctY,qdctU,qdctV]=quantization(dctY,dctU,dctV,qY,qU,qV);

%zigzagչ��
Yzigzag=zigzag(qdctY);
Uzigzag=zigzag(qdctU);
Vzigzag=zigzag(qdctV);

%DPCM����
Y_dc=dc_dpcm(Yzigzag);
U_dc=dc_dpcm(Uzigzag);
V_dc=dc_dpcm(Vzigzag);

%rlc����
Y_ac2=ac_rlc(Yzigzag);
U_ac2=ac_rlc(Uzigzag);
V_ac2=ac_rlc(Vzigzag);

%huffman����
[Y_dc,Ydc_diction]=huffman_encode(Y_dc);
[Y_ac,Yac_diction]=huffman_encode(Y_ac2);
[U_dc,Udc_diction]=huffman_encode(U_dc);
[U_ac,Uac_diction]=huffman_encode(U_ac2);
[V_dc,Vdc_diction]=huffman_encode(V_dc);
[V_ac,Vac_diction]=huffman_encode(V_ac2);

%��������
save('savedata.mat','r','rr','c','cc','Y_dc',...
    'Y_ac','U_dc','U_ac','V_dc','V_ac',...
    'Ydc_diction','Yac_diction','Udc_diction',...
    'Uac_diction','Vdc_diction','Vac_diction');
clear;
load('savedata.mat');



%������RGBתYUV
function yuv=rgbtoyuv(rgb)
R=rgb(:,:,1);
G=rgb(:,:,2);
B=rgb(:,:,3);

Y=0.299*R+0.587*G+0.114*B;
U=128-0.168*R-0.331264*G+0.5*B;
V=128+0.5*R-0.418688*G-0.081312*B;

yuv=cat(3,Y,U,V);

end

%��ȫͼƬ
function complete=completion(img)
[r,c,~]=size(img);
rr=ceil(r/16)*16;
cc=ceil(c/16)*16;

for i=r+1:rr
    img(i,:,:)=img(r,:,:);
end

for j=c+1:cc
    img(:,j,:)=img(:,c,:);
end

complete=img;

end

%��ɫ�²���
function [Y,U,V]=downsample(img)
[rr,cc,~]=size(img);
Y=double(img(:,:,1));
U=double(img(1:2:rr-1,1:2:cc-1,2));
V=double(img(2:2:rr,2:2:cc,3));

end

%�ֿ����dct�任
function [dctY,dctU,dctV]=imgdct(Y,U,V)

dctY=blkproc(Y,[8,8],'dct2(x)');
dctU=blkproc(U,[8,8],'dct2(x)');
dctV=blkproc(V,[8,8],'dct2(x)');

end

%�ֿ��������
function [qdctY,qdctU,qdctV]=quantization(dctY,dctU,dctV,qY,qU,qV)

qdctY=blkproc(dctY,[8,8],'round(x./P1)',qY);
qdctU=blkproc(dctU,[8,8],'round(x./P1)',qU);
qdctV=blkproc(dctV,[8,8],'round(x./P1)',qV);
%blkproc(y1,[8 8],'round(x./P1)',m);

end

%�Կ����zigzagչ��
function line=zigzag_block(block)

%չ������
zigzag_table=[
    1,2,9,17,10,3,4,11,18,25,...
    33,26,19,12,5,6,13,20,27,34,41,49,...
    42,35,28,21,14,7,8,15,22,29,36,...
    43,50,57,58,51,44,37,30,23,...
    16,24,31,38,45,52,59,60,53,46,...
    39,32,40,47,54,61,62,55,48,56,63,64];

line=reshape(block,1,64);
line=line(zigzag_table);

end

%zigzagչ��
function zigzag_qdct=zigzag(qdct)
[r,c]=size(qdct);
num=r*c/64;
zigzag_qdct=zeros(num,64);


for i=1:r/8
    for j=1:c/8
        zigzag_qdct((i-1)*(c/8)+j,:)=zigzag_block(qdct(i*8-7:i*8,j*8-7:j*8));
        
    end
end

end

%��dcֵ����DPCM����
function dc=dc_dpcm(zigzag)
[n,~]=size(zigzag);
%n=size(zigzag,1)
dc=zeros(1,n);

for i=1:n
    dc(1,i)=zigzag(i,1);
end

dc=dpcm_code(dc,n);

end

%��ÿ��rcֵ����rlc����
function cout=ac_rlc(cin)
n=size(cin,1);
cout=[];
for i=1:n
    cout=[cout;rlc_code(cin(i,:))];
end

end

%rcֵ��rlc����
function cout=rlc_code(cin)
n=length(cin);
result=[];
count=0;

for i=1:n
    if cin(i)~=0
        result=[result;[count,cin(i)]];
        count=0;
    else
        count=count+1;
    end
    
end
result=[result;[0,0]];
cout=result;
end

%DPCM���뺯��
function [differ_b]=dpcm_code(signal,length)
%length=size(signal);
 predict_a=generate_signal(length);
 predict_b=generate_signal(length);
 differ_b=generate_signal(length);
 differ_a=generate_signal(length);
 

%�������ݺ󣬶��źŵ�ǰ�������������ݽ����������%
predict_a(1)=signal(1);
differ_a(1)=signal(1)-predict_a(1);
differ_b(1)=4*round((255+differ_a(1))/4)-256+2;
predict_b(1)=predict_a(1)+differ_b(1);
 
if(length>=2)
predict_a(2)=round((signal(1)+predict_b(1))/2);
differ_a(2)=signal(2)-predict_a(2);
differ_b(2)=16*round((255+differ_a(2))/16)-256+8;
predict_b(2)=predict_a(2)+differ_b(2);
end
%����ѭ���ṹ���źŵ�ʣ�����������������%
if(length>=3)
n=3;
while n<=length
    predict_a(n)=round((predict_b(n-1)+predict_b(n-2))/2);
    differ_a(n)=signal(n)-predict_a(n);
    differ_b(n)=16*round((255+differ_a(n))/16)-256+8;
    predict_b(n)=predict_a(n)+differ_b(n);
    n=n+1;
end 
end

differ_b(1)=signal(1);
end

%�������У�����DPCM���룩
function[signal]=generate_signal(num)
signal=round(rand(1,num)*255);
end

%huffman����
function [code,diction]=huffman_encode(signal)
[r,c]=size(signal);
num=r*c;
new=reshape(signal,1,num);

p=[];
char=[];

for i=1:num
    if find(new(1:i-1)==new(i))
        continue
    else
        count=length(find(new==new(i)));
        char=[char,new(i)];
        p=[p,count/num];
    end
end
%aa=size(char);
%bb=size(p);

diction=huffmandict(char,p);
%new=new';
code = huffmanenco(new,diction); 

end




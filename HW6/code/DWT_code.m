
%����һ��ͼƬ
picture=imread('lenacolor.bmp');

%��ͼƬ����ɫ�����ֿ�
R=double(picture(:,:,1));
G=double(picture(:,:,2));
B=double(picture(:,:,3));

%picture=double(rgb2gray(picture));


%��ͼ����ж�άhaarС��dwt�任
dwtDR=my_dwtplusD(R,3);
dwtDG=my_dwtplusD(G,3);
dwtDB=my_dwtplusD(B,3);

figure,imshow(uint8(dwtDR));

%ȥ��
%de_dwtDpic=my_denoise(dwtDpic);
de_dwtDR=my_denoise(dwtDR);
de_dwtDG=my_denoise(dwtDG);
de_dwtDB=my_denoise(dwtDB);

%figure,imshow(dwtDpic);


[M,N]=size(de_dwtDR);
%չ������
lineR=reshape(de_dwtDR,1,M*N);
lineG=reshape(de_dwtDG,1,M*N);
lineB=reshape(de_dwtDB,1,M*N);

%Huffman����
[Rco_line,Rco_dict]=huffman_encode(lineR);
[Gco_line,Gco_dict]=huffman_encode(lineG);
[Bco_line,Bco_dict]=huffman_encode(lineB);


save('savedata.mat','M','N','Rco_line','Rco_dict','Gco_line','Gco_dict','Bco_line','Bco_dict');
clear;

%ȥ�뺯��
function sig=my_denoise(sig)
[M,N]=size(sig);
%��ֵ����Ϊ10��5��2

%ȥ��һ��dwt�任�е�����
for i=M/2+1:M
    for j=1:N
        if (sig(i,j)<5)&(sig(i,j)>-5)
            sig(i,j)=0;
        end
    end
end

for i=1:M
    for j=N/2+1:N
        if (sig(i,j)<5)&(sig(i,j)>-5)
            sig(i,j)=0;
        end
    end
end

%ȥ������dwt�任�е�����
for i=M/4+1:M/2
    for j=1:N/2
        if (sig(i,j)<3)&(sig(i,j)>-3)
            sig(i,j)=0;
        end
    end
end
for i=1:M/2
    for j=N/4+1:N/2
        if (sig(i,j)<3)&(sig(i,j)>-3)
            sig(i,j)=0;
        end
    end
end

%ȥ������dwt�任�е�����
for i=M/8+1:M/4
    for j=1:N/4
        if (sig(i,j)<1)&(sig(i,j)>-1)
            sig(i,j)=0;
        end
    end
end
for i=1:M/4
    for j=N/8+1:N/4
        if (sig(i,j)<1)&(sig(i,j)>-1)
            sig(i,j)=0;
        end
    end
end

end


%������haarС���Ķ�άdwt�任
function pic=my_dwtplusD(pic,time)
[M,N]=size(pic);
%dwtDpic=zeros(M,N);
P=M*2;
Q=N*2;
%��timeΪ���Ʊ����������haarС����dwt�任
for i=1:time
P=P/2;
Q=Q/2;
pic(1:P,1:Q)=my_dwtplus(pic(1:P,1:Q));
end

end

%�������Զ�ά�źŽ���haarС����dwt�任
function dwtpic=my_dwtplus(pic)
[M,N]=size(pic);
dwtpic=zeros(M,N);
%�Զ�ά�źź������haarС����dwt�任
for i=1:M
    dwtpic(i,:)=my_dwt(pic(i,:),1);
end
%�Զ�ά�ź��������haarС����dwt�任
for j=1:N
    dwtpic(:,j)=my_dwt(dwtpic(:,j),0);
end

end

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


%Huffman���뺯��
function [code,diction]=huffman_encode(signal)
[r,c]=size(signal);
num=r*c;
new=reshape(signal,1,num);

p=[];
char=[];

%���㲻ͬ�����źų��ֵ�Ƶ��
for i=1:num
    if find(new(1:i-1)==new(i))
        continue
    else
        count=length(find(new==new(i)));
        char=[char,new(i)];
        p=[p,count/num];
    end
end

%����Huffman�ֵ�
diction=huffmandict(char,p);
%Huffman��������
code = huffmanenco(new,diction); 

end




%读入一张图片
picture=imread('lenacolor.bmp');

%将图片的颜色分量分开
R=double(picture(:,:,1));
G=double(picture(:,:,2));
B=double(picture(:,:,3));

%picture=double(rgb2gray(picture));


%对图像进行多维haar小波dwt变换
dwtDR=my_dwtplusD(R,3);
dwtDG=my_dwtplusD(G,3);
dwtDB=my_dwtplusD(B,3);

figure,imshow(uint8(dwtDR));

%去噪
%de_dwtDpic=my_denoise(dwtDpic);
de_dwtDR=my_denoise(dwtDR);
de_dwtDG=my_denoise(dwtDG);
de_dwtDB=my_denoise(dwtDB);

%figure,imshow(dwtDpic);


[M,N]=size(de_dwtDR);
%展开矩阵
lineR=reshape(de_dwtDR,1,M*N);
lineG=reshape(de_dwtDG,1,M*N);
lineB=reshape(de_dwtDB,1,M*N);

%Huffman编码
[Rco_line,Rco_dict]=huffman_encode(lineR);
[Gco_line,Gco_dict]=huffman_encode(lineG);
[Bco_line,Bco_dict]=huffman_encode(lineB);


save('savedata.mat','M','N','Rco_line','Rco_dict','Gco_line','Gco_dict','Bco_line','Bco_dict');
clear;

%去噪函数
function sig=my_denoise(sig)
[M,N]=size(sig);
%阈值设置为10，5，2

%去除一级dwt变换中的噪声
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

%去除二级dwt变换中的噪声
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

%去除三级dwt变换中的噪声
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


%函数：haar小波的多维dwt变换
function pic=my_dwtplusD(pic,time)
[M,N]=size(pic);
%dwtDpic=zeros(M,N);
P=M*2;
Q=N*2;
%以time为控制变量，做多次haar小波的dwt变换
for i=1:time
P=P/2;
Q=Q/2;
pic(1:P,1:Q)=my_dwtplus(pic(1:P,1:Q));
end

end

%函数：对二维信号进行haar小波的dwt变换
function dwtpic=my_dwtplus(pic)
[M,N]=size(pic);
dwtpic=zeros(M,N);
%对二维信号横向进行haar小波的dwt变换
for i=1:M
    dwtpic(i,:)=my_dwt(pic(i,:),1);
end
%对二维信号纵向进行haar小波的dwt变换
for j=1:N
    dwtpic(:,j)=my_dwt(dwtpic(:,j),0);
end

end

%函数：对一维信号做haar小波的dwt变换
function dwtsig=my_dwt(signal,flag)
[M,N]=size(signal);
%flag为控制变量
%控制一维信号的横纵
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


%Huffman编码函数
function [code,diction]=huffman_encode(signal)
[r,c]=size(signal);
num=r*c;
new=reshape(signal,1,num);

p=[];
char=[];

%计算不同单个信号出现的频率
for i=1:num
    if find(new(1:i-1)==new(i))
        continue
    else
        count=length(find(new==new(i)));
        char=[char,new(i)];
        p=[p,count/num];
    end
end

%生成Huffman字典
diction=huffmandict(char,p);
%Huffman编码生成
code = huffmanenco(new,diction); 

end



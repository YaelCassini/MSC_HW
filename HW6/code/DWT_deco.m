load('savedata.mat');

%Huffman解码
de_lineR=huffmandeco(Rco_line,Rco_dict);
de_lineG=huffmandeco(Gco_line,Gco_dict);
de_lineB=huffmandeco(Bco_line,Bco_dict);
%恢复矩阵大小
re_dwtDR=reshape(de_lineR,M,N);
re_dwtDG=reshape(de_lineG,M,N);
re_dwtDB=reshape(de_lineB,M,N);

%test=re_line-de_dwtDpic;

%对图像进行多维haar小波dwt反变换
idwtDR=my_idwtplusD(re_dwtDR,3);
idwtDG=my_idwtplusD(re_dwtDG,3);
idwtDB=my_idwtplusD(re_dwtDB,3);

idwtDpic=uint8(cat(3,idwtDR,idwtDG,idwtDB));

%展示图片
figure,imshow(uint8(idwtDpic));


function pic=my_idwtplusD(pic,time)
[M,N]=size(pic);
%dwtDpic=zeros(M,N);
P=M*2;Q=N*2;
%以time为控制变量，做多次haar小波的dwt反变换
for i=1:time
P=P/2;
Q=Q/2;
end
for i=1:time
pic(1:P,1:Q)=my_idwtplus(pic(1:P,1:Q));
P=P*2;
Q=Q*2;
end

end


%函数：对二维信号进行haar小波的反dwt变换
function idwtpic=my_idwtplus(pic)
[M,N]=size(pic);
idwtpic=zeros(M,N);

%对二维信号横向进行haar小波的反dwt变换
for i=1:M
    idwtpic(i,:)=my_idwt(pic(i,:),1);
end

%对二维信号纵向进行haar小波的反dwt变换
for j=1:N
    idwtpic(:,j)=my_idwt(idwtpic(:,j),0);
end

end

%函数：对一维信号做haar小波的反dwt变换
function idwtsig=my_idwt(signal,flag)
[M,N]=size(signal);
%flag为控制变量
%控制一维信号的横纵
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
load('savedata.mat');

%Huffman����
de_lineR=huffmandeco(Rco_line,Rco_dict);
de_lineG=huffmandeco(Gco_line,Gco_dict);
de_lineB=huffmandeco(Bco_line,Bco_dict);
%�ָ������С
re_dwtDR=reshape(de_lineR,M,N);
re_dwtDG=reshape(de_lineG,M,N);
re_dwtDB=reshape(de_lineB,M,N);

%test=re_line-de_dwtDpic;

%��ͼ����ж�άhaarС��dwt���任
idwtDR=my_idwtplusD(re_dwtDR,3);
idwtDG=my_idwtplusD(re_dwtDG,3);
idwtDB=my_idwtplusD(re_dwtDB,3);

idwtDpic=uint8(cat(3,idwtDR,idwtDG,idwtDB));

%չʾͼƬ
figure,imshow(uint8(idwtDpic));


function pic=my_idwtplusD(pic,time)
[M,N]=size(pic);
%dwtDpic=zeros(M,N);
P=M*2;Q=N*2;
%��timeΪ���Ʊ����������haarС����dwt���任
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


%�������Զ�ά�źŽ���haarС���ķ�dwt�任
function idwtpic=my_idwtplus(pic)
[M,N]=size(pic);
idwtpic=zeros(M,N);

%�Զ�ά�źź������haarС���ķ�dwt�任
for i=1:M
    idwtpic(i,:)=my_idwt(pic(i,:),1);
end

%�Զ�ά�ź��������haarС���ķ�dwt�任
for j=1:N
    idwtpic(:,j)=my_idwt(idwtpic(:,j),0);
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
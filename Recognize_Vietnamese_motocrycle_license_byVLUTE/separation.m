function [im1,im2] = separation(img)
    %%Tien xu ly    
    g=rgb2gray(img);
    g=imadjust(g);
    g1=imadjust(g,[0 1],[1 0],2);
    g1=imadjust(g1);
    g1=imclearborder(g1,8);
    g1=imadjust(g1);
    
    %Anh bien - xu ly lap day
    bw=edge(g1,'canny');
    bw=imdilate(bw,[0 1 0; 1 1 1; 0 1 0]);
    bw=imfill(bw,'holes');
    bw=imopen(bw,strel('disk',2));
    
    %stat: struct
    stat=regionprops(bw,'Area','Image','BoundingBox','Centroid');
    count=0;
    for i=1:length(stat)
        a=stat(i).Area; % Dien tich cac doi tuong
        b=stat(i).Image;% anh crop cua cac doi tuong
        d=stat(i).BoundingBox(1:2);% Khung bao cua cac doi tuong
        [r,c]=size(b);% Lay kich thuoc 
        if r>c && c>0.2*r&& c<0.55*r
            count=count+1;
            t(count,1)=a;% luu lai dien tich
            t(count,2)=i;% luu lai vi tri
            t(count,3)=round(r*c);% lay kich thuoc anh
            t(count,4:5)=[d(2),d(1)];% Lay Vi Tri Diem Dau
        end
    end
    n=length(t);
    t=sortrows(t,1);% Xep theo dien tich tang dan 
    count=0;
    
    % truong hop phat hien nhieu hon 9 doi tuong
    if n>=9 
        ts=t(end-8:end,:);% lay 9 doi tuong co dien tich lon nhat
        su=sum(ts(:,3))/9;
        for i=1:9
            if ts(i,3)>0.2*su
                count=count+1;
                ts1(count,:)=ts(i,:);
            end
        end 
    else
        ts1=t;
    end
    ts1=sortrows(ts1,4);
    t1=ts1(1:4,:);
    t1=sortrows(t1,5);
    t2=ts1(5:end,:);
    t2=sortrows(t2,5);
    n1=size(t1,1);
    im1=cell(1,n1);
    
    n2=size(t2,1);
    im2=cell(1,n2);
    for i=1:n1
        a=(stat(t1(i,2)).BoundingBox);
        b=imcrop(img,a);
        b=rgb2gray(b);
        b=imadjust(b);
        b=imadjust(b,[0 1],[1 0],2);
        b=im2bw(b);
        b=my_BwTrim(b);
        b=imopen(b,strel('disk',1));
        im1{i}=b;
    end

    for i=1:n2
        a=(stat(t2(i,2)).BoundingBox);
        b=imcrop(img,a);
        b=rgb2gray(b);
        b=imadjust(b);
        b=imadjust(b,[0 1],[1 0],2);
        b=im2bw(b);
        b=my_BwTrim(b);
        b=imopen(b,strel('disk',1));
        im2{i}=b;
    end
end


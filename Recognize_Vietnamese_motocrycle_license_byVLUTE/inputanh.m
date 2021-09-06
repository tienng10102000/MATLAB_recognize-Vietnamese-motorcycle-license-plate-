function y = inputanh(rgb)
    gray=rgb2gray(rgb); % chuyen anh mau thanh anh xam
    gray=imadjust(gray);% can bang cuong do sang
    [row,col]=size(gray);% Lay kich thuoc anh
    cp=[round(row/2),round(col/2)];% toa do diem tam

    de=round(0.01*row);% khoang cong tru
    cm1=cp(1)-de:cp(1)+de;% khoang thoa man theo hang
    cm2=cp(2)-de:cp(2)+de;% khoang thoa man theo cot

    %var: Gia tri: Dung loc nhieu
    %dung mo rong anh nhi phan
    doituongnho=round(0.02*row*col);% so diem anh doi tuong nho
    % so diem anh toi thieu co the co
    % trong hinh
    %Dung de loc nhieu
    %19:14 la ti le cua bien so xe
    biensonho=[round(0.08*row),round(0.08*19*row/14)];

    thresh=0; % khoi tao nguong
    check=0; % khoi tao kiem tra

    %Chay mot vong lap while(cho nguong tang dan deu +0.01, 
    %va chuyen doi anh xam dan theo nguong 
    while check==0
        thresh=thresh+0.01;
        if thresh==1
            msgbox('Khong phat hien duoc bien so');
            break;
        else
            bw=im2bw(gray,thresh);

        %Su dung bwareopen: de khu nhieu doi tuong nho
        %Xet trong mot doi tuong anh, neu so luong phan tu anh mang gia tri 1
        %trong region nho hon 'doituongnho' thi loai bo
        bw1=bwareaopen(bw,doituongnho);

        %Su dung imfill de lap day cac lo trong
        bw2=imfill(bw1,'holes');

        %Tac dung xoa vien
        %Ngan chan cac cau truc anh sang, ket noi voi vien anh
        %65 - X4 7855
        bw3=imclearborder(bw2,4);

        %Xu ly hinh thai anh
        %Mo rong anh voi mat na bien so nho
        %bw la 1 bang trang wwhite table
        %mat na la 'biensonho'
        bw4=imopen(bw3,strel('rectangle',biensonho));
        
        %Tra ve so luong ket noi duoc tim thay
        %L: matran; n: so luong ket noi
        [L,n]=bwlabel(bw4);

        if n>0
            for i=1:n
                %find: Tim cac vi tri co chi so i
                [row1,col1]=find(bw4==i);

                %tong cac mang lai
                %ismember(xet xem cm1 co trong row1 hay ko)
                %cm1/cm2: Khoang
                a=sum(ismember(cm1,row1));
                b=sum(ismember(cm2,col1));

                %xac dinh hinh chu nhat bao quanh
                stat=regionprops((L==i),'BoundingBox');

                try 
                    %nm
                    mat=stat.BoundingBox;
                    if a>0 && b> 0 && mat(4)< mat(3)
                        check=1;
                        %Neu da thay khung thi khong can phai chay while tiep
                        %bw=(L==i);
                        break;
                    else
                        check=0;
                    end
                catch e
                    msgbox(e.message);
                end
            end
        end
        end
    end
    %img la anh nhi phan cua bang so 
    if thresh<1
        y = imcrop(rgb,mat);
    else
        y = im2bw(rgb);
    end
end
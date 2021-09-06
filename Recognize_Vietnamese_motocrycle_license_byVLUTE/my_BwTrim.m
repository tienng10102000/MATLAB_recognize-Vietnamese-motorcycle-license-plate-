function y = my_BwTrim( bw )
% Read a bw image and trim it
% bw_image: black and white image
% 1: white
% 0: black
% y: out put image, trim the black surround
stat=regionprops(bw,'Image','Area');
n=length(stat);
a=zeros(1,n);
for i=1:n
    a(i)=stat(i).Area;
end
k= a==max(a);
y=stat(k).Image;
end


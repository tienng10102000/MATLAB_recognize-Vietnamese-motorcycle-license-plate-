%PHUONG PHAP BIEN DOI HOUGH
function y= houghangle(rgb)
    %Chuyen ve anh xam
    gray=rgb2gray(rgb);

    %Chuyen ve anh bien
    BW=edge(gray,'canny');

    %Xoi mon anh
    BW=imclose(BW,strel('line',10,90));

    %Bien doi HOUGH
    [H,theta,rho] = hough(BW);

    %houghpeaks: Xac dinh dinh bien doi HOUGH
    P = houghpeaks(H,1,'threshold',ceil(0.3*max(H(:))));

    %hoghlines: Tich xuat cac phan doan dong dua tren bien doi HOUGH
    lines = houghlines(BW,theta,rho,P,'FillGap',5,'MinLength',7);

    % figure, imshow(rgb), hold on
    max_len = 0;
    p=0;
    for i = 1:length(lines)
       len = norm(lines(i).point1 - lines(i).point2);
       if ( len > max_len)
          max_len = len;
          p=i;
       end
    end
    A=lines(p).point1;
    B=lines(p).point2;
    goc=atan2(B(2)-A(2),B(1)-A(1));
    goc=rad2deg(goc);
    if goc <80
    y=imrotate(rgb,goc,'crop');
    end

end

%PHUONG PHAP BIEN DOI RADON
% function y = angle(rgb)
% %     gray_image = rgb2gray(rgb_image);
%     theta = (0:179)';
%     [R, xp] = radon(edge(rgb), theta);
%     i = find(R > (max(R(:)) - 25));
%     [foo, ind] = sort(-R(i));
% 
%     [y, x] = ind2sub(size(R), i);
%     t = -theta(x)*pi/180;
%     r = xp(y);
%     [r,c] = find(R == max(R(:)));
%     thetap = theta(c(1));
%     angle = 90 - thetap;
% end

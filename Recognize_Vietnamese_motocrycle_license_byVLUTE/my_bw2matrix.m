function matrix = my_bw2matrix( bw )
%MY_MW2MATRIX Summary of this function goes here
%   Detailed explanation goes here
%CONVERT Summary of this function goes here
%   Detailed explanation goes here
[row,col]=size(bw);
matrix=ones(row*col,1);
for i=1:row
    for j=1:col
        if bw(i,j)==0 
            matrix(j+(i-1)*col)=-1;
        end
    end
end

end


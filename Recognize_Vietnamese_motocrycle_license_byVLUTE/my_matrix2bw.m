function img = my_matrix2bw( matrix,row,col )
%MY_MATRIX2BW Summary of this function goes here
%   Detailed explanation goes here
% Matrix: row or collum matric
% row,col: row and col of image being bulding
img = ones(row,col);
for i = 1:row
   for j = 1:col
      if matrix(j+(i-1)*col) == -1
          img(i,j) =0;
      end
   end
end
end


% John Canty                                   Created 10/22/15
% Yildiz Lab

% Converts .bin files to .txt files from Insight3
% Function calls:
%   dlmcell.m - creates a tab-delimited .txt file from cell array
%   Source: http://www.mathworks.com/matlabcentral/fileexchange/25387-write-cell-array-to-text-file

function bin2txt(file)

fid = fopen(file,'r');
skip = fread(fid,12); 
A = fread(fid,'float32');

%   1       2   3   4   5   6       7       8       9   10  11  12
% Cas44178	X	Y	Xc	Yc	Height	Area	Width	Phi	Ax	BG	I	
%   13  14      15      16      17  18
% Frame	Length	Link	Valid	Z	Zc

x = A(2:18:end);
y = A(3:18:end);
z = A(18:18:end);

xc = A(4:18:end);
yc = A(5:18:end);
zc = A(19:18:end);

h = A(6:18:end);
area = A(7:18:end);
width = A(8:18:end);
phi = A(9:18:end);
Ax = A(10:18:end);
bg = A(11:18:end);
I = A(12:18:end);

clear A;

frewind(fid);
skip = fread(fid,12);
A = fread(fid,'int32');

cat = A(13:18:end);
valid = A(14:18:end);
frame = A(15:18:end);
len = A(16:18:end);

clear A;

fclose(fid);

mol = horzcat({x},{y},{xc},{yc},{h},{area},...
    {width},{phi},{Ax},{bg},{I}...
    ,{frame},{len},{cat},{valid}...
    ,{z},{zc})

% Make all arrays same size
mx = max([length(x),length(y),length(z),length(xc),length(yc),length(zc),...
    length(h),length(area),length(width),length(phi),length(Ax),...
    length(bg),length(I),length(cat),length(valid),length(frame),length(len)]);

mn = min([length(x),length(y),length(z),length(xc),length(yc),length(zc),...
    length(h),length(area),length(width),length(phi),length(Ax),...
    length(bg),length(I),length(cat),length(valid),length(frame),length(len)]);

for i = 1:length(mol)
    cell = mol(i)
    if length(cell{1}) == mx
        cell{1} = cell{1}(1:end-1)
    else
        continue
    end
end
        
% Append column labels to first row
label = {'X' 'Y' 'Xc' 'Yc' 'Height' 'Area' 'Width' 'Phi' 'Ax' 'BG' 'I'...
         'Frame' 'Length' 'Link' 'Valid' 'Z' 'Zc'};
mol = [label;mol];

% Save to tab-delimited .txt file
ind = strfind(file,'.');
file(ind+1:end)=[];
fout = strcat(file,'txt');
dlmcell(fout,mol);

end
    
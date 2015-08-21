% John Canty                                    Date created: 06/17/2015
% Yildiz Lab                                    

% Description
% Converts pixel coordinates given by the Sony camera to pixel coordinates
% given by the Andor camera.
% INPUTs: sony.txt file
% OUTPUTs: a drift.txt file with 3 columns (number, X_corrected,
% Y_corrected)

% Modified 08/21/15: changed pixel ratios

% Open file and read into a cell array
nm = input('File name? ','s');
f = strcat(nm,'.txt');
fileID = fopen(f);
cds = textscan(fileID,'%f %f');
x = cds{1};
y = cds{2};

% Drift correct pixel coordinates
sz = length(cds{1});
x_c = x/3.19;
y_c = y/3.13;
num = linspace(1,sz,sz)'
length(x_c);
length(y_c);
length(num);
data = horzcat(num,x_c,y_c)
dlmwrite('drift.txt',data,'\t')


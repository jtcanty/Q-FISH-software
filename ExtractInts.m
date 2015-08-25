% John Canty                                      Created 08/24/15
% Yildiz Lab

% Takes outputted .txt file from .dax ROI of Z-stack and extracts the
% intensity values. Outputs values as an excel file.

% Modified 08/24/15

clear all;

dirData = dir('*.txt');
num = length(dirData);
int_list = [];

for i = 1:num
    field = dirData(i);
    fname = field.name;
    info = tdfread(fname,'\t');
    ints = info.I;
    int_list = vertcat(int_list,ints);
end

% Write to excel file
name = input('Input file name: ','s');
filename = strcat(name,'.xlsx');
xlswrite(filename,int_list);
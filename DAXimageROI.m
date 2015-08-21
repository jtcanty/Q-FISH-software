% John Canty                                Date created: 06/22/15
% Yildiz Lab                                Date last modified: 08/21/15

% Description
% Adapted from DAXimage by Jigar N Bandaria
% Identifies a .dax file and converts the file into a multidimensional
% array corresponding to a stack of 16-bit images. 

% Function calls: None
% OUTPUTs:
%   data3 = multidimensional array of u16-bit integers corresponding to
%   the image stack
%   nframes = number of frames in the stack 

function [data3,nframes] = DAXimageROI

clear all
clc

%Getting the Filename and the Path. Will open a popup window looking for
%inf file.
[FileName,PathName] = uigetfile('*.inf','Select the MATLAB code file');

%opens the file and gets the number of frames and dimensions of the frame.
%it will also calculate total number of pixels in a frames and the size of
%the image in bytes. Note: roi.inf has frame/dim info different from .inf
fid=fopen(FileName);
tline = fgetl(fid);
i = 1;
while i < 17
    tline = fgetl(fid);
    i = i + 1;
end
disp(tline);
fclose(fid);

C = textscan(tline,'%s'); %this creates a 1X1 cell
data = cellstr(C{1}); %data in string format is read from the cell
nframes = str2num(char(data(5))); %this is the number of frames.

% Determine total number of pixels and number of bytes 
fid = fopen(FileName);
for i=1:10
tline=fgetl(fid);
end
disp(tline);

C = textscan(tline,'%s');
data=cellstr(C{1});
vend = char(data);
ypixel=str2num(vend(6:8));

for i = 1:2
    tline = fgetl(fid);
end
disp(tline);

C = textscan(tline,'%s');
data=cellstr(C{1});
hend = char(data);
xpixel=str2num(hend(6:8));

t_pixel=xpixel*ypixel;
fclose(fid);
fbytes=t_pixel*2;
clear C data i tline fid ans;

%loading the dax file that has the same name but with an inf
%extension and then loading the first frame.
idx = strfind(FileName,'.');
FileName(idx+1:end)=[];
name1=strcat(FileName,'dax');
data1=fopen(name1,'r');
data2=fread(data1,inf,'int16=>uint16',0, 'ieee-be');%reading all data
data3= flipdim(rot90(reshape(data2,xpixel,ypixel,[]),1),1); %need to flip differently for ROI
%imshow(double(data3(:,:,1))/4095)
f_count=5;%frame # to read
% data4=rot90(reshape(data2((f_count*t_pixel+1):(f_count+1)*t_pixel),xpixel,ypixel),2);
%J=imadjust(data3);
%avg_img=sum(reshape(data2,xpixel,ypixel,nframes),3)/nframes;
%imshow(data4,[]);

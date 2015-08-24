% John Canty                                    Created 08/23/15
% Yildiz Lab

% Converts a .tiff file to a .dax file
% Last modified: 08/23/15

clear all;

% Obtain list of files in file directory
dirData = dir('*.tif');

for file = dirData:
    
    info = imfinfo(file);
    num_img = numel(info);

    % Create 1-D array of all image pixels 
    for k = 1:num_img
        curr_img = imread(fname, k, 'Info' ,info);
        data = vertcat(data, reshape(rot90(curr_img,2),size(curr_img,1)*size(curr_img,2),1));
    end

    % Create .dax file
    base = strfind(fname,'.');
    fname(base+1:end) = [];
    dax_name = strcat(fname,'dax');
    fnew = fopen(dax_name,'w','ieee-be');
    fwrite(fnew,data,'uint16',0,'ieee-be');
    fclose(fnew);

    finfo = strcat(fname,'inf');
    fileID = fopen(finfo,'w');
    fprintf(fileID,'file path = %s\r\n',PathName);
    fprintf(fileID,'number of frames = %d\r\n',num_images);
    fprintf(fileID,'binning = 1 x 1\r\n');
    fprintf(fileID,'frame dimensions = %d x %d',size(A,1),size(A,2));
    fclose(fileID);

end
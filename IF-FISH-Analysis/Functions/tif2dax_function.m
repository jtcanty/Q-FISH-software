% John Canty                                    Created 08/23/15
% Yildiz Lab

% Converts a .tiff file to a .dax file. Navigate workspace to directory.
% Modified 08/25/15: allow to change working directory
%   Input: wd = user input working directory containing Z-stack .tif images

function tif2dax_function(dirData)

% Obtain list of files in file directory
num = length(dirData);
data = [];
PathName = pwd;

for i = 1:num
    % Identify image name and num of frames 
    field = dirData(i);
    fname = field.name;
    info = imfinfo(fname);
    num_frame = numel(info);

    % Create 1-D array of all image pixels 
    for k = 1:num_frame
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
    
    data = [];
    
    finfo = strcat(fname,'inf');
    fileID = fopen(finfo,'w');
    fprintf(fileID,'file path = %s\r\n',PathName);
    fprintf(fileID,'number of frames = %d\r\n',num_frame);
    fprintf(fileID,'binning = 1 x 1\r\n');
    fprintf(fileID,'frame dimensions = %d x %d',size(curr_img,1),size(curr_img,2));
    fclose(fileID);

end






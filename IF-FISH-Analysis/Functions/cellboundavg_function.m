% John Canty                            Date Created: 06/24/15
% Yildiz Lab                            Last modified: 08/21/15
 
% Description
% Calculates avg of background for a z stack of a single cell.
% Adapted from CellBound.m

% Function calls: DAXimage_function, CellBound

function [min_above,bkrd_avg] = cellboundavg_function(fname)

% Pick .dax file
[img_stack,nframes] = DAXimage_function(fname);

% determine average background of frames
percentile = [];
for i = 1:nframes
    img = img_stack(:,:,i);
    [bkrd,prct] = CellBound(img);
    percentile = [percentile;[bkrd,prct]];
end

bkrd_avg = round(mean(percentile(:,1)));
max_percentile = max(percentile(:,2));

min_above = max_percentile - bkrd_avg;
bkrd_avg;
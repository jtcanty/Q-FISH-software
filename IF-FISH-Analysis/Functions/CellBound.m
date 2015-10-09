% John Canty                                   Date created: 06/22/15
% Yildiz Lab                                   Date modified: 08/21/15


% Description
% Applies a smooth gaussian filter to the image and then performs edge
% detection in order to determine the boundaries of the cell. Outputs the
% average pixel intensity and standard deviation of pixel intensities
% within the cell boundary

% Function calls: none

function [bkgrd,prct] = CellBound(data)

% gaussian filter image
sz = size(data);
gauss = fspecial('gaussian',sz,20); %Use broad filter instead
filt = imfilter(data, gauss,'same','replicate');

% edge detection and convex hull
ed = edge(filt,'Canny');
ch = bwconvhull(ed);
% imshow(ch);
% pause 

% find coordinates in convex hull
ind = find(ch);
[nr,nc] = size(ch);
[r,c] = ind2sub([nr,nc],ind);

% create array of pix ints in convext hull
rcpx = [r c];
len = size(rcpx,1);
ints = zeros(1,len);
for i = 1:len
    ints(i) = data(rcpx(i,1),rcpx(i,2));
end

% Two possible background subtraction methods

% -------------------------------------------------------------------------
% find image background average from all pixel intensities
mu = mean(ints);
std_dev = std(ints);
histogram(ints);

% calculate background from lowest 20% of pixel intensities
ints_sort = sort(ints);
lowest = round(.20*length(ints_sort));
bkgrd = mean(ints_sort(1:lowest));
%--------------------------------------------------------------------------

% calculate upper percentile of pixels
prct = prctile(ints,95);
 

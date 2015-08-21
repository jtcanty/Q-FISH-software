% John Canty                            Date Created: 06/24/15
% Yildiz Lab                            Last modified: 08/21/15
 
% Description
% Calculates avg of background for a z stack of a single cell.
% Adapted from CellBound.m

% Function calls: DAXimageROI, CellBound

% Pick .dax file
clear all
clc
[img_stack,nframes] = DAXimageROI();


% determine average background of frames
percentile = [];
for i = 1:nframes
    img = img_stack(:,:,i);
    [bkrd,prct] = CellBound(img);
    percentile = [percentile;[bkrd,prct]];
end

bkrd_avg = round(mean(percentile(:,1)));
max_percentile = max(percentile(:,2));

min_above = max_percentile - bkrd_avg
bkrd_avg

% std_dev
%{
mu_sigma = [];
for i = 1:nframes
    img = img_stack(:,:,i);
    [avg,std_dev] = CellBound(img);
    mu_sigma = [mu_sigma;[avg,std_dev]];
end

avg_mu = round(mean(mu_sigma(:,1)));
avg_sigma = round(mean(mu_sigma(:,2)));
five_sig = 5*avg_sigma;

five_sig
avg_mu
%}
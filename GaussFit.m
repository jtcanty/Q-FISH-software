% John Canty                                        Date created: 06/23/15
% Yildiz Lab                                        

% Description
% Fits the selected point to a 2D Gaussian function. If the FWHM is beyond
% a certain distance, the point is discarded. Adapted from Gaussian_Fit.m

% Function calls: Data_Fit.m
% INPUTs:
%   img = input frame
%   mxc = list of coordinates obtained from frame
% OUTPUTs:
%   mxc_filt = list of coordinates that fit the gaussian

function mxc_fit = GaussFit(img,mxc)

mxc_fit = [];
n = size(mxc,1);
for i = 1:n
    % normalize and fit data to 2D gaussian
    pt = [mxc(i,1),mxc(i,2)];
    roi = img(pt(1)-6:pt(1)+6,pt(2)-6:pt(2)+6);
    m = min(min(roi));
    diff = roi - m;
    s = sum(sum(diff));
    norm_roi = double(diff)/s;
    r = linspace(1,size(norm_roi,1),size(norm_roi,1));
    c = linspace(1,size(norm_roi,2),size(norm_roi,2));
    % sftool
    [fitresult, gof] = Data_Fit(r, c, norm_roi);
   
    % determine FWHM and either keep or throw out point
    coeffs = coeffvalues(fitresult);
    sigma = coeffs(4);
    fwhm = 2.3548*sigma*122;
    if fwhm > 200 & fwhm < 600
        mxc_fit = [mxc_fit;pt];
    else
        continue
    end 
end

    
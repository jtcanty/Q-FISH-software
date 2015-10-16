%%                        findspots_v1

% John Canty                                Created: 10/08/15
% Yildiz Lab

% Overview:
%   This code loads images of cells stained for both telomere spots and TIF 
%   spots, locates and determines the intensities of the telomeres, locates 
%   the TIF spots, then determines locations and intensities of telomere
%   spots that colocalize with the TIF spots.

% Inputs for this script are .tif images that contain telomeres in one
% channel and TIF spots in another color channel. Make sure that the
% channels are separated into two .tif files before running. This code
% is used in conjunction with Insight3.

% Input subroutines:
% tif2dax_function.m - converts .tif to .dax files

% NAVIGATE to working directory containing .tif files before startup first!
% FISH .tifs should be named 'name'_FISH.tif
% 53BP1 .tifs should be named 'name'_53BP1.tif

global insightExe
global IniTemp
global DataPath

disp('findspots_v1.m running...');
%DataPath = strcat(pwd,'\');

%% Step 1 - Calculate background and thresholds

% Convert .tif files to .dax files
dirDataTIF = dir('*.tif');
tif2dax_function(dirDataTIF);

% Calculate average background of all .dax Z-stacks
dirDataINF = dir('*.inf');
num = length(dirDataINF);

% Save average background and min. peak thresholds
bkd_threshold_list = [];
for i = 1:num
    fname = dirDataINF(i).name;
    [min_above,avg_bkd] = cellboundavg_function(fname);
    bkd_threshold_list = vertcat(bkd_threshold_list,[min_above,avg_bkd]);
end

xlswrite('thresholds_avgbkd.xlsx',bkd_threshold_list);

%% Step 2 - Configure Insight3 .ini file and run Insight3

% Make sure the .ini file path is set to where Insight3 is located
%insightExe = 'C:\Users\TweedleDee\Documents\STORM\Software\Insight3\InsightM.exe';
%Parameters = 'C:\Users\TweedleDee\Documents\STORM\Software\Insight3\Insight3.ini';

% Update .ini file before each InsightM execution
for i = 1:num
    % Update .ini file
    set_parameters(bkd_threshold_list(i,1),bkd_threshold_list(i,2));
    % Update dax file name
    FileName = dirDataINF(i).name;
    ind = strfind(FileName,'.');
    FileName(ind+1:end)=[];
    dax = strcat(FileName,'dax');
    daxfile = strcat(DataPath,dax);
    % Call InsightM.exe
    ccall = ['!', insightExe,' "',daxfile,'" ',' "',IniTemp,'" '];
    eval(ccall);
end

%% Step 4 Convert .bin to .txt files


%% Step 5 - Identify colocalizations
% Call FISH_DDR_colocalization.m function
dirDataTxt = dir('*_FISH_list.txt');
num = numel(dirDataTxt);
Allstackdata_xyI = [];

for i = 1:num
    TxtFileName = dirDataTxt(i).name;
    stackdata_xyI = FISH_DDR_colocalization(TxtFileName);
    Allstackdata_xyI = [Allstackdata_xyI;{stackdata_xyI}];
end

%% Step 6 - Export data
% Export colocalized telomeres and their intensities into one excel file
% and non colocalized telomeres into another excel file.
% Colocalized telomeres = Colocalized_ints.xlsx
% Noncolocalized telomeres = Noncolocalized_ints.xlsx
% All telomeres = All_ints.xlsx








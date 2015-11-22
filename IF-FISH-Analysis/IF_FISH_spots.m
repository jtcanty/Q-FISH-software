%%                        IF-FISH_spots

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

% For processing .lsm files:
% For IF-FISH, run the lsm2tiff_FISH_splitandmerge.sh script


% Input subroutines:
% tif2dax_function.m - converts .tif to .dax files
% DDR_FISH_colocalization.m - visual identification of colocalizations

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
dirDataTIF1 = dir('*_53BP1.tif');
dirDataTIF2 = dir('*_FISH.tif');
jointdirTIF = [dirDataTIF1;dirDataTIF2];
tif2dax_function(jointdirTIF);

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
    eval(ccall)
end

%% Step 4 Convert .bin to .txt files
disp('Convert .bin files to .txt files')
dirDataBIN = dir('*_FISH_list.bin');
for i = 1:length(dirDataBIN)
    bin_file = dirDataBIN(i).name;
    bin2txt(bin_file);
end


%% Step 5 - Identify colocalizations
% Call FISH_DDR_colocalization.m function
dirDataMerge = dir('*_merge.tif');
num = numel(dirDataMerge);
All_co_stackdata_xyI = [];
All_locs_stackdata_xyI = [];
All_notco_stackdata_xyI = [];

for i = 1:num
    MergeFileName = dirDataMerge(i).name;
    [locs_stackdata_xyI,co_stackdata_xyI,notco_stackdata_xyI] = FISH_DDR_colocalization(MergeFileName);
    All_co_stackdata_xyI = [All_co_stackdata_xyI;co_stackdata_xyI];
    All_locs_stackdata_xyI = [All_locs_stackdata_xyI;locs_stackdata_xyI];
    All_notco_stackdata_xyI = [All_notco_stackdata_xyI;notco_stackdata_xyI];
end

%% Step 6 - Export data
% Export colocalized telomeres and their intensities into one excel file
% and non colocalized telomeres into another excel file.

% Colocalized telomeres = Colocalized_ints.xlsx
colocalized_ints = 'colocalized_ints.xlsx';
xlswrite(colocalized_ints,All_co_stackdata_xyI);

% Noncolocalized telomeres = Noncolocalized_ints.xlsx
noncolocalized_ints = 'noncolocalized_ints.xlsx';
xlswrite(noncolocalized_ints,All_notco_stackdata_xyI);

% All telomeres = All_ints.xlsx
all_ints = 'all_ints.xlsx';
xlswrite(all_ints,All_locs_stackdata_xyI);






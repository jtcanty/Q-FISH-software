% Startup Script for findspots_v1.m
% Sets paths for all necessary functions.

% NAVIGATE to working directory containing .tif files first!
% Make sure only .tif and .lsm files are in the directory!

%% Define global variables
global FindSpots
global insightExe
global IniPath
global DataPath
global IniTemp

%% Create function paths
functionpaths = genpath([FindSpots,'Functions']);
disp('Adding function paths');
addpath(functionpaths);

%% Set paths needed for InsightM
insightExe = 'C:\Users\TweedleDee\Documents\STORM\Software\Insight3\InsightM.exe';
IniPath = 'C:\Users\TweedleDee\Documents\STORM\Software\Insight3\Insight3.ini';
IniTemp = 'C:\Users\TweedleDee\Documents\STORM\Software\Insight3\Insight3_temp.ini';

disp('Adding InsightM paths');
disp('-------------------------');

%% Create data and IF-FISH_spots paths
DataPath = strcat(pwd,'\');
FindSpots = 'C:\Users\TweedleDee\Documents\Projects\Q-FISH-toolbox\IF-FISH-Analysis\';
addpath(FindSpots);
IF_FISH_spots;
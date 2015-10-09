% Startup Script for findspots_v1.m
% Sets paths for all necessary functions.

% NAVIGATE to working directory containing .tif files first!

%% Define global variables
global FindSpots
global insightExe
global IniPath
global Parameters
global DataPath
global IniTemp

%% Create function paths
functionpaths = genpath([FindSpots,'Functions']);
disp('Adding function paths');
addpath(functionpaths);

%% Set paths needed for InsightM
insightExe = 'C:\Users\TweedleDee\Documents\STORM\Software\Insight3\InsightM.exe';
Parameters = 'C:\Users\TweedleDee\Documents\STORM\Software\Insight3\Insight3.ini';
IniPath = 'C:\Users\TweedleDee\Documents\STORM\Software\Insight3\Insight3.ini';
IniTemp = 'C:\Users\TweedleDee\Documents\STORM\Software\Insight3\Insight3_temp.ini';

disp('Adding InsightM paths');
disp('-------------------------');

%% Create data and findspots_v1 paths
DataPath = strcat(pwd,'\');
FindSpots = 'C:\Users\TweedleDee\Documents\Projects\Q-FISH-toolbox\IF-FISH-Analysis\';
addpath(FindSpots);
findspots_v1;
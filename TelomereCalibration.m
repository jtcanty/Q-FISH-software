% John Canty                                         % Created 07/26/16
% Yildiz Lab

% This function calibrates telomere intensities obtained from QFISH experiments to DNA length in
% base-pairs. Generates a simple linear regression between HeLa and HeLa
% 1.2.11 cell-line to create a standard curve. 

% Inputs:
%   Average HeLa intensities obtained from Q-FISH experiment
%   Average HeLa 1.2.11 intensities obtained from Q-FISH experiment
%   'matchpts.xlsx' Excel file containing the telomere intensities to be calibrated

% Outputs
%  1. Array containing DNA lengths of telomeres
%  2. Modified excel file containing calibrated telomere lengths 
%  3. Calibration plot and equation

function [DNALength] = TelomereCalibration()

% Expected telomere lengths of HeLa and HeLa 1.2.11 cell-lines
HeLa_Length = 6600;
HeLa1211_Length = 24000;

HeLa_Intensity = 9000;
HeLa1211_Intensity = 30000;

Lengths = [HeLa_Length,HeLa1211_Length];
Intensities = [HeLa_Intensity,HeLa1211_Intensity];

% Perform regression analysis
p = polyfit(Intensities,Lengths,1);
fit = polyval(p,Intensities);

%Plot scatter of fit to data
scatter(Intensities,Lengths,'b');
hold on
plot(Intensities,fit);
title('Intensity and Length Calibration');
xlabel('Intensity');
ylabel('DNA Length (base)');
legend('data','fit');
text(20000,10000, ['via polyfit: ' poly2str(p,'x')]);

%Convert intensity data to DNA length in base-pairs. 
TelomereData = xlsread('matchedpts.xls');
Intensities = TelomereData(:,11);
DNALength = Intensities.*p(1)+p(2);
TelomereData = [TelomereData,DNALength];

%Save DNA length data
header = {'X_STORM','Y_STORM','X_STORMnorm','Y_STORMnorm','Localizations','Ellipsoidal Volume','X_QFISH','Y_QFISH','X_QFISHnorm','Y_QFISHnorm','Intensity','DNA Length (bases)'};
TelomereDataFile = num2cell(TelomereData);
all_data = [header;TelomereDataFile];
xlswrite('matchedpts.xls',all_data);

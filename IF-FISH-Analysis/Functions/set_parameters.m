%%                  set_parameters.m
% John Canty
% Yildiz Lab

% Modifies the Insight3.ini background and threshold default settings.
% Called by findspots_v1.m script.

function set_parameters(min_above,avg_bkd)
global IniPath
global IniTemp
%IniPath = 'C:\Users\TweedleDee\Documents\STORM\Software\Insight3\Insight3.ini';
fin = fopen(IniPath,'rt');
%IniTemp = 'C:\Users\TweedleDee\Documents\STORM\Software\Insight3\Insight3_temp.ini';
fout = fopen(IniTemp,'wt');

% Set minimum threshold
i = 0;
while ~feof(fin)
    i = i+1;
    s = fgetl(fin);
    if i==22
        s = strcat('min height=',num2str(min_above)) 
    end 
    if i==24
        s = strcat('Fit ROI=',num2str(13));
    end
    if i==33
        s = strcat('default background=',num2str(avg_bkd))
    end
    if i==40
        s = strcat('pixel size=',num2str(66.15));
    end
    fprintf(fout,'%s\n',s);
end

fclose('all')




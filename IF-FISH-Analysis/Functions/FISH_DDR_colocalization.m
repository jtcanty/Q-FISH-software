%%                    FISH_DDR_colocalization.m

% John Canty                                    % Created 10/12/15
% Yildiz Lab

%% Extracts XY coordinates of FISH spots. Overlays them onto a two-channel 
%% image of DDR-FISH. User manuals removes all colocalizers and the XY coordinates
%% and intensity values are exported

function [locs_stackdata_xyI,co_stackdata_xyI,notco_stackdata_xyI] = FISH_DDR_colocalization(file)

%Identify number of frames in image stack
info = imfinfo(file);
fnum = numel(info);

% Import image stack into multidimensional array. 
for i = 1:fnum
    img_stack(:,:,i) = imread(file,i,'Info',info);
end
%Merge channels of consecutive images. Note that imfuse creates a
%multidimensional array of size(:,:,3)
merge_stack = [];
for i = 1:fnum-1
    if mod(i,2) == 1
        fused_img = imfuse(img_stack(:,:,i),img_stack(:,:,i+1));
        merge_stack = [merge_stack,{fused_img}];
    elseif mod(i,2) == 0
        continue
    end
end

% Open text file containing localized spots for the image stack outputted
% from InsightM. Create arrays of XY coordinates and frames.
ind = strfind(file,'merge.');
file(ind:end) = [];
txtfile = strcat(file,'FISH_list.txt');
FISHinfo = tdfread(txtfile,'\t');
xc_array = FISHinfo.Xc;
yc_array = FISHinfo.Yc;
I_array = FISHinfo.I;
frame_array = FISHinfo.Frame;

% Iterate over image stack. For each image overlay all points found on that
% frame onto the image.
% Note: Use Data-Brush tool to remove all points that do not look like they
% colocalize.

set(0, 'DefaultFigurePosition', [-816    57   804   910]);

co_stackdata_xyI = [];
locs_stackdata_xyI = [];
notco_stackdata_xyI = [];

merge_fnum = numel(merge_stack);
for i = 1:merge_fnum
    % Find elements of XY coordinates with current frame number
    ind = find(frame_array == i);
    if isempty(ind)
        img = imagesc(merge_stack{i})
        disp('Hit enter after clearing any non-colocalizers...');
        pause
        close
        continue
    elseif ~isempty(ind)
        x_frame = xc_array(ind);
        y_frame = yc_array(ind);
        I_frame = I_array(ind);
        frame_val = frame_array(ind);
        xyI_frame = horzcat(x_frame,y_frame,I_frame,frame_val);
        % Append locs to array
        locs_stackdata_xyI = vertcat(locs_stackdata_xyI,xyI_frame);

        % Overlay coordinates onto current image
        img = imagesc(merge_stack{i});
        hold on;
        plot(xyI_frame(:,1)',xyI_frame(:,2)','y.');
        brush on
        disp('Hit enter after selecting colocalizers...');
        pause
        
        % Save brushed data into array
        h = findobj(gca,'Type','line');
        brush_ind = logical(get(h,'BrushData'))';
        xyI_frame_remain = xyI_frame(brush_ind,:);
        
        % Append unbrushed points to array
        xyI_frame_not = xyI_frame(~brush_ind,:);
        notco_stackdata_xyI = vertcat(notco_stackdata_xyI,xyI_frame_not);
        
        close
    end
end

end
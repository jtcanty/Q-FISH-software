% John Canty                                        Date created: 06/17/15
% Yildiz Lab

% Description
% Calculates the IOD values of telomeres in a stack of epifluorescence
% images. Tracks telomeres that are present in multiple images.
% Function calls: DAXimage.m, pkfnd.m, pkfinder.m

% Currently non-functional

% Pick .dax file
clear all
clc
[img_stack,nframes] = DAXimage();

% Iterate through image stack. 
for i = 2:nframes % First frame usually repeated
  
    % Determine average and standard deviation of image
    img = img_stack(:,:,i);
    avg = mean2(img);
    std_dev = std2(img);
    
    % Set threshold and determine local maxima coordinates
    th = 1500 + std_dev; % Average value may be too low
    sz = 3;
    mxc = pkfnd(img,th,sz);
    
    % Determine iod values, insert frame coordinate
    coord_iod = pkfinder(img,mxc,sz);
    
    % insert frame coordinate
    if ~isempty(coord_iod);
        frame_col = (i*ones(1,size(coord_iod,1)))';
        coord_iod = [coord_iod(:,1:2) frame_col coord_iod(:,3)];
    end
    
    % Add count column
    counter = ones(1,size(coord_iod,1))';
    coord_iod = [coord_iod counter];
    
    % Append iod values and coordinates to a cell array consisting of the
    % coord_iod matrices for each frame
    stack{i} = coord_iod;
end

% Clear empty cells
stack_new = stack(~cellfun(@isempty,stack));

% Create 3D scatterplot of the data
rcf_coord = [];
for i = 1:length(stack_new)
    rcf_coord = [rcf_coord;stack_new{i}(:,:)];
end
scatter3(rcf_coord(:,1),rcf_coord(:,2),rcf_coord(:,3));  

% Create histogram of unadded spots
% histogram(rcf_coord(:,4))
mu = mean(rcf_coord(:,4));

%Overlay the mean
hold on
plot([mu,mu],ylim,'r--','LineWidth',2)
hold off

% Sum all points in the stack that correspond to same telomeres
tel_iod = [];
i = 2;
while i < size(stack_new,2)
    % Find current and next frame
    fr = stack_new{i};
    fr_next = stack_new{i+1};
    % Iterate over each pix in current frame
    for pix = 1:size(fr,1)
        % Find euclidian between current pix and pix in next frame
        dist = sqrt((fr(pix,1)-fr_next(:,1)).^2+(fr(pix,2)-fr_next(:,2)).^2+(fr(pix,3)-fr_next(:,3)).^2);
        add_ind = find(dist < sqrt(5));
        % If two pix close enough, add iod of current pix to next one
        if ~isempty(add_ind) & length(add_ind) == 1
            stack_new{i+1}(add_ind,4) = fr(pix,4)+stack_new{i+1}(add_ind,4);
        % If no pix close enough, export current iod to array and skip
        elseif isempty(add_ind)
            tel_iod = [tel_iod;fr(pix,[1:2 4])];
        end
    end
    i = i+1;
end

clear pix
% Export iod of last frame to external array
last_fr = stack_new{end};
for pix = 1:size(last_fr,1)
    tel_iod = [tel_iod;last_fr(pix,[1:2 4])];
end

% Remove any zero intensities from the array
zeros = (tel_iod(:,3) == 0);
list = find(zeros);
if ~isempty(list)
    for i = list
        tel_iod(i,:) = [];
    end
end

% Create histogram of data
histogram(tel_iod(:,3))
mu = mean(tel_iod(:,3))

% Overlay the mean
hold on
plot([mu,mu],ylim,'r--','LineWidth',2)
hold off
      
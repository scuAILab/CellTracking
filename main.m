% tracking phase1 blobs
%% 1. load data
disp('1. Initial data');
%     clear; clc; close all;
addpath util
addpath data
addpath temp
tracker = 'CT';
addpath(fullfile('trackers',tracker));

dataPath = './data/c1';
maskPath = './data/c2';

if exist('images','var')==0
    if exist('data/images.mat','file') == 0 
        images = getImages(dataPath,false); 
        save ('data/images','images');
    else
        load('data/images.mat');
    end
end

% 135 ~ 181
startID = 181;    % 15/16 85/86  134/135  181/182     299   % 255-startID+1
endID   = 135; 
                
%% 2. init start points
disp('2. started tracking');
imageNum = size(images,4);
h1 = figure(1);
title('first frame');
im = images(:,:,:,startID);
figure(1);
imshow(im,[]);

%% blob tracking
%  ---   minus mask
%
% 

%% 3. cell detection

%-----------  method 1 ------------     % detect  cell
% % init mean
% imMean = getMean(images(:,:,:,1:end-100));
imMean = mean(images(:,:,:,1:end-100),4);
temp = double( images(:,:,:,50)) - imMean ;
temp = (rgb2gray(temp)/255);
imshow(temp,[]);
% level = graythresh(temp);
% BW = im2bw(temp,level);
subplot(121);
imshow(images(:,:,:,50),[]);
subplot(122);
imshow(BW);

%------------- method 2 -------------    % detect cell-kernel
% im_mask = createMask(im);
% subplot(122);
% imshow(im_mask);
% se = strel('disk', 2);                                                     % opt SIZE
% mask = imopen(im_mask,se);
% imshow(mask);
% 
% % get cell by Rect 
% [mask , cellNum] = bwlabel(mask);
% status=regionprops(mask,'BoundingBox');
% subplot(121);
% for i=1:cellNum
%     rectangle('position',status(i).BoundingBox,'edgecolor','r');
%     text(status(i).BoundingBox(1)+5,status(i).BoundingBox(2)+5,sprintf('%d',i),'Color','g','FontSize',7);    
% end 

%------------  method 3 ---------------- %  by hand rect

h = imrect();
position = wait(h);


%% 4. cell tracking
 
% ------------- continue from method 3.2  -----------------
%   random choose tracking numbers
trackNum  = 6;
seeds = randi([1,cellNum],6,1);
figure(2);
title('tracking part');

frmNum = 0;
for idx = startID:-1:endID
    frmNum = frmNum +1;   
    seq.s_frames{frmNum} = images(:,:,:,idx);
end
% tracking each cell 
for cellIdx = 1:length(seeds)    
    seq.init_rect = status(seeds(cellIdx)).BoundingBox;
    seq.init_rect(3) = seq.init_rect(3)+10;
    seq.init_rect(4) = seq.init_rect(4)+10;          % agument boundingbox 
    result{cellIdx}= run_CT(seq,'',false);
end
% -----------  continue from method 2 ------------------------


% ------------- stage tracking  ------------------  % continue from 3.3
% frmNum = 0;
% for idx = startID:-1:endID
%     frmNum = frmNum +1;   
%     seq.s_frames{frmNum} = images(:,:,:,idx);
% end
% fprintf('%d frames to tracking',frmNum);
% seq.init_rect = ceil(position);
% seq.opt.startID = startID;
% seq.opt.endID = endID;
% seq.opt.imageNum = imageNum;
% res_path = '/home/jamin/Documents/MATLAB/cell/temp/';
% result{1} = run_CT(seq,res_path,true);


%% 5. show lineage in trees
figure(3);
title('lineage tree');
% polt every point
for cellIdx = 1:length(result)
    clr = rand(1,3);    
    temp = result{cellIdx};
    frameNum = size(temp,1);
    % calc center point of cellIdx
    x = zeros(frameNum,1);    
    for j = 1:frameNum
       x(j) = temp(j,1)+temp(j,3)/2;
       y(j) = temp(j,2)+temp(j,4)/2;
    end
    z = 1:frameNum;
    
    % plot lineage tree
    plot3(x,y,z,'Color',clr);
    hold on;
    
end





% tracking phase1 blobs
%% 1. load data
disp('1. Load data from path');
% clear ; clc; 
close all;
addpath util
addpath data
addpath temp
tracker = 'CT';

DEBUG = true;

%****** opt *******%
%   opt.crop
opt.crop.imageWidth  = 817;
opt.crop.imageHeight = 610;
opt.crop.startX = 3268;                 % crop started point:  x-axis
opt.crop.startY = 1220;
opt.crop.debug  = DEBUG;
%   opt.segment

%   opt.tracking
opt.tracking.startID = 181; % 15/16 85/86  134/135  181/182   total: 299
opt.tracking.endID   = 135; 
opt.tracking.tracker = tracker;
%  choose different arch
arch = computer('arch');
switch arch
    case 'glnxa64', 
        dataPath = '/media/jamin/Data/Cell/c1'; 
        c2Path   = '';
        c1c2Path = '';
    case 'win64',
        dataPath = ' ~~~~~~~~~~~~'; 
        c2Path   = '';
        c1c2Path = '';
    case 'maci64',
        dataPath = '/media/jamin/Data/Cell/tracking/c1'; 
        c2Path   = '';
        c1c2Path = '';
end

% check workspace Only check 'images'
if exist('images','var')==0
    if exist('data/images.mat','file') == 0 
        images = loadData(dataPath,c2Path,c1c2Path,opt.crop,DEBUG);
        save ('data/images','images');
    else
        load('data/images.mat');
    end
end
                
%% 2. blob tracking
% disp('2. Blob tracking.')
%

%% 3. cell detection
disp('3. Cell detection')
[segmentResult, status ] = segmentCell(images(:,:,:,opt.tracking.startID));
% show segmentResult
figure;
subplot(121);
imshow(images(:,:,:,opt.tracking.startID),[]);
subplot(122);
imshow(segmentResult);
hold on;
subplot(121);
for i = 1:length(status)  
     rectangle('position',status(i).BoundingBox,'edgecolor','r');
     text(status(i).BoundingBox(1)+5,status(i).BoundingBox(2)+5,sprintf('%d',i),'Color','g','FontSize',7);    
end 

%% 4. cell tracking
disp('4. Cell tracking')
figure;
switch arch
    case 'glnxa64',
        trackResult = trackBackCell(images,segmentResult, status, opt.tracking );
    case 'win64'
        trackResult = trackFeedCell(images,segmentResult, status, opt.tracking );
end
    

%% 5. show lineage in trees
figure();
title('lineage tree');
showLineage(trackResult);





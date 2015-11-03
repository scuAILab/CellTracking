% tracking phase1 blobs
%% 1. load data
disp('1. Load data from path');
% clear ; clc; 
close all;
addpath util
addpath data
addpath cellSeg
addpath temp
tracker = 'CNN';  % DLT,TLD;CNN

DEBUG = true;

%****** opt *******%
%   opt.crop
opt.crop.imageWidth  = 817;%512;
opt.crop.imageHeight = 610;%512;
opt.crop.imageWidth  = 512;
opt.crop.imageHeight = 512;
opt.crop.startX = 3268;                 % crop started point:  x-axis
opt.crop.startY = 1220;
opt.crop.debug  = DEBUG;
%   opt.segment

%   opt.tracking
opt.tracking.startID = 181; % 15/16 85/86  134/135  181/182   total: 299
opt.tracking.endID   = 136; 
opt.tracking.tracker = tracker;
%  choose different arch
arch = computer('arch');
switch arch
    case 'glnxa64', 
        dataPath = '/media/jamin/Data/Cell/c1'; 
        c2Path   = '';
        c1c2Path = '';
    case 'win64',
        dataPath = 'E:\zy\ҽ�ƴ����\�����п�Ժ���\osk-8000-B-new\C1'; 
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

caseID = 4;
firstFrm = images(:,:,:,opt.tracking.startID);
switch caseID
    case 1   % Based on morphology
        [segmentResult, status ] = segmentCell(firstFrm);          
    case 2   % Based on morphology
        [segmentResult, status] = segmentCellNuclei(firstFrm);
    case 3   % Based on entropy
        [segmentResult, status] = segmentEntropyCell(firstFrm);
    case 4   % Based on CNN cell detection
        [segmentResult, status] = segmentCNNCell(firstFrm);
end
showSegmentation(status,firstFrm,segmentResult); 


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
% title('lineage tree');
% showLineage(trackResult);





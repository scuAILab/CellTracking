% tracking phase1 blobs
%% 1. load data
disp('1. Load data from path');
% clear ; clc; close all;
addpath util
addpath data
addpath temp
tracker = 'CT';
addpath(fullfile('trackers',tracker));

DEBUG = true;

%****** opt *******%
%   opt.crop
opt.crop.imageDim = 512;
opt.crop.startX = 0;        % crop started point:  x-axis
opt.crop.startY = 0;
opt.crop.debug  = DEBUG;
%   opt.segment

%   opt.tracking
opt.tracking.startID = 181; % 15/16 85/86  134/135  181/182   total: 299
opt.tracking.endID   = 135; 

%  choose different arch
arch = computer('arch');
switch arch
    case 'glnxa64', 
        dataPath = '/media/jamin/Data/Cell/tracking/test'; 
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

<<<<<<< HEAD
% check workspace Only check 'images'
=======

>>>>>>> origin/master
if exist('images','var')==0
    if exist('data/images.mat','file') == 0 
        images = loadData(dataPath,c2Path,c1c2Path,opt.crop,DEBUG);
        save ('data/images','images');
    else
        load('data/images.mat');
    end
end
<<<<<<< HEAD
=======


arch = computer('arch') ;
switch arch
    case 'glnxa64', dataPath = ''; 
    case 'maci64', opts.imageLibrary = 'quartz' ;
    case 'win64', opts.imageLibrary = 'gdiplus' ;
end



% 135 ~ 181
startID = 181;    % 15/16 85/86  134/135  181/182     299   % 255-startID+1
endID   = 135; 
>>>>>>> origin/master
                
%% 2. blob tracking
% disp('2. Blob tracking.')
%

%% 3. cell detection
disp('3. Cell detection')
segmentResult = segmentCell(images);


%% 4. cell tracking
disp('4. Cell tracking')
trackResult = trackCell(images,segmentResult,opt.tracking );


%% 5. show lineage in trees
showLineage(result);





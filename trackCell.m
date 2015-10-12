function [ result ] = trackCell( images,segmentResult, boundingBoxes,tracking )
%TRACKCELL  tracking different cells 
%
%
%


% init parameters
startID = tracking.startID;
endID   = tracking.endID;
tracker = tracking.tracker;
addpath(fullfile('trackers',tracker));
% cellMask = segmentResult.cellMask;
status =  boundingBoxes;

imageNum = size(images,4);
% h1 = figure(1);
% title('first frame');
% im = images(:,:,:,startID);
% figure(1);
% imshow(im,[]);

% % ------------- continue from method 3.2  ------
% %   random choose tracking numbers
% trackNum  = 6;
% seeds = randi([1,cellNum],6,1);
% figure(2);
% title('tracking part');
% 
% frmNum = 0;
% for idx = startID:-1:endID
%     frmNum = frmNum +1;   
%     seq.s_frames{frmNum} = images(:,:,:,idx);
% end
% % tracking each cell 
% for cellIdx = 1:length(seeds)    
%     seq.init_rect = status(seeds(cellIdx)).BoundingBox;
%     seq.init_rect(3) = seq.init_rect(3)+10;
%     seq.init_rect(4) = seq.init_rect(4)+10;          % agument boundingbox 
%     result{cellIdx}= run_CT(seq,'',false);
% end
% -----------  continue from method 2 ------------------------


% ------------- stage tracking  ------------------  % continue from 3.3
frmNum = 0;
for idx = startID:-1:endID
    frmNum = frmNum +1;   
    seq.s_frames{frmNum} = images(:,:,:,idx);
end
fprintf('%d frames to tracking',frmNum);
seq.init_rect = ceil(status(randi([1,length(status)])).BoundingBox);
seq.opt.startID = startID;
seq.opt.endID = endID;
seq.opt.imageNum = imageNum;
res_path = '/home/jamin/Documents/MATLAB/cell/temp/';
result{1} = run_CT(seq,res_path,true);


result =  null;
end


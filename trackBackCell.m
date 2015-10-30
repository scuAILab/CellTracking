function [ result ] = trackBackCell( images, segmentResult, boundingBoxes,tracking )
%TRACKCELL  tracking different cells 
%
%
res_path = '/home/jamin/Documents/MATLAB/cell/temp/';
% init parameters
startID = tracking.startID;
endID   = tracking.endID;
tracker = tracking.tracker;
addpath(fullfile('trackers',tracker));
% cellMask = segmentResult.cellMask;
status =  boundingBoxes;
imageNum = size(images,4);
cellNum  = length(status);
trackNum = cellNum;         %6;
seq.opt.startID = startID;
seq.opt.endID = endID;
seq.opt.imageNum = imageNum;
frmNum = 0;

% ensamble seqence
for idx = startID:-1:endID
    frmNum = frmNum +1;   
    seq.s_frames{frmNum} = images(:,:,:,idx);
end
fprintf('Tracking frome %d to %d, total %d frames.\n',endID,startID,frmNum);

% tracking each cell 
for cellIdx = 3% 1:trackNum
    seq.init_rect = status(cellIdx).BoundingBox;
    seq.opt.cellIdx = cellIdx;
    result{cellIdx}= eval(strcat('run_',tracker,'(seq,res_path,false)'));
end

end


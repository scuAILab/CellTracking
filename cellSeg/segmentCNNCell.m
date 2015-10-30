function [segmentResult, status] = segmentCNNCell(im)
%   pre-process


% 
    result = load('data/cnnSeg/yhat.mat');
    yhat = result.yhat(1,1,:,:);
    im = squeeze(yhat);    
    im = im2bw(im,graythresh(im));
    im = bwareaopen(im,30);
    [mask , cellNum] = bwlabel(im);
    status=regionprops(mask,'BoundingBox');
    segmentResult = mask;


end
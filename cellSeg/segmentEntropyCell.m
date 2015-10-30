function [ segmentResult, status ] = segmentEntropyCell( im )
% Based on entroySeg
% 
    segmentResult =  entropySeg(im);
    [mask , cellNum] = bwlabeln(segmentResult);
    status=regionprops(mask,'BoundingBox');
    
end


function [ images,c2_mask, c1c2_mask ] = loadData( dataPath, c2Path, c1c2Path, crop, DEBUG)
% load data from path
% Params:
%       dataPath    load TIF(single images) from path
%       c2Path,c1c2Path default NULL
%       DEBUG = 1	crop original size to 1024*1024
%       DEBUG = 0   load original size.
% Return:
%       images:  4D   width*height*chanle*imageNum
%       c2_mask,c1c2_mask:  default null   
% PS :
%     if c2Path or c1c2Path is NULL , will not load data from this path
%

if exist(dataPath,'dir')
    images =    getImages(dataPath, crop, DEBUG);
end
if exist(c2Path,'dir')
    c2_mask =   getImages(c2Path,   crop, DEBUG);
end
if exist(c1c2Path,'dir')
    c1c2_mask = getImages(c1c2Path, crop, DEBUG);
end

end


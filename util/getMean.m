function [ imMean ] = getMean( images )
%GETMEAN Summary of this function goes here
%   Detailed explanation goes here
%     images = getImages(imagePath);
    imMean = images.mean(squeeze(images),3);
end


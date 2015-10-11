function [output,c] = getImages(inputpath,iSMean)
% PS: 
%    1. Wraped output size:  512*512
%    2. Only one case;
%    3. Norm: mean
%    4. Get out wight line ??
t = tic();
%% init 
imageDim = 512;
cropWhileLine = false;                  %default not crop, not confuse the result. 

%% Get iamge [weight hight 1 num]
% addpath(inputpath);
filePath = dir(inputpath); 
n = length(filePath);
fileNum = n -2;
output = zeros(imageDim,imageDim,3,fileNum,'uint8');
countNum = 0;
j = 1;
for i = 1:n
    if filePath(i).isdir == 0
        if j == 1             % just for modify
            c{j} = filePath(i).name;
            im = imread( fullfile(inputpath,char(c{j})) );
            imH = size(im,1);
            imW = size(im,2);
            output = zeros(imH,imW,3,fileNum,'uint8');
        end
        c{j} = filePath(i).name;
        im = imread( fullfile(inputpath,char(c{j})) );
        if ~ismatrix(im)
        im = imread( fullfile(inputpath,char(c{j})) ) ;
        end
        imH = size(im,1);
        imW = size(im,2);
        if cropWhileLine 
            imH = min(imH,imW);
            imW = imH;
        end        
%         if imH>imageDim || imW>imageDim
%             im = imresize(im,[imageDim imageDim]);
%             imH = imageDim;
%             imW = imageDim;
%         end
        output(1:imH,1:imW,:,j) = im;
        countNum = countNum + 1;
        j = j+1;
    end
end

if iSMean
    dataMean = mean(mean(mean(output)));
    output = bsxfun(@minus, output, dataMean);
end;

fprintf('Loaded %d pics form %s takes %3.2fSec \n',countNum,inputpath,toc(t));
end

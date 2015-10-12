function [output,c] = getImages(inputpath,crop,DEBUG)
% PS: 
%    1. Wraped output size:  512*512
%    2. DEBUG   crop
%    3. c{}     images's names

t = tic();
%%  init 
imageDimHeight = crop.imageHeight;
imageDimWidth = crop.imageWidth;
startX = crop.startX;        % crop started point:  x-axis
startY = crop.startY;        %                      y-axis


%% Get iamge [weight hight 3 num]
addpath(inputpath);
% filePath = dir(inputpath,'*.TIF'); 
filePath = dir(inputpath); 
n = length(filePath);
fileNum = n -2;
countNum = 0;
j = 1;
for i = 1:n
    if filePath(i).isdir == 0
        if j == 1             % just for modify
            c{j} = filePath(i).name;
            im = imread( fullfile(inputpath,char(c{j})) );
            imW = size(im,2);        %width
            imH = size(im,1);        %height
            chanels = size(im,3);
            if DEBUG 
                output = zeros(imageDimHeight,imageDimWidth,chanels,fileNum,'uint8');
            else
                output = zeros(imH     ,imW     ,chanels,fileNum,'uint8');
            end
            assert(startX+imageDimWidth  < imW+1,'started point and crop size exceed the width  range!');
            assert(startY+imageDimHeight < imH+1,'started point and crop size exceed the height range!');
        end
        
        c{j} = filePath(i).name;
        im = imread( fullfile(inputpath,char(c{j})) );
        
        if DEBUG % crop
            output(:,:,:,j) = im(startY+1:startY+imageDimHeight, startX+1:startX+imageDimWidth,:);          
        else  % not crop            
            output(:,:,:,j) = im;
        end
        countNum = countNum + 1;
        j = j+1;
    end
end

fprintf('Loaded %d pics form %s takes %3.2fSec \n',countNum,inputpath,toc(t));
end

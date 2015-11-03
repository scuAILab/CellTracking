function [ result ] = run_CNN( seq,res_path,iSave  )
% RUN_CNN 
%   using CNN as the classer
addpath matconvnet
warning off

result = [];
initstate = seq.init_rect;
startID   = seq.opt.startID;
endID     = seq.opt.endID;
imageNum  = seq.opt.imageNum;
cellIdx   = seq.opt.cellIdx;              % the idx of cells
imgDim  = 28;
DEBUG = true;
%----------------------------------------------------------------
trparams.init_negnumtrain = 100;     %number of trained negative samples
trparams.init_postrainrad = 4.0;     %radical scope of positive samples
trparams.initstate = initstate;      % object position [x y width height]
trparams.srchwinsz = 20;             % size of search window  %  default= 20
% Sometimes, it affects the results.

run(fullfile(fileparts(mfilename('fullpath')),'matconvnet','matlab','vl_setupnn.m')) ;
%- load CNN modeld from trainSCN
if exist('data/model/pretrain.mat','var')    
   load('data/model/pretrain.mat');
else
%     pretrain( );  % save pretrained net to data/models    
    net = cnn_cell_init();
end

%-- read first image
img = seq.s_frames{1};
img = double(rgb2gray(img));
%-- sample 
posx.sampleImage = sampleImg(img,initstate,trparams.init_postrainrad,0,100000);
negx.sampleImage = sampleImg(img,initstate,1.5*trparams.srchwinsz,4+trparams.init_postrainrad,50);
if DEBUG
    showSampleImages(img,initstate,posx.sampleImage,negx.sampleImage);
end
%-- enssemble data
sampleNum = length( posx.sampleImage.sx ) + length( negx.sampleImage.sx);
imdb.images.data =  zeros(imgDim , imgDim ,1, sampleNum);
imdb.images.labels = zeros(1,sampleNum);
posNum = length( posx.sampleImage.sx );
for i = 1:sampleNum
   if i <= length( posx.sampleImage.sx ) 
       % positive
       im = img( posx.sampleImage.sy(i):posx.sampleImage.sy(i)+posx.sampleImage.sh(i)-1, ... 
           posx.sampleImage.sx(i):posx.sampleImage.sx(i)+posx.sampleImage.sw(i)-1 );
       imdb.images.data(:,:,1,i) = imresize(im,[imgDim,imgDim]);         
       imdb.images.labels(i) = 1;  %positive
   else
       % negtive
       im = img( fix(negx.sampleImage.sy(i-posNum)):fix(negx.sampleImage.sy(i-posNum))+negx.sampleImage.sh(i-posNum)-1,...
           fix(negx.sampleImage.sx(i-posNum)):fix(negx.sampleImage.sx(i-posNum))+negx.sampleImage.sw(i-posNum)-1 );
       imdb.images.data(:,:,1,i) = imresize(im,[imgDim,imgDim]);
       imdb.images.labels(i) = 2;   % negtive
   end   
end
imdb.images.set = ones(1,sampleNum);
imdb.images.set(end-5:end) = 2;
imdb.images.set(length(posx.sampleImage.sx)-5:length(posx.sampleImage.sx)) = 2;
imdb.images.data_mean = mean(imdb.images.data,3);
imdb.meta.sets = {'train', 'val', 'test'} ;
imdb.meta.classes = arrayfun(@(x)sprintf('%d',x),0:1,'uniformoutput',false) ;

%-------------------------------------
%-- train CNN network  30 epoches
    net = trainCellCNN(imdb,net);
%-----------------------------------

num = length(seq.s_frames);  % number of frames

for i = 2:num
    img = seq.s_frames{i};
    imgSr = img;  % imgSr is used for showing tracking results.
    img = double(rgb2gray(img));
    detectx.sampleImage = sampleImg(img,initstate,trparams.srchwinsz,0,1000);   
    if DEBUG 
        showSampleImages(img,initstate,detectx.sampleImage);    
    end
    %- -----  CNN predicate the next location
    result = cellDetection(net,img,detectx.sampleImage);
    showSampleImages(imgSr,result);
    
    
    
%     iH = integral(img);%Compute integral image
%     detectx.feature = getFtrVal(iH,detectx.sampleImage,ftr);
%     %------------------------------------
%     r = ratioClassifier(posx,negx,detectx);% compute the classifier for all samples
%     clf = sum(r);% linearly combine the ratio classifiers in r to the final classifier
%     %-------------------------------------
%     [c,index] = max(clf);
%     %--------------------------------
%     x = detectx.sampleImage.sx(index);
%     y = detectx.sampleImage.sy(index);
%     w = detectx.sampleImage.sw(index);
%     h = detectx.sampleImage.sh(index);
%     initstate = [x y w h];
%     
%     %-------------------------------save result 
%     result = [result ; initstate];
%     
%     %-------------------------------Show the tracking results
%     imshow(uint8(imgSr));
%     rectangle('Position',initstate,'LineWidth',2,'EdgeColor','b');
%     hold on;
% %     text(5, 18, strcat('#',num2str(i)), 'Color','y', 'FontWeight','bold', 'FontSize',20);
%     text(5, 18, strcat('#',num2str((startID)-i+2)), 'Color','y', 'FontWeight','bold', 'FontSize',20);
%     set(gca,'position',[0 0 1 1]); 
%     pause(0.00001); 
%     hold off;
    
    % ------------save pic  
    if iSave
        frame = getframe(gcf);
        im = frame2im(frame);
        [I,map] = rgb2ind(im,256);
        if ~exist( fullfile(res_path,int2str(cellIdx)), 'dir')
            mkdir( res_path,int2str(cellIdx));
        end        
        imwrite(I,map, fullfile(res_path,int2str(cellIdx), strcat(num2str((startID)-i+2),'.jpg')));
    end    
    
%     %------------------------------Extract samples  
%     posx.sampleImage = sampleImg(img,initstate,trparams.init_postrainrad,0,100000);
%     negx.sampleImage = sampleImg(img,initstate,1.5*trparams.srchwinsz,4+trparams.init_postrainrad,trparams.init_negnumtrain);
%     showSampleImages(img,initstate,posx.sampleImage,negx.sampleImage);
%     
%     %--------------------------------------------------Update all the features 
%     posx.feature = getFtrVal(iH,posx.sampleImage,ftr);
%     negx.feature = getFtrVal(iH,negx.sampleImage,ftr);
%     %--------------------------------------------------
%     [posx.mu,posx.sig,negx.mu,negx.sig] = classiferUpdate(posx,negx,posx.mu,posx.sig,negx.mu,negx.sig,lRate);% update distribution parameters

end


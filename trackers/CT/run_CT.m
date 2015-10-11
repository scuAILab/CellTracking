function [ result ] = run_CT( seq,res_path,iSave )
%RUN_CT Summary of this function goes here

% rand('state',0);
result = [];
initstate = seq.init_rect;
startID = seq.opt.startID;
endID   = seq.opt.endID;
imageNum = seq.opt.imageNum;

% read first image
img = seq.s_frames{1};
img = double(rgb2gray(img));

%----------------------------------------------------------------
trparams.init_negnumtrain = 50;     %number of trained negative samples
trparams.init_postrainrad = 4.0;    %radical scope of positive samples
trparams.initstate = initstate;     % object position [x y width height]
trparams.srchwinsz = 20;            % size of search window
% Sometimes, it affects the results.
%-------------------------
% classifier parameters
clfparams.width = trparams.initstate(3);
clfparams.height= trparams.initstate(4);
%-------------------------
% feature parameters
% number of rectangle from 2 to 4.
ftrparams.minNumRect = 2;
ftrparams.maxNumRect = 4;
%-------------------------
M = 50;% number of all weaker classifiers, i.e,feature pool
%-------------------------
posx.mu = zeros(M,1);% mean of positive features
negx.mu = zeros(M,1);
posx.sig= ones(M,1);% variance of positive features
negx.sig= ones(M,1);
%-------------------------Learning rate parameter
lRate = 0.85;
%-------------------------
%compute feature template
[ftr.px,ftr.py,ftr.pw,ftr.ph,ftr.pwt] = HaarFtr(clfparams,ftrparams,M);
%-------------------------
%compute sample templates
posx.sampleImage = sampleImg(img,initstate,trparams.init_postrainrad,0,100000);
negx.sampleImage = sampleImg(img,initstate,1.5*trparams.srchwinsz,4+trparams.init_postrainrad,50);
%-----------------------------------
%--------Feature extraction
iH = integral(img);%Compute integral image
posx.feature = getFtrVal(iH,posx.sampleImage,ftr);
negx.feature = getFtrVal(iH,negx.sampleImage,ftr);
%--------------------------------------------------
[posx.mu,posx.sig,negx.mu,negx.sig] = classiferUpdate(posx,negx,posx.mu,posx.sig,negx.mu,negx.sig,lRate);% update distribution parameters
%-------------------------------------------------
num = length(seq.s_frames);% number of frames
%--------------------------------------------------------
x = initstate(1);% x axis at the Top left corner
y = initstate(2);
w = initstate(3);% width of the rectangle
h = initstate(4);% height of the rectangle
%--------------------------------------------------------
for i = 2:num
    img = seq.s_frames{i};
    imgSr = img;% imgSr is used for showing tracking results.
    img = double(rgb2gray(img));
    detectx.sampleImage = sampleImg(img,initstate,trparams.srchwinsz,0,100000);   
    iH = integral(img);%Compute integral image
    detectx.feature = getFtrVal(iH,detectx.sampleImage,ftr);
    %------------------------------------
    r = ratioClassifier(posx,negx,detectx);% compute the classifier for all samples
    clf = sum(r);% linearly combine the ratio classifiers in r to the final classifier
    %-------------------------------------
    [c,index] = max(clf);
    %--------------------------------
    x = detectx.sampleImage.sx(index);
    y = detectx.sampleImage.sy(index);
    w = detectx.sampleImage.sw(index);
    h = detectx.sampleImage.sh(index);
    initstate = [x y w h];
    
    %-------------------------------save result 
    result = [result ; initstate];
    
    %-------------------------------Show the tracking results
    imshow(uint8(imgSr));
    rectangle('Position',initstate,'LineWidth',2,'EdgeColor','b');
    hold on;
%     text(5, 18, strcat('#',num2str(i)), 'Color','y', 'FontWeight','bold', 'FontSize',20);
    text(5, 18, strcat('#',num2str((startID)-i+2)), 'Color','y', 'FontWeight','bold', 'FontSize',20);
    set(gca,'position',[0 0 1 1]); 
    pause(0.00001); 
    hold off;
    
    % ------------save pic     
    if iSave
        frame = getframe(gcf);
        im_t = frame2im(frame);
        imwrite(im_t,strcat(res_path,num2str((startID)-i+2),'.jpg'));
    end    
    
    %------------------------------Extract samples  
    posx.sampleImage = sampleImg(img,initstate,trparams.init_postrainrad,0,100000);
    negx.sampleImage = sampleImg(img,initstate,1.5*trparams.srchwinsz,4+trparams.init_postrainrad,trparams.init_negnumtrain);
    %--------------------------------------------------Update all the features 
    posx.feature = getFtrVal(iH,posx.sampleImage,ftr);
    negx.feature = getFtrVal(iH,negx.sampleImage,ftr);
    %--------------------------------------------------
    [posx.mu,posx.sig,negx.mu,negx.sig] = classiferUpdate(posx,negx,posx.mu,posx.sig,negx.mu,negx.sig,lRate);% update distribution parameters
end





end


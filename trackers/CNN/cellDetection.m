function result = cellDetection(net,img,dectx)


imgDim = 28;

% path load and store
opts.expDir = fullfile('data','cellDetection');
opts.numEpochs = 1000 ;
opts.batchSize = 40 ;
opts.conserveMemory = false;
opts.backPropDepth = +inf;
opts.sync = false;
opts.numSubBatches = 1;
opts.prefetch = false;

opts.savePic = true;         % save output to case*/ROI folder
iSMean = true;               % load images and do test
opts.iShow = false;           % show the output images of test

%% 2. Load case data and labels
for i = 1:sampleNum   
       % positive
       im = img( dectx.sampleImage.sy(i):dectx.sampleImage.sy(i)+dectx.sampleImage.sh(i)-1, ... 
           dectx.sampleImage.sx(i):dectx.sampleImage.sx(i)+dectx.sampleImage.sw(i)-1 );
       imdb.images.data(:,:,1,i) = imresize(im,[imgDim,imgDim]);         
       imdb.images.labels(i) = 1;  %positive
     
end















%  Load normailized data,Olny load once
if ~exist('testData','var') || ~exist('fileCell','var')
    [ testData , fileCell] = getImages(testData_path,iSMean);
    [ testMask , ~ ]= getImages(testMask_path,iSMean);
end
%  Load least net params
for epoch = 1:opts.numEpochs
    modelPath = @(ep) fullfile(opts.expDir, sprintf('net-epoch-%d.mat', ep));
    if exist(modelPath(epoch),'file')
        if epoch == opts.numEpochs
            load(modelPath(epoch), 'net', 'info') ;
        end
        continue ;
    end
    if epoch > 1
        fprintf('resuming by loading epoch %d\n', epoch-1) ;
        load(modelPath(epoch-1), 'net', 'info') ;
        break;
    else
        error('Not trained net in Jawbone-baseline Folders');
    end
end

%% 3. Test and saving output 
training = 0 ;
if training, mode = 'training' ; else, mode = 'validation' ; end
one = single(1) ;
res = [] ;
subset = 1:size(testData,4);
numDone = 0 ;
for t=1:opts.batchSize:numel(subset)
  fprintf('%s: batch %3d/%3d ', mode,      fix(t/opts.batchSize)+1, ceil(numel(subset)/opts.batchSize)) ;
  batchSize = min(opts.batchSize, numel(subset) - t + 1) ;
  batchTime = tic ;  
  for s=1:opts.numSubBatches
    % get this image batch and prefetch the next
    batchStart = t + (labindex-1) + (s-1) * numlabs ;
    batchEnd = min(t+opts.batchSize-1, numel(subset)) ;
    batch = subset(batchStart : opts.numSubBatches * numlabs : batchEnd);    
    im = testData(:,:,:,batch);
    im = single(im);
    im = im./255;

    labels = testMask(:,:,:,batch);
    labels =labels./255;

    
    % evaluate CNN
    net.layers{end}.class = labels ;                      % labels in my pro is a mask
    if training, dzdy = one; else, dzdy = [] ; end    
    res = vl_simplenn(net, im, dzdy, res, ...
                          'accumulate', s ~= 1, ...
                          'disableDropout', ~training, ...
                          'conserveMemory', opts.conserve7Memory, ...
                          'backPropDepth', opts.backPropDepth, ...
                          'sync', opts.sync) ;                   
    % show Result
    if opts.iShow
        showResults(res, net.layers(end), numDone,caseID);   
    end
    % save mask to pictures        
    if opts.savePic
        savePic(roi_path,res,fileCell,numDone); 
    end
    numDone = numDone + numel(batch); 
  end
  fprintf(', done:%d\n',numDone);
end









end
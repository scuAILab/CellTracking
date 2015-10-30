function [ net ] = trainCellCNN( imdb,net )
%  first frame train the CNN network
opts.expDir =  fullfile('data','model','cell-baseline') ;
% opts.dataDir = fullfile('data','') ;
% opts.imdbPath = fullfile(opts.expDir, 'imdb.mat');
opts.useBnorm = false ;
opts.train.batchSize = 100 ;
opts.train.numEpochs = 30 ;
opts.train.continue = true ;
opts.train.gpus = [] ;
opts.train.learningRate = 0.001 ;
opts.train.expDir = opts.expDir ;


[net, ~ ] = cnn_train(net, imdb, @getBatch, opts.train) ;

end

% 
function [im, labels] = getBatch(imdb, batch)
% --------------------------------------------------------------------
im = imdb.images.data(:,:,:,batch) ;
labels = imdb.images.labels(1,batch) ;
im = single(im);
end



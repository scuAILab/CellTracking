% p = [px, py, sx, sy, theta]; The location of the target in the first
% frame.
% px and py are th coordinates of the centre of the box
% sx and sy are the size of the box in the x (width) and y (height)
%   dimensions, before rotation
% theta is the rotation angle of the box
%
% 'numsample',1000,   The number of samples used in the condensation
% algorithm/particle filter.  Increasing this will likely improve the
% results, but make the tracker slower.
%
% 'condenssig',0.01,  The standard deviation of the observation likelihood.
%
% 'affsig',[4,4,.02,.02,.005,.001]  These are the standard deviations of
% the dynamics distribution, that is how much we expect the target
% object might move from one frame to the next.  The meaning of each
% number is as follows:
%    affsig(1) = x translation (pixels, mean is 0)
%    affsig(2) = y translation (pixels, mean is 0)
%    affsig(3) = x & y scaling
%    affsig(4) = rotation angle
%    affsig(5) = aspect ratio
%    affsig(6) = skew angle
close all; clc;
dataPath = '/home/jamin/Documents/MATLAB/cell/data/';
title = 'test_';
p = [0 0 0 0 0];
opt = struct('numsample',1000,'affsig',[1,1,0,.000,.000,.000]);     
% The number of previous frames used as positive samples.
opt.maxbasis = 10;
opt.updateThres = 0.8;
% Indicate whether to use GPU in computation.
global useGpu;
useGpu = true;
opt.condenssig = 0.01;
opt.tmplsize = [32, 32];
opt.normalWidth = 320;
opt.normalHeight = 240;


% Load data
disp('Loading data...');
fullPath = [dataPath, title, '/'];
d = dir([fullPath, '*.jpg']);
if size(d, 1) == 0
    d = dir([fullPath, '*.png']);
end
if size(d, 1) == 0
    d = dir([fullPath, '*.bmp']);
end
im = imread([fullPath, d(1).name]);
data = zeros(size(im, 1), size(im, 2), size(d, 1));
% get the track object
figure(2);
h1 = imshow(im);
if p(1) == 0 
    h = imrect();
    position = wait(h);
    p(1:4) = ceil(position);
end
delete h1;

seq.init_rect = [p(1) - p(3) / 2, (p(2) - p(4) / 2), p(3), p(4), p(5)];

seq.s_frames = cell(size(d, 1), 1);
for i = 1 : size(d, 1)
    seq.s_frames{i} = [fullPath, d(i).name];
end
seq.opt = opt;
results = run_DLT(seq, '../result/DLT', true);
save([title '_res'], 'results');
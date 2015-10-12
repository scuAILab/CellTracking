close all;

filename = 'E:\zy\医疗大数据\广州中科院数据\mitosis\osk-8000-B-new_t182c1.TIF';

I = imread(filename);
I = rgb2gray(I);
figure, imshow(I), title('original image');
text(size(I,2),size(I,1)+15, ...
    'Image courtesy of Alan Partin', ...
    'FontSize',7,'HorizontalAlignment','right');
text(size(I,2),size(I,1)+25, ....
    'Johns Hopkins University', ...
    'FontSize',7,'HorizontalAlignment','right');

%% Step 2: Detect Entire Cell  检测细胞
% Two cells are present in this image, but only one cell can be seen in its entirety. We will detect this cell. Another word for object detection is segmentation. The object to be segmented differs greatly in contrast from the background image. Changes in contrast can be detected by operators that calculate the gradient of an image. The gradient image can be calculated and a threshold can be applied to create a binary mask containing the segmented cell. First, we use edge and the Sobel operator to calculate the threshold value. We then tune the threshold value and use edge again to obtain a binary mask that contains the segmented cell.
[~, threshold] = edge(I, 'sobel');
% fudgeFactor = .5;
%-----------------手工设置1.8
% fudgeFactor = 1.8;
fudgeFactor = 2;
BWs = edge(I,'sobel', threshold * fudgeFactor);
figure, imshow(BWs), title('binary gradient mask');

%% Step 3: Dilate the Image 膨胀
% The binary gradient mask shows lines of high contrast in the image. These lines do not quite delineate the outline of the object of interest. Compared to the original image, you can see gaps in the lines surrounding the object in the gradient mask. These linear gaps will disappear if the Sobel image is dilated using linear structuring elements, which we can create with the strel function.
% se90 = strel('line', 3, 90);
% se0 = strel('line', 3, 0);
se90 = strel('line', 4, 90);
se0 = strel('line', 4, 0);

%% 
BWsdil = imdilate(BWs, [se90 se0]);
BWsdil = imdilate(BWsdil, [se90 se0]);
% figure, imshow(BWsdil), title('dilated gradient mask');
figure, imshow(double(BWsdil).*double(I)), title('dilated gradient mask');
imdil = double(BWsdil).*double(I);

%% Step 4: Fill Interior Gaps 填补
BWdfill = imfill(BWsdil, 'holes');
figure, imshow(BWdfill);
title('binary image with filled holes');

%% Step 5: Remove Connected Objects on Border 移除处在边界上的对象
BWnobord = BWdfill;
% BWnobord = imclearborder(BWdfill, 4);
% figure, imshow(BWnobord), title('cleared border image');

%% 显示分割区域
figure, imshow(I), title('original image');
[L, num] = bwlabel(BWdfill);
for i=1:num
    [r c] = find(L==i);  %第一个区域
    rectWidth = max(c) - min(c);
    rectHeight = max(r) - min(r);
    if rectWidth>10 && rectHeight>10
        fprintf('w:%d  h:%d\n', rectWidth, rectHeight);
        rectX = min(c);
        rectY = min(r);
        rectangle('Position', [rectX, rectY, rectWidth, rectHeight],...
            'LineWidth',1, 'edgecolor', 'r');
    end
end

%% Step 6: Smoothen the Object 平滑目标
% seD = strel('diamond',1);
% BWfinal = imerode(BWnobord,seD);
% BWfinal = imerode(BWfinal,seD);
% figure, imshow(BWfinal), title('segmented image');

%% 
% BWoutline = bwperim(BWfinal);
% Segout = I;
% Segout(BWoutline) = 255;
% figure, imshow(Segout), title('outlined original image');

%% 

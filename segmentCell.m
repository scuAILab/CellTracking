<<<<<<< HEAD:SegmentCell.m
function [boundingBoxes, segmentResult] = segmentCell(im)

    I = rgb2gray(im);
=======
function [ segmentResult ] = segmentCell(images)
close all;

filename = 'E:\zy\ҽ�ƴ����\�����п�Ժ���\mitosis\osk-8000-B-new_t182c1.TIF';
>>>>>>> refs/remotes/origin/master:segmentCell.m

    %% Detect Entire Cell 
    % Two cells are present in this image, but only one cell can be seen in its entirety. We will detect this cell. Another word for object detection is segmentation. The object to be segmented differs greatly in contrast from the background image. Changes in contrast can be detected by operators that calculate the gradient of an image. The gradient image can be calculated and a threshold can be applied to create a binary mask containing the segmented cell. First, we use edge and the Sobel operator to calculate the threshold value. We then tune the threshold value and use edge again to obtain a binary mask that contains the segmented cell.
    [~, threshold] = edge(I, 'sobel');
    % fudgeFactor = .5;
    %-----------------set 1.8
    fudgeFactor = 1.8;
    BWs = edge(I,'sobel', threshold * fudgeFactor);
    % figure, imshow(BWs), title('binary gradient mask');

<<<<<<< HEAD:SegmentCell.m
    %% Step 3: Dilate the Image 
    % The binary gradient mask shows lines of high contrast in the image. These lines do not quite delineate the outline of the object of interest. Compared to the original image, you can see gaps in the lines surrounding the object in the gradient mask. These linear gaps will disappear if the Sobel image is dilated using linear structuring elements, which we can create with the strel function.
    % se90 = strel('line', 3, 90);
    % se0 = strel('line', 3, 0);
    se90 = strel('line', 4, 90);
    se0 = strel('line', 4, 0);

    %% 
    BWsdil = imdilate(BWs, [se90 se0]);
    BWsdil = imdilate(BWsdil, [se90 se0]);
    % figure, imshow(BWsdil), title('dilated gradient mask');
%     figure, imshow(double(BWsdil).*double(I)), title('dilated gradient mask');
%     imdil = double(BWsdil).*double(I);

    %% Step 4: Fill Interior Gaps �
    BWdfill = imfill(BWsdil, 'holes');
%     figure, imshow(BWdfill);
%     title('binary image with filled holes');

    %% Step 5: Remove Connected Objects on Border �Ƴ����ڱ߽��ϵĶ���
    BWnobord = BWdfill;
    % BWnobord = imclearborder(BWdfill, 4);
    % figure, imshow(BWnobord), title('cleared border image');

    %% ��ʾ�ָ�����
    figure, imshow(I), title('original image');
    boundingBoxes = regionprops(BWdfill, 'BoundingBox');
    for i=1:numel(boundingBoxes)
        rect = boundingBoxes(i).BoundingBox;
        rectangle('Position', [rect(1), rect(2), rect(3), rect(4)],...
                'LineWidth',1, 'edgecolor', 'r');
    end
    [L, num] = bwlabel(BWdfill);
    for i=1:num
        [r c] = find(L==i);  %��һ������
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
=======
%% Step 2: Detect Entire Cell  ���ϸ��
% Two cells are present in this image, but only one cell can be seen in its entirety. We will detect this cell. Another word for object detection is segmentation. The object to be segmented differs greatly in contrast from the background image. Changes in contrast can be detected by operators that calculate the gradient of an image. The gradient image can be calculated and a threshold can be applied to create a binary mask containing the segmented cell. First, we use edge and the Sobel operator to calculate the threshold value. We then tune the threshold value and use edge again to obtain a binary mask that contains the segmented cell.
[~, threshold] = edge(I, 'sobel');
% fudgeFactor = .5;
%-----------------�ֹ�����1.8
% fudgeFactor = 1.8;
fudgeFactor = 2;
BWs = edge(I,'sobel', threshold * fudgeFactor);
figure, imshow(BWs), title('binary gradient mask');

%% Step 3: Dilate the Image ����
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

%% Step 4: Fill Interior Gaps �
BWdfill = imfill(BWsdil, 'holes');
figure, imshow(BWdfill);
title('binary image with filled holes');

%% Step 5: Remove Connected Objects on Border �Ƴ��ڱ߽��ϵĶ���
BWnobord = BWdfill;
% BWnobord = imclearborder(BWdfill, 4);
% figure, imshow(BWnobord), title('cleared border image');

%% ��ʾ�ָ�����
figure, imshow(I), title('original image');
[L, num] = bwlabel(BWdfill);
for i=1:num
    [r c] = find(L==i);  %��һ������
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

%% Step 6: Smoothen the Object ƽ��Ŀ��
% seD = strel('diamond',1);
% BWfinal = imerode(BWnobord,seD);
% BWfinal = imerode(BWfinal,seD);
% figure, imshow(BWfinal), title('segmented image');
>>>>>>> refs/remotes/origin/master:segmentCell.m

    %% Step 6: Smoothen the Object ƽ��Ŀ��
    % seD = strel('diamond',1);
    % BWfinal = imerode(BWnobord,seD);
    % BWfinal = imerode(BWfinal,seD);
    % figure, imshow(BWfinal), title('segmented image');

    %% 
    % BWoutline = bwperim(BWfinal);
    % Segout = I;
    % Segout(BWoutline) = 255;
    % figure, imshow(Segout), title('outlined original image');
    
    segmentResult = L;
    
%% 

segmentResult = null;
end
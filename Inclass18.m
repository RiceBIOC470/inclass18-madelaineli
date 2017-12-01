% In class 18
%GB comments
1. 100
2. 100
Overall:100


clear all
% Problem 1. In this directory, you will find the same image of yeast cells as you used
% in homework 5. First preprocess the image any way you like - smoothing, edge detection, etc. 
% Then, try to find as many of the cells as you can using the
% imfindcircles routine with appropriate parameters. 
% Display the image with the circles drawn on it. 

img = imread('yeast.tif');
% threshold
mask = img > 66;
figure(1)
imshow(mask)
% background subtraction
img_sm = imfilter(mask, fspecial('gaussian', 4, 2));
img_bg = imopen(img_sm, strel('disk', 100));
figure(2)
img_sm_bgsub = imsubtract(img_sm,img_bg);
imshow(img_sm_bgsub, [])
% edge detection
hx = fspecial('sobel');
hy = hx';
Iy = imfilter(double(img_sm_bgsub),hy,'replicate');
Ix = imfilter(double(img_sm_bgsub),hx,'replicate');
edge_img = sqrt(Ix.^2+Iy.^2);
figure(3)
imshow(edge_img,[])
% find circles
[centers,radii] = imfindcircles(edge_img,[19 30], 'Sensitivity', 0.96);
figure(4)
imshow(img,[]); hold on;
for ii = 1:length(centers)
    drawcircle(centers(ii,:),radii(ii),'m');
end

% Problem 2. (A) Draw two sets of 10 random numbers - one from the integers
% between 1 and 9 and the second from the integers between 1 and 10. Run a
% ttest to see if these are significantly different. (B) Repeat this a few
% times with different sets of random numbers to see if you get the same
% result. (C) Repeat (A) and (B) but this time use 100 numbers in each set
% and then 1000 numbers in each set. Comment on the results. 

% 10 random numbers in each set
A = randi(9,[10,1]);
B = randi(10,[10,1]);
[is_sig,pval] = ttest2(A,B)
% is_sig = 0 --> do not reject null, the two random samples come from
% populations with equal means
for ii = 1:10
    A = randi(9,[10,1]);
    B = randi(10,[10,1]);
    [is_sig(ii),pval(ii)] = ttest2(A,B);
end
ratio_rejected = sum(is_sig)/10
% ratio_rejected = 0.1 --> out of 10 trials, only one of them has two 
% random samples coming from populations with unequal means. 

% 100 random numbers in each set
A_100 = randi(9,[100,1]);
B_100 = randi(10,[100,1]);
[is_sig_100,pval_100] = ttest2(A_100,B_100)
% is_sig_100 = 0 --> do not reject null, the two random samples come from
% populations with equal means
for ii = 1:10
    A_100 = randi(9,[100,1]);
    B_100 = randi(10,[100,1]);
    [is_sig_100(ii),pval_100(ii)] = ttest2(A_100,B_100);
end
ratio_rejected_100 = sum(is_sig_100)/10
% ratio_rejected_100 = 0.1 --> out of 10 trials, only one of them has two 
% random samples coming from populations with unequal means.
% The size of the sample is not large enough to show the difference in the
% population. In other words, in the 100 numbers we choose, we don't have
% enough 10's to distort the mean of the second sample to the statistically
% significant level yet. 

% 1000 random numbers in each set
A_1000 = randi(9,[1000,1]);
B_1000 = randi(10,[1000,1]);
[is_sig_1000,pval_1000] = ttest2(A_1000,B_1000)
% is_sig_1000 = 1 --> reject null, the two random samples do not come from
% popuations with equal means
for ii = 1:10
    A_1000 = randi(9,[1000,1]);
    B_1000 = randi(10,[1000,1]);
    [is_sig_1000(ii),pval_1000(ii)] = ttest2(A_1000,B_1000);
end
ratio_rejected_1000 = sum(is_sig_1000)/10
% ratio_rejected_1000 = 1 --> all of the 10 trials had 2 random samples
% coming from populations with unequal means. 
% With 1000 numbers, we have enough 10's in the second set to get a mean
% that is statistically significantly different from the mean of the first
% set, which does not include any 10's. Thus we have all trials rejecting
% the null hypothesis when we have 1000 numbers. 

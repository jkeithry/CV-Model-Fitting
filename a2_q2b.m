%2RANSAC-based Image Stitching
%Part B question 1
clear('variables','global');
run('c:\vlfeat-0.9.21\toolbox\vl_setup');
rye_left_c = imread('images/Ryerson-left.jpg');
rye_right_c = imread('images/Ryerson-right.jpg');
img_left = rgb2gray(rye_left_c);
img_left = single(img_left);
img_right = rgb2gray(rye_right_c);
img_right = single(img_right);
img_left = imresize(img_left,[2500, 2500]);
img_right = imresize(img_right,[2500, 2500]);

%compute features ,compute distance
disp('Computing features...')
[rye_frame1, rye_desc1] = vl_sift(img_left);
[rye_frame2, rye_desc2] = vl_sift(img_right);
[rye_matches, rye_scores] = vl_ubcmatch(rye_desc1,rye_desc2);

%Ransac vars
prob = 0.99;
rho = 50;
distance_th = 100000;

rye_homography = MyRansac2(distance_th,rho,prob,rye_frame1,rye_frame2,rye_matches,rye_scores,'h');

%stitch
if rye_homography == 0
    1 == 1;
else
    disp('Stitching...')
    MyPano(rye_left_c,rye_right_c,rye_homography,'h');
end




%2RANSAC-based Image Stitching
%Part B question 2
% clear('variables','global');
run('c:\vlfeat-0.9.21\toolbox\vl_setup');
my_left_c = imread('images/car-left.jpg');
my_right_c = imread('images/car-right.jpg');

%pre-process
img_left = rgb2gray(my_left_c);
img_left  = single(img_left);
img_left = imresize(img_left,[2500, 2500]);
img_right = rgb2gray(my_right_c);
img_right  = single(img_right);
img_right = imresize(img_right,[2500, 2500]);

%compute features ,compute distance
% disp('Computing features...');
% [my_frame1, my_desc1] = vl_sift(img_left);
% [my_frame2, my_desc2] = vl_sift(img_right);
% [my_matches, my_scores] = vl_ubcmatch(my_desc1,my_desc2);

%Ransac vars
prob = 0.99;
rho = 7000;
distance_th = 1000;

my_homography = MyRansac2(distance_th,rho,prob,my_frame1,my_frame2,my_matches,my_scores,'h');

%stitch
if my_homography == 0
    1 == 1;
else
    disp('Stitching...')
    MyPano(my_left_c ,my_right_c,my_homography,'h');
end




%2RANSAC-based Image Stitching
run('c:\vlfeat-0.9.21\toolbox\vl_setup')
clear('variables','global');
%Part A
parl_left = imread('images/parliament-left.jpg');
parl_right = imread('images/parliament-right.jpg');

%convert rgb2gray and single
img_left_c = single(parl_left);
img_left = rgb2gray(img_left_c);
img_right_c = single(parl_right);
img_right = rgb2gray(img_right_c);


%resize
img_left = imresize(img_left,[2500, 2500]);
img_right = imresize(img_right,[2500, 2500]);

%compute features, distance
disp('computing features...');
[parl_frame_left, parl_desc1] = vl_sift(img_left);
[parl_frame_right, parl_desc2] = vl_sift(img_right);
[parl_matches, parl_scores] = vl_ubcmatch(parl_desc1,parl_desc2);

%Ransac vars
prob = 0.99;
rho = 0.02;
distance_th = 7000;

affine = MyRansac2(distance_th,rho,prob,parl_frame_left,parl_frame_right,parl_matches,parl_scores,'a');

%stitch
if affine == 0
    1 == 1;
else
    disp('Stitching...')  
    MyPano(img_left_c,img_right_c,affine,'a');
end



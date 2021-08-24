function best_transformation = MyRansac2(DISTANCE_THEASHOLD,RHO,P,frame1, frame2, matches,scores,TYPE)
disp('Performing RANSAC...')
if TYPE == 'a'
    MIN_PTS = 3;
    OUTLIER_PROB = 0.9;
end
if TYPE == 'h'
    MIN_PTS = 4;
    OUTLIER_PROB = 0.7;
end
num_inliers = 0;
max_num_inliers = 0;
%P that at least one sample is not contaminated 
num_samples = round(log(1-P)/log(1-(1-OUTLIER_PROB)^MIN_PTS));

num_matches = size(matches); 
X1 = frame1(1,:);
Y1 = frame1(2,:);

X2 = frame2(1,:);
Y2 = frame2(2,:);

%prune features
d_less_than = scores < DISTANCE_THEASHOLD;

for sample = 1:num_samples          
    rand_nums = randsample(num_matches(2),MIN_PTS); 
    rand_matches = zeros(MIN_PTS,2);
    x = zeros(1, MIN_PTS);
    y = zeros(1, MIN_PTS);
    xp = zeros(1, MIN_PTS);
    yp = zeros(1, MIN_PTS);
    %Step 1 set minimum point set
    %Affine
    for i = 1:MIN_PTS            
        %random matches [im1 match, im2 match]; 6 points         
        rand_matches(i,:) = [matches(1,rand_nums(i)), matches(2,rand_nums(i))]; 
    end
    for j = 1:MIN_PTS
        x(j) = X1(rand_matches(j));
        y(j) = Y1(rand_matches(j));
        xp(j) = X2(rand_matches(j+MIN_PTS));
        yp(j) = Y2(rand_matches(j+MIN_PTS));
    end
    if TYPE == 'a'
        A = zeros(2*MIN_PTS);
        c = 1;
        for k = 1:2:2*MIN_PTS
            A(k:k+1,:) = [ x(c) y(c)  0     0    1   0
                             0     0   x(c) y(c) 0   1];
            c = c + 1;
        end
        b = [ xp(1), yp(1), xp(2), yp(2), xp(3), yp(3) ]';
        %Step 2 find best fitting line/transform
        %get affine
        unknowns = pinv(A)*b;
        rotation = [unknowns(1),unknowns(2);unknowns(3),unknowns(4)];
        translation = [unknowns(5),unknowns(6)]';   
        transformation = [rotation translation]; 
    end
    
    if TYPE == 'h'
        A = zeros(2*MIN_PTS,9);
        c = 1;
%         for k = 1:2:2*MIN_PTS %assuming w = 1
%             A(k:k+1,:) = [ x(c) y(c)  1  0   0   0    -1*xp(c)*x(c)   -1*xp(c)*y(c) -1*xp(c)
%                            0   0   0  x(c) y(c)  1    -1*yp(c)*x(c)   -1*yp(c)*y(c) -1*yp(c)];
%             c = c + 1;
%         end
         A = [ x(1) y(1)  1  0   0   0    -1*xp(1)*x(1)   -1*xp(1)*y(1) -1*xp(1)
                0   0   0  x(1) y(1)  1    -1*yp(1)*x(1)   -1*yp(1)*y(1) -1*yp(1)
                x(2) y(2)  1  0   0   0    -1*xp(2)*x(2)   -1*xp(2)*y(2) -1*xp(2)
                0   0   0  x(2) y(2)  1    -1*yp(2)*x(2)   -1*yp(2)*y(2) -1*yp(2)
                x(3) y(3)  1  0   0   0    -1*xp(3)*x(3)   -1*xp(3)*y(3) -1*xp(3)
                0   0   0  x(3) y(3)  1    -1*yp(3)*x(3)   -1*yp(3)*y(3) -1*yp(3)
                x(4) y(4)  1  0   0   0    -1*xp(4)*x(4)   -1*xp(4)*y(4) -1*xp(4)
                0   0   0  x(4) y(4)  1    -1*yp(4)*x(4)   -1*yp(4)*y(4) -1*yp(4)];

           [~,~,V] = svd(A); 
            X = V(:,end);
            transformation = reshape(X,[3,3]);

    end
   for match = 1:num_matches(2)  
        this_match = matches(:,match);        
        im1_location = [X1(this_match(1)),Y1(this_match(1))]';
        im2_location = [X2(this_match(2)),Y2(this_match(2))]';
        if TYPE == 'a'
            new_im1_location = zeros(2,1);
            new_im1_location(1) =  rotation(1,:)* im1_location  + translation(1);
            new_im1_location(2) =  rotation(2,:)* im1_location  + translation(2);
            eu_distance = norm(im2_location - new_im1_location);
        end
        if TYPE == 'h'
            new_im1_location =  [im1_location; 1]'*transformation ;  
            eu_distance = norm(im2_location - new_im1_location(1:2)/new_im1_location(3));
        end
        
        if d_less_than(match) == 1 
            if eu_distance < RHO
                num_inliers = num_inliers + 1;    
            end
        else
            continue;
        end
    end
    if num_inliers > max_num_inliers        
        max_num_inliers = num_inliers;
        best_transformation = transformation;
    end 
%     fprintf('iteration, %d ',sample);
%     fprintf('number of inliers: %d\n', num_inliers);
    num_inliers = 0;
end

fprintf('====================================');
fprintf('\nAfter %d iteration, %d',num_samples);
fprintf('max number of inliers: %d\n', max_num_inliers);
fprintf('\n RHO: %d', RHO) ;
fprintf('\n DISTANCE_THEASHOLD: %d \n', DISTANCE_THEASHOLD) ;
if max_num_inliers == 0
    fprintf('\nWarning: no transformation estiamte found; returning 0\n ');
    best_transformation = 0;
end
fprintf('====================================\n');
        
        

%%%%1. Least Squares Fitting of a Plane 
%1.1
function estimate =  a2_q1(a,b,g)
x = [1:500]';
y = [1:500]';

z = a*x + b*y + g;
z = z + randn(size(x));

%1.2
estimate = FitPlane(x,y,z);

%1.3
disp("abs error: ")
disp(abs(estimate' - [a,b,g]))




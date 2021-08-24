%CPS843
%Assignment 2
%Jeffrey Keith
%500804619
%March 10th 2021

fprintf('\nCPS843\nAssignment 2\nJeffrey Keith\n500804619\nMarch 23th 2021\n\n');

fprintf('\n==============================Question 1=================================\n');
a = input('Enter value for alpha: ');
b = input('Enter value for beta: ');
g = input('Enter value for gamma: ');
fprintf('\tAlpha\tBeta\tGamma\n');
fprintf('\n');
estimates = a2_q1(a,b,g);
fprintf('estimates: \n');
disp(estimates');
fprintf('Press enter to continue\n\n');
pause;

fprintf('=============================Question 2: Part A=============================\n');
a2_q2;
fprintf('Press enter to continue\n\n');
pause;
fprintf('===========================Question 2: Part B #1===========================\n');
disp('Skipping long process and displaying results...');
rye_fig = openfig('images/rye.fig');
rye_fig;
%a2_q2b;
fprintf('Press enter to continue\n\n');
pause;
fprintf('===========================Question 2: Part B #2===========================\n');
disp('Skipping long process and displaying results...');
my_fig = openfig('images/my.fig');
my_fig;
%a2_q2b2;
fprintf('End of script\n');
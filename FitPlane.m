function abg_estimate = FitPlane(X,Y,z)
%FITPLANE(X,Y,z) where z is the value of the plane 
%returns estimates for parameters alpha, beta, gamma where z = alpha*x + beta*y + gamma
A = [X Y ones(size(X))];

abg_estimate = pinv(A)*z;

%Surpressed Warnings:
% Warning: Matrix is singular to working precision. 
% > In FitPlane (line 6)
% In a2_cps824_q1 (line 28)
% In a2_main (line 8)
%  
% Warning: Rank deficient, rank = 2, tol =  7.177208e-10. 
% > In FitPlane (line 8)
% In a2_cps824_q1 (line 28)
% In a2_main (line 8)
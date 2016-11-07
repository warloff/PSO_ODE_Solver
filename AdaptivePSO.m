function [ OUT,gbesttrace,pbestrace ] = AdaptivePSO()
%% Main Function which governs the PSO process and polynomial regressions
% Function first calls a version of PSO which outputs 250 particles after
% the global best is recognized  to be under 0.003

% The function then randomly chooses 25 particles from the 250 particles
% for use of the second call of PSO

% The second call of PSO uses only 25 particles but allows for the switch
% over to the ODE solver
% 
% This is a form of adaptive PSO which allows for better runtimes
% 
% 
%% Define variables and Obtain experimental Data
% % Define the bounds on the parameters
Bounds = [1e2 1e7; 0.1 100; 1e2 1e7; 0.1 100; 1e2 1e7 ; 0.1 100];
% 
% % Variables for first pso run
Pdef = [500 100000 250 2 1 0.95 0.3 90000 3e-3 2000 0.003 0 0];
% 
% % variables for second pso run
Pdef2 = [500 100000 25 2 1 0.95 0.3 90000 1e-8 2000 NaN 0 1];
gbestval = 1;
% 
load data_6.mat
% 
data.t     = da.Ti.set3(32:53);
data.T     = da.tm.set3(32:53);
data.alpha = da.a.set3(32:53)-0.03;
data.HR = mean(diff(data.T)./diff(data.t));
% 
%% Calculate Polynomial Regression 
p = polyfit(data.T,data.alpha,4);
d = polyval(p,data.T);
dpoly=[p(1)*4, p(2)*3, p(3)*2, p(4)];
DTDXpoly1 = polyval(dpoly,data.T);
% 
% 
% 
%% First PSO call with 250 particles and no switch to ODE solver
% While loop loops until the gbestval hits 0.005
while gbestval > 0.003
    FitnessFunc_nonODE('init', data, DTDXpoly1, Bounds);
    
    %PSO that only outputs the particles 
    [particles,gbestval]=pso_Trelea_vectorized_nonODE('FitnessFunc_nonODE',6,...
            [3e4 4 3e4 4 3e4 4],Bounds,0,Pdef,'goplotpso_b');

    FitnessFunc_nonODE('dest');
    clf
end

%load workspace_gb0-005.mat

%% Randomly choose particles from the 250
% get randomly 25 out of the 250 particles at random without replacement
f = randperm(250,25);
% Choose randomly the particles for which to proceed with
initialpos = [];

% Populate a variable named initialpos with the randomly chosen particles
for i = 1:25
    initialpos(i,:) = particles(f(i),:);
end
    
% Function call with fewer particles, same fitness function but different
%


%% PSO with ODE solver
% Reinitialize persistants
FitnessFunc_ODE('init', data, DTDXpoly1, Bounds);

% PSO call with seed value and 25 particles
[OUT,gbesttrace,pbestrace]=pso_Trelea_vectorized('FitnessFunc_ODE',6,...
        [3e4 4 3e4 4 3e4 4],Bounds,0,Pdef2,'goplotpso_b',initialpos);
% Delete persistants
FitnessFunc_ODE('dest');


end





function [ OUT ] = AdaptivePSO_wrapper()

%% Function Encases the PSO process and simplifies the call from MAIN

%Function calls one run of the program
%clearvars -EXCEPT hundredruns -EXCEPT poolObj
FitnessFunc_nonODE('dest');
FitnessFunc_ODE('dest');



tic

% Call to the PSO function
[ OUT,~,~ ] = AdaptivePSO();

%Clean-up ReactionFitness variables.
FitnessFunc_nonODE('dest');
FitnessFunc_ODE('dest');
clf


end



%Will Arloff 
%Karl Schmitt 

%Solar Research Project Summer 2016

% Script runs the method 100 times to get parameters for each run for
% statistical analysis

clear
clc


%Initialize empty array to be filled with runs
hundredruns = [];


%For loop runs the script 100 times and them keeps the runs
maintime=tic;
delete(gcp('nocreate'))
poolObj=parpool;

for i = 1:100
    hundredruns(i,:) = AdaptivePSO_wrapper; %Calls the function holding comparison script
    %et2=toc(maintime);
    %mymsg=['Trial Run time:',datestr(et2,'HH:MM:SS.FFF')];
    %display(mymsg);
    clf
    clearvars -EXCEPT hundredruns %poolObj maintime
end

delete(poolObj)
save hundredruns
% Optimization Research Fall 2014

% Professor Schmitt
% William Arloff




% Optimization of the differential equation's variables 


% This script will do the following


% Script inputs data in column vectors
% Inputs alpha, time, temperature from the datasets 
% Script then takes a polynomial regression of degree 6 
% Takes the derivitive of the polynomial regression and computes Dt/Dx







% Input Data

clear
clc

% Clears the persitent variables that may have been defined.
%ReactionFitness('dest');
%delete(gcp('nocreate'));
% drivename
% filename = 'C:\Users\warloff\Documents\Valpo\LocalPSO\SFOparameters.txt';
% filedata = DataRetrieve('C:\Users\will arloff\Documents\Valpo\LocalPSO\SFOparameters.txt');
% 

% end





load data_6.mat

data.t     = da.Ti.set3(32:53);
data.T     = da.tm.set3(32:53);
data.alpha = da.a.set3(32:53)-0.03;
data.HR = mean(diff(data.T)./diff(data.t));



% Eag = Eaf = 1568
% Ag = Kof = 3.194e+68
% Ai = A = 1.832e+03
% Eai = Ear = 94
% 
% Calculate Dt/Dx numerically with DiffEq

% c = .999/max(data.alpha);  % Scalar because alpha cant be over 1
% 
% scaledalpha = c.*data.alpha; 

% Calculates DtDx using given DiffEq with temp and alpha from data

% DtDx = diffreactionrate2(alpha,temp,beta,varargin

%DtDxdiffeq = diffreactionrate3(data.alpha,data.T,data.HR...
%    ,'Eag',1568,'Ai',1.832e+03,'Eai',94,'Ag',3.194e+68);

%[1568, 1.832e+03, 94, 3.194e+68, 0.0000001 ,0.000001]

% Calculate Dt/Dx with Polynomial Regression

p = polyfit(data.T,data.alpha,4);
%p = polyfit(data.T./max(data.T),data.alpha,4);
%p = polyfit(data.T,data.alpha,7);
scalars = [1:23]';
d = polyval(p,data.T);
%d = polyval(p,data.T./max(data.T));

scalars = [1:23]';
%dpoly=[p(1)*3, p(2)*2, p(3)];
dpoly=[p(1)*4, p(2)*3, p(3)*2, p(4)];
%dpoly=[p(1)*5, p(2)*4, p(3)*3, p(4)*2, p(5)];
%dpoly=[p(1)*7, p(2)*6, p(3)*5, p(4)*4, p(5)*3, p(6)*2, p(7)];

DTDXpoly1 = polyval(dpoly,data.T);
%DTDXpoly1 = polyval(dpoly,data.T./max(data.T));
%[r2, rmse] = rsquare(DTDXpoly1,DtDxdiffeq);


Bounds = [1e2 1e7; 0.1 100; 1e2 1e7; 0.1 100; 1e2 1e7 ; 0.1 100];
%Bounds = [1 5000; 0.01 45; 1 5000; 0.01 45];
% 
% poolObj=parpool;
% ReactionFitness('init', data, DTDXpoly1, Bounds);
% ReactionFitness_adapt('init', data, DTDXpoly1, Bounds);
% 
% 
% Pdef = [500 100000 250 2 1 0.95 0.3 90000 1e-8 2000 NaN 0 0];
% 
% 
% Pdef2 = [500 100000 250 2 1 0.95 0.3 90000 1e-8 2000 NaN 0 0];
% 
% tic
% 
% 
% 
% [ OUT,gbesttrace,pbestrace ] = PSOadaptive;
% 
% 



   
% 
% %Clean-up ReactionFitness variables.
% ReactionFitness('dest');
% ReactionFitness_adapt('dest');
% delete(poolObj);
% 
% %Call DiffreactionRate w/ optOUT
% disp(OUT)
% 
% DtDxdiffeq = diffreactionrate3(data.alpha,data.T,data.HR, OUT(1:6));
% alpha=ReactionModel_ODEcaller(data.HR,data.T,OUT(1:6));

% figure;
% set(gcf,'Position',[200    200   1000   800]);

whitebg('w')

plot(data.T,data.alpha,'b','DisplayName','Experimental') 
hold on
plot(data.T,d,'r--','DisplayName','Polynomial')

ylabel('\alpha')
xlabel('T(K)')
set(gcf, 'PaperPositionMode', 'auto');


subplot(2,2,2)
% plot(data.T,data.alpha,'b','DisplayName', 'Experimental') 
% hold on
% plot(data.T,alpha,'g:','DisplayName', 'ODE Solution')
% title('Alpha Vs. Temperature, ODE-Solver')
% ylabel('\alpha')
% xlabel('T(K)')
% 
% 
% subplot(2,2,3)
% plot(data.T,d,'r--','DisplayName','Polynomial')
% hold on
% plot(data.T,alpha,'g:','DisplayName','ODE Solution')
% title('Polynomial vs. ODE Solution');
% %title('Reaction Rate Equation (d\alpha/dT) Vs. Temperature')
% ylabel('\alpha')
% xlabel('T(K)')
% 
% subplot(2,2,4)
% plot(data.T,DTDXpoly1,'r--','DisplayName','Polynomial')
% hold on, plot(data.T,DtDxdiffeq,'g:','DisplayName','ODE Solution')
% title('Polynomial vs. Final Parameters in Differential (d\alpha/dT)')
% ylabel('d\alpha/dT')
% xlabel('T(K)')


function [ localRMSE ] = FitnessFunc_ODE2( varargin ) 

% Reaction Fitness is the code that wraps the differential reaction rate %%

% Section defines which parts of the code are defined as persistant
persistent DTDXpoly1 particles RMSE_funct;

%Variables to help speed up computations
persistent T_array Alpha_array HR_send;

%Testing
%persistent myT_array

% If varargin{1}= 'init' ..then setup the persitent variables.
% If varargin{1}= 'dest' ...then delete the persistent variables.

% In should take in a variety of inputs. But also so it can interface with
% the optimizer.
% Sets the persistent variables. 

%Initializer
if strcmp(varargin{1},'init')
    inputdata = varargin{2}; %Data
    
    %Code in explicit variable arrays to speed up computations.
    T_array=inputdata.T; %Temperature array
    Alpha_array = inputdata.alpha; %Alpha Array
    HR_send= inputdata.HR; %Average Temp change/heat (beta).
    DTDXpoly1 = varargin{3}; %regression
    RMSE_funct=1; %On/Off variable for which RMSE generation method to use
    
    
    %T_start=inputdata.T(1); %Start Temperature
    %T_end = inputdata.T(length(inputdata.T)); %End Temperature
    %Bounds = varargin{4};  %Bounds from the Optimizer
    
    return 
end

if strcmp(varargin{1},'dest')
    localRMSE=RMSE_funct;
    clear DTDXpoly1 particles T_array Alpha_array HR_send;
    return
end


% Runs the reaction rate equation 
%Get the number of particles to generate RMSE for. 
[m,~]=size(varargin{1});
localRMSE=ones(m,1);

if isempty(particles)
    particles=m;
    
    for jj=1:m
    DtDxdiffeq = diffreactionrate3(Alpha_array, T_array, HR_send, varargin{1}(jj,:));

    % Calculates the RMS Error of the fit vs the reaction rate equation 
    localRMSE(jj) = rmse(DTDXpoly1,DtDxdiffeq);   
    end
    
    return
end


switch RMSE_funct
    case 0
        
% Empty Slot, RMSE_funct is always 1
        
    case 1

        parray=varargin{1};
        [m_L2,~] = size(parray); 
        %This code will always load a set of positions the ODE solver works
        %on.
        %load 100_positions_ODE.mat
        %parray=tmppos;       
 
        
        %Create local copies of all the arrays on parallel machines.
%         spmd
%             myAlpha_array=Alpha_array;
%             myT_array=T_array;
%             myHR_send=HR_send;
%             myDTDXpoly1=DTDXpoly1;
%         end
%         
%        tic
%         spmd
%             codistr=codistributor1d(1,codistributor1d.unsetPartition,size(parray));
%             my_particles=codistributed(parray,codistr);
%             [m_L, ~]=size(getLocalPart(my_particles));
%             local_particles=getLocalPart(my_particles);
%             myRMSE=ones([codistr.Partition(labindex),1]);%,codistributor());
              myRMSE=ones(m,1);
            for jj=1:m_L2
                
                try
                    
                    %Call ODE solver with parameters to estimate alphas.
                    alpha=ReactionModel_ODEcaller(HR_send, T_array, parray(jj,1:6) );
                                       
                    %Compute the RMSE value for the jj particle.
                    myRMSE(jj)=rmse(Alpha_array,alpha);
   
                catch
                    DtDxdiffeq = diffreactionrate3(Alpha_array, T_array, HR_send, local_parray(jj,1:6));
                    
                    % Calculates the RMS Error of the fit vs the reaction rate equation
                    tstRMSE = rmse(myDTDXpoly1,DtDxdiffeq);
                    
                    myRMSE(jj)=tstRMSE;
                    
                end
                
            end
            
        end
        distRMSE=gather(myRMSE);
        localRMSE=cat(1,distRMSE{[1:size(distRMSE,2)]});
        
 
end

% Check the Gbest RMSE to decide if we should switch fitness functions.




function outLocalRMSE=testparfor(m,Alpha_array,T_array,HR_send,particles, DTDXpoly1)

        outLocalRMSE=ones(m,1)*NaN;

        for jj=1:m
        %for jj=1:m
            DtDxdiffeq = diffreactionrate3(Alpha_array, T_array, HR_send, particles(jj,:));
            
            % Calculates the RMS Error of the fit vs the reaction rate equation
            outLocalRMSE(jj) = rmse(DTDXpoly1,DtDxdiffeq);
        end
        
end











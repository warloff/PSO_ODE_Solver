function [out2]=ReactionModel_ODEcaller(HR_in,T_array,varargin)
%ode_fun must be the handle to a built-in MATLAB ODE-Solver
% Taken out to simplify initial development of code. 

%% Differential equation model, which calls an ODE-Solver

% Used to develop a model of the kinetics of the solar-driven reduction of
% the metal oxides in air and in their re-oxidation using data from the
% thermogravimetric analysis.

%% ===================== READ ME ===============================%
%------------------------------------------------------------%
% varargin only accepts 3 different types of inputs

% 1)  String input  
% - lengths must be either 4, 8 or 12 inputs
%[DaDt] = diffreactionrate3(alpha,T,beta,'Eai',X,'As',Y,...)
% Where 'Eai' = X
% the order of the strings does not matter


% 2)  Vector input
% - A single vector of either length 2, 4, or 6 
%[DaDt] = diffreactionrate3(alpha,T,beta,[vector])
% if length is 2 then program sets Eai and Ai
% if length is 4 then sets Eai, Ai, Eag, Ag
% if length is 6 then sets Eai, Ai, Eag, Ag, Eas, As


% 3)  Scalar input
% - Lengths must be either 2, 4 or 6
% order goes as follows
%[DaDt] = diffreactionrate3(alpha,T,beta,Eai,Ai,Eag,Ag,Eas,As)

%% ======================== Variables ===========================%
 
% The goal of this function is to be ran multiple times by the optimizer
% in order to find values for the six unknowns
% Eag, Ag, Eai, Ai, Eas, As


% Eas is the Activation energy of solid
% Eai is the Initial activation energy
% Eag is the Activaion energy of the gas
% Activation energies range from [0 5000]

% Ai is the initial pre exponential factor 
% As is the pre exponential factor for solid
% Ag is the pre exponentila factor for gas

% Activation energy = E
% pre-exponential factor = A


% Beta is the constant rate of heating of the sample

% error(nargchk(3,15,nargin)); %#ok<NCHKN> %Error message if varargin is out of bounds 

%% Variable Inputs

%R = 0.00831446;  % Universal gas constant
R=8.31445;
%ode_opt=odeset('AbsTol', 1e-3);



if (ischar(varargin{1})) && (~ischar(varargin{2})) % checks if first value is a string
    varlen = length(varargin); % variable varlen holds the length of varargin
    if (varlen == 4) ||(varlen == 8) ||(varlen == 12); %  length must be 4,8 or 12
    % loop through the length and set variables based on string values
    % variable is set to value of string before it
        for i = 1:varlen ;

            switch varargin{i} % switch and case sets the variables
                case 'Eai' 
                    Eai=varargin{i+1};
                case 'Ai'
                    Ai=varargin{i+1};
                case 'Eag'
                    Eag=varargin{i+1};
                case 'Ag'
                    Ag=varargin{i+1};
                case 'Eas'
                    Eas=varargin{i+1};
                case 'As'
                    As=varargin{i+1};
            end
        end
    else
        % Gives error if length of varargin is anything other than 4 8 or
        % 12
        error('Data structure not supported please read guidelines')
    end
    
elseif isscalar(varargin{1}) % if first arguement of varargin is a scalar
% then lengths must be 2 4 or 6 in order to set varargin to variables    
    varlen = length(varargin);
    
    switch varlen % if length varargin is 2 set Eai and Ai
        case 2;    
            Eai = varargin{1};
            Ai = varargin{2};
        case 4; % if length varargin is 4 set Eai, Ai, Eag, and Ag
            Eai = varargin{1};
            Ai = varargin{2};
            Eag = varargin{3};
            Ag = varargin{4};
        case 6; % if length varargin is 6 set all the variable
            Eai = varargin{1}; %Ear
            Ai = varargin{2};  %A
            Eag = varargin{3}; %Eaf
            Ag = varargin{4};  %kfo
            Eas = varargin{5}; %Eaa
            As = varargin{6};  %Do
        otherwise % if length is anything other than 2,4 or 6 send error message
            error('Data structure not supported please read guidelines')
    end
elseif (~isempty(varargin{1}) && ~ischar(varargin{1}) ); % Check if the input is a vector

    vect=varargin{1};
    
    switch length(vect)
        case 2;   % Check if length of vector is 2
            Eai = vect(1);  % set variables Eai and Ai to vector
            Ai = vect(2);
        case 4; % Check if length of vector is 4
            Eai = vect(1); % set variables Eai, Ai, Eag, Ag 
            Ai = vect(2);
            Eag = vect(3);
            Ag = vect(4);
        case 6; % Check if length of vector is 6
            Eai = vect(1); % Define all the variables 
            Ai = vect(2);
            Eag = vect(3);
            Ag = vect(4);
            Eas = vect(5);
            As = vect(6);
        otherwise 
        % if not correct length send error message
            error('Data structure not supported please read guidelines')
    end   
else
    error('Data structure not supported please read guidelines')
end

model_call_counter=0;

[~, out2]=ode23s(@model_call, T_array,0);


    function [DaDt]=model_call(T,alpha)
        %t is time, or for reaction, temperature
        %y is alpha for reaction.
   
        %This counts how many times this function has been called within
        %the current call to ReactionModel_ODEcaller. It'll throw an
        %error when we exceed 2500
        %
        % IMPORTANT NOTE: -- This is just a guess, based on code profiling
        % of a cap for calls to the model. Different data, models, or
        % ODE-solvers might need a different cap. 
        if model_call_counter < 2500
            model_call_counter=model_call_counter+1;
        else
            %display('Hit call error');
            error('To many calls to model, probably stuck in ODEsolver.')
        end
        
        if exist('Ag','var') && exist('Eag','var') && Ag~=0 % Eas, As are the variables in the first part of the equation
            k_g=(10.^Ag).*exp((-1*(Eag))./(R.*T));
            A = 1./(k_g); % First segment of the diffeq is set to A
        else
            A = 0; % segment of diffeq is set to zero to avoid division by zero
        end
        
        if exist('As','var') && exist('Eas','var') && As~=0 % Eas, As are the variables in the second set of the equation
            k_s=(10.^As).*exp((-1*(Eas))./(R.*T));
            k_s_pre= 2./k_s;
            B = k_s_pre .* ( (1-alpha).^(-1/3)-1); % Second segment to the diffeq is set to B
        else
            B = 0; % Segment of code is set to zero
        end
        
        if exist('Ai','var') && exist('Eai','var') && Ai~=0 % Ai and Eai are the variables in the third part of the equation
            k_i=(10.^Ai).*exp((-1*(Eai))./(R.*T));
            C = ((1-alpha).^(-2/3))./(3.*k_i); % Third segment is set equal to C
        else
            C = 0; % Segment of code is set to zero
        end
        
        DaDt = (1/HR_in).*((A+B+C).^(-1));  % Final calculation including the values for each segment
        
    end

end

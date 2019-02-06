%%
% The following work is the original creation of Russell Jeter, PhD at Emory
% University 2018-2019. It is licensed and shared under a Creative Commons 
% Attribution-NonCommercial-ShareAlike 4.0 International License. This means
% reproduction of the work is allowed provided that it is for non-commercial
%applications and the creating authors are cited.
%
%% Discrete Action to Continuous Action
% Inputs:   discrete_action:  Integer representing one of the 25 unique
%                             actions
%                    
%
% Outputs:  continuous_action: Continuous version of the discrete action
%                     
%
% This function maps each discrete action to a continuous action based on
% the median value of the continuous actions for each discrete action.
%
%% discrete_action_to_continuous implementation

function continuous_action = discrete_action_to_continuous(discrete_action)

%Levels computed as the median value for each continuous action in the corresponding
%discrete action space.
pressor_levels = [0, 0.04, 0.10,  0.15,  0.30];
fluid_levels   = [0, 16,   46.23, 88.71, 223.96];


pressor_dose = pressor_levels(floor((discrete_action - 1)/5) + 1);

fluid_action_indices = mod(discrete_action, 5);
fluid_action_indices(fluid_action_indices == 0) = 5;
fluid_dose = fluid_levels(fluid_action_indices);
continuous_action = [pressor_dose; fluid_dose];

end
%%
% The following work is the original creation of Russell Jeter, PhD at Emory
% University 2018-2019. It is licensed and shared under a Creative Commons 
% Attribution-NonCommercial-ShareAlike 4.0 International License. This means
% reproduction of the work is allowed provided that it is for non-commercial
%applications and the creating authors are cited.
%
%% Add AI Actions
% Inputs:   data_set:  Patient data set, primarily needed for just the
%                      discrete trajectory
%
%           ai_policy: Vector describing AI dosing suggests for each state.
%                    
%
% Outputs:  data_set: The input dataset with the recommended AI actions 
%                     (discrete and continuous at each time point
%
% This function takes in a data set and the ai policy and adds the
% recommended ai actions for each time point to the data set.  The
% continuous actions are computed using the median values of the real
% clinician dosing recommendations in each discrete dose action bin.
%% create_policy implementation.
function data_set = add_ai_actions(data_set, ai_policy)
    
N = length(data_set);
    
    parfor i = 1 : N
        
        patient    = data_set{i};
        trajectory = patient.discrete_trajectory;
        num_steps  = length(trajectory);
        ai_actions = zeros(num_steps, 1);
        
        for j = 1 : num_steps
        
            ai_actions(j) = ai_policy(trajectory(j));
        end
        
        patient.ai_actions            = ai_actions;
        patient.continuous_actions_ai = discrete_action_to_continuous(patient.ai_actions)';
        
        data_set{i} = patient;
    end

end
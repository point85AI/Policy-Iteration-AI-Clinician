%%
% The following work is the original creation of Russell Jeter, PhD at Emory
% University 2018-2019. It is licensed and shared under a Creative Commons 
% Attribution-NonCommercial-ShareAlike 4.0 International License. This means
% reproduction of the work is allowed provided that it is for non-commercial
%applications and the creating authors are cited.
%
%% Create Clinician Policy Description
% Inputs:   states:   Vector of the discrete patient states.
%
%           actions:  Vector of the real clinical actions (after
%                     discretization) corresponding to the discrete patient
%                     states.
%                              
%
% Outputs:  clinician_policy:  K x |A| matrix (where |A| is the number of
%                              actions) giving the probability that given 
%                              state i, the clinician will choose action j.
%
% This function takes the vectors of states and their corresponding
% clinician actions and creates the clinician dosing policy by empirically
% counting the number of times a clinician used a given action for a given
% state in the cohort.

%% create_policy implementation.
function clinician_policy = create_clinician_policy(states, actions)

num_states  = max(states);
num_actions = max(actions);

%Initialize the clinician policy matrix.
clinician_policy = zeros(num_states, num_actions);

%Count the instances of action j in state i.
for i = 1:length(states)
    
    state  = states(i);
    action = actions(i);
    
    clinician_policy(state, action) = clinician_policy(state, action) + 1;
end

%Convert empirical counts to observed probabilities.
for i = 1 : num_states
    
    clinician_policy(i, :) = (1 / sum(clinician_policy(i, :))) * clinician_policy(i, :);
end

end

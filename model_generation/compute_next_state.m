%%
% The following work is the original creation of Russell Jeter, PhD at Emory
% University 2018-2019. It is licensed and shared under a Creative Commons 
% Attribution-NonCommercial-ShareAlike 4.0 International License. This means
% reproduction of the work is allowed provided that it is for non-commercial
%applications and the creating authors are cited.
%
%% Create Clinician Policy Description
% Inputs:   transition_matrix: The empirically derived transition matrix
%                              that gives the probabilities of 
%                              transitioning between states.
%            
%           current_state:     Integer representing a patient's current
%                              state.
%
%           action:            Integer representing the policy's
%                              recommended action.
%                              
%
% Outputs:  next_state: Integer representing the next patient state given
%                       the current state and the choice of action.
%
%
% This function takes in the transition matrix, current patient state, and
% recommended action and returns the next patient state.


function next_state = compute_next_state(transition_matrix, current_state, action)

num_states         = length(transition_matrix(1,:,1));
probability_vector = transition_matrix(current_state, :, action);

possible_states = 1 : num_states;

next_state = randsrc(1, 1, [possible_states; probability_vector]);

end
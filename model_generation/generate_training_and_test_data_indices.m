%%
% The following work is the original creation of Russell Jeter, PhD at Emory
% University 2018-2019. It is licensed and shared under a Creative Commons 
% Attribution-NonCommercial-ShareAlike 4.0 International License. This means
% reproduction of the work is allowed provided that it is for non-commercial
%applications and the creating authors are cited.
%
%% Generate Training and Test Data Indices Description
% Inputs:   normalized_data:      All patient data after normalization.
%
%           training_proportion:  Proportion of the data the user wants to
%                                 be used for training (the rest will be 
%                                 used in the test set).
%                              
%
% Outputs:  test_set_states:  The corresponding states for the first patient
%                             time point in the test set data generated 
%                             using the centroids that correspond to the 
%                             K states in the environment.

% This function takes in the normalized data and the proportion of the 
% normalized data the user wants to use for thier training set and returns 
% the corresponding indices for the training and test data sets.


%% generate_training_and_test_data_indices

function [training_set_indices, test_set_indices] = ...
    generate_training_and_test_data_indices(normalized_data, ...
                                            training_proportion)

if training_proportion >= 1.0 || training_proportion <= 0
    error('Your training proportion is not valid.')
end

N            = length(normalized_data);
num_training = round(N * training_proportion);

training_set_indices = randperm(N, num_training);
indices              = 1 : N;
test_set_indices     = indices(~ismember(indices, training_set_indices));

end

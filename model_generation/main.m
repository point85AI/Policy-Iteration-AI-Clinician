%%
% The following work is the original creation of Russell Jeter, PhD at Emory
% University 2018-2019. It is licensed and shared under a Creative Commons 
% Attribution-NonCommercial-ShareAlike 4.0 International License. This means
% reproduction of the work is allowed provided that it is for non-commercial
%applications and the creating authors are cited.
%
%% Generate Models Description
% 
% This is the main file that needs to be run to generate the 500 models
% used in our analysis.  It starts by importing the normalized data, then
% for each model, it constructs the environment and determines the
% corresponding AI and clinician policies.  It then saves all 500 models
% for future analysis.
%
% CAUTION:  THIS SCRIPT CAN BE QUITE COMPUTATIONALLY EXPENSIVE.  WE HAVE
% PROVIDED .mat FILES FOR 500 MODELS WITH THIS CODE TO ASSIST THE READER IN
% THEIR OWN ANALYSIS.

load('../data/normalized_data.mat');

%This script determines the optimal number of clusters.
%script_find_optimal_number_of_clusters();

K = 10;
%Found using the CalinskiHarabasz Criterion for evaluating the optimal
%number of clusters.  The criterion finds the maximum of the ratio of the
%between cluster variance over the within cluster variance.

num_actions         = 25;
gamma               = 0.99;
training_proportion = 0.8;

num_models = 500;

best_V_WIS  = 0;
V_WIS       = zeros(num_models, 1);
V_Clinician = zeros(num_models, 1);

models = repmat({struct('model_number',[])}, num_models, 1);

parfor i = 1 : num_models
    
    %Grab and empty model from the list and generate its test and training
    %data sets.
    model = models{i};
    model.model_number = i;
    disp(['Creating model ' num2str(i)]);
    [model.training_set_indices, model.test_set_indices] = generate_training_and_test_data_indices(normalized_data, training_proportion);
    
    %From the model's test and training sets, generate the corresponding
    %clinical environment.
    [clusters, model.centroids, model.transition_matrix, reward, actions] = generate_environment(normalized_data(model.training_set_indices), K);
    
    %From the model's environment, construct the clinician and AI policies
    model.policy = create_policy(reward, num_actions, model.transition_matrix, gamma);
    model.clinician_policy = create_clinician_policy(clusters, actions);
    
    %States from the test set to compute the estimated return values for
    %the policy.
    test_set_states = generate_test_set_states(normalized_data(model.test_set_indices), model.centroids);
    
    %Compute the estimated return values computed using importance
    %sampling.  We the average V_WIS over 10 trials (each V_WIS is itself
    %computed from 10000 resamples.
    V_clinician_vector = zeros(1, 10);
    V_WIS_vector       = zeros(1, 10);
    
    for j = 1 : 10
        
        [V_clinician_vector(j), V_WIS_vector(j)] = ...
            return_estimated_values(test_set_states, model.transition_matrix,...
                                    gamma, reward, model.policy, ...
                                    model.clinician_policy);
    end
    
    model.V_WIS       = mean(V_WIS_vector);
    model.V_clinician = mean(V_clinician_vector);
    
    disp(['The expected agent reward for model ' num2str(i) ' is ' num2str(model.V_WIS)])
    disp(['The expected clinician reward for model ' num2str(i) ' is ' num2str(model.V_clinician)])
    
    models{i} = model;
end
disp('Saving models');
save('../data/models.mat', 'models', '-v7.3')
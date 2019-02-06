%%
% The following work is the original creation of Russell Jeter, PhD at Emory
% University 2018-2019. It is licensed and shared under a Creative Commons 
% Attribution-NonCommercial-ShareAlike 4.0 International License. This means
% reproduction of the work is allowed provided that it is for non-commercial
%applications and the creating authors are cited.
%
%% Run Analysis
%
% This script compares all of the generated models, isolates the best model,
% and shows how the ai actions for this model compare with the real 
% clinical actions.
%
%% model_value_comparison implementation

load('../data/models.mat');

disp('Generating the model comparison box plots.')
model_value_comparison(models)
disp('Isolating the best model.')
best_model = get_best_model(models);
best_model = add_normalized_data_to_model(best_model);
best_model = add_policy_information_to_model(best_model);
disp('Plotting the AI dosing recommendations for the best model.')
plot_ai_actions(best_model);
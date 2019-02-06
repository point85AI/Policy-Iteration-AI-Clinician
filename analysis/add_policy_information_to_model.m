%%
% The following work is the original creation of Russell Jeter, PhD at Emory
% University 2018-2019. It is licensed and shared under a Creative Commons 
% Attribution-NonCommercial-ShareAlike 4.0 International License. This means
% reproduction of the work is allowed provided that it is for non-commercial
%applications and the creating authors are cited.
%
%% Add Policy Information 
% Inputs:   model:  Policy model with environment, ai, and clinician
%                   policies.
%                    
%
% Outputs:  model: The input model with discrete patient trajectories and 
%                  ai actions added.
%                     
%
% This function adds the ai recommendations and discrete patient
% trajectories to a model.
%
%% add_policy_information_to_model implementation
function model = add_policy_information_to_model(model)

%Add discrete trajectories to the test and training sets for the model.
model.test_set     = add_discrete_trajectories(model.test_set,...
                                                    model.centroids);
model.training_set = add_discrete_trajectories(model.training_set,...
                                                    model.centroids);
%Add the ai action recommendations to the test and training sets for the model.
model.test_set     = add_ai_actions(model.test_set, model.policy);
model.training_set = add_ai_actions(model.training_set, model.policy);

end
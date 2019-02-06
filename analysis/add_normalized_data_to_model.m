%%
% The following work is the original creation of Russell Jeter, PhD at Emory
% University 2018-2019. It is licensed and shared under a Creative Commons 
% Attribution-NonCommercial-ShareAlike 4.0 International License. This means
% reproduction of the work is allowed provided that it is for non-commercial
%applications and the creating authors are cited.
%
%% Add Normalized Data to Model
% Inputs:   model:  Policy model with environment, ai, and clinician
%                   policies.
%                    
%
% Outputs:  model: The input model with normalized patient data added.
%                     
%
% This function adds the normalized patient data to a model.
%
%% add_normalized_data_to_model implementation

function model = add_normalized_data_to_model(model)

load('../data/normalized_data.mat', 'normalized_data');

test_indices     = model.test_set_indices;
training_indices = model.training_set_indices;

N        = length(test_indices);
test_set = repmat({struct('icuid',[])}, N, 1);

for i = 1 : N
    
    index       = test_indices(i);
    test_set{i} = normalized_data{index};
    
end

N            = length(training_indices);
training_set = repmat({struct('icuid',[])}, N, 1);

for i = 1 : N
    
    index           = training_indices(i);
    training_set{i} = normalized_data{index};
    
end

model.test_set     = test_set;
model.training_set = training_set;
end
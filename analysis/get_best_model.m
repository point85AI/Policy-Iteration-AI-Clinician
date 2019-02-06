%%
% The following work is the original creation of Russell Jeter, PhD at Emory
% University 2018-2019. It is licensed and shared under a Creative Commons 
% Attribution-NonCommercial-ShareAlike 4.0 International License. This means
% reproduction of the work is allowed provided that it is for non-commercial
%applications and the creating authors are cited.
%
%% Get Best Model
% Inputs:   models:  All policy models generated from the generate_models 
%                    script.
%
% Outputs:  best_model: The model with the highest clinician value
%                     
%
% This function returns the model with the highest ai clinician value.
%
%% get_best_model implementation
function best_model = get_best_model(models)

N = length(models);

best_V_WIS = 0;

for i = 1 : N
    
    model = models{i};
    
    if model.V_WIS > best_V_WIS
        
        best_model = model;
        best_V_WIS = best_model.V_WIS;
    end
end

end
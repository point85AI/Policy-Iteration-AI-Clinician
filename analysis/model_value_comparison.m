%%
% The following work is the original creation of Russell Jeter, PhD at Emory
% University 2018-2019. It is licensed and shared under a Creative Commons 
% Attribution-NonCommercial-ShareAlike 4.0 International License. This means
% reproduction of the work is allowed provided that it is for non-commercial
%applications and the creating authors are cited.
%
%% Model Value Comparison
% Inputs:   models:  All policy models generated from the generate_models 
%                    script.
%
% This function generates the boxplot comparing the expected policy values 
% for all of the clinicians and all of the ai clinicians.
%
%% model_value_comparison implementation

function model_value_comparison(models)

num_models = length(models);

clinician_value  = zeros(num_models, 1);
ai_value         = zeros(num_models, 1);

for i = 1 : num_models
    
    model = models(i);
    model = model{1};
    
    clinician_value(i)  = model.V_clinician;
    ai_value(i)         = model.V_WIS;
end


group = [ones(size(clinician_value)); 2*ones(size(ai_value))];
f = figure('visible', 'off');

set(f, 'Position', [0, 0, 1000, 800])
set(gca, 'fontsize', 30)

h = boxplot([clinician_value, ai_value], group, 'width', .75);

ylabel('Expected Policy Value')
set(gca, 'XTickLabel', {'Clinician Policy', 'AI Policy'});
set(h, 'LineWidth', 2)
set(gca, 'fontsize', 30)

print('./Figures/expected_policy_value.png', '-dpng')
end
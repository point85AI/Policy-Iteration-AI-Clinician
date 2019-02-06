%%
% The following work is the original creation of Russell Jeter, PhD at Emory
% University 2018-2019. It is licensed and shared under a Creative Commons 
% Attribution-NonCommercial-ShareAlike 4.0 International License. This means
% reproduction of the work is allowed provided that it is for non-commercial
%applications and the creating authors are cited.
%
%% Generate Test Set States Description
% Inputs:   test_set:   Cell array of the raw test set data.
%
%           centroids:  Vector of the centroids that represent the
%                       discretization of the patient state space.
%                              
%
% Outputs:  test_set_states:  The corresponding states for the first patient
%                             time point in the test set data generated 
%                             using the centroids that correspond to the 
%                             K states in the environment.

% This function takes in the raw test set data and a vector of the state 
% centroids created when the environment was generated.  It then returns 
% the corresponding states for the first hour of patient data.


%% generate_test_set_states

function test_set_states = generate_test_set_states(test_set, centroids)

%Create the cell array that will store the raw patient data.
N                       = length(test_set);
trajectories_normalized = cell(N, 1);

for i = 1 : N
    
    trajectories_normalized{i} = test_set{i}.trajectory(1, :);
end

trajectories_normalized = cell2mat(trajectories_normalized);

K               = length(centroids(:, 1));
test_set_states = zeros(N, 1);

%Assign the data to the centroid that minimizes the distance from the data
%point to the centroid.
parfor i = 1 : N
    
    for j = 1 : K
        
        if j == 1
        
            test_set_states(i) = j;
            min_distance = norm(centroids(j, :) - trajectories_normalized(i, :));
        else
            
            current_distance = norm(centroids(j, :) - trajectories_normalized(i, :));
            
            if current_distance < min_distance
            
                min_distance = current_distance;
                test_set_states(i) = j;
            end
        end
    end
end

end
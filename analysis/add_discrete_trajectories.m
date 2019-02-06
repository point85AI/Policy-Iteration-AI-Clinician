%%
% The following work is the original creation of Russell Jeter, PhD at Emory
% University 2018-2019. It is licensed and shared under a Creative Commons 
% Attribution-NonCommercial-ShareAlike 4.0 International License. This means
% reproduction of the work is allowed provided that it is for non-commercial
%applications and the creating authors are cited.
%
%% Add Discrete Trajectories
% Inputs:   data_set:  Patient data set, primarily needed for just the
%                      discrete trajectory
%
%           centroids: Matrix of the centroids for the K states that 
%                      define the environment.
%                    
%
% Outputs:  data_set: The input dataset with the discrete trajectories added.
%                     
%
% This function takes in a data set and the environment centroids and adds the
% discretization of a patient trajectory to the data set.
%
%% add_discrete_trajectories implementation
function data_set = add_discrete_trajectories(data_set, centroids)


N  = length(data_set);
K  = length(centroids(:, 1));

for i = 1 : N
    
    patient = data_set{i};
    num_points = length(patient.trajectory(:, 1));
    patient.discrete_trajectory = zeros(num_points, 1);
    
    for k = 1 : num_points
    
        for j = 1 : K
            
            if j == 1
        
                state = j;
                min_distance = norm(centroids(j, :) - patient.trajectory(k, :));
            else
                
                current_distance = norm(centroids(j, :) - patient.trajectory(k, :));
                if current_distance < min_distance
                
                    min_distance = current_distance;
                    state = j;
                end
            end
        end
        
        patient.discrete_trajectory(k) = state;
    end
    
    data_set{i} = patient;
end

end
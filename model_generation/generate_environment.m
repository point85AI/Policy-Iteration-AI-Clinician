%%
% The following work is the original creation of Russell Jeter, PhD at Emory
% University 2018-2019. It is licensed and shared under a Creative Commons 
% Attribution-NonCommercial-ShareAlike 4.0 International License. This means
% reproduction of the work is allowed provided that it is for non-commercial
%applications and the creating authors are cited.
%
%% Generate Environment Description
% Inputs:   training_set: The normalized patient data for the training set
%           
%           K:            The optimal number of clusters for the
%                         normalized patient data.
%
% Outputs:  clusters:          Cluster membership of each patient data
%                              point
%
%           centroids:         Locations of the centroids after K means is
%                              performed
%
%           transition_matrix: The empirically derived transition matrix
%                              that gives the probabilities of 
%                              transitioning between states.
%
%           reward:            Vector of patient rewards.
%
%           actions:           Vector of discrete actions taken by the real
%                              clinicians.
%
% This function takes in the training set and the number of clusters K that
% is optimal for this dataset.
% It uses the K means clustering algorithm to generate the state summaries
% for all of the patient data at a given point.  

%% generate_environment implementation.

function [clusters, centroids, transition_matrix, reward, actions] = generate_environment(training_set, K)

%Initialize a cell for all trajectories and clinician actions, then fill
%those cells with the appropriate values from the training set.
N                       = length(training_set);
trajectories_normalized = cell(N, 1);
actions                 = cell(N, 1);

parfor i = 1 : N
    
    trajectories_normalized{i} = training_set{i}.trajectory;
    actions{i} = training_set{i}.actions;
end

trajectories_normalized = cell2mat(trajectories_normalized);
actions                 = cell2mat(actions);

%% Cluster the normalized patient data.
[clusters, centroids] = kmeans(trajectories_normalized, K);

%% Empirically construct the transition matrix.
%To construct the transition matrix properly, we iterate over each
%patient's trajectory and count the transitions between the states we have
%already created.  We have to iterate through each patient to ensure we
%don't falsely count transitions from the final state of one patient to the
%initial state of another.

%num_states is used to store the number of states for each patient in the
%training set.
num_states = zeros(N, 1);
num_actions = 25;

parfor i = 1 : N
    
    num_states(i) = training_set{i}.num_observations;
end

%Initialize the variables used for creating the transition matrix.
total_num_time_points = length(trajectories_normalized);
patient_index         = 1;
index                 = 1;
hour_index            = 1;
transition_matrix     = zeros(K + 2, K + 2, num_actions);
patient               = 0;

while index < total_num_time_points
    
    num_hours  = num_states(patient_index);
    hour_index = 1;
    
    while hour_index < num_hours
        
        if(index + 1 > total_num_time_points)
        
            break
        end
        
        i      = clusters(index);
        j      = clusters(index + 1);
        action = actions(index);
        
        transition_matrix(i, j, action) = transition_matrix(i, j, action) + 1;
        
        hour_index = hour_index + 1;
        index      = index + 1;
    end
    
    i = clusters(index);
    
    if (training_set{patient_index}.mortality == 1)
        
        j       = K + 2;
        patient = patient + 1;
    else
        
        j       = K + 1;
        patient = patient + 1;
    end
    
    transition_matrix(i, j, :) = transition_matrix(i, j, :) + 1;
    
    patient_index = patient_index + 1;
    index         = index + 1;
    
end

parfor i = 1 : K
    
    for k = 1 : num_actions
    
        transition_matrix(i, :, k) = transition_matrix(i, :, k) / sum(transition_matrix(i, :, k));
    end
end

%% Define the reward vector 
%The reward vector is zero everywhere except the two terminal states, 
%which correspond to mortality and survival.  A reward of 1 is given for
%survival, and -1 for expiration.

reward = zeros(K + 2, 1);
reward(K + 1) = 1;
reward(K + 2) = -1;
end

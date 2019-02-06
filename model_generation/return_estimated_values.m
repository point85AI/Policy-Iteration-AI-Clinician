%%
% The following work is the original creation of Russell Jeter, PhD at Emory
% University 2018-2019. It is licensed and shared under a Creative Commons 
% Attribution-NonCommercial-ShareAlike 4.0 International License. This means
% reproduction of the work is allowed provided that it is for non-commercial
%applications and the creating authors are cited.
%
%% Create Clinician Policy Description
% Inputs:   test_set_states:   The corresponding states for the first patient
%                              time point in the test set data generated 
%                              using the centroids that corre
%
%           transition_matrix: The empirically derived transition matrix
%                              that gives the probabilities of 
%                              transitioning between states.
%            
%           gamma:             Reward decay rate.
%
%           reward:            Vector of patient rewards.
%           
%           policy:            AI's recommended action to take for each state.
%            
%           clinician_policy:  K x |A| matrix (where |A| is the number of
%                              actions) giving the probability that given 
%                              state i, the clinician will choose action j.
%                              
%
% Outputs:  V_clinician: Clinician's expected value 

%           V_WIS:       The importance sampling weighted expected value
%                        for the AI Clinician.
%
% This function takes in the environment (by virtue of the transition matrix
% and test set states), the policies (ai and clinician), reward, and reward 
% decay rate.  It uses these to compute the expected value of the clinician
% and AI policies.  The clinician's policy is computed using the temporal
% difference method, and the AI value is computed using importance sampling
% to weigh different action choices.  This works by iterating through the
% environment using the clinician policy, and assigning higher weights to
% trajectories in which the AI clinician's and the real clinician's
% policies matched.


%% create_policy implementation.

function [V_clinician, V_WIS] = return_estimated_values(test_set_states, transition_matrix, gamma, reward, policy, clinician_policy)

num_trials  = 10000;
max_steps   = 1000;
K           = length(clinician_policy(:, 1));
num_actions = length(clinician_policy);

%Initialize the set of trials that we will store all of the trial data in.
trials = repmat({struct('trial_number',[])}, num_trials, 1);

parfor i = 1 : num_trials
    
    trial                   = trials{i};
    trial.trial_number      = i;
    trial.clinician_states  = zeros(max_steps, 1);
    trial.clinician_actions = zeros(max_steps, 1);
    trial.clinician_rewards = zeros(max_steps, 1);
    trial.rho               = zeros(max_steps, 1);
    trials{i}               = trial;
end

%Iterate through a patient's trajectory using the clinician policy.
parfor i = 1 : num_trials

    trial         = trials{i};
    initial_state = test_set_states(randperm(size(test_set_states, 1), 1));
    state         = initial_state;
    trial_reward  = 0;
    num_steps     = 1;
    
    while trial_reward == 0 && num_steps < max_steps
        
        trial.clinician_states(num_steps) = state;
        
        action                             = randsample(1:num_actions, 1, ...
                                                true, clinician_policy(state,:));
        trial.clinician_actions(num_steps) = action;
        
        state = compute_next_state(transition_matrix, state, action);
        
        trial_reward                       = reward(state);
        trial.clinician_rewards(num_steps) = trial_reward;
        
        num_steps = num_steps + 1;
    end
    
    trial.clinician_steps = num_steps - 1;
    
    trials{i} = trial;
end

%Compute rho.
parfor i = 1 : num_trials
    
    trial     = trials{i};
    num_steps = trial.clinician_steps;
    
    for j = 1 : num_steps
       
        state     = trial.clinician_states(j);
        action    = trial.clinician_actions(j);
        ai_action = policy(state);
        
        if ai_action == action
        
            pi_ai = 0.99;
        else
            
            pi_ai = 0.01/(K - 1);
        end
        
        pi_clinician = clinician_policy(state, action);
        trial.rho(j) = pi_ai/pi_clinician;
    end
    
    trial.rho(num_steps + 1 : end) = 1;
    trials{i} = trial;
end

%Compute W for each time point.
w = zeros(max_steps, 1);

for i = 1 : max_steps
    
    for j = 1 : num_trials

        w(i) = w(i) + prod(trials{j}.rho(1:i));
    end
end

w                  = w * (1/num_trials);
gamma_vector       = power(gamma, 0:max_steps);
V_vector           = zeros(num_trials, 1);
V_vector_clinician = zeros(num_trials, 1);

%Compute the value for the clinician and the AI Clinician.
parfor i = 1 : num_trials
    
    trial     = trials{i};
    num_steps = trial.clinician_steps;
    rho       = prod(trial.rho(1 : num_steps));
    reward    = trial.clinician_rewards(1:num_steps);
    w_H       = w(num_steps);
    
    V_vector(i)           =  (rho/w_H) * gamma_vector(1:num_steps) * reward;
    V_vector_clinician(i) = gamma_vector(1 : num_steps) * reward;
end

%Set the values to the average computed over all of the trials.
V_WIS       = mean(V_vector);
V_clinician = mean(V_vector_clinician);

end

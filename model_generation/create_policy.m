%%
% The following work is the original creation of Russell Jeter, PhD at Emory
% University 2018-2019. It is licensed and shared under a Creative Commons 
% Attribution-NonCommercial-ShareAlike 4.0 International License. This means
% reproduction of the work is allowed provided that it is for non-commercial
%applications and the creating authors are cited.
%
%% Create Policy Description
% Inputs:   transition_matrix: The empirically derived transition matrix
%                              that gives the probabilities of 
%                              transitioning between states.
%           
%           reward:            Vector of rewards for each state.
%                              
%           num_actions:       Number of discrete actions the AI can take.
%           
%           gamma:             Reward decay rate.
%                
%
% Outputs:  policy:  AI's recommended action to take for each state.
%
% This function takes the reward vector, number of actions, transition
% matrix, and reward decay rate (gamma) as inputs, and implements Policy
% Iteration to find the optimal policy for this environment.  This optimal
% policy is used as the AI Clinician's policy.

%% create_policy implementation.
function policy = create_policy(reward, num_actions, transition_matrix, gamma)

%Initilize the policy vector to random numbers, except for the terminal
%states, which have a policy of 0.
K                    = length(reward);
policy_vector        = randi(num_actions, K, 1);
policy_vector(K - 1) = 0;
policy_vector(K)     = 0;

%Initialize the value vector
value_vector     = zeros(K, 1);
value_vector_old = value_vector;
%Set any NaN values in the transition matrix to zero (there shouldn't be
%any, but we're being safe)
transition_matrix(isnan(transition_matrix)) = 0;
%Set the allowable norm of the difference between the old policy and the
%new policy, so we know when the optimal value has been reached.
epsilon = 1;

new_policy_vector = zeros(K, 1);

iteration = 0;
%This while loop is where Policy Iteration is performed.  For more
%information on Policy Iteration, see here:
% https://medium.com/@m.alzantot/deep-reinforcement-learning-demysitifed-episode-2-policy-iteration-value-iteration-and-q-978f9e89ddaa
while norm(new_policy_vector - policy_vector) > epsilon
    
    if(iteration > 1)
    
        policy_vector = new_policy_vector;
    end
    
    for s = 1 : K - 2
    
        a        = policy_vector(s);
        sum_term = 0;
        
        for s_prime = 1 : K
        
            sum_term = sum_term + transition_matrix(s, s_prime, a)*value_vector_old(s_prime);
        end
        
        expected_reward = transition_matrix(s, :, a) * reward;
        value_vector(s) = gamma*sum_term + expected_reward;
    end
    
    value_vector_old = value_vector;
    %Update policy
    for s = 1 : K - 2
    
        best_action = policy_vector(s);
        best_value  = min(value_vector_old);
        
        for a = 1 : num_actions    
            
            sum_term = 0;
            for s_prime = 1 : K - 2
            
                sum_term = sum_term + transition_matrix(s, s_prime, a) * value_vector_old(s_prime);
            end
            
            expected_reward = transition_matrix(s, :, a) * reward;
            value           = gamma*sum_term + expected_reward;
            
            if value > best_value
            
                best_value  = value;
                best_action = a;
            end
        end
        
        new_policy_vector(s) = best_action;
    end
    
    iteration = iteration + 1;
end

policy = policy_vector;
end
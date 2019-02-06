%%
% The following work is the original creation of Russell Jeter, PhD at Emory
% University 2018-2019. It is licensed and shared under a Creative Commons 
% Attribution-NonCommercial-ShareAlike 4.0 International License. This means
% reproduction of the work is allowed provided that it is for non-commercial
%applications and the creating authors are cited.
%
%This script finds the optimal number of clusters given the normalized
%binned patient data.
%The method uses the CalinskiHarabasz Criterion for evaluating the optimal
%number of clusters.  The criterion finds the maximum of the ratio of the
%between cluster variance over the within cluster variance.

load('./data/normalized_trajectory_data.mat');

options = statset('UseParallel',1);

max_clusters = 1000;
cluster_step = 10;

num_steps = max_clusters/cluster_step;
clust     = zeros(size(trajectories_normalized,1), num_steps);

for i = 1 : num_steps
    
    K = i * cluster_step;
    
    disp(['Generating clustering ' num2str(K) '/' num2str(max_clusters)]);
    
    clust(:,i) = kmeans(trajectories_normalized , K, 'Options', options,...
                        'Display','final', 'Replicates', 10);
end



eval = evalclusters(trajectories_normalized, clust, 'CalinskiHarabasz');

disp(['The optimal number of clusters is ' num2str(eval.OptimalK)]);
save('optimal_clusters.mat')
%%
% The following work is the original creation of Russell Jeter, PhD at Emory
% University 2018-2019. It is licensed and shared under a Creative Commons 
% Attribution-NonCommercial-ShareAlike 4.0 International License. This means
% reproduction of the work is allowed provided that it is for non-commercial
%applications and the creating authors are cited.
%
%% Plot AI Actions
% Inputs:   model:  Policy model with environment, ai, and clinician
%                   policies.
%
% This function generates the plots that compare the ai clinician's 
% recommendation to the real clinician dosing practices.
%
%% plot_ai_actions implementation

function plot_ai_actions(model)
real_clinician = true;
test_set = model.test_set;

N = length(test_set);


for i = 1 : N
    
    patient   = test_set{i};
    num_steps = length(patient.discrete_trajectory);
    
    if real_clinician
        continuous_actions_clinician = patient.cont_actions';
    end
    
    continuous_actions_ai = patient.continuous_actions_ai;
    
    MAP = patient.MAP;
    MAPIndex = 1:length(MAP);
    
    
    test_set{i} = patient;
    
    
    close all;
    
    navy   = [0.071, 0.184, 0.239];
    red    = [0.745, 0.243, 0.169];
    
    Nlen = length(continuous_actions_clinician(:, 1));
    f = figure('visible', 'off');
    
    set(f, 'Position', [0, 0, 1000, 800])
    set(gca, 'fontsize', 30)
    
    ax(1)=subplot(3,1,1);
    h = stem(continuous_actions_ai(:, 1),'-.', 'Filled');
    h(1).LineWidth = 2;
    h(1).MarkerSize = 8;
    h(1).Color = navy;
    ylim([0 110]);
    hbase = h.BaseLine;
    hbase.LineStyle = '--';
    hbase.LineWidth = 2;
    hold on,
    h = stem(continuous_actions_clinician(:, 1),'-.','color', red);
    h(1).LineWidth = 2;
    h(1).MarkerSize = 8;
    ylim([0 110]);
    hbase = h.BaseLine;
    hbase.LineStyle = '--';
    hbase.LineWidth = 2;
    ylim([0 1.25]);
    xlim([0-0.5 Nlen+0.5])
    ylabel('Pressors');
    hleg = legend('RL Agent','Clinician','orientation','horizontal', 'location', 'northoutside');
    set(gca,'FontSize',25);
    set(gca,'xticklabel',[])
    
    ax(2) =subplot(3,1,2);
    h = stem(continuous_actions_ai(:, 2),'--', 'Filled');
    h(1).LineWidth = 2;
    h(1).MarkerSize = 8;
    h(1).Color = navy;
    hold on,
    h = stem(continuous_actions_clinician(:, 2),'--','color', red);
    h(1).LineWidth = 2;
    h(1).MarkerSize = 8;
    ylim([0 110]);
    hbase = h.BaseLine;
    hbase.LineStyle = '--';
    hbase.LineWidth = 2;
    ylim([0 1500]);
    xlim([0-0.5 Nlen+0.5]),
    ylabel('Fluids');
    xlabel('Time (Hours)')
    set(gca, 'fontsize', 25)
    
    ax(3)=subplot(3,1,3);
    
    h = stem(MAPIndex(MAP > 65), MAP(MAP > 65), 'Filled', 'BaseValue', 65);
    h(1).LineWidth = 2;
    h(1).MarkerSize = 8;
    h(1).Color = navy;
    hold on
    if ~isempty(MAPIndex(MAP < 65))
        h = stem(MAPIndex(MAP < 65), MAP(MAP < 65), 'Filled', 'BaseValue', 65);
        h(1).LineWidth = 2;
        h(1).MarkerSize = 8;
        h(1).Color = red;
    end
    hbase = h.BaseLine;
    hbase.LineStyle = '--';
    hbase.LineWidth = 2;
    ylabel('MAP');ylim([40 110]);
    xlim([0-0.5 Nlen+0.5]);
    set(gca,'FontSize',25),
    xlabel('Time')
    
    print(['./Figures/' num2str(i) '_actions'], '-dpng')
    close;
end
end






%% PLOTS PAST, PRESENT & FUTURE RATES OF GLOBAL AND ANTARCTIC SEA LEVEL
% 
% This script produces Figure 1.
% 
% Sources:
%
% Holocene (total global mean sea level):
% Lambeck, K., Rouby, H., Purcell, A., Sun, Y., & Sambridge, M. (2014). Sea level and global ice volumes from the Last Glacial Maximum to the Holocene. Proceedings of the National Academy of Sciences, 111(43), 15296-15303.
% 
% 20th Century (total global mean sea level and Antarctic-specific
% contribution):
% Frederikse, T., Landerer, F., Caron, L., Adhikari, S., Parkes, D., Humphrey, V. W., ... & Wu, Y. H. (2020). The causes of sea-level rise since 1900. Nature, 584(7821), 393-397.
%
% Future projections until 2100 CE (showing only Antarctic-specific
% contribution):
% Edwards, T. L., Nowicki, S., Marzeion, B., Hock, R., Goelzer, H., Seroussi, H., ... & Zwinger, T. (2021). Projected land ice contributions to twenty-first-century sea level rise. Nature, 593(7857), 74-82.
%
%
% Created by Richard Selwyn Jones (Nov 2021)
%
%
%%

clear % Start fresh

addpath(genpath('..'))

% Load data
load Holocene_L14
load Historical_F20
load Future_E21


% Specify parameters for the figure
time_Hol = [100,11650];     % Time bounds for the Holocene (years ago, from 1950 CE)
time_C20 = [1908,2010];     % Time bounds for future projections (years CE)
time_future = [2020,2100];  % Time bounds for future projections (years CE)
mmyr_lim = [0,25];          % Bounds for rate of change (y axis)
lwidth = 1;                 % Plotted linewidth
fsize = 7;                  % Font size


figure

% Holocene
ax1 = subplot(3,3,1);
plot(L14.time_a,L14.rate_m_mov100y*1000,'k-','linewidth',lwidth);
ylim(mmyr_lim);  xlim(time_Hol);
ax1.XDir='reverse'; ax1.YGrid='on';  box off; ax1.TickDir='both';
ylabel({'mm per year'});
xlabel('Years ago');
title('Holocene'); ax1.FontSize = fsize;

% Historical (20th Century)
ax2 = subplot(3,3,2);
plot(F20.time,F20.Rate.Obs_m*1000,'k-','linewidth',lwidth); hold on;
plot(F20.time,F20.Rate.Ant_m*1000,'r-','linewidth',lwidth);
ylim(mmyr_lim); xlim(time_C20);
xlabel('Years CE');
ax2.YTickLabel=[]; ax2.YGrid='on'; ax2.YColor='none'; box off; ax2.TickDir='both';
title('Historical');  ax2.FontSize = fsize;

% Projected (to 2100)
ax3 = subplot(3,3,3);
plot(E21.proj.years,E21.proj.Ant.Main2p6.rate_mean_30y*100,'r--','linewidth',lwidth); hold on;
plot(E21.proj.years,E21.proj.Ant.Main8p5.rate_mean_30y*100,'r-','linewidth',lwidth);
plot(E21.proj.years,E21.proj.Ant.Risk2p6.rate_mean_30y*100,'r--','linewidth',lwidth);
plot(E21.proj.years,E21.proj.Ant.Risk8p5.rate_mean_30y*100,'r-','linewidth',lwidth); hold off;
ylim(mmyr_lim); xlim(time_future);
xlabel('Years CE');
ax3.YTickLabel=[]; ax3.YGrid='on'; ax3.YColor='none'; box off; ax3.TickDir = 'both';
title('Future'); ax3.FontSize = fsize;

% Adjust plot positions
ax2_pos = ax2.Position; ax2_pos(1) = ax2_pos(1)-0.06; ax2.Position = ax2_pos;
ax3_pos = ax3.Position; ax3_pos(1) = ax3_pos(1)-0.12; ax3.Position = ax3_pos;
ax1_pos = ax1.Position; ax1_pos(4) = ax2_pos(4); ax1.Position = ax1_pos;


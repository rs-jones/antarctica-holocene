%% PLOT ANTARCTIC ICE THICKNESS CHANGE FROM EMPIRICAL DATA
% 
% This script produces parts of Figure 2 (based on cosmogenic exposure age
% data and ice core data).
%
% The cosmogenic data were sourced from the ICE-D Antarctica database
% (http://antarctica.ice-d.org/; last accessed 05 Nov 2021), and using 10Be
% and 14C ages calculated using the LSDn scaling scheme. To prioritise data
% that should provide a reliable timeline of ice thickness change, data 
% were included where the site was a nunatak with at least 5 samples that 
% covered at least 10 m elevation range. The rate of ice surface elevation 
% change was estimated by linearly interpolating the age-elevation data at 
% each site, calculating the elevation difference for 1000-year windows, 
% and averaging across sites for each sector.
%
% The ice core data includes accumulation rates that are displayed as the 
% summed accumulation for 500-year windows relative to pre-Industrial 
% (1700-1850 CE). Model-derived ice surface elevation change estimates are 
% shown for WAIS Divide, Dome C and Dome Fuji sites.
% 
% Sources:
%
% Cosmogenic exposure age database (and original sources within):
% Balco, G. (2020). A prototype transparent-middle-layer data management and analysis infrastructure for cosmogenic-nuclide exposure dating. Geochronology, 2(2), 169-175.
% 
% Snow accumulation rates:
% Buizert, C., Fudge, T. J., Roberts, W. H., Steig, E. J., Sherriff-Tadano, S., Ritz, C., ... & Schwander, J. (2021). Antarctic surface temperature and elevation during the Last Glacial Maximum. Science, 372(6546), 1097-1101.
%
% Model-derived surface elevations at ice core sites:
% Parrenin, F., Dreyfus, G., Durand, G., Fujita, S., Gagliardini, O., Gillet, F., ... & Yoshida, N. (2007). 1-D-ice flow modelling at EPICA Dome C and Dome Fuji, East Antarctica. Climate of the Past, 3(2), 243-259.
% Koutnik, M. R., Fudge, T. J., Conway, H., Waddington, E. D., Neumann, T. A., Cuffey, K. M., ... & Taylor, K. C. (2016). Holocene accumulation and ice flow near the West Antarctic Ice Sheet Divide ice core site. Journal of Geophysical Research: Earth Surface, 121(5), 907-924.
%
% Colour schemes (cmocean):
% Thyng, K. M., Greene, C. A., Hetland, R. D., Zimmerle, H. M., & DiMarco, S. F. (2016). True colors of oceanography: Guidelines for effective and accurate colormap selection. Oceanography, 29(3), 9-13.
%
%
% Created by Richard Selwyn Jones (Nov 2021)
%
%
%%

clear % Start fresh

addpath(genpath('..'))

% Load data
load ThicknessChange_Cosmogenic
load ThicknessChange_IceCore


%% Ice thickness change from cosmogenic exposure data

% Specify parameters for the figure
Holocene_time = [0,11700];  % Time period (years ago)
interval = 1000;            % Time interval for bins (years)
font_sz = 10;               % Font size

% Define colours
sector_cols = [205,110,171;179,99,56;111,66,140;46,153,195;106,147,71]/255;
elevChange_cols = flipud(cmocean('matter',100+1));


% Calculate camels for all transects
Hol_time_arr = min(Holocene_time):1:max(Holocene_time);
clear transect_data; clear transects_bySector
for d = 1:numel(cosmo_data.by_sector)
    transects_bySector{d}.age = nan(1,3);
    transects_bySector{d}.sitenames = strings(1,1);
end
for i = 1:numel(cosmo_data.by_site)
    this_site_data = cosmo_data.by_site{i};
    if this_site_data.transect == 1
        this_transect.sitename = this_site_data.sitename;
        this_transect.time = Hol_time_arr;
        this_transect.sector_num = this_site_data.sector_num;
        this_transect.age = this_site_data.age;
        this_transect.elev_masl = this_site_data.elev_masl;
        if ~exist('transect_data','var')
            transect_data{1} = this_transect;
        else
            transect_data{end+1} = this_transect;
        end
        % Add data for site to relevant sector
        if this_site_data.sector_num == 1
            transects_bySector{1}.age = [transects_bySector{1}.age;this_site_data.age];
            transects_bySector{1}.sitenames = [transects_bySector{1}.sitenames;this_site_data.sitename];
        elseif this_site_data.sector_num == 2
            transects_bySector{2}.age = [transects_bySector{2}.age;this_site_data.age];
            transects_bySector{2}.sitenames = [transects_bySector{2}.sitenames;this_site_data.sitename];
        elseif this_site_data.sector_num == 3
            transects_bySector{3}.age = [transects_bySector{3}.age;this_site_data.age];
            transects_bySector{3}.sitenames = [transects_bySector{3}.sitenames;this_site_data.sitename];
        elseif this_site_data.sector_num == 4
            transects_bySector{4}.age = [transects_bySector{4}.age;this_site_data.age];
            transects_bySector{4}.sitenames = [transects_bySector{4}.sitenames;this_site_data.sitename];
        elseif this_site_data.sector_num == 5
            transects_bySector{5}.age = [transects_bySector{5}.age;this_site_data.age];
            transects_bySector{5}.sitenames = [transects_bySector{5}.sitenames;this_site_data.sitename];
        end
    end
end


% Calculate change in sample elevation with time

elevChange_time = 0:12000;
interval_edges = min(elevChange_time):interval:max(elevChange_time); interval_edges = [interval_edges,max(interval_edges)+interval];  annual2bins = discretize(elevChange_time,interval_edges);
bin_mid = interval_edges + (interval/2); bin_mid = bin_mid(1:end-1);
time_array = interval_edges(1:end-1);

% Preallocate arrays
for d = 1:numel(cosmo_data.by_sector)
    cosmo_elevChange{d}.elevChange_binned = nan(numel(transect_data),max(annual2bins));
end

% Calculate elevation change for each site
for dd = 1:numel(transect_data)
    this_transect_data = transect_data{dd};
    ages_errs = this_transect_data.age;
    this_elev_masl = this_transect_data.elev_masl;
    tran_elevChange_binned = getTransectElevChange(ages_errs,this_elev_masl,elevChange_time,interval);
    elevChange_binned(dd,:) = tran_elevChange_binned;
    
    % Add data for site to relevant sector
    if this_transect_data.sector_num == 1
        cosmo_elevChange{1}.elevChange_binned(dd,:) = tran_elevChange_binned;
    elseif this_transect_data.sector_num == 2
        cosmo_elevChange{2}.elevChange_binned(dd,:) = tran_elevChange_binned;
    elseif this_transect_data.sector_num == 3
        cosmo_elevChange{3}.elevChange_binned(dd,:) = tran_elevChange_binned;
    elseif this_transect_data.sector_num == 4
        cosmo_elevChange{4}.elevChange_binned(dd,:) = tran_elevChange_binned;
    elseif this_transect_data.sector_num == 5
        cosmo_elevChange{5}.elevChange_binned(dd,:) = tran_elevChange_binned;
    end
end

% Average elevation change across sites for each sector
for ddd = 1:numel(cosmo_elevChange)
    sect_elevChange_binned(:,ddd) = mean(cosmo_elevChange{ddd}.elevChange_binned,'omitnan');
end
sect_elevChange_binned(isnan(sect_elevChange_binned)) = 0;
elevChange_binned_summed = sum(sect_elevChange_binned,2,'omitnan'); % Summed across sectors


figure;

% Plot as camels, divided by sector
ax1 = subplot(3,1,1);
txt_pos = linspace(0.5,0.62,numel(transects_bySector));
for aa = 1:numel(transects_bySector)
    this_sector_data = transects_bySector{aa}; hold on;
    sector_name = cosmo_data.by_sector{aa}.sector_name;
    [x,~,summed_camel] = getCamels(this_sector_data.age(2:end,1),this_sector_data.age(2:end,3));
    plot(x,summed_camel,'-w','LineWidth',4);
    [x,~,summed_camel] = getCamels(this_sector_data.age(2:end,1),this_sector_data.age(2:end,3));
    plot(x,summed_camel,'-','LineWidth',2,'Color',sector_cols(aa,:));
    dim = [.52 txt_pos(aa) .3 .3];
    annotation('textbox',dim,'String',sector_name,'HorizontalAlignment','right','FitBoxToText','off','EdgeColor','none','Color',sector_cols(aa,:));
end
hold off; box off; grid off;
ylabel({'Timing of','ice surface lowering','(relative probability)'},'FontSize',font_sz);
xlim(Holocene_time); ax1.XDir='reverse'; ax1.TickDir='out';
ax1.XTickLabels=[]; ax1.YTick=[]; ax1.YTickLabels=[]; ax1.XAxis.LineWidth=1; ax1.YAxis.Visible='off';

% Plot change in sample elevation with time, divided by sector
ax2 = subplot(3,1,2);
imagesc('XData',bin_mid,'YData',1:numel(cosmo_elevChange),'CData',sect_elevChange_binned')
colormap(ax2,elevChange_cols);
for bb = 1:numel(transects_bySector)
    this_sector_data = transects_bySector{bb};
    sector_name = cosmo_data.by_sector{bb}.sector_name;
    n_sites = numel(unique(transects_bySector{bb}.sitenames));
    n_samples = numel(cosmo_data.by_sector{bb}.age(:,1));
    this_text = {sector_name,strcat('n=',num2str(n_sites),'(',num2str(n_samples),')')};
    text(500,bb,this_text,'HorizontalAlignment','right','FontSize',font_sz);
end
cbar1 = colorbar(ax2,'Location','southoutside');
ylabel(cbar1,{'Ice surface elevation change','(m per 1000 years)'},'FontSize',font_sz);
ax2.YTick = []; ylim([.5,numel(cosmo_elevChange)+.5]); 
xlim(Holocene_time); ax2.XDir = 'reverse'; ax2.XTickLabels=[];
ax2.FontSize = font_sz; box on; ax2.LineWidth = 2;

% Plot sum of sectors
ax3 = subplot(3,1,3);
imagesc('XData',bin_mid,'YData',1,'CData',elevChange_binned_summed')
colormap(ax3,gray(8)); caxis([-400,0]); cbar2 = colorbar(ax3,'Location','southoutside');
ylabel(cbar2,'Sum of sectors (m)','FontSize',font_sz); ax3.YTick = []; ylim([.5,1.5]);
xlim(Holocene_time); ax3.XDir = 'reverse'; xlabel('Years ago');
ax3.FontSize = font_sz; box on;  ax3.LineWidth = 2;
ax3.TickDir='out';

% Adjust plot positions
plot_xpos = 0.15;
plot_width = 0.7;
ax2_ypos = 0.33;
ax3_ypos = 0.25;
ax1_height = 0.25;
ax2_height = 0.35;
ax3_height = ax2_height/numel(cosmo_elevChange);
ax1.Position([1,3,4])=[plot_xpos,plot_width,ax1_height];
ax2.Position=[plot_xpos,ax2_ypos,plot_width,ax2_height];
ax3.Position=[plot_xpos,ax3_ypos,plot_width,ax3_height];
cbar1.Position(2)=cbar1.Position(2)-0.15;
cbar2.Position([2,4])=cbar1.Position([2,4]);
cbar1.Position(3)=(cbar1.Position(3)/2) -0.02;
cbar2.Position(3)=cbar1.Position(3);
cbar2.Position(1)=cbar1.Position(1)+cbar2.Position(3)+(0.02*2);
fig = gcf; fig.WindowState = 'maximized';


%% Ice thickness change from ice core data

% Specify parameters for the figure
Holocene_time = [0,11650];  % Time period (years ago)
interval = 500; % Set time interval for bins (years)
font_sz = 10;               % Font size

% Define colours
acc_anom_cols = flipud(cmocean('balance',101));
acc_anom_cols((length(acc_anom_cols(:,1))+1)/2,:) = [.95,.95,.95]; % Make middle near-white


% Calculate change in sample elevation with time
interp_time = 0:1:12000;
for i = 1:numel(IceCore_acc)
    acc_time = IceCore_acc{i}.acc.time;
    this_interp_acc = interp1(acc_time,IceCore_acc{i}.acc.mid,interp_time,'linear');
    preInd_idx = find(interp_time<=250 & interp_time>=100);
    this_acc_preInd = nanmean(this_interp_acc(preInd_idx));
    interpolated_acc_anom = this_interp_acc - this_acc_preInd;
    
    % Bin accumulation for each time interval
    interval_edges = min(interp_time):interval:max(interp_time); interval_edges = [interval_edges,max(interval_edges)+interval];
    annual2bins = discretize(interp_time,interval_edges);  uniq_bins = unique(annual2bins);
    this_acc_anom_binned = zeros(1,max(annual2bins));
    for ii = 1:max(annual2bins)
        this_bin_id = uniq_bins(ii);
        this_bin_log = this_bin_id == annual2bins;
        this_acc_anom_binned(ii) = nansum(interpolated_acc_anom(this_bin_log));
    end
    this_acc_anom_binned(isnan(this_acc_anom_binned)) = 0; % Make NaNs zeros
    acc_anom_binned(i,:) = this_acc_anom_binned;
end
bin_mid = interval_edges + (interval/2); bin_mid = bin_mid(1:end-1);

% Order ice cores (1 WAIS, 2 DML, 3 DomeC, 4 Talos, 5 Siple, 6 SouthP, 7 Fuji)
sorted_acc_idx = fliplr([5,1,4,7,2,3,6]);
sorted_acc_anom_binned = acc_anom_binned(sorted_acc_idx,:);


figure;

imagesc('XData',bin_mid,'YData',1:numel(IceCore_acc),'CData',sorted_acc_anom_binned); hold on;
caxis([-35,35]);
surf_lim = [-100,50];
colormap(acc_anom_cols);
for bb = 1:numel(IceCore_acc)
    this_core_idx = sorted_acc_idx(bb);
    this_core_data = IceCore_acc{this_core_idx};
    if isfield(this_core_data,'surf')
        this_surf_anom = this_core_data.surf.surf_anom(this_core_data.surf.time<max(Holocene_time));
        this_surf_rescaled = rescale(this_surf_anom,'InputMin',surf_lim(1),'InputMax',surf_lim(2)) + bb-0.5;
        plot(this_core_data.surf.time(this_core_data.surf.time<max(Holocene_time)),this_surf_rescaled,'-w','Linewidth',4); hold on;
        plot(this_core_data.surf.time(this_core_data.surf.time<max(Holocene_time)),this_surf_rescaled,'-k','Linewidth',1); hold on;
    end
    core_name = IceCore_acc{this_core_idx}.sitename;
    text(500,bb,core_name,'HorizontalAlignment','right','FontSize',font_sz);
end
cbar=colorbar('Location','southoutside'); ax=gca;
ylabel(cbar,strcat({'Accumulation rate anomaly  (m per '},num2str(interval),{' years)'}),'FontSize',font_sz); % Sum
ylim([.5,numel(IceCore_acc)+.5]);
ax.YTick=[1.5,2.5,3.5,4.5,5.5,6.5]; ax.YTickLabel=string([surf_lim,surf_lim,surf_lim]); ylabel('Ice surface elevation anomaly (m)');
xlim(Holocene_time); ax.XDir='reverse'; xlabel('Years ago');
ax.FontSize=font_sz; box on; ax.LineWidth=2;
ax.TickDir='out'; ax.YAxisLocation='right';


% Adjust plot positions
plot_xpos = 0.15;
plot_width = 0.7;
ax_height = 0.7;
ax.Position([1,3,4])=[plot_xpos,plot_width,ax_height];
cbar.Position(1)=cbar.Position(1)+0.17;
cbar.Position(3)=cbar.Position(3)/2;
fig = gcf; fig.WindowState = 'maximized';


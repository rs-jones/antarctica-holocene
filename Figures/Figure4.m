%% PLOT ANTARCTIC ICE VOLUME CHANGE FROM ICE SHEET MODELS
% 
% This script plots Figure 4.
%
% Sources:
%
% Ice sheet models:
% Albrecht, T., Winkelmann, R., & Levermann, A. (2020). Glacial-cycle simulations of the Antarctic Ice Sheet with the Parallel Ice Sheet Model (PISM)–Part 2: Parameter ensemble analysis. The Cryosphere, 14(2), 633-656.
% Briggs, R. D., Pollard, D., & Tarasov, L. (2014). A data-constrained large ensemble analysis of Antarctic evolution since the Eemian. Quaternary Science Reviews, 103, 91-115.
% Golledge, N. R., Menviel, L., Carter, L., Fogwill, C. J., England, M. H., Cortese, G., & Levy, R. H. (2014). Antarctic contribution to meltwater pulse 1A from reduced Southern Ocean overturning. Nature communications, 5(1), 1-10.
% Gomez, N., Weber, M. E., Clark, P. U., Mitrovica, J. X., & Han, H. K. (2020). Antarctic ice dynamics amplified by Northern Hemisphere sea-level forcing. Nature, 587(7835), 600-604.
% Kingslake, J., Scherer, R. P., Albrecht, T., Coenen, J., Powell, R. D., Reese, R., ... & Whitehouse, P. L. (2018). Extensive retreat and re-advance of the West Antarctic Ice Sheet during the Holocene. Nature, 558(7710), 430-434.
% Pollard, D., Gomez, N., & Deconto, R. M. (2017). Variations of the Antarctic Ice Sheet in a coupled ice sheet‐Earth‐sea level model: Sensitivity to viscoelastic Earth properties. Journal of Geophysical Research: Earth Surface, 122(11), 2124-2138.
% Pollard, D., Gomez, N., DeConto, R. M., & Han, H. K. (2018). Estimating Modern Elevations of Pliocene Shorelines Using a Coupled Ice Sheet‐Earth‐Sea Level Model. Journal of Geophysical Research: Earth Surface, 123(9), 2279-2291.
% Tigchelaar, M., Timmermann, A., Pollard, D., Friedrich, T., & Heinemann, M. (2018). Local insolation changes enhance Antarctic interglacials: Insights from an 800,000-year ice sheet simulation with transient climate forcing. Earth and Planetary Science Letters, 495, 69-78.
% Whitehouse, P. L., Bentley, M. J., & Le Brocq, A. M. (2012). A deglacial model for Antarctica: geological constraints and glaciological modelling as a basis for a new model of Antarctic glacial isostatic adjustment. Quaternary Science Reviews, 32, 1-24.
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
load Ant_basins
load BedMachine_Antarctica_GL-coast.mat


%% Get change in modelled ice thickness

% Specify time periods
EarlyHol_period = [-11650,-8200];   % Min,Max time (old,young)
MidHol_period = [-8200,-4200];      % Min,Max time (old,young)
LateHol_period = [-4200,-100];      % Min,Max time (old,young)
interval = 500;                     % Bin interval (years)

% Select models to use
models = ["A20","B14","G14","G20i5g","G20anu","K18ref","P17st","P17elra","P18","T18","W12"];

% Set model to use for a standardise grid
model_standard = "G14";     % Model ID
model_std_res = 15000;      % Grid spacing (m)


% Sort model files
models_alph = sort(models);
filelist = dir('../AntarcticIceSheetModels');  filenames = {filelist.name};  filenames = filenames(~strncmp(filenames,'.',1));
model_filenames = filenames(contains(filenames,models));
model_std_filename = filenames(contains(filenames,model_standard));


% Get standard grid
load(model_std_filename{1}); std_model = eval(model_standard);

% Find sectors for standard grid
std_x = reshape(std_model.x_grid,[],1);
std_y = reshape(std_model.y_grid,[],1);
for aa = 1:numel(basins)
    this_sector_poly = polyshape(basins{aa}.x,basins{aa}.y);
    inSector_log = isinterior(this_sector_poly,std_x,std_y); 
    inSector{aa} = reshape(inSector_log,size(std_model.x_grid));
end


% Calculate mean and deviation of model changes for each time period
for i = 1:length(model_filenames)
    
    % Get model data
    load(model_filenames{i}); this_model = eval(models_alph(i));
    
    % Early Holocene
    this_thkChange = getModelThkChange(this_model,EarlyHol_period,std_model);
    EH_thkChange(:,:,i) = this_thkChange.thk_diff;
    EH_gr_ice_t1(:,:,i) = this_thkChange.gr_ice_t1;
    EH_gr_ice_t2(:,:,i) = this_thkChange.gr_ice_t2;
    
    % Mid Holocene
    this_thkChange = getModelThkChange(this_model,MidHol_period,std_model);
    MH_thkChange(:,:,i) = this_thkChange.thk_diff;
    MH_gr_ice_t1(:,:,i) = this_thkChange.gr_ice_t1;
    MH_gr_ice_t2(:,:,i) = this_thkChange.gr_ice_t2;
    
    % Late Holocene
    this_thkChange = getModelThkChange(this_model,LateHol_period,std_model);
    LH_thkChange(:,:,i) = this_thkChange.thk_diff;
    LH_gr_ice_t1(:,:,i) = this_thkChange.gr_ice_t1;
    LH_gr_ice_t2(:,:,i) = this_thkChange.gr_ice_t2;
    
end

% Mean thickness change across models
EH_thkChange_mean = mean(EH_thkChange,3,'omitnan');
MH_thkChange_mean = mean(MH_thkChange,3,'omitnan');
LH_thkChange_mean = mean(LH_thkChange,3,'omitnan');

% Standard deviation of thickness change across models
EH_thkChange_stdev = std(EH_thkChange,1,3,'omitnan');
MH_thkChange_stdev = std(MH_thkChange,1,3,'omitnan');
LH_thkChange_stdev = std(LH_thkChange,1,3,'omitnan');

% Get largest ice extent across models
EH_thkChange_t1ice = max(EH_gr_ice_t1,[],3);
MH_thkChange_t1ice = max(MH_gr_ice_t1,[],3);
LH_thkChange_t1ice = max(LH_gr_ice_t1,[],3);
EH_thkChange_t2ice = max(EH_gr_ice_t2,[],3);
MH_thkChange_t2ice = max(MH_gr_ice_t2,[],3);
LH_thkChange_t2ice = max(LH_gr_ice_t2,[],3);
EH_thkChange_maxice = max(cat(3,EH_thkChange_t1ice,EH_thkChange_t2ice),[],3);
MH_thkChange_maxice = max(cat(3,MH_thkChange_t1ice,MH_thkChange_t2ice),[],3);
LH_thkChange_maxice = max(cat(3,LH_thkChange_t1ice,LH_thkChange_t2ice),[],3);

% Remove non-ice areas
EH_thkChange_mean(EH_thkChange_maxice==0) = NaN;
MH_thkChange_mean(MH_thkChange_maxice==0) = NaN;
LH_thkChange_mean(LH_thkChange_maxice==0) = NaN;
EH_thkChange_stdev(EH_thkChange_maxice==0) = NaN;
MH_thkChange_stdev(MH_thkChange_maxice==0) = NaN;
LH_thkChange_stdev(LH_thkChange_maxice==0) = NaN;


% Calculate mean ice thickness change across models for each sector

modelvolChange_time = -12000:1:0;
interval_edges = min(modelvolChange_time):interval:max(modelvolChange_time);
rho_ice = 917; % Density of ice (kg/m^3)

for i = 1:numel(models)
    
    % Get model data
    load(model_filenames{i}); this_model = eval(models_alph(i));
    
    % Do for each time interval
    for ii = 1:length(interval_edges)-1
        this_int_period = [interval_edges(ii),interval_edges(ii+1)];
        this_thkChange = getModelThkChange(this_model,this_int_period,std_model);
        this_thkDiff_arr = reshape(this_thkChange.thk_diff,[],1);
               
        % Calculate ice volume change for each sector
        for iii = 1:numel(inSector)
            this_inSector_log = inSector{iii};
            this_sector_thkDiff = this_thkDiff_arr; this_sector_thkDiff(~this_inSector_log) = NaN;
            this_m3_perInterval = sum(this_sector_thkDiff(:)*model_std_res^2,'omitnan'); % Calculate volume change in cubic metres
            this_m3_perYear = this_m3_perInterval/interval; % Convert to volume change per year
            ivolChange_bySector.kg_perYear(ii,iii,i) = this_m3_perYear * rho_ice; % Convert to mass in kg (per year)
            ivolChange_bySector.Gt_perYear(ii,iii,i) = ivolChange_bySector.kg_perYear(ii,iii,i) * 1e-12; % Convert to Gt (per year)
            
        end
        this_model_thkDiff_mean(ii) = nanmean(this_thkDiff_arr);
    end
    
end
ivolChange_bySector.mean.Gt_perYear = mean(ivolChange_bySector.Gt_perYear,3,'omitnan');


%% Ice volume change by sector

% Specify parameters for the figure
Holocene_lim = [0,11650];  % Time period (years ago)

% Define colours
sector_cols = [205,110,171;179,99,56;111,66,140;46,153,195;106,147,71]/255;

interval_mids = interval_edges(1:end-1) + interval/2;
txt_pos = linspace(0.5,0.62,numel(basins));


figure

ax = subplot(3,1,1);
b_h = bar(-interval_mids,-ivolChange_bySector.mean.Gt_perYear,1,'stack');
alpha .8
for i = 1:numel(b_h)
    b_h(i).EdgeColor = 'w';
    b_h(i).FaceColor = sector_cols(i,:);
    dim = [.6 txt_pos(i) .3 .3];
    sector_name = basins{i}.name;
    annotation('textbox',dim,'String',sector_name,'HorizontalAlignment','right','FitBoxToText','off','EdgeColor','none','Color',sector_cols(i,:));
end
xlim(Holocene_lim); ylim([-100,815]); box off;
xlabel('Years ago');
ylabel({'Mass loss','(Gt per year)'});
ax.XDir='reverse'; ax.TickDir = 'both'; ax.XAxisLocation = 'origin';
ax.XLabel.Position([1,2]) = [max(Holocene_lim)/2,-400]; ax.XLabel.HorizontalAlignment = 'center';


%% Maps of change in ice thickness

% Specify parameters for the figure
f_size = 14; % Font size for plots


figure

% Mean ice thickness change in Early, Mid and Late Holocene
ax1 = subplot(2,3,1);
title(strcat('Early Holocene (',num2str(EarlyHol_period(1)/1000),{' to '},num2str(EarlyHol_period(2)/1000),{' kyrs)'}));
axesm('stereo','MapLatLimit',[-90 -60],'FontSize',7,'Grid','on','Frame','on');
surfm(std_model.lat_grid,std_model.lon_grid,EH_thkChange_mean); hold on;
plotm(Ant_GL.lat,Ant_GL.lon,'k-');
cmap = cmocean('-balance','pivot',0); colormap(ax1,cmap);
c1 = colorbar(ax1,'FontSize',f_size);  c1.Label.String = 'Mean ice thickness change (m)';
ax1.Box = 'off'; ax1.Color = 'none'; ax1.XColor = 'none'; ax1.YColor = 'none';
ax1.FontSize = f_size;

ax2 = subplot(2,3,2);
title(strcat('Mid Holocene (',num2str(MidHol_period(1)/1000),{' to '},num2str(MidHol_period(2)/1000),{' kyrs)'}));
axesm('stereo','MapLatLimit',[-90 -60],'FontSize',7,'Grid','on','Frame','on');
surfm(std_model.lat_grid,std_model.lon_grid,MH_thkChange_mean); hold on;
plotm(Ant_GL.lat,Ant_GL.lon,'k-');
cmap = cmocean('-balance','pivot',0); colormap(ax2,cmap);
c2 = colorbar(ax2,'FontSize',f_size);  c2.Label.String = 'Mean ice thickness change (m)';
ax2.Box = 'off'; ax2.Color = 'none'; ax2.XColor = 'none'; ax2.YColor = 'none';
ax2.FontSize = f_size;

ax3 = subplot(2,3,3);
title(strcat('Late Holocene (',num2str(LateHol_period(1)/1000),{' to '},num2str(LateHol_period(2)/1000),{' kyrs)'}));
axesm('stereo','MapLatLimit',[-90 -60],'FontSize',7,'Grid','on','Frame','on');
surfm(std_model.lat_grid,std_model.lon_grid,LH_thkChange_mean); hold on;
plotm(Ant_GL.lat,Ant_GL.lon,'k-');
cmap = cmocean('-balance','pivot',0); colormap(ax3,cmap);
c3 = colorbar(ax3,'FontSize',f_size);  c3.Label.String = 'Mean ice thickness change (m)';
ax3.Box = 'off'; ax3.Color = 'none'; ax3.XColor = 'none'; ax3.YColor = 'none';
ax3.FontSize = f_size;


% Standard deviation of ice thickness change in Early, Mid and Late Holocene
ax4 = subplot(2,3,4);
axesm('stereo','MapLatLimit',[-90 -60],'FontSize',7,'Grid','on','Frame','on');
surfm(std_model.lat_grid,std_model.lon_grid,EH_thkChange_stdev); hold on;
plotm(Ant_GL.lat,Ant_GL.lon,'k-');
cmap = cmocean('speed'); colormap(ax4,cmap);
c4 = colorbar(ax4,'FontSize',f_size);  c4.Label.String = 'Standard deviation';
ax4.Box = 'off'; ax4.Color = 'none'; ax4.XColor = 'none'; ax4.YColor = 'none';
ax4.FontSize = f_size;

ax5 = subplot(2,3,5);
axesm('stereo','MapLatLimit',[-90 -60],'FontSize',7,'Grid','on','Frame','on');
surfm(std_model.lat_grid,std_model.lon_grid,MH_thkChange_stdev); hold on;
plotm(Ant_GL.lat,Ant_GL.lon,'k-');
cmap = cmocean('speed'); colormap(ax5,cmap);
c5 = colorbar(ax5,'FontSize',f_size);  c5.Label.String = 'Standard deviation';
ax5.Box = 'off'; ax5.Color = 'none'; ax5.XColor = 'none'; ax5.YColor = 'none';
ax5.FontSize = f_size;

ax6 = subplot(2,3,6);
axesm('stereo','MapLatLimit',[-90 -60],'FontSize',7,'Grid','on','Frame','on');
surfm(std_model.lat_grid,std_model.lon_grid,LH_thkChange_stdev); hold on;
plotm(Ant_GL.lat,Ant_GL.lon,'k-');
cmap = cmocean('speed'); colormap(ax6,cmap);
c6 = colorbar(ax6,'FontSize',f_size);  c6.Label.String = 'Standard deviation';
ax6.Box = 'off'; ax6.Color = 'none'; ax6.XColor = 'none'; ax6.YColor = 'none';
ax6.FontSize = f_size;


% Adjust plot positions
upp_ypos = 0.5;
low_ypos = 0.2;
cbar_height = 0.2;
cbar_width = 0.008;
ax1.Position(2)=upp_ypos; ax2.Position(2)=upp_ypos; ax3.Position(2)=upp_ypos; ax4.Position(2)=low_ypos; ax5.Position(2)=low_ypos; ax6.Position(2)=low_ypos;
c1.Position([2,3,4])=[(ax1.Position(4)/2)+(ax1.Position(2)-(cbar_height/2)),cbar_width,cbar_height];
c2.Position([2,3,4])=[(ax2.Position(4)/2)+(ax2.Position(2)-(cbar_height/2)),cbar_width,cbar_height];
c3.Position([2,3,4])=[(ax3.Position(4)/2)+(ax3.Position(2)-(cbar_height/2)),cbar_width,cbar_height];
c4.Position([2,3,4])=[(ax4.Position(4)/2)+(ax4.Position(2)-(cbar_height/2)),cbar_width,cbar_height];
c5.Position([2,3,4])=[(ax5.Position(4)/2)+(ax5.Position(2)-(cbar_height/2)),cbar_width,cbar_height];
c6.Position([2,3,4])=[(ax6.Position(4)/2)+(ax6.Position(2)-(cbar_height/2)),cbar_width,cbar_height];
fig = gcf; fig.WindowState = 'maximized';


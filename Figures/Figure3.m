%% PLOT ANTARCTIC GROUNDING LINE MIGRATION
% 
% This script produces parts of Figure 3 (map of grounding line retreat/
% readvance and retreat age probabilities).
% 
% Sources:
%
% Antarctic ice surface and bed elevations, and present-day grounding line (BedMachine):
% Morlighem, M., Rignot, E., Binder, T., Blankenship, D., Drews, R., Eagles, G., ... & Young, D. A. (2020). Deep glacial troughs and stabilizing ridges unveiled beneath the margins of the Antarctic ice sheet. Nature Geoscience, 13(2), 132-137.
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
load BedMachine_Antarctica_5km
load BedMachine_Antarctica_GL-coast
load GroundingLine


%% Map grounding line retreat ages and locations of readvance

% Specify parameters for the figure
Holocene_time = [0,11650];  % Time period (years ago)
latlim = [-90,-61];         % Latitudes (min, max)
f_size = 14;                % Font size
m_size = 12;                % Marker size

% Define colours
retreat_cols = cmocean('matter',max(Holocene_time)+2000);


figure

axesm('stereo','MapLatLimit',latlim,'FontSize',f_size,'Grid','on','Frame','on'); 
bed_h = surfm(Ant_lat_5km,Ant_lon_5km,Ant_bed_5km); hold on;
surf_h = surfm(Ant_lat_5km,Ant_lon_5km,Ant_surf_5km);
alpha 0.7
plotm(Ant_coast.lat,Ant_coast.lon,'k-');
plotm(Retreat_data.inland.subglacial_14C(:,1),Retreat_data.inland.subglacial_14C(:,2),'s','Color','w','MarkerFaceColor',[77,175,74]/255,'MarkerSize',m_size-1);
plotm(Retreat_data.inland.icerises(:,1),Retreat_data.inland.icerises(:,2),'^','Color','w','MarkerFaceColor',[55,126,184]/255,'MarkerSize',m_size-1);
hold on;

% Plot pre-Holocene first
for ii = 1:numel(Retreat_data.chronology)
    this_site = Retreat_data.chronology{ii};
    if ~this_site.Holocene
        preH_h = plotm(this_site.latlon(1,:),'o','Color','k','MarkerFaceColor','none','MarkerSize',m_size);
    end
end

% Plot Holocene second
for ii = 1:numel(Retreat_data.chronology)
    this_site = Retreat_data.chronology{ii};
    if this_site.Holocene
        if this_site.age_mid > max(Holocene_lim)
            this_retreat_col = retreat_cols(end,:);
        else
            this_retreat_col = retreat_cols(round(this_site.age_mid),:);
        end
        this_h = plotm(this_site.latlon(1,:),'o','Color','w','MarkerFaceColor',this_retreat_col,'MarkerSize',m_size);
        if this_site.age_mid > max(Holocene_lim)
            maxH_h = this_h;
        end
    end
end
ax=gca;
leg_marker_times = [11.65,10,8,6,4,2,0.001]*1000;
for i = 1:numel(leg_marker_times)
    this_retreat_col = retreat_cols(leg_marker_times(i),:);
    Hol_h(i) = plotm(90,0,'o','Color','w','MarkerFaceColor',this_retreat_col,'MarkerSize',m_size);
end
leg_h = legend([preH_h,Hol_h],['Pre-Holocene',string(leg_marker_times(1:end-1)),'0'],'Location','southwest'); title(leg_h,{'Retreat age','(years ago)'}); leg_h.EdgeColor='none'; leg_h.Color='none';
leg_h.Position(1)=leg_h.Position(1)-0.18;
ax.Color = 'none'; ax.XColor = 'none'; ax.YColor = 'none'; ax.FontSize = f_size;
caxis([-6000,6000]);  cmap = cmocean('topo','pivot',0); colormap(cmap);
ax.Color = 'none'; ax.XColor = 'none'; ax.YColor = 'none'; ax.FontSize = f_size;


%% Grounding line retreat probability curves

% Specify parameters for the figure
Holocene_time = [0,11650];  % Time period (years ago)
font_sz = 15;               % Font size

% Define colours
sector_cols = [205,110,171;179,99,56;111,66,140;46,153,195;106,147,71]/255;


% Calculate camels for each sector
Hol_time_arr = min(Holocene_time):1:max(Holocene_time);
clear retreatAges_bySector
for i = 1:5
    retreatAges_bySector{i}.age = nan(1,2);
    retreatAges_bySector{i}.sector_name = strings(1,1);
end
for ii = 1:numel(Retreat_data.chronology)
    this_site_data = Retreat_data.chronology{ii};
    this_site_age = [this_site_data.age_mid,this_site_data.age_std];
    
    % Add data for site to relevant sector
    if isfield(this_site_data,'sector_num') && this_site_data.sector_num == 1
        retreatAges_bySector{1}.age = [retreatAges_bySector{1}.age;this_site_age];
        retreatAges_bySector{1}.sector_name = this_site_data.sector_name;
    elseif isfield(this_site_data,'sector_num') && this_site_data.sector_num == 2
        retreatAges_bySector{2}.age = [retreatAges_bySector{2}.age;this_site_age];
        retreatAges_bySector{2}.sector_name = this_site_data.sector_name;
    elseif isfield(this_site_data,'sector_num') && this_site_data.sector_num == 3
        retreatAges_bySector{3}.age = [retreatAges_bySector{3}.age;this_site_age];
        retreatAges_bySector{3}.sector_name = this_site_data.sector_name;
    elseif isfield(this_site_data,'sector_num') && this_site_data.sector_num == 4
        retreatAges_bySector{4}.age = [retreatAges_bySector{4}.age;this_site_age];
        retreatAges_bySector{4}.sector_name = this_site_data.sector_name;
    elseif isfield(this_site_data,'sector_num') && this_site_data.sector_num == 5
        retreatAges_bySector{5}.age = [retreatAges_bySector{5}.age;this_site_age];
        retreatAges_bySector{5}.sector_name = this_site_data.sector_name;
    end
end


figure

subplot(3,1,1:2)
txt_pos = linspace(0.4,0.6,numel(retreatAges_bySector));
for iii = 1:numel(retreatAges_bySector)
    this_sector_data = retreatAges_bySector{iii}; hold on;
    NaN_row = any(isnan(this_sector_data.age),2); this_sector_data.age(NaN_row,:)=[];
    sector_name = this_sector_data.sector_name;
    
    [x,~,this_sector_summedCamel] = getCamels(this_sector_data.age(2:end,1),this_sector_data.age(2:end,2));
    plot(x,this_sector_summedCamel,'-w','LineWidth',7);
    plot(x,this_sector_summedCamel,'-','Color',sector_cols(iii,:),'LineWidth',3);
    dim = [.42 txt_pos(iii) .3 .3];
    annotation('textbox',dim,'String',sector_name,'FitBoxToText','off','EdgeColor','none','Color',sector_cols(iii,:),'FontSize',font_sz);
end
hold off; box on; ax=gca;
ylabel({'Retreat age','(probability)'},'FontSize',font_sz);
xlim(Holocene_time);  xlabel('Years ago','FontSize',font_sz);
ax.XDir='reverse';  ax.FontSize=font_sz;


%% PLOT GLOBAL RELATIVE SEA LEVELS FROM ANTARCTIC ICE VOLUME CHANGE SCENARIOS
%
% This script plots Figure 6.
%
% Sea level modelling was carried out by Yucheng Lin, using a 
% gravitationally self-consistent theory that accounts for shoreline 
% migration and rotational feedback, with the response to ice load change  
% calculated for a suite of 24 depth-varying three-layer Maxwell Earth 
% models which have an effective lithospheric thickness of 71 and 96 km and
% upper/lower mantle viscosity in the range 0.1-1/5-30 Pa s. The Early-Mid 
% Holocene rapid ice loss scenarios used the ice thicknesses from the 11 
% Antarctic ice sheet models (see Figure4.m), while the Mid-Late Holocene 
% ice volume gain scenario used ice thickness from the ice sheet model with
% the greatest ice volume gain (K18ref).
% The cross stippling indicates where the signal is insignificant (mean 
% predicted relative sea-level change is less than the standard deviation 
% from the 24 Earth models).
%
% Source:
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
load RelativeSeaLevel
load coastlines; 
land = shaperead('landareas','UseGeoCoords',true);


%% Maps of ice thickness and relative sea level for ice loss and gain scenarios

% Specify parameters for the figure
latlim_Ant = [-90 -60];     % Latitude range (Antarctica)
latlim_Glob = [-90 90];     % Latitude range (globe)
lonlim_Glob = [-180 180];   % Longitude range (globe)
f_size = 12;                % Font size
s_size = 2;                 % Stipple size
s_density = 80;             % Stipple density


figure


% Antarctic ice thickness change

% Rapid ice loss
subplot(2,2,1);
ax1 = axesm('stereo','MapLatLimit',latlim_Ant,'Frame','off');
surfm(Ant_thk.rapidloss.ISM_mean.lat_grid,Ant_thk.rapidloss.ISM_mean.lon_grid,Ant_thk.rapidloss.ISM_mean.thkChange); hold on;
contourm(Ant_thk.rapidloss.ISM_mean.lat_grid,Ant_thk.rapidloss.ISM_mean.lon_grid,double(~isnan(Ant_thk.rapidloss.ISM_mean.thkChange)),[0,0],'-','Color',[.5,.5,.5]);
caxis([-1500,0]);
cmap = cmocean('-balance','pivot',0); colormap(ax1,cmap);
c3 = colorbar(ax1,'FontSize',f_size);  c3.Label.String = 'Ice thickness change (m)';
ax1.Box = 'off'; ax1.Color = 'none'; ax1.XColor = 'none'; ax1.YColor = 'none';
c3.Ticks = [-1500,0];  c3.TickLabels = string([-1500,0]);
ax1.FontSize = f_size;
title('Early to Mid Holocene rapid ice loss','FontSize',f_size);

% Ice gain
subplot(2,2,2);
ax2 = axesm('stereo','MapLatLimit',latlim_Ant,'Frame','off');
surfm(Ant_thk.icegain.ISM_max.lat_grid,Ant_thk.icegain.ISM_max.lon_grid,Ant_thk.icegain.ISM_max.thkChange); hold on;
contourm(Ant_thk.icegain.ISM_max.lat_grid,Ant_thk.icegain.ISM_max.lon_grid,double(~isnan(Ant_thk.icegain.ISM_max.thkChange)),[0,0],'-','Color',[.5,.5,.5]);
caxis([-500,1000]);
cmap = cmocean('-balance','pivot',0); colormap(ax2,cmap);
c4 = colorbar(ax2,'FontSize',f_size);  c4.Label.String = 'Ice thickness change (m)';
c4.Ticks = [-500,0,1000];  c4.TickLabels = string([-500,0,1000]);
ax2.Box = 'off'; ax2.Color = 'none'; ax2.XColor = 'none'; ax2.YColor = 'none';
ax2.FontSize = f_size;
title('Mid to Late Holocene ice gain ','FontSize',f_size);


% Global relative sea level change

% Generate stippling
[lat_grid,lon_grid] = ndgrid(RSL.lat,RSL.lon);
RSL_rapidloss_sig = abs(RSL.rapidloss.ISM_mean.EM_mean) > RSL.rapidloss.ISM_mean.EM_stdev;
RSL_icegain_sig = abs(RSL.icegain.ISM_max.EM_mean) > RSL.icegain.ISM_max.EM_stdev;
[stipple_lats,stipple_lons,mask_rapidloss_nosig] = getStipple(~RSL_rapidloss_sig,lat_grid,lon_grid,s_density);
[~,~,mask_icegain_nosig] = getStipple(~RSL_icegain_sig,lat_grid,lon_grid,s_density);

% Define intervals to display
RSL_intervals_rapidloss = -5:1:5;
RSL_intervals_icegain = -.5:.1:.5;
cticks_rapidloss = [min(RSL_intervals_rapidloss):max(RSL_intervals_rapidloss)/2:max(RSL_intervals_rapidloss)];
cticks_icegain = [min(RSL_intervals_icegain):max(RSL_intervals_icegain)/2:max(RSL_intervals_icegain)];

% Rapid ice loss
subplot(2,2,3);
ax3 = axesm('robinson','MapLatLimit',latlim_Glob,'MapLonLimit',lonlim_Glob,'Frame','on');
surfm(RSL.lat,RSL.lon,RSL.rapidloss.ISM_mean.EM_mean); hold on;
plotm(stipple_lats(mask_rapidloss_nosig),stipple_lons(mask_rapidloss_nosig),'xk','MarkerSize',s_size);
geoshow(ax3,land,'FaceColor','w')
caxis([min(RSL_intervals_rapidloss) max(RSL_intervals_rapidloss)]);
cmap = crameri('roma',(numel(RSL_intervals_rapidloss)-1)*2,'pivot',0); colormap(ax3,cmap);
c1 = colorbar(ax3,'southoutside','FontSize',f_size);  c1.Label.String = 'Relative sea-level change (m)';
c1.Ticks = cticks_rapidloss;  c1.TickLabels = string(cticks_rapidloss);  %c1.Position(3) = c1.Position(3)*0.8;
ax3.Box = 'off'; ax3.Color = 'none'; ax3.XColor = 'none'; ax3.YColor = 'none';

% Ice gain
subplot(2,2,4);
ax4 = axesm('robinson','MapLatLimit',latlim_Glob,'MapLonLimit',lonlim_Glob,'Frame','on');
surfm(RSL.lat,RSL.lon,RSL.icegain.ISM_max.EM_mean); hold on;
plotm(stipple_lats(mask_icegain_nosig),stipple_lons(mask_icegain_nosig),'xk','MarkerSize',s_size);
geoshow(ax4,land,'FaceColor','w')
caxis([min(RSL_intervals_icegain) max(RSL_intervals_icegain)]);
cmap = crameri('roma',(numel(RSL_intervals_icegain)-1)*2,'pivot',0); colormap(ax4,cmap);
c2 = colorbar(ax4,'southoutside','FontSize',f_size);  c2.Label.String = 'Relative sea-level change (m)';
c2.Ticks = cticks_icegain;  c2.TickLabels = string(cticks_icegain);
ax4.Box = 'off'; ax4.Color = 'none'; ax4.XColor = 'none'; ax4.YColor = 'none';

fig = gcf; fig.WindowState = 'maximized';


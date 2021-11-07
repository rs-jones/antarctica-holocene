%% CREATE STIPPLING FOR MAP AXES PLOT

% Requires a logical grid of (in)significant values, corresponding latitude
% and longitude grids, and a specified stipple density. Based on 'stipple' 
% by Chad Greene.

% Created by Richard Selwyn Jones (Nov 2021)


function [stipple_lats,stipple_lons,stipple_mask] = getStipple(significant_grid,lat_grid,lon_grid,stipple_density)

InputDensity = hypot(size(significant_grid,1),size(significant_grid,2));
sc = stipple_density/InputDensity;

stipple_lats = imresize(lat_grid,sc);  
stipple_lons = imresize(lon_grid,sc);

stipple_mask = imresize(significant_grid,sc);  

end


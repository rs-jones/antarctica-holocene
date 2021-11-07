%% FUNCTION TO GET ICE THICKNESS CHANGE FROM MODEL OUTPUT

% Requires the model data, a specified time period and a lat-lon grid, 
% which is used for interpolation to get a standardised gridded output.

% Created by Richard Selwyn Jones (Nov 2021)


function out = getModelThkChange(ice_model,time_period_minmax,std_model)

% See if time interval exists in data
time_period_log = ismember(time_period_minmax,ice_model.time_Hol); 


if all(time_period_log) % If time intervals are present, extract data
    
    % Find time intervals
    time1_ind = find(ice_model.time_Hol==time_period_minmax(1));
    time2_ind = find(ice_model.time_Hol==time_period_minmax(2));
    
    % Get ice thickness for time intervals
    thk_time1 = squeeze(ice_model.ice_thk(:,:,time1_ind));
    thk_time2 = squeeze(ice_model.ice_thk(:,:,time2_ind));
    
    % Find grounded ice for intervals
    mask_time1 = squeeze(ice_model.ice_mask(:,:,time1_ind));
    gr_ice_time1 = mask_time1 == 2;
    mask_time2 = squeeze(ice_model.ice_mask(:,:,time2_ind));
    gr_ice_time2 = mask_time2 == 2;
    
    % Remove non-ice values
    thk_gr_1 = thk_time1;  thk_gr_1(~gr_ice_time1)=0;%NaN;
    thk_gr_2 = thk_time2;  thk_gr_2(~gr_ice_time2)=0;   
    
else % Otherwise, if time interval is missing, interpolate
     
    % Get ice thickness for time intervals
    thk_time1 = interp3(ice_model.y,ice_model.x,ice_model.time_Hol,...
        ice_model.ice_thk,ice_model.y,ice_model.x,time_period_minmax(1),'linear');
    thk_time2 = interp3(ice_model.y,ice_model.x,ice_model.time_Hol,...
        ice_model.ice_thk,ice_model.y,ice_model.x,time_period_minmax(2),'linear');
    
    % Find grounded ice for intervals
    mask_time1 = interp3(ice_model.y,ice_model.x,ice_model.time_Hol,...
        ice_model.ice_mask,ice_model.y,ice_model.x,time_period_minmax(1),'linear');
    mask_time2 = interp3(ice_model.y,ice_model.x,ice_model.time_Hol,...
        ice_model.ice_mask,ice_model.y,ice_model.x,time_period_minmax(2),'linear');
    gr_ice_time1 = mask_time1 == 2;
    gr_ice_time2 = mask_time2 == 2;
    
    % Remove non-ice values
    thk_gr_1 = thk_time1;  thk_gr_1(~gr_ice_time1)=0;%NaN;
    thk_gr_2 = thk_time2;  thk_gr_2(~gr_ice_time2)=0;
    
end


% Calculate change in thickness
this_thk_diff = thk_gr_2 - thk_gr_1;


% Interpolate to standard grid
gr_ice_time1_db = double(gr_ice_time1);  gr_ice_time2_db = double(gr_ice_time2);
this_thk_diff_regrid = interp2(ice_model.y_grid,ice_model.x_grid,...
    this_thk_diff,std_model.y_grid,std_model.x_grid,'nearest');
this_grice_t1_regrid = interp2(ice_model.y_grid,ice_model.x_grid,...
    gr_ice_time1_db,std_model.y_grid,std_model.x_grid,'nearest');
this_grice_t2_regrid = interp2(ice_model.y_grid,ice_model.x_grid,...
    gr_ice_time2_db,std_model.y_grid,std_model.x_grid,'nearest');
this_grice_t1_regrid(isnan(this_grice_t1_regrid)) = 0;
this_grice_t2_regrid(isnan(this_grice_t2_regrid)) = 0;


% Output
out.thk_diff = this_thk_diff_regrid;
out.gr_ice_t1 = this_grice_t1_regrid;
out.gr_ice_t2 = this_grice_t2_regrid;
out.lat_grid = std_model.lat_grid;
out.lon_grid = std_model.lon_grid;

end


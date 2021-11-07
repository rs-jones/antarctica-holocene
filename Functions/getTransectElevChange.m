%% FUNCTION TO CALCULATE ICE SURFACE ELEVATION CHANGE FROM COSMOGENIC DATA

% Requires cosmogenic exposure ages, corresponding sample elevation, time
% period and interval for calculating elevation change.

% Created by Richard Selwyn Jones (Nov 2021)


function elevChange_binned = getTransectElevChange(ages_errs,elev_masl,interp_time,bin_interval)

    [sorted_elevs,elev_sort_idx] = sort(elev_masl,'descend'); % Arrange into descending elevations
    ages_mean_sortedBYelev = ages_errs(elev_sort_idx,1); % Sort ages accordingly
     
    % Deal with any identical elevations - arrange by age
    if numel(sorted_elevs) > numel(unique(sorted_elevs))
        [~,nonuniq_elevs] = unique(sorted_elevs,'stable');
        nonuniq_idx = setdiff(1:numel(sorted_elevs),nonuniq_elevs);
        nonuniq_val = sorted_elevs(nonuniq_idx);
        for ii = 1:numel(nonuniq_idx)
            this_nonuniq_val = nonuniq_val(ii);
            this_nonuniq_log = sorted_elevs == this_nonuniq_val;
            this_oldest_idx = find(ages_mean_sortedBYelev==max(ages_mean_sortedBYelev(this_nonuniq_log)));
            if this_oldest_idx == nonuniq_idx(ii)
                ages_mean_sortedBYelev([nonuniq_idx(ii)-1,nonuniq_idx(ii)]) = ages_mean_sortedBYelev([nonuniq_idx(ii),nonuniq_idx(ii)-1]);
            end
        end
    end
    
    [sorted_ages_mean,age_sort_idx] = sort(ages_mean_sortedBYelev,'ascend'); % Rearrange ages for interpolation
    elev_sortedBYage = sorted_elevs(age_sort_idx,1); % Sort elevation accordingly
        
    % Deal with any identical ages - average corresponding elevation values
    if numel(sorted_ages_mean) > numel(unique(sorted_ages_mean))
        [~,nonuniq_ages] = unique(sorted_ages_mean,'stable');
        nonuniq_idx = setdiff(1:numel(sorted_ages_mean),nonuniq_ages);
        nonuniq_val = sorted_ages_mean(nonuniq_idx);
        for ii = 1:numel(nonuniq_idx)
            this_nonuniq_val = nonuniq_val(ii);
            this_nonuniq_log = sorted_ages_mean == this_nonuniq_val;
            elev_sortedBYage(this_nonuniq_log) = mean(elev_sortedBYage(this_nonuniq_log));
            remove_idx = find(sorted_ages_mean==this_nonuniq_val,1);
            sorted_ages_mean(remove_idx) = [];  elev_sortedBYage(remove_idx) = [];
        end
    end
    
    % Interpolate site elevation at annual resolution across period covered by data
    interpolated_elev = interp1(sorted_ages_mean',elev_sortedBYage',interp_time,'linear');
        
    % Bin elevations for each time interval
    interval_edges = min(interp_time):bin_interval:max(interp_time); interval_edges = [interval_edges,max(interval_edges)+bin_interval];
    annual2bins = discretize(interp_time,interval_edges);  uniq_bins = unique(annual2bins);
    elevChange_binned = zeros(1,max(annual2bins));
    for ii = 1:max(annual2bins)
        this_bin_id = uniq_bins(ii);
        this_bin_log = this_bin_id == annual2bins;
        elevChange_binned(ii) = nanmin(interpolated_elev(this_bin_log))-nanmax(interpolated_elev(this_bin_log));
    end
    elevChange_binned(isnan(elevChange_binned)) = 0;
    elevChange_binned(elevChange_binned>0) = 0;
    
end


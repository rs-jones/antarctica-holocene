%% FUNCTION TO CALCULATE NORMAL DENSITY ESTIMATES FROM RADIOMETRIC AGES

% Requires the mean/mid and uncertainty of radiometric ages, and outputs
% individual and summed 'camel' estimates for the dataset. Based on
% 'fancy_pants_camelplot' by Greg Balco.

% Created by Richard Selwyn Jones (Nov 2021)


function [x,camels,summed_camel] = getCamels(ages,errors)

numsamples = length(ages);

minAge = min(ages) - (4*errors(ages == min(ages)));
maxAge = max(ages) + (4*errors(ages == max(ages)));
ageRange = maxAge - minAge;

x = minAge:(ageRange/1000):maxAge;
totalPdf = zeros(size(x));

for a = 1:numsamples
	mu = ages(a); sigma = errors(a);
	xn = (x - mu) ./ sigma;
	y = exp(-0.5 * xn .^2) ./ (sqrt(2*pi) .* sigma);
	pdf(a,:) = y;
    
    % Fancy-pants normalization
    expected = 1 ./ (sqrt(2*pi) .* (ages.*0.03)); % expected height if 3% uncert
    pdf(a,:) = pdf(a,:) ./ (expected(a));
    totalPdf = totalPdf + pdf(a,:);
    
    % Individual curves, normalised to 1/n
    camels(a,:) = pdf(a,:) ./ numsamples;
    
end

% total curve, normalised to 1
summed_camel = totalPdf ./ numsamples;

end

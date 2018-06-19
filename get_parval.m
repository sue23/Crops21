function [ Mean, Range, IC ] = get_parval(val)
%GET_PARVAL get parameters (mean, range, IC) from vector val
%   Detailed explanation goes here

if ~isnan(val)
    Mean = nanmean(val);
    Range = abs(max(val)-min(val));
    IC =val(1);
else
    Mean = nan;
    Range = nan;
    IC =nan;
end
end


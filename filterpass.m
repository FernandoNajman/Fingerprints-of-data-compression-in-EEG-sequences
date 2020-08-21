function y = filterpass( data, cutoff_freq, sample_rate, type, order ) 
% FILTERPASS filter the EEG data
%
% INPUTS
%
% data        : EEG data
% cutoff_freq : cutoff frequency
% sample_rate : sample rate
% type        : filter type (high/low)
% order       : filter order
%
% OUTPUTS
%
% y           : data filtered

%Date   : 01/2020

if nargin < 5
    order = 2;
end

Wn = cutoff_freq / sample_rate * 2 ;
[b, a] = butter(order,Wn,type); % Butterworth filter

y = filtfilt(b, a, data);

end
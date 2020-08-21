%%% Find the position of the triggers to be epoched.
function [EEG_nan] = EEG_Epoch(EEG, eventos, t, tb)
%Usefull EEG metrics
%ParamTst;
% Set initial configurations

posi = 1;
loc_of = nan(1, length(EEG.event));
% For each EEG to epoch
for evln = 1:length(EEG.event)
    % If it is a stimulus
    if ismember(EEG.event(evln).type, eventos)
        % Reajust the positon
        loc_of(posi) = evln;
        posi = posi +1;
    end
end

% Epoch data
EEG_nan = EEG_epoch_data(EEG,eventos, t, tb, loc_of);

%EEG_nan = squeeze(EEG_nan(e, :, :))';
  
        
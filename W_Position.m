%%% Create a vector with the corresponding generating (auditory) sequence.
function [qualevnt, tam] = W_Position(EEG, eventos, A)

posi = 1;
qualevnt = nan(1, length({EEG.event.type}));
for evln = 1:length(EEG.event)
    % If it is a stimulus
    if ismember(EEG.event(evln).type, eventos)

        % Save order of stimuli
        ind = find(strcmp(eventos, EEG.event(evln).type));
        qualevnt(posi) = A(ind);

        % Reajust the positon
        posi = posi+1;
    end
end
nanEVT = find(isnan(qualevnt), 1, 'first');
qualevnt(nanEVT:end) = [];
tam = length(qualevnt);
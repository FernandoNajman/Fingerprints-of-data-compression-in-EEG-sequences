%%% Epochs the events of interest in the EEG struct. Erases all other
%%% events.
function dados = EEG_epoch_data(EEG,eventos, t, tb,loc_of)

% Epoch the correspondent EEG, save its data
%disp(evln)
%a = {EEG.event.type};
%a = unique(a);

EEG_evs = pop_epoch(EEG, eventos, [t(1) t(2)], 'eventindices' ,loc_of);
EEG_evs = pop_rmbase(EEG_evs, [tb(1) tb(2)]);
delet = [];
for indi = 1:length(EEG_evs.event)
    if ~any(strcmp(EEG_evs.event(indi).type, eventos))
        delet = [delet, indi];
    end
end
EEG_evs.event(delet) = [];
dados = EEG_evs.data;
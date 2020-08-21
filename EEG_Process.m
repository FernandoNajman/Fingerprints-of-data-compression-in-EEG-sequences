%%% Chooses the parameters of the pre-processing and do it inthe right
%%% order.
function [EEG, elecruid] = EEG_Process(EEG,Data_EEG, autorejec,chanrejec,filtering, resampl, Lowcut, Upcut, Notch, tresh, usefil, Or, std_fac)


%% Resample
if resampl < EEG.srate
    EEG = EEG_resample(EEG, resampl);
end
%% Filter
if any(filtering)
    EEG = Filter_EEG(EEG, filtering,Lowcut, Upcut, Notch, usefil, Or);
end
%% Chanel Rejection
if chanrejec == 1;
	[EEG chnrj] = EEG_ChanRejec(EEG, tresh, std_fac);
end

EEG = pop_reref( EEG,[] );
%% Auto Rejection
if autorejec == 1
    elecruid = EEG_AutoReject(EEG);
else	
	elecruid = [];
end

%%Re reference

%% ICA /// To do


%% Fix artifacts

%Fix this latter
if ~Data_EEG == 1
    EEG.event(809).type = 'other';
end

%Mark boundary artifacts
for bondary = 1:length(EEG.event)
    if strcmp(EEG.event(bondary).type, 'boundary')
       EEG.event(bondary).type = 'other';
    end    
end
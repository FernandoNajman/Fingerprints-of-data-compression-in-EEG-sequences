%%% Resample of the EEG data.
function EEG = EEG_resample(EEG, resampl)
EEG = pop_resample(EEG, resampl);
eeg_checkset(EEG);
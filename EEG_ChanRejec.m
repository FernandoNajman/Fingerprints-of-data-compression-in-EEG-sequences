%%% Identifies and removes noisy electrodes from the EEG struct.
function [EEG chnrj] = EEG_ChanRejec(EEG, tresh, std_fac)
%[EEG chnrj] = pop_rejchan(EEG,'threshold',tresh,'norm','on','measure','kurt');
[EEG chnrj] = pop_rejchanspec( EEG, 'freqlims', tresh, 'stdthresh', repmat( std_fac, size(tresh,1), 1 ) );
eeg_checkset(EEG);
%%% Filter the EEG data. Lowpass, Highpass and Notch filter.
function EEG =  Filter_EEG(EEG, filtering,Lowcut, Upcut, Notch, usefil, Or)

%    HP = 1;
%    LP = 30;
%    ddata = double(EEG.data);
%    order = 4;
%    datafiltered = filterpass( ddata', HP,  EEG.srate, 'high',  order);
%    datafiltered = filterpass( datafiltered, LP,  EEG.srate, 'low' , order);
%    EEG.data = datafiltered';


if usefil == 1
	if filtering(1) == 1;
		EEG = pop_eegfiltnew(EEG, [],Lowcut,8250,1,[],0);
	end
	if filtering(2) == 1;
		EEG = pop_eegfiltnew(EEG, [],Upcut,8250,0,[],0);
	end
	if filtering(3) == 1;
		EEG = pop_eegfiltnew(EEG, Notch(1), Notch(2),4126,1,[],0);
	end
elseif usefil == 2
    ddata = double(EEG.data);
    datafiltered = filterpass( ddata', Lowcut,  EEG.srate, 'high',  Or);
    datafiltered = filterpass( datafiltered, Upcut,  EEG.srate, 'low' , Or);
    EEG.data = datafiltered';


end	
%EEG = pop_eegfiltnew(EEG, 1, 5,4126,1,[],0);
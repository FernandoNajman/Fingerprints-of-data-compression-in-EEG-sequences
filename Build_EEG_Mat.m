%%% Return the EEG data in a matrix
function [EEG, qualevnt, elecruid, exdt] = Build_EEG_Mat(sim, fil, resampl, Lowcut,Upcut, Notch, tresh, autorejec, filtering, chanrejec, eventos, t, tb, sigma,  lengthSeq, tr, leeg, srate, sennum, electrodes, participantes, usefil, Or, std_fac);
%%% Find data files
%addpath(genpath(genpar));
elnum = length(electrodes);

if sim(1) == 0
	%%%Load the data using eeglab
	EEG = LoadData(sim(2), fil, eventos);
	[EEG, elecruid] = EEG_Process(EEG,sim(2), autorejec,chanrejec,filtering, resampl, Lowcut, Upcut, Notch, tresh, usefil, Or, std_fac);
	[qualevnt, tam] = W_Position(EEG, eventos, 0:1:length(eventos)-1);
	EEG = EEG_Epoch(EEG, eventos, t, tb);
	if sim(2) == 2
		qualevnt = qualevnt(1:end-1);
		err = find(find_seq(qualevnt, [2 2]));
		qualevnt(err) = [];
		EEG(:, :, err) = [];
		tam = length(qualevnt);
	end
	EEG = EEG(electrodes, :, :);
	exdt = [];
elseif sim(1) == 4
	%addpath('/var/tmp/CopyOfData/MATLAB/Files_com-rmbase/')
	addpath('/var/tmp/CopyOfData/MATLAB/preprocessed_data/')
	if fil < 4
		ld = load(['V0' num2str(fil) '.mat']);
	else

		f2 = fil+1;
		if 3 < f2 && f2  <= 9
			ld = load(['V0' num2str(f2) '.mat']);
		else
			ld = load(['V' num2str(fil+1) '.mat']);
		end
	end
	nms = fieldnames(ld);
	eval(['data = ld.' nms{1} ';'])
%	[s1, s2] = size(data.Y_qua{2, 1});
	[s1, s2] = size(data.Y_ter{2, 1});
	EEG = nan(length(electrodes), s1, s2);
	pss = 0;
	for el = electrodes
		pss = pss +1;
%		EEG_fil = data.Y_qua{2, el};
		EEG_fil = data.Y_ter{2, el};
		EEG(pss, :,:) = EEG_fil;
	end
%	qualevnt = data.X_qua(1, :);
	qualevnt = data.X_ter(1, :);
	exdt = [];
	elecruid = [];
else
	EEG = nan(elnum, leeg*srate, lengthSeq);
	elecruid = [];
	[ctxs, P, A] = Trees2Use(tr);
	addpath('/var/tmp/CopyOfData/MATLAB/EstimateContextTree/')
	qualevnt = generatesampleCTM(ctxs, P, A, lengthSeq);
	[~, EEG_e, exdt] = RunSim(sigma, lengthSeq, sim(1), sim(2), ctxs, P, A, leeg, sennum, srate, qualevnt, elnum);
	for repe = 1:elnum
		EEG(repe, :, :) = EEG_e{repe}';
	end
	
end


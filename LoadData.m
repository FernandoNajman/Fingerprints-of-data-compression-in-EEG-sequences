%%% Load the EEG data using EEGLAB.
function [EEG] = LoadData(Data_EEG, fil, eventos)
eeglabpath = '/var/tmp/CopyOfData/MATLAB/eeglab14_1_2b';
addpath(genpath(eeglabpath));
if Data_EEG == 1
    %base_rootdir = '/Users/pesquisador/Desktop/servidor/MATLAB/DadosEEG/';
    %base_rootdir = '/usr/mount/MATLAB/DadosEEG/';%pasta com os dados
	base_rootdir = '/var/tmp/CopyOfData/MATLAB/DadosEEG/';
	end_file = '*.vhdr';%formato
    rootdir = fullfile(base_rootdir );
    files = dir( fullfile( rootdir, end_file ) );
    EEG = pop_loadbv(base_rootdir, files(fil).name);
elseif Data_EEG == 2
    %base_rootdir = '/usr/mount/MATLAB/EEG_Rhythm/';
	base_rootdir = '/var/tmp/CopyOfData/MATLAB/EEG_Rhythm/';
    end_file = 'V*.raw';
    EEG = Data_Rythm2Freq(base_rootdir,end_file, 'Qua', fil, eventos) ;
else
    %base_rootdir = '/usr/mount/MATLAB/DadosEEG_Ter/';%pasta com os dados
	base_rootdir = '/var/tmp/CopyOfData/MATLAB/DadosEEG_Ter/';
    end_file = '*.vhdr';%formato
    rootdir = fullfile(base_rootdir );
    files = dir( fullfile( rootdir, end_file ) );
    EEG = pop_loadbv(base_rootdir, files(fil).name);
end
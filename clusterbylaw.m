function clusterbylaw
%%%Parameters
numdist = 500;
sim = [3 0] ;%Simulate or real data
%0: 1 - Pitch | 2 - Rythm | 3 Pitch Ter 
%1: 1 - Context Funct | 2 - Prob | 3 - Likelihood
%2: 0 - Brownian
%3: 0 - ARModel
%4: 0 - Rythm_pre-pros

%%Which dist
ksd = 2;%1 - binomial | 2 - KSDist
alpha = 0.3; %If using KSDist
%%How much noise
sigma = 0.3;
%%%Size of simulation
lengthSeq = 600;

%electrodes = [1 2 3 4 8 9 13 14 15 16 18 19 20 25 26 30 31 32];
%electrodes = 1:18;
electrodes = 1;
participantes = 100;%Number of participants


if sim(1) == 4
electrodes = 13;
participantes = 18;
end

%Individual results or avg/median
useavg = 3;
avgormedian = 1;

%Resample
resampl = 250;
% Filter
Lowcut = 1;%Non-empty
Upcut = 30; % Non-empty
Notch = [55, 65];
% Elec Rejec
tresh = [1:29 59; 2:30 61];
std_fac = [-3 3];
%% EEG_PROCESSING
filtering = [1, 1, 0];%[Lowcut, Highcut, Notch]
autorejec = 0;
chanrejec = 0;


%% Stimulus of interest
eventos = {'S  1' 'S  2' 'S  3'};

%% Epoch window
t = [-0.05, 0.4];%In s
%% Baseline window
tb = [-50, -0];   %In ms

%% Altura da arvore inicial
h_t = 3;

%%Which filter 1 - FIR | 2 - Butter
usefil = 2;
%%Butter Order
Or = 4;

tr = 2;
leeg = 0.45;
srate = 500;
sennum = 30;

whatkmeans = 'kmeiod';



%%%%%%%Code
sv_pro = cell(1, participantes);
all_X_Y = cell(2, participantes);
pars = cell(1, participantes);
for fil = 1:participantes
%for fil = 7
	%%Load data using eeglab
	[EEG, qualevnt_all, elecruid, exdt] = Build_EEG_Mat(sim, fil, resampl, Lowcut,Upcut, Notch, tresh, autorejec, filtering, chanrejec, eventos, t, tb, sigma, lengthSeq, tr, leeg, srate, sennum,  electrodes, participantes, usefil, Or, std_fac);
	all_X_Y{1, fil} = EEG;
	keyboard
	all_X_Y{2, fil} = qualevnt_all;
	pars{fil} = exdt;
end
%%%For each electrode
elnum = 0;

for e = electrodes
	elnum = elnum +1;
	for fil = 1:participantes
		qualevnt = all_X_Y{2, fil};
		[placement, Tree] = Find_Placement(qualevnt, 0:1:length(eventos)-1, h_t);
		datamat_a = all_X_Y{1, fil};
		datamatfull = squeeze(datamat_a(elnum, :, end-length(placement)+1:end))';
		kmax = max(placement);
	    if fil == 1 && elnum == 1;
			kclust = nan(length(qualevnt)-h_t, kmax-1, length(electrodes), participantes);
			dataTrees = cell(length(electrodes), participantes);
			placeEquae = cell(2, participantes);
			MDisMat = cell(length(electrodes), participantes);
			all_kstar = nan(length(electrodes), participantes);
		end
		addpath('/var/tmp/CopyOfData/MATLAB/EstimateContextTree/')
		placeEquae{1, fil} = placement;
		placeEquae{2, fil} = qualevnt;
		dataTrees{elnum, fil} = estimate_functionalSeqRoCTM(qualevnt(h_t:end), datamatfull', 0:1:length(eventos), h_t, numdist, alpha, alpha);
		[datamat, ~] = GenKDataCont(datamatfull, placement, numdist);
		sv_pro{fil} = datamat;
		MDis = [];
		MDis = SetsDists(datamat, placement, ksd);
		disp('Here')
		MDisMat{elnum, fil} = MDis;
	end
	disp(e)
end

%MDisMat(find(cellfun('length',MDisMat) ~= max(cellfun('length', MDisMat)))) = [];
[hort, vert] = size(MDis);
all_clus = nan(kmax-1, length(MDis(1)));
whclus = cell(participantes, length(electrodes));
whois = cell(3, participantes, length(electrodes));

if useavg == 1;	
	al_k = [];
	vv = nan(kmax-1,max(placement),length(electrodes));
	kclust = kclust(:, :, :, 1);
	for we = 1:length(electrodes)
		Mt = nan([hort vert]);
		gvet = nan(1, participantes);
		for h = 1:hort
			for v = 1:vert
				for fil = 1:participantes
					gvet(fil) = MDisMat{we, fil}(h, v);
				end
				if avgormedian == 1
					Mt(h, v) = mean(gvet);
				else
					Mt(h, v) = median(gvet);
				end
			end		
		end
		for k = 2:kmax
            clusters = Which_cluster([1:1:max(placement)]',k, whatkmeans, Mt)';
			vv(k-1, :, we) = clusters;
			for putinposition = 1:length(placement)
                indices(putinposition) = clusters(placement(putinposition))-1;
            end
			disp(['Start Clustering for K = ' num2str(k)])
            kclust(1:length(indices), k-1, we) = indices;
        end
		[kstar resul maxdistperk posofmax] = SimilarityInLaw(Mt, placeEquae, elnum, fil, datamat, ksd, alpha, vv(:, :, we));
		clusstar = vv(kstar-1, :, we);
		whclus{1, we} = clusstar;
		disp(kstar)
		al_k = [al_k kstar];
		whois{1, 1, we} = resul;
		whois{2, 1, we} = maxdistperk;
		whois{3, 1, we} = posofmax;
		[ChTr, LogLik, PenCons] = EEG_Champion(kclust(:, kstar-1, we)');
		if isempty(ChTr)
			hti = {};
			ltree(1, we, 1) = 0;
			champion(1, we, 1) = {hti};
		else
			hti = BootChampion(ChTr, kclust(:, kstar-1, we)', 200, 400);
			ltree(1, we, 1) = max(cellfun('size', hti, 2));
			champion(1, we, 1) = {hti};
		end
	end
	whois = squeeze(whois);
	%whclus = whclus{1, :};
	ltree = squeeze(ltree);
	champion = squeeze(champion);
elseif useavg == 2
	al_k = nan(participantes, length(electrodes));
	vv = nan(kmax-1,max(placement),length(electrodes), participantes);
	for fil = 1:participantes
		for we = 1:length(electrodes)
			for k = 2:kmax
				clusters = Which_cluster([1:1:max(placement)]',k, whatkmeans, MDisMat{we, fil})';
				vv(k-1, :, we, fil) = clusters;
				for putinposition = 1:length(placement)
					indices(putinposition) = clusters(placement(putinposition))-1;
				end
				disp(['Start Clustering for K = ' num2str(k)])
				kclust(1:length(indices), k-1, we, fil) = indices;
			end
			[kstar resul maxdistperk posofmax] = SimilarityInLaw(MDisMat{we, fil}, placeEquae, elnum, fil, sv_pro{fil}, ksd, alpha, vv(:, :, we, fil));
			whois{1, fil, we} = resul;
			whois{2, fil, we} = maxdistperk;
			whois{3, fil, we} = posofmax;
			if kstar-1 <= 0 
				keyboard
			end
			clusstar = vv(kstar-1, :, we, fil);
			whclus{fil, we} = clusstar;
			al_k(fil, we) = kstar;
			[ChTr, LogLik, PenCons] = EEG_Champion(kclust(:, kstar-1, we, fil)');
			if isempty(ChTr)
				hti = {};
				ltree(fil, we, 1) = 0;
				champion(1, we, fil) = {hti};
			else
				hti = BootChampion(ChTr, kclust(:, kstar-1, we, fil)', 200, 400);
				ltree(fil, we, 1) = max(cellfun('size', hti, 2));
				champion(1, we, fil) = {hti};
			end
		end
	end
elseif useavg == 3
	vv = nan(kmax-1,max(placement),length(electrodes), participantes);
	for fil = 1:participantes
		for we = 1:length(electrodes)
%			for k = 2:kmax
			for k = [8]

				if size(MDisMat{1}, 2) < k
					clusters = [1:1:size(MDisMat{1}, 2)];
					vv(k-1, 1:length(clusters), we, fil) = clusters;
					if length(clusters) < max(placement)
						keyboard
					end
					for putinposition = 1:length(placement)
						indices(putinposition) = clusters(placement(putinposition))-1;
					end
					disp(['Start Clustering for K = ' num2str(k)])
					kclust(1:length(indices), k-1, we, fil) = indices;
				else
					clusters = Which_cluster([1:1:length(MDisMat{we, fil})]',k, whatkmeans, MDisMat{we, fil})';
					vv(k-1, 1:length(clusters), we, fil) = clusters;
					if length(clusters) < max(placement)
						keyboard
					end
					for putinposition = 1:length(placement)
						indices(putinposition) = clusters(placement(putinposition))-1;
					end
					disp(['Start Clustering for K = ' num2str(k)])
					kclust(1:length(indices), k-1, we, fil) = indices;
				end
			end
%			for k = 1:kmax-1
			for k = [7]
				[ChTr, LogLik, PenCons] = EEG_Champion(kclust(:, k, we, fil)');		
				if isempty(ChTr)
					hti = {};
					ltree(fil, we, k) = 0;
					champion(1, we, fil) = {hti};
				else
					hti = BootChampion(ChTr, kclust(:, k, we, fil)', 200, 400);
					ltree(fil, we, k) = max(cellfun('size', hti, 2));
					champion(k, we, fil) = {hti};
				end
			end
		end
	end
end


keyboard

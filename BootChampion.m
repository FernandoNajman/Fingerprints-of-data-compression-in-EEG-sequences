function TrueTree = BootChampion(ChTr, seq, nrep, tamblocks)
%%%BootChampion
%%% This function returns the context tree model in the set of the champion trees that best explain the sequence of symbols observed.
%%% ChTr is the set of champion trees, in the order from the largest to the smallest.
%%% seq is the sequence of symbols form which we want to retrieve the context tree.
%%% nrep is the number of resamplings of the bootstraping algorithm.
%%% TrueTree is the retrieved tree.

resp = 1; %In the case that no tree is identified as the right one, the algorithm retunrs the complete tree.

if min(seq) > 0 
	seq = seq-min(seq);
end

blocks = 0;
blocksok = 0;
for i = 1:numel(ChTr)-1 %We take two consecutive trees in the champion set.
	T1 = ChTr{i};
	T2 = ChTr{i+1};


	if isempty(T2) && i == 1  %Precaution in the case the champion trees has returned only the complete tree and the empty tree.
		break
	else


		[useleaf, oneempty] = FindLeafForBoot(T1, T2, seq); %Find which leaf of the trees to use to do the bootstrap.
		%keyboard
		disp(['Useleaf = ' num2str(useleaf)])
		if length(blocks) <= tamblocks
			blocks = BlocksForBoot(useleaf, seq); %Create the independent blocks for the bootstraping.
		else
			blocksok = 1;
		end
		tamboot = length(seq);
		a = 0;%See if it is necessary to enlarge the resamplet sized latter.

		pg = 0; 
		while pg == 0
			if a ~= 0 || blocksok == 0
				[bootseqs, sizeblocks] = GenBoot(blocks, tamboot, nrep);%Generate the new samples.
			end
			if sizeblocks == 1
				h = 0;
				break
			end

			[h, tz] = StatisticBoot(T1, T2, bootseqs, seq, nrep);%Run the statistic as in the original paper.
			if tz == 1 
				pg = 1; %Return the test result,
			else
				tamboot = round(tamboot*1.2); %Or, to be sure, repeat the test with a larger resamples.
				a = a+1;
				disp(['Repetition of the test =' num2str(a)])
				if a == 5
					pg = 1; %If this continues to give too many zeroes, accept the result.
				end
				%nrep = round(nrep*1.2);
			end
		end
		if h == 1 %If the null hypoteses is rejected, return the first tree as the true tree.
			resp = i;
			break
		end
	end
end
TrueTree = ChTr{resp}; %Identify the correct tree.

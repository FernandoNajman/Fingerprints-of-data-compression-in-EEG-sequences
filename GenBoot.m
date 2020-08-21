function [bootseqs, sizeblocks] = GenBoot(blocks, sizeb, nrep)
sizeblocks = 0;
lblock = length(blocks);
if length(blocks) < 15%If the most common leaf is to rare, it isnt possible to do the bootstrap.
	disp(['Number of blocks (' num2str(length(blocks)) ') is to small to properly bootstrap the sequence'])
	bootseqs = [];
	sizeblocks = 1;
	return
end
%Create the new samples.
bootseqs = nan(nrep, sizeb);
for i = 1:nrep
	bootseq = [];

	while length(bootseq) < sizeb+(sizeb/10)
		ran = randperm(lblock);
		bootseq = [bootseq blocks{ran(1)}];
	end
	bootseq = bootseq(end-sizeb+1:end);
	bootseqs(i, :) = bootseq;
end

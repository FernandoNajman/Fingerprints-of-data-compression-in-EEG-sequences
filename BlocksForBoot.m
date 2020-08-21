function [blocks, overleap] = 	BlocksForBoot(useleaf, seq)
overleap = 0;%Verify if the chosen leaf overeleaps with it self.
for j = 1:length(useleaf)
	if sum(useleaf(end-j+1:end) == useleaf(1:j)) == j &&  length(useleaf(1:j)) ~= length(useleaf)
		overleap = overleap + 1;%If there exists an oveleap, wait to completely see again the leaf before sniping the block.
		%break
	end
end

%Find the blocks.
blstrt = find(find_seq(seq, useleaf));
blocks = cell(1, numel(blstrt)-1-overleap);
for i = 1:numel(blstrt)-1-overleap

	blocks{i} = seq(blstrt(i)+1:blstrt(i+1+overleap));
end
%This helps me see in the prompt how common are the leafs used. Can be deleted with no consequences.
disp(['Numberof blocks = ' num2str(length(blocks))])
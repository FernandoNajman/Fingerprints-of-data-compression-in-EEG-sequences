%%% Retrieve the champion trees from a vector taking value in finite space.
function [aa, bb, cc]= EEG_Champion(seqk)


alph = unique(seqk);
if length(alph) ~= max(alph)+1
	for repl = 1:length(alph)
		seqk(seqk == alph(repl)) = repl -1;
	end
end
ksz = length(alph)-1;
if min(seqk) > 0 
	seqk = seqk-min(seqk);
end
con = 10;
if sum(seqk ~= seqk(1)) == 0
	aa = {};
	bb = 0;
	cc = 0;
	return
end

[c, ~] = estimate_contexttree(seqk, 0:1:ksz, ceil(log(length(seqk))/log(length(0:1:ksz))), 'bic', con);

if isempty(c);
    [aa, bb, cc] = estimate_championTrees(seqk, ceil(log(length(seqk))/log(length(0:1:ksz))), 0:1:ksz);
else
    while ~isempty(c);
        con = con+round(con*0.4);
		disp(['New constant = ' num2str(con)])
        [c, ~] = estimate_contexttree(seqk, 0:1:ksz, ceil(log(length(seqk))/log(length(0:1:ksz))), 'bic', con);
    end
    [aa, bb, cc] = estimate_championTrees(seqk, ceil(log(length(seqk))/log(length(0:1:ksz))), 0:1:ksz, 0, con);
end


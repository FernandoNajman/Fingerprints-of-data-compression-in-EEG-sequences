function [kstar resul maxdistperk posofmax] = SimilarityInLaw(MDis,  placeEquae, e, fil, datamat, ksd, alpha, vv)

if iscell(placeEquae)
	placement = placeEquae{1, fil};
else
	placement = placeEquae;
end
if ksd == 1
	nrp = (length(datamat(1, :))-1)/datamat(1, end);
	crit = binoinv(1-0.1, nrp, 0.1);
	usecrit = crit/nrp;
else
	usecrit = sqrt(-1/2 * (log(alpha/2)));
end
[resul, maxdistperk, posofmax] = MnDistLaw(MDis, placeEquae, e, fil, vv);
kstar = 0;
for i = 1:length(resul)
	l = posofmax{i};
	tsts = MDis(l(1), l(2));
%	tsts = KSdist(datamat(l(1), :), datamat(l(2), :));
	if tsts <= usecrit && i < length(resul)
		kstar = i+1;
		break
	elseif i == length(resul)
		kstar = length(maxdistperk{end});
	end
end

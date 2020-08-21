function [resul, maxdistperk, posofmax] = MnDistLaw(MDis, placeEquae, e, par, vvv)

if iscell(placeEquae)
	placement = placeEquae{1, par};
else
	placement = placeEquae;
end
resul = nan(1, max(placement)-1);
posofmax = cell(1, max(placement)-1);
maxdistperk = cell(1, max(placement)-1);
for k = 2:max(placement)
%	if max(placement) ~= 12
%		keyboard
%	end
	%for i = 1:max(placement)
%		asd = kclust(placement == i, k-1, e, par);
%		if sum(asd == asd(1)) ~= length(asd)
%			keyboard
%		end
%		vv(i) = asd(1);
%	end
%	vv = RetrieveClus(kclust, placeEquae, k, e, par);	
	vv = vvv(k-1, :);
%	if length(unique(vv)) ~= k
%		keyboard
%	end
	grd = [];
	avgsofcl = nan(1, k);
	for j = 1:k
		psi = find(vv == j);
		grd = MDis(psi, psi);
		if isempty(grd)
			avgsofcl(isnan(avgsofcl)) = [];
			break
		else
			avgsofcl(j) = max(max(grd));
		end
	end
	[p1 p2] = find(triu(MDis) == max(avgsofcl));
	posofmax{k-1} = [p1(1) p2(1)];
	maxdistperk{k-1} = avgsofcl;
	
	if max(avgsofcl) ~= 0
		resul(k-1) = max(avgsofcl);
	else
		resul(k-1) = max(avgsofcl);
		if k ~= (max(placement))
			for rep = k+1:(max(placement))
				%keyboard
				p1 = 1;
				p2 = 1;
				posofmax{rep-1} = [p1(1) p2(1)];
				maxdistperk{rep-1} = [avgsofcl 0];
				resul(rep-1) = 0;
			end
		end
		break
	end

end
%keyboard
function clus = RetrieveClus(kclust, placeEquae, k, e, fil)

if iscell(placeEquae)
	placement = placeEquae{1, fil};
else
	placement = placeEquae;
end
%kmax = length(kclsut(1, :, 1, 1));
clus = nan(1, max(placement));
for i = 1:max(placement)
	wh = kclust(placement == i, k-1, e, fil)';
	clus(i) = wh(1);
end

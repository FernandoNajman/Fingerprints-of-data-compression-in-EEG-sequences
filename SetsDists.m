function MDis = SetsDists(datamat, placement, ksd)
MDis = nan(size(datamat, 1));
for i = 1:max(placement)
	for j = 1:max(placement)
		if ksd == 1;
			MDis(i, j) = KSdist(datamat(i, :), datamat(j, :));
		elseif ksd == 2;
			MDis(i, j) = KSdist_old(datamat(i, :), datamat(j, :));
		end
	end
end

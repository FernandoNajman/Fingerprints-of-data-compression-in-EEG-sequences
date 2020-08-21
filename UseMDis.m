function KSD = UseMDis(X1, X2, MDis)
%keyboard
sz = size(X2);
lX2 = sz(1);
if length(sz) > 2
	keyboard
end
KSD = nan(1, lX2);
for dorep = 1:lX2;
	KSD(1, dorep) = MDis(X1, X2(dorep));
end
KSD = KSD';

function newmat = medianlaws(MDisMat)
newmat = nan(12, 12, 18);
for e = 1:18

%a1 = 1;
%a2 = 1;

for a1 = 1:12
for a2 = 1:12
	vsv = [];

for par = 1:18
	mm = MDisMat{e, par}>binoinv(1-0.1, 5000, 0.1)/5000;
	vsv = [vsv mm(a1, a2)];
end
newmat(a1, a2, e) = median(vsv);
%newmat(a1, a2, e) = mean(vsv);
end


end
end
keyboard
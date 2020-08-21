function [dataCont, sizeofmax] = GenKDataCont(datamat, placement, numdist)


for i = 1:max(placement)
    a(i) = sum(placement == i);
end
dataCont = zeros(max(placement), max(a)*numdist+1);
browns = nan(numdist, length(datamat(1, :)));
for proj = 1:numdist
    browns(proj, :) = Brownian_Brigde(length(datamat(1, :)));
end

for j = 1:max(placement)
       vet = find(placement == j);
       for aa = 1:sum(placement == j)
           for b = 1:numdist
               dataCont(j, aa+(max(a)*(b-1))) = dot(datamat(vet(aa), :), browns(b, :)); 
           end
       end
       dataCont(j, end) = max(a);
end
sizeofmax = max(a);

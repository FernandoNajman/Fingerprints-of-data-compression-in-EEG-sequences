function KSD = KSdist_old(X1, X2)

[lX2, ~] = size(X2);

sizerep = X1(1, end);
newX1 = X1(1:end-1);
KSDrep = nan(length(newX1)/sizerep, lX2);


for dorep = 1:lX2;
    newX2 = X2(dorep, 1:end-1);
    for posicao = 1:length(newX1)/sizerep;
		Z1 = newX1(1+(sizerep*(posicao-1)):sizerep+(sizerep*(posicao-1)));
		Z2 = newX2(1+(sizerep*(posicao-1)):sizerep+(sizerep*(posicao-1)));
		Z1(Z1 == 0) = [];
		Z2(Z2 == 0) = [];
		data = [-inf, sort([Z1 Z2]), inf];
		H1 = histc(Z1 , data);
		H2 = histc(Z2 , data);
		C1 = cumsum(H1)./sum(H1);
		C2 = cumsum(H2)./sum(H2);
		KSDrep(posicao, dorep) = max(abs(C1-C2))*sqrt(length(Z1)*length(Z2)/(length(Z1)+length(Z2)));

    end
end

KSD = mean(KSDrep);


function vetfunc =  AutoModGen(Parmt, lengthfunc, sigma)
past = length(Parmt)-1;
invet = ones(1, past);
vetfunc = nan(1, 4*lengthfunc);
vetfunc(1:past) = invet;
c = Parmt(1);
compon = nan(1, past);

for i = past+1:length(vetfunc)
	for j = 1:past
		compon(j) = vetfunc(i-j)*Parmt(end-j+1);
	end
	vetfunc(i) = c+sum(compon)  + normrnd(0, sigma);
end
vetfunc = vetfunc(end-lengthfunc+1:end);

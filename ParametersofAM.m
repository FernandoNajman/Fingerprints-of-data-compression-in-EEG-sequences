function Parmtmat = ParametersofAM(tamvet, numpar)
Parmtmat = nan(tamvet, numpar);
for i = 1:tamvet
	Parmtmat(i, :) = (rand(1, numpar)-0.5)*2;
end

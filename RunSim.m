function [X,Y_all, extradata] = RunSim(sigma, lengthSeq, datatype, usecontx, ctxs, P, A, leeg, sennum, srate, X, elnum)



%Trees2Use;
eegmat = ContEGG(length(ctxs), leeg, srate, sennum);


Parmtmat = ParametersofAM(length(ctxs), 3);
%Parmtmat(:, 1) = 0;

Y_all = cell(1, elnum);

for i = 1:elnum
	if datatype == 1 || datatype == 2
		Y = Ygen(X, eegmat, ctxs, P, sigma, datatype, usecontx);
		extradata = eegmat;
		Y_all{i} = Y;
	elseif datatype == 3
		%Parmtmat = ParametersofAM(length(ctxs), floor(log(leeg*srate)));
		Y = YgenAutoMod(X, Parmtmat, ctxs, sigma, leeg*srate);
		extradata = Parmtmat;
		Y_all{i} = Y;
	else
		disp('Error, simulation with model undefined.')
		return
	end
end


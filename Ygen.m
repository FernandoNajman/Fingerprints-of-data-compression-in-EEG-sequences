function Y = Ygen(X, eegmat, ctxs, P, sigma, datatype, usecontx)
value = randperm(length(ctxs));
Y = nan(length(X), length(eegmat(1, :)));



for i = max(cellfun('size',ctxs,2)):length(X)

    for j = 1:length(ctxs)
        if i < max(cellfun('size',ctxs,2))
            if sum(X(1:i) == ctxs{j}) == i
                %Y(i, :) = RuidFun(eegmat(j, :), sigma);  Need one more
                %argument
            end
        end
        
        if sum(X(i-length(ctxs{j})+1:i) == ctxs{j}) == length(ctxs{j})
            if datatype == 1;
				if usecontx == 1
					Y(i, :) = RuidFun(eegmat(j, :), sigma, 1);
				elseif usecontx == 2
					probmeas = unique(P, 'rows');
					[s1 s2] = size(probmeas);
					for z = 1:s1
						if sum(P(j,:)==probmeas(z, :)) == s2
							Y(i, :) = RuidFun(eegmat(z, :), sigma, 1);
						end
					end
				elseif usecontx == 3
					if i == max(cellfun('size',ctxs,2))
						Y(i, :) = RuidFun(eegmat(j, :), sigma, 1);
					else
						Liks = unique(P)';
						Liks(Liks==0) = [];
						A = unique(X);
						evnt = find(A == X(i));
						for w = 1:length(ctxs)
							if sum(X(i-length(ctxs{w}):i-1) == ctxs{w}) == length(ctxs{w})
								posctx = w;
							end
						end
						surp = find(Liks == P(posctx, evnt));
						Y(i, :) = RuidFun(eegmat(surp, :), sigma, 1);
					end
				end
            elseif datatype == 2;
                Y(i, :) = Brownian_Brigde(length(eegmat(j, :)))*value(j);
            end
        end
        
        
    end
end
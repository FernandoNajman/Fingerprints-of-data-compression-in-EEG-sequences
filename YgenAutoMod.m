function Y = YgenAutoMod(X, Parmtmat, ctxs, sigma, nfun)

Y = nan(length(X), nfun);

for i = max(cellfun('size',ctxs,2)):length(X)

    for j = 1:length(ctxs)
        if i < max(cellfun('size',ctxs,2))
            if sum(X(1:i) == ctxs{j}) == i
                %Y(i, :) = RuidFun(eegmat(j, :), sigma);  Need one more
                %argument
            end
        end
        
        if sum(X(i-length(ctxs{j})+1:i) == ctxs{j}) == length(ctxs{j})
                Y(i, :) = AutoModGen(Parmtmat(j, :), nfun, sigma);
        end
        
        
    end
end
%keyboard
%%% Bad fucntion name. Assings to each position a number representing a
%%% string of length h_t. Note that it shortens the size of the vector by
%%% h_t.
function [placement, tree] = Find_Placement(qualevnt, A, h_t)
addpath('/var/tmp/CopyOfData/MATLAB/EstimateContextTree/')

placement = nan(1, length(qualevnt)-h_t+1);
[tree, ~, ~] = completetree(qualevnt, h_t, A);
for n = h_t:length(qualevnt)
    [c, ~] = contextfunction(qualevnt(1:n), tree);
    for b = 1:length(tree)
        if isequal(tree{b}, c)
            placement(n-h_t+1) = b;
        end
    end
end

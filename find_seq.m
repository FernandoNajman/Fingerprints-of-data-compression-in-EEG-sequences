%%% Finds the position of specific sequences in an vector.
function v_str = find_seq(seq, str)
v_str = nan(1, length(seq));
v_str(1:length(str)-1) = 0;
for q = length(str):length(seq)
    if sum(seq(q-length(str)+1:q) == str) == length(str)
        v_str(q) = 1;
    else
        v_str(q) = 0;
    end
end
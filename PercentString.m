function num = PercentString(sec, str)

num = 0;
for i = length(str):length(sec)
	if isequal(sec(i-length(str)+1:i), str)
		num = num + 1;
	end
end
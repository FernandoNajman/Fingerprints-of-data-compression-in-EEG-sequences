function [useleaf, oneempty] = FindLeafForBoot(T1, T2, seq)

%Invert the order of the leafs in the champion tree set so the smalles leafs appear first.
T1 = fliplr(T1);
T2 = fliplr(T2);

%Verify if any tree is empty. If one of them is, this should indicate that the correct tree is the complete tree or the empty tree.
oneempty = 0;

if isempty(T1) || isempty(T2)
	if isempty(T1) && ~isempty(T2)
		T1 = T2;
		oneempty = 1;
	elseif ~isempty(T1) && isempty(T2)
		oneempty = 1;
	elseif isempty(T1) && isempty(T2)
		disp('Both trees are empty, this isnt possible.')
		return
	end
end


%Identify how many time each leaf of the largest tree appear in the sequence.
sleaf = nan(1, length(T1));
for i = 1:length(T1)
	sleaf(i) = PercentString(seq, T1{i});
end
sleaf2 = sleaf;
ordr = [];



%Order the leafs according to the number of times they appeared.
while sum(sleaf2) ~= numel(sleaf)*-1
	nmax = find(sleaf2 == max(sleaf2));
	ordr = [ordr nmax];
	sleaf2(nmax) = -1;
end


%If one of the trees is enpty, use the most common leaf of the tree that isnt as the leaf for the bootstraping.
useleaf = {};
if oneempty == 1
	useleaf = T1{ordr(1)};
end

%Find the alphabet of the sequence of symbols.
alph = unique(seq);
alph = sort(alph);


for i = 1:numel(T1) %For each leaf on the largest tree,
	for j = 1:numel(T2)%and each leaf on the smaller tree,
		if isempty(useleaf) && isequal(T1{ordr(i)}, T2{j})%find the most common leaf of the largest tree that appear on the smaller tree.
			useleaf = T2{j}; 
			for k = 1:numel(T1)%Then, look for each other leaf on the largest tree,
				for aina = alph
					for aina2 = alph
						if PercentString(T1{i}, [aina T1{k} aina2]) > 0%and if this leaf appear inside antother leaf,
							useleaf = {};%dont use this leaf and restar the algorithm.
						end
					end
				end
			end
		end
		if ~isempty(useleaf)%If a leaf with the previous propeties has been found, use it.
			break
		end
	end
	if ~isempty(useleaf)
		break
	end
end
if isempty(useleaf)%As a precaution, shouldnt happen.
	useleaf = T1{ordr(1)};
end


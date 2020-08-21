%%% Defines wich clustering function.
function clusters = Which_cluster(datamat, k, whatkmeans, MDis)


if strcmp(whatkmeans, 'kmeans')
    clusters = kmeans(datamat, k,'MaxIter',1000, 'OnlinePhase','on')';
elseif strcmp(whatkmeans, 'hier')
    %clusters = clusterdata(datamat','distance', KS, 'linkage','ward','SaveMemory','off','Maxclust',k);
    clusters = clusterdata(datamat,'distance', 'euclidean', 'linkage','ward','SaveMemory','off','Maxclust',k);
    %clusters = clusterdata(EEG_nan, k, 'Distance', 'euclidean','SaveMemory', 'off');
elseif strcmp(whatkmeans, 'kmeiod')
    %KS = @KSdist_old;
	%KS = @KSdist;
    %clusters = clusterdata(datamat,'distance', KS, 'linkage','ward','SaveMemory','off','Maxclust',k);
	KS = @(X1, X2) UseMDis(X1,X2, MDis);
	if length(MDis) < k
		clusters = [1:1:k];
	else
		clusters = kmedoids(datamat,k, 'Distance',KS);
	end
end

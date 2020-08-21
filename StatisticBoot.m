function [h, ToZeros] =  StatisticBoot(T1, T2, bootseqs, seq, nrep)

ToZeros = 1;%The t-test assumes normality, which isnt the case. If too many zeroes appear, use this to test if this is distorting the statistics.

%Chose the new samples size.
EstimatLik = nan(2, nrep);
n1 = round(length(seq)*(9.5/10));
n2 = round(length(seq)*(2.5/10));

%Estimate the lok-likelihood of both trees using the new samples up to the lengths defined in the previous step.
for j = 1:nrep
	EstimatLik(1, j) = (treeloglikelihood(T2, bootseqs(j, 1:n1), unique(seq)) - treeloglikelihood(T1, bootseqs(j, 1:n1), unique(seq)));
	disp(['Difference of likelihoods n1 =' num2str(EstimatLik(1, j))])
	EstimatLik(2, j) = (treeloglikelihood(T2, bootseqs(j, 1:n2), unique(seq)) - treeloglikelihood(T1, bootseqs(j, 1:n2), unique(seq)));
	disp(['Difference of likelihoods n2 =' num2str(EstimatLik(2, j))])
end

%Test if the second one is growing in a super-lienar fashion.
h = ttest2(EstimatLik(1, :)/(n1^0.9), EstimatLik(2, :)/(n2^0.9), 'Tail', 'left');
if isnan(h)
	h = 0;
else
	h = h(1);
end


%This is to avoid false positives. The t-test assumes normality, which we dont have here. If too many zeroes happen, test a few more times with a larger resampling size.
EstimatLik2 = EstimatLik(:, (EstimatLik(2, :) ~= 0));
if isempty(EstimatLik2)
	h2 = 0;
else
	h2 = ttest2(EstimatLik2(1, :)/(n1^0.9), EstimatLik2(2, :)/(n2^0.9), 'Tail', 'left');
end
if h ~= h2
	ToZeros = 0;

end
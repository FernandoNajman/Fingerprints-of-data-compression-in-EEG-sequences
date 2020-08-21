function eegmat = ContEGG(numcon, leeg, srate, sennum)

eegmat = nan(numcon, leeg*srate);


for i = 1:numcon
   freqs = rand(sennum, 1)*40';
   eegmat(i, :) =  FakeEEG(leeg, srate, freqs');
end

function fakeeeg = FakeEEG(leeg, srate, freqs)
feeg = nan(length(freqs), leeg*srate);
for i = 1:length(freqs)
    feeg(i, :) = GenFun(freqs(i), leeg, srate);    
end
fakeeeg = sum(feeg)/length(freqs);
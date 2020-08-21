function stim = GenFun(freq, leeg, srate)
tamanho = round(leeg*srate);
angu = linspace(0, 2*pi, srate);
stim = sin(angu*freq);
stim = stim(1:tamanho);
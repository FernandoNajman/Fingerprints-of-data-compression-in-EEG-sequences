%%% Finds the timefame of noisy data in the EEG. Does not removes it from
%%% the struct, indicates wich epochs are noisy only.
function elecruid = EEG_AutoReject(EEG)
elecruid = [];

    [~, selectedregions]  = pop_rejcont(EEG,'freqlimit', [20 40],'epochlength', 0.4, 'overlap', 0.2, 'contiguous',4,'addlength',0.25,'taper','hamming');
    %EEG = pop_select( EEG,'nopoint', selectedregions);
    eeg_checkset(EEG);
    %useless = 0;
           for ruido = 1:length(selectedregions)
			   for evln = 1:length(EEG.event)-1
%               if evln ~= length(EEG.event)
                   v1 = selectedregions(ruido, :);
                   v2 = [EEG.event(evln).latency, EEG.event(evln+1).latency];
                   %if overlaps
                   if ~(v2(1)>v1(2)) && ~(v1(1)>v2(2))
                       %useless = useless +1;
                       elecruid = [elecruid, 1];
                   else
                       elecruid = [elecruid, 0];
                   end
               end
           end
%                     if useless == 0;
%                         elecruid = [elecruid, 0];
%                     else
%                         elecruid = [elecruid, 1];
%                     end

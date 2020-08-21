%%% Creates an struct from the rhythm EEG with the data of ony one tree.
function EEG = Data_Rythm2Freq(base_rootdir, end_file,  Data_tree, input, eventos)
%% Files menagement
 %Param;

 anapath = '/var/tmp/CopyOfData/MATLAB/eeg-tree-algorithms-master/';
 addpath(genpath(anapath));
 rootdir = fullfile( base_rootdir);

 files = dir( fullfile( rootdir, end_file ));
 k = input;
    ALLEEG={};
    %% Importing
%   EEG = pop_readegi( fullfile( rootdir, files(k).name ), [], [], 'GSN_HydroCel_129.sfp' );
    EEG = pop_readegi(fullfile(rootdir, files(k).name), [],[],'auto');
    EEG.setname = files(k).name(1:end-4);
    EEG.filename=EEG.setname;
    volname=EEG.filename(1:3);
        %% Sharing in blocks
    eventcells = squeeze( struct2cell( EEG.event ) );
    foundevents = find( strcmp( eventcells(1,:), 'sil ' ) ); % vetor das posicoes em que o evento aparace em eventcells
    indices = cell2mat( {EEG.event(foundevents).latency} ); % vetor das latências desse evento
    if length( indices ) > 13
        EEG_b1 = pop_select( EEG, 'point', [indices(1)  indices(14)] );
        EEG_b1.filename=['B1' EEG_b1.filename];
    else
        warning( sprintf( 'could not segment file %s, too small (less than 1 block)', files(k).name ) )
    end
    if length( indices ) > 28
        EEG_b2 = pop_select( EEG, 'point', [indices(15)  indices(29)] );
        EEG_b2.filename=['B2' EEG_b2.filename];
    else
        warning( sprintf( 'could not segment file %s, too small (less than 2 blocks)', files(k).name ) )
    end
        indices = getEventPointsIndices( EEG_b1, 'sil ' ); %encontra as latencias dos sil's
    inds = strfind( files(k).name, '_' );
    ritmo = files(k).name(inds(end)+1);
    if strcmpi( ritmo , 'T' ),
       ritmo_nome = 'Ter';
       ind=1;
       elseif strcmpi( ritmo, 'Q' );
       ritmo_nome = 'Qua';
       ind=2;
       elseif strcmpi( ritmo, 'I' );
       ritmo_nome = 'Ind';
       ind=3;
    end
    EEG_ritmo = pop_select( EEG_b1, 'point', [indices(1)  indices(4)] );
    EEG_ritmo.filename=[ritmo_nome 'B1' EEG_ritmo.setname];
    ALLEEG_aux={};
    ALLEEG_aux=eeg_store(ALLEEG_aux,  EEG_ritmo,ind);
    ALLEEG_aux(ind).setname=[ritmo_nome 'B1' EEG.setname];
    for r=1:2
        ritmo = files(k).name(inds(end)+1+r);
        if strcmpi( ritmo , 'T' ),
           ritmo_nome = 'Ter'; ind=1;
           elseif strcmpi( ritmo, 'Q' );
           ritmo_nome = 'Qua'; ind=2;
           elseif strcmpi( ritmo, 'I' );
           ritmo_nome = 'Ind'; ind=3;
        end
        EEG_ritmo = pop_select( EEG_b1, 'point', [indices(r*5)  indices(4+5*r)] );
        EEG_ritmo.filename=[ritmo_nome 'B1' EEG_ritmo.setname];
        ALLEEG_aux=eeg_store(ALLEEG_aux,  EEG_ritmo,ind);
        ALLEEG_aux(ind).setname=[ritmo_nome 'B1' EEG.setname];
    end
    indices = getEventPointsIndices( EEG_b2, 'sil ' );
    ritmo = files(k).name(inds(end)+3);
    if strcmpi( ritmo , 'T' ),
       ritmo_nome = 'Ter'; ind=1;
       elseif strcmpi( ritmo, 'Q' );
       ritmo_nome = 'Qua'; ind=2;
       elseif strcmpi( ritmo, 'I' );
       ritmo_nome = 'Ind'; ind=3;
    end
    EEG_ritmo = pop_select( EEG_b2, 'point', [indices(2)  indices(5)] );
    EEG_ritmo.filename=[ritmo_nome 'B2' EEG_ritmo.setname];
    ALLEEG_aux=eeg_store(ALLEEG_aux,  EEG_ritmo,ind+3);
    ALLEEG_aux(ind+3).setname=[ritmo_nome 'B2' EEG.setname];
    for r=1:2
        ritmo = files(k).name(inds(end)+3-r);
        if strcmpi( ritmo , 'T' ),
          ritmo_nome = 'Ter'; ind=1;
        elseif strcmpi( ritmo, 'Q' );
          ritmo_nome = 'Qua'; ind=2;
        elseif strcmpi( ritmo, 'I' );
          ritmo_nome = 'Ind'; ind=3;
        end
        EEG_ritmo = pop_select( EEG_b2, 'point', [indices(r*5+2)  indices(5*(r+1))] );
        EEG_ritmo.filename=[ritmo_nome 'B2' EEG_ritmo.setname];
        ALLEEG_aux=eeg_store(ALLEEG_aux,  EEG_ritmo,ind+3);
        ALLEEG_aux(ind+3).setname=[ritmo_nome 'B2' EEG.setname];
    end
    %% Merging Dataset
    EEG_ter=pop_mergeset(ALLEEG_aux(1),ALLEEG_aux(4));
    ALLEEG=eeg_store(ALLEEG,  EEG_ter,1);
    ALLEEG(1).setname=['Ter' EEG_ter.filename(6:8)];

    EEG_qua=pop_mergeset(ALLEEG_aux(2),ALLEEG_aux(5));
    ALLEEG=eeg_store(ALLEEG,  EEG_qua,2);
    ALLEEG(2).setname=['Qua'  EEG_qua.filename(6:8)];
    if strcmp(Data_tree, 'Qua')
        EEG = ALLEEG(2);
    else
        EEG = ALLEEG(1);
    end

    for s = 1 : length(EEG.event)
        if strcmp(EEG.event(s).type, 'miss') || strcmp(EEG.event(s).type, 'v0  ')
            EEG.event(s).type = 'S  1';
        end

        if strcmp(EEG.event(s).type, 'v1a ') || strcmp(EEG.event(s).type, 'v1b ')
            EEG.event(s).type = 'S  2';
        end
 
        if strcmp(EEG.event(s).type, 'v2  ')
            EEG.event(s).type = 'S  3';
        end
    end

    %ParamClus
    delet = [];
    for indi = 1:length(EEG.event)
        if ~any(strcmp(EEG.event(indi).type, eventos))
            delet = [delet, indi];
        end
    end
    EEG.event(delet) = [];
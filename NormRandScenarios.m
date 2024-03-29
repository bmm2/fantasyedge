% rndscenarioMatrix:
% This file just calculates the random scenarios for the week of interest,
% junk2 finds the standard deviation for that week

ns = 20;
[p10, d10] = LoadFFData(10);
positions = {'qb'; 'rb'; 'wr'; 'te'; 'k'; 'def' };
%Coefficient of variation of Def allowed for each position wr = qb = te
defV_CV = [0.70; 0.65; 0.70; 0.70; 0.63; 0.54];
% NFL average FF pts allowed for this position
for n = 1:length(positions)
    % NFL average FF pts allowed for this position
    defVpos_nfl = mean(d10.(positions{n}).FFPtsPG);
    % Number of defenses (=32)
    np = length(d10.(positions{n}).Team);
    % Initialize output data structure
    bob = 1;
    for p = 1:np
    defVpos_avg = d10.(positions{n}).FFPtsPG(p);
    defVpos_ravg = normrnd(defVpos_avg, defV_CV(n)*defVpos_avg, 1, ns);
%     def_rndsc(p,:,n) = defVpos_ravg./defVpos_nfl;
    def_rndsc.(positions{n})(p,:) = defVpos_ravg./defVpos_nfl;
    end
end

%Need to run junk2 first!!!
for n = 1:length(positions)
    np = length(p10.(positions{n}).Name);
    bob = 1;
    for p = 1:np
        pavg = p10.(positions{n}).AVG(p);
        pstd = FFPstd.(positions{n})(p);
    	p_rndsc = normrnd(pavg, pstd, 1, ns);
         % Lookup opponent pts allowed
        opp_index = find( strcmp(p10.(positions{n}).Opp(p), d10.(positions{n}).Team) );
        if ( isempty(opp_index) )
            error('Could not find an opponent for %s', pdata.(positions(n)).Opp(p));
        end
        FFp_rndsc.(positions{n})(p,:) = p_rndsc.*def_rndsc.(positions{n})(opp_index,:);
    end
end

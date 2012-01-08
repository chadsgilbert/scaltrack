function varargout = pcolor_particles(seas, behav, pld, varargin)
%PCOLOR_PARTICLES plot particle distributions from data folder.
%  PCOLOR_PARTICLES compares two different model runs by plotting the resulting
%  particles distributions of each side-by-side.
%
%  PCOLOR_PARTICLES(SEAS, BEHAV, PLD) uses the string arguments to decide which 
%  data to load and plot. To make a comparison, two values for one (and only 
%  one) of these values must be constrasted. To choose these values, provide one
%  (and only one) of these values as a [1x2] cell array of strings instead of 
%  just a string.
%
%  PCOLO_PARTICLES(..., OPTS) The OPTS arguments are optional, and defines the
%  scaling and range of the color axis.
%
%  Example:
%  >> pcolor_particles('fal', {'pa', 'py'}, 'const');
%  compares the model run in fall, with passive vs. pycnocline-seeking behaviour
%  and constant PLD. Passive is plotted on the left, and pycno on the right,
%  because that's how they are arranged in the cell array provided.
%
%See also: Settlement, Track, Domain, Bed, plot_settlement

% Check and assign the input arguments.
opts.pld = pld;
opts.scale = 1;
opts.caxis = [0 5];
opts.compare = [];
opts.datadir = '~/School/results/';
for i = 1:2:(nargin-3)
    opts.(varargin{i}) = varargin{i+1};
end


% Create the load strings.
if iscell(seas) && size(seas,1) == 2 && size(seas,2) == 1
    % Compare two seasons, side-by-side.
    s1 = [seas{1} '_' behav];
    s2 = [seas{2} '_' behav];
    opts.compare = 'season';
    opts.pld = {opts.pld opts.pld};
    h=plot_3x2(s1,s2,opts);
    
elseif iscell(seas) && size(seas,1) == 2 && size(seas,2) == 1
    % compare two seasons, side-by-side.
    s1 = [seas{1} '_' behav];
    s2 = [seas{2} '_' behav];
    opts.compare = 'season';
    opts.pld = {opts.pld opts.pld};
    h=plot_2x3(s1,s2,opts);
    
elseif iscell(behav) && size(behav,1) == 1 && size(behav,2) == 2
    % Compare two behaviours, top-by-bottom.
    s1 = [seas '_' behav{1}];
    s2 = [seas '_' behav{2}];
    opts.compare = 'behaviour';
    opts.pld = {opts.pld opts.pld};
    h=plot_3x2(s1,s2,opts);

elseif iscell(behav) && size(behav,1) == 2 && size(behav,2) == 1
    % Compare two behaviours, side-by-side.
    s1 = [seas '_' behav{1}];
    s2 = [seas '_' behav{2}];
    opts.compare = 'behaviour';
    opts.pld = {opts.pld opts.pld};
    h=plot_2x3(s1,s2,opts);
    
elseif iscell(opts.pld) && size(opts.pld,1) == 1 && size(opts.pld,2) == 2
    % Compare two behaviours, top-by-bottom.
    s1 = [seas '_' behav];
    opts.compare = 'pld';
    h=plot_3x2(s1,s1,opts);
    
elseif iscell(opts.pld) && size(opts.pld,1) == 2 && size(opts.pld,2) == 1
    % Compare two behaviours, side-by-side.
    s1 = [seas '_' behav];
    opts.compare = 'pld';
    h=plot_2x3(s1,s1,opts);
    
elseif ischar([seas behav opts.pld])
    % Just plot one model run.
    s = [seas '_' behav];
    h=plot_1x3_plain(s,opts);

else
    error('Must provide one cell array of strings for comparison.')
end

% Assign the output arguments.
switch nargout
    case 0
    case 1
        varargout{1} = h;
    otherwise
        error('Wrong number of output arguments requested.');
end

end

function h=plot_2x3(s1,s2,opts)
%PLOT_2X3 plots the results in a 2x3 matrix, with all the fixins' on top.
%  PLOT_2X3 gets called whenever a cell array like {'era1'; 'era2'} is passed in
%  to pcolor_larvae.m, making a nice plot for comparison of two model runs.
%
%  PLOT_2X3(S1, S2, OPTS) S! is a string for the top row and S2 is a string for
%  the bottom row. OPTS contains any specified options for the plot, such as the
%  scale factor and color axis range.
%
%  Example: 
%  >> h=plot(s1, s2, opts)
%  plots the run referenced by string S1 and string S2, using the opts in the
%  opts struct.
%
%See also: pcolor_larvae, plot_3x2, plot_1x3, plot_3x1

wb = waitbar(0, 'Loading requested settlement data...');

% load the domain.
datadir = opts.datadir;
load([datadir 'domain.mat']);
load([datadir 'gsc']); load([datadir 'nep']); load([datadir 'sfl']);

bed = {'gsc', 'nep' 'sfl'};

waitbar(0.1, wb);

% Load the left-side data for each bed.
uans = [];

for i = 1:3
    settstr = ['sett_trac_' s1 '_' opts.pld{1} '_' bed{i}];
    if exist([datadir settstr '.mat'],'file')
        load([datadir settstr]);
    elseif exist([datadir 'tr_' s1 '_' bed{i} '.mat'], 'file')
        trstr = ['tr_' s1 '_' bed{i}];
        load([datadir trstr]);
        sett = Settlement(eval(trstr), domain, opts.pld{1});
        eval([settstr ' = sett;']);
        save([datadir settstr], settstr);
    else
        error(['Can''t find file: tr_' s1 '_' bed{i} '.mat']);
    end
    waitbar(i/7.5 + 0.1, wb);
end

% Load the right-side data for each bed.
for i = 1:3
    settstr = ['sett_trac_' s2 '_' opts.pld{2} '_' bed{i}];
    if exist([datadir settstr '.mat'],'file')
        load([datadir settstr]);
    elseif exist([datadir 'tr_' s2 '_' bed{i} '.mat'], 'file')
        trstr = ['tr_' s2 '_' bed{i}];
        load([datadir trstr]);
        sett = Settlement(eval(trstr), domain, opts.pld{2});
        eval([settstr ' = sett;']);
        save([datadir settstr], settstr);
    else
        error(['Can''t find file: tr_' s2 '_' bed{i}]);
    end
    waitbar(i/7.5 + 0.4, wb);
end

waitbar(1, wb);
close(wb);

% Now, make the figure.
h = figure;

h1=subplot(2,3,1); set(h1, 'pos', [.05 .50 .30 .45]);
sett = eval(['sett_trac_' s1 '_' opts.pld{1} '_gsc']);
plot_settlement(sett/opts.scale, domain, gsc, nep, sfl);
caxis(opts.caxis); text(1.25e6, -.30e6, 'a)', 'fontsize', 14);
ylabel(sett.(opts.compare), 'fontsize', 14);
title(sett.bed, 'fontsize', 14);

h2=subplot(2,3,2); set(h2, 'pos', [.35 .50 .30 .45]);
sett = eval(['sett_trac_' s1 '_' opts.pld{1} '_nep']);
plot_settlement(sett/opts.scale, domain, gsc, nep, sfl);
caxis(opts.caxis); text(1.25e6, -.30e6, 'b)', 'fontsize', 14);
title(sett.bed, 'fontsize', 14);

h3=subplot(2,3,3); set(h3, 'pos', [.65 .50 .30 .45]);
sett = eval(['sett_trac_' s1 '_' opts.pld{1} '_sfl']);
plot_settlement(sett/opts.scale, domain, gsc, nep, sfl);
caxis(opts.caxis); text(1.25e6, -.30e6, 'c)', 'fontsize', 14);
title(sett.bed, 'fontsize', 14);

h4=subplot(2,3,4); set(h4, 'pos', [.05 .05 .30 .45]);
sett = eval(['sett_trac_' s2 '_' opts.pld{2} '_gsc']);
plot_settlement(sett/opts.scale, domain, gsc, nep, sfl);
caxis(opts.caxis); text(1.25e6, -.30e6, 'd)', 'fontsize', 14);
ylabel(sett.(opts.compare), 'fontsize', 14);

h5=subplot(2,3,5); set(h5, 'pos', [.35 .05 .30 .45]);
sett = eval(['sett_trac_' s2 '_' opts.pld{2} '_nep']);
plot_settlement(sett/opts.scale, domain, gsc, nep, sfl);
caxis(opts.caxis); text(1.25e6, -.30e6, 'e)', 'fontsize', 14);

h6=subplot(2,3,6); set(h6, 'pos', [.65 .05 .30 .45]);
sett = eval(['sett_trac_' s2 '_' opts.pld{2} '_sfl']);
plot_settlement(sett/opts.scale, domain, gsc, nep, sfl); caxis(opts.caxis); 
text(1.25e6, -.30e6, 'f)', 'fontsize', 14); axis image
text(1.16e6, -.265e6, 'Particles per {km}^2 ','fontsize', 10);

% Create the colorbar.
%axes('Position', [0.05 0.05 0.9 0.9], 'Visible', 'off');
c=colorbar('location','south'); caxis(opts.caxis);
%xlabel(c,'Particles per km^2','fontsize', 14);
set(c,'position',[.05 .05 .90 .03]);

set(h, 'pos', [50 50 1200 611]);

end

function h=plot_3x2(s1,s2,opts)
%PLOT_3X2 plots the results in a 2x3 matrix, with all the fixins' on top.
%  PLOT_3X2 gets called whenever a cell array like {'era1', 'era2'} is passed in
%  to pcolor_larvae.m, making a nice plot for comparison of two model runs.
%
%  PLOT_3X2(S1, S2, OPTS) S1 is a string for the left row and S2 is a string for
%  the right row. OPTS contains any specified options for the plot, such as the
%  scale factor and color axis range.
%
%  Example: 
%  >> h=plot(s1, s2, opts)
%  plots the run referenced by string S1 and string S2, using the opts in the
%  opts struct.
%
%See also: pcolor_larvae, plot_2x3, plot_1x3, plot_3x1

wb = waitbar(0, 'Loading requested settlement data...');

% Load the domain.
datadir = opts.datadir;
load([datadir 'domain.mat']);
load([datadir 'gsc']); load([datadir 'nep']); load([datadir 'sfl']);

bed = {'gsc', 'nep' 'sfl'};


waitbar(0.1, wb);

% Load the left-side data for each bed.
uans = [];

for i = 1:3
    settstr = ['sett_trac_' s1 '_' opts.pld{1} '_' bed{i}];
    if exist([datadir settstr '.mat'],'file')
        load([datadir settstr]);
    elseif exist([datadir 'tr_' s1 '_' bed{i} '.mat'], 'file')
        trstr = ['tr_' s1 '_' bed{i}];
        load([datadir trstr]);
        sett = Settlement(eval(trstr), domain, opts.pld{1});
        eval([settstr ' = sett;']);
        save([datadir settstr], settstr);
    else
        error(['Can''t find file: tr_' s1 '_' bed{i} '.mat']);
    end
    waitbar(i/7.5 + 0.1, wb);
end

% Load the right-side data for each bed.
for i = 1:3
    settstr = ['sett_trac_' s2 '_' opts.pld{2} '_' bed{i}];
    if exist([datadir settstr '.mat'],'file')
        load([datadir settstr]);
    elseif exist([datadir 'tr_' s2 '_' bed{i} '.mat'], 'file')
        trstr = ['tr_' s2 '_' bed{i}];
        load([datadir trstr]);
        sett = Settlement(eval(trstr), domain, opts.pld{2});
        eval([settstr ' = sett;']);
        save([datadir settstr], settstr);
    else
        error(['Can''t find file: tr_' s2 '_' bed{i}]);
    end
    waitbar(i/7.5 + 0.4, wb);
end

waitbar(1, wb);
close(wb);

% Now, make the figure.
h = figure; set(h, 'pos', [0 0 700 800]); hold on;

h1=subplot(3,2,1);
sett = eval(['sett_trac_' s1 '_' opts.pld{1} '_gsc']);
plot_settlement(sett/opts.scale, domain, gsc, nep, sfl);
caxis(opts.caxis);
text(1.27e6, -.067e6, '(a)', 'fontsize', 14, 'backgroundcolor','white');
title(sett.(opts.compare), 'fontsize', 14);
ylabel(sett.bed, 'fontsize', 14);
 
h2=subplot(3,2,3);
sett = eval(['sett_trac_' s1 '_' opts.pld{1} '_nep']);
plot_settlement(sett/opts.scale, domain, gsc, nep, sfl); caxis(opts.caxis);
text(1.27e6, -.067e6, '(b)', 'fontsize', 14, 'backgroundcolor','white');
ylabel(sett.bed, 'fontsize', 14); drawnow;

h3=subplot(3,2,5); 
sett = eval(['sett_trac_' s1 '_' opts.pld{1} '_sfl']);
plot_settlement(sett/opts.scale, domain, gsc, nep, sfl); caxis(opts.caxis);
text(1.27e6, -.067e6, '(c)', 'fontsize', 14, 'backgroundcolor','white');
ylabel(sett.bed, 'fontsize', 14);

h4=subplot(3,2,2); 
sett = eval(['sett_trac_' s2 '_' opts.pld{2} '_gsc']);
plot_settlement(sett/opts.scale, domain, gsc, nep, sfl); caxis(opts.caxis);
text(1.27e6, -.067e6, '(d)', 'fontsize', 14, 'backgroundcolor','white');
title(sett.(opts.compare), 'fontsize', 14);

h5=subplot(3,2,4);
sett = eval(['sett_trac_' s2 '_' opts.pld{2} '_nep']);
plot_settlement(sett/opts.scale, domain, gsc, nep, sfl); caxis(opts.caxis);
text(1.27e6, -.067e6, '(e)', 'fontsize', 14, 'backgroundcolor','white');

h6=subplot(3,2,6); 
sett = eval(['sett_trac_' s2 '_' opts.pld{2} '_sfl']);
plot_settlement(sett/opts.scale, domain, gsc, nep, sfl); caxis(opts.caxis);
text(1.27e6, -.067e6, '(f)', 'fontsize', 14, 'backgroundcolor','white');

% Place the colorbar.
c=colorbar('location','south','xtick',opts.caxis);
set(c,'position',[.83 .02 .15 .02]);
text(1.16e6, -.265e6, 'Particles per {km}^2 ','fontsize', 10);

% Set the axes positions.
set(h1, 'pos', [.05 .63 .47 .31]); set(h4, 'pos', [.52 .63 .47 .31]);
set(h2, 'pos', [.05 .32 .47 .31]); set(h5, 'pos', [.52 .32 .47 .31]);
set(h3, 'pos', [.05 .01 .47 .31]); set(h6, 'pos', [.52 .01 .47 .31]);

end

function h=plot_1x3(strs,opts)
%PLOT_1X3 plots the results in a 1x3 matrix, with all the fixins' on top.
%  PLOT_1X3 gets called whenever no cell array like {'era1'; 'era2'} are passed 
%  in to pcolor_larvae.m. Instead, a 1x3 array of plots will be made for just
%  one single model run.
%
%  PLOT_1X3(STRS, OPTS) STRS is a string for the model run to be plotted. OPTS
%  contains any specified options for the plot, such as the scale factor and 
%  color axis range. If a minus sign is included in the string, then the
%  difference between two model runs will be plotted (and the settlement
%  distribution saved in the database for future reference).
%
%  Example:
%  >> h=plot({'era1','fal','py','m1-m0'}, opts)
%  plots the difference between the era1_fal_py_m1 and era1_fal_py_m0 runs.
%
%See also: pcolor_larvae, plot_3x2, plot_2x3, plot_3x1

wb = waitbar(0, 'Loading requested settlement data...');

% load the domain.
datadir = opts.datadir;
load([datadir 'data/domain.mat']);
load([datadir 'data/gsc']); 
load([datadir 'data/nep']); 
load([datadir 'data/sfl']);
bed = {'gsc', 'nep' 'sfl'};

waitbar(0.25, wb);

s = [strs{1} '_' strs{2} '_' strs{3}];
s(strfind(s,'-')) = 'v';

for i = 1:3
    if exist([datadir 'data/sett_' s '_' bed{i} '.mat'], 'file')
        load([datadir 'data/sett_' s '_' bed{i} '.mat']);
    else
        disp('Couldn''t find sett object, making it now...');
        a = strfind(strs, '-');
        j = 1; while isempty(a{j}), j = j+1; end
        strs1 = strs; strs2 = strs;
        strs1{j} = strs{j}(1:(a{j}-1)); strs2{j} = strs{j}((a{j}+1):end);
        s1 = [strs1{1} '_' strs1{2} '_' strs1{3} '_' strs1{4}];
        s2 = [strs2{1} '_' strs2{2} '_' strs2{3} '_' strs2{4}];

        if exist([datadir 'data/l_' s1 '_' bed{i} '.mat'], 'file') && ...
                exist([datadir 'data/l_' s2 '_' bed{i} '.mat'], 'file')
            load([datadir 'data/l_' s1 '_' bed{i}]);
            load([datadir 'data/l_' s2 '_' bed{i}]);
            l = eval(['l_' s1 '_' bed{i} ' - l_' s2 '_' bed{i}]);
            sett = Settlement(l, domain, 'ind');
            eval(['sett_' s '_' bed{i} ' = sett;'])
            save([datadir 'data/sett_' s '_' bed{i}],['sett_' s '_' bed{i}]);
        else
            error('L doesn''t exist.');
        end
    end
    waitbar(i/4 + 0.25, wb)
end

close(wb);

% Now make the figure.
h = figure;

h1=subplot(1,3,1);
sett = eval(['sett_' s '_gsc']);
plot_settlement(sett/opts.scale, domain, gsc, nep, sfl);
caxis(opts.caxis); text(1.25e6, -.30e6, 'a)', 'fontsize', 14);
if isfield(sett, opts.compare)
    ylabel(sett.(opts.compare), 'fontsize', 14);
else
    ylabel(opts.compare, 'fontsize', 14)
end
title(sett.bed, 'fontsize', 14);

h2=subplot(1,3,2);
sett = eval(['sett_' s '_nep']);
plot_settlement(sett/opts.scale, domain, gsc, nep, sfl);
caxis(opts.caxis); text(1.25e6, -.30e6, 'b)', 'fontsize', 14);
title(sett.bed, 'fontsize', 14);

h3=subplot(1,3,3);
sett = eval(['sett_' s '_sfl']);
plot_settlement(sett/opts.scale, domain, gsc, nep, sfl);
caxis(opts.caxis); text(1.25e6, -.30e6, 'c)', 'fontsize', 14);
title(sett.bed, 'fontsize', 14);

axes('Position', [0.05 0.05 0.9 0.9], 'Visible', 'off');
set(h1, 'pos', [.05 .20 .30 .70]);
set(h2, 'pos', [.35 .20 .30 .70]);
set(h3, 'pos', [.65 .20 .30 .70]);

% Create the colorbar.
c=colorbar('location','south'); caxis(opts.caxis);
xlabel(c,'Particles per {km}^2','fontsize', 14);
set(c,'position',[.05 .05 .90 .03]);

set(h, 'pos', [50 50 1200 345]);

end

function h=plot_1x3_plain(s,opts)
%PLOT_1X3 plots the results in a 1x3 matrix, with all the fixins' on top.
%  PLOT_1X3 gets called whenever no cell array like {'era1'; 'era2'} are passed 
%  in to pcolor_larvae.m. Instead, a 1x3 array of plots will be made for just
%  one single model run.
%
%  PLOT_1X3(STRS, OPTS) STRS is a string for the model run to be plotted. OPTS
%  contains any specified options for the plot, such as the scale factor and 
%  color axis range. If a minus sign is included in the string, then the
%  difference between two model runs will be plotted (and the settlement
%  distribution saved in the database for future reference).
%
%  Example:
%  >> h=plot({'era1','fal','py','m1-m0'}, opts)
%  plots the difference between the era1_fal_py_m1 and era1_fal_py_m0 runs.
%
%See also: pcolor_larvae, plot_3x2, plot_2x3, plot_3x1

wb = waitbar(0, 'Loading requested settlement data...');

% load the domain.
datadir = opts.datadir;
load([datadir 'domain.mat']);
load([datadir 'gsc']); 
load([datadir 'nep']); 
load([datadir 'sfl']);
bed = {'gsc', 'nep' 'sfl'};

waitbar(0.25, wb);

% Load the data.
for i = 1:3
    if exist([datadir 'sett_' s '_' opts.pld '_' bed{i} '.mat'], 'file')
        load([datadir 'sett_' s '_' opts.pld '_' bed{i} '.mat']);
    elseif exist([datadir 'tr_' s '_' bed{i} '.mat'], 'file')
        load([datadir 'tr_' s '_' bed{i}]);
        
        sett = Settlement(eval(['tr_' s '_' bed{i}]), domain, opts.pld);
        eval(['sett_' s '_' opts.pld '_' bed{i} ' = sett;'])
        save([datadir 'sett_' s '_' opts.pld '_' bed{i}], ...
            ['sett_' s '_' opts.pld '_' bed{i}]);
    else
        error('Track doesn''t exist.');
    end
    waitbar(i/4 + 0.25, wb)
end

close(wb);

% Now make the figure.
h = figure;

% Plot the GSC-spawned particles.
h1=subplot(1,3,1);
sett = eval(['sett_' s '_' opts.pld '_gsc']);
plot_settlement(sett/opts.scale, domain, gsc, nep, sfl); caxis(opts.caxis); 
text(1.27e6, -.067e6, '(a)', 'fontsize', 14, 'backgroundcolor','white');
if isfield(sett, opts.compare)
    ylabel(sett.(opts.compare), 'fontsize', 14);
else
    ylabel(opts.compare, 'fontsize', 14)
end
title(sett.bed, 'fontsize', 14);

% Plot the NEP-spawned particles.
h2=subplot(1,3,2); 
sett = eval(['sett_' s '_' opts.pld '_nep']);
plot_settlement(sett/opts.scale, domain, gsc, nep, sfl); caxis(opts.caxis);
text(1.27e6, -.067e6, '(b)', 'fontsize', 14, 'backgroundcolor','white');
title(sett.bed, 'fontsize', 14);

% Plot the SFL-spawned particles.
h3=subplot(1,3,3); 
sett = eval(['sett_' s '_' opts.pld '_sfl']);
plot_settlement(sett/opts.scale, domain, gsc, nep, sfl); caxis(opts.caxis); 
text(1.27e6, -.067e6, '(c)', 'fontsize', 14, 'backgroundcolor','white');
title(sett.bed, 'fontsize', 14);
text(1.14e6, -0.27e6, 'Particles per  {km}^2', 'fontsize', 12);

set(h1, 'pos', [.05 .05 .30 .85]);
set(h2, 'pos', [.35 .05 .30 .85]);
set(h3, 'pos', [.65 .05 .30 .85]);

axes('Position', [0.05 0.05 0.9 0.9], 'Visible', 'off');
% Create the colorbar.
c=colorbar('location','south'); caxis(opts.caxis);
set(c,'position',[.85 .075 .09 .05]);

% Resize the figure window to fit everything nicely.
set(h, 'pos', [50 50 1200 285]);

end

function sett = load_settlement(strs,datadir)
% Load diff loads the string for each bed.
%
%  SETT = LOAD_SETTLEMENT(STRS)

wb = waitbar(0, 'Loading requested settlement data...');

% load the domain.
load([datadir 'domain.mat']);
bed = {'gsc', 'nep' 'sfl'};

waitbar(0.25, wb);


s = [strs{1} '_' strs{2}];
ss = s;
ss(strfind(s,'-')) = 'v';
ss(strfind(s,'/')) = 'd';

% If an already-existing field is being plotted.
if exist([datadir 'sett_' ss '_sfl.mat'], 'file')
    for i = 1:length(bed)
        load([datadir 'sett_' ss '_' bed{i} '.mat']);
        sett.(bed{i}) = eval(['sett_' ss '_' bed{i}]);
        waitbar((i+1)/5);
    end
    
elseif exist([datadir 'tr_' ss '_sfl.mat'], 'file')
    for i = 1:length(bed)
        load([datadir 'tr_' ss '_' bed{i} '.mat']);
        tr = eval(['tr_' ss '_' bed{i} ';']);
        sett.(bed{i}) = Settlement(tr, domain, 'ind', strs{4});
        eval(['sett_' ss '_' bed{i} ' = sett.(bed{i});']);
        save([datadir 'sett_' ss '_' bed{i}],['sett_' ss '_' bed{i}]);
        waitbar((i+1)/5);
    end
    
elseif ~isempty(strfind(s,'-'))
    % If two fields are being compared via subtraction.
    
    for i = 1:length(bed)
        % Find the names of the two fields being comapred.
        a = strfind(strs, '-');
        j = 1; while isempty(a{j}), j = j+1; end
        strs1 = strs; strs1{j} = strs{j}(1:(a{j}-1));
        strs2 = strs; strs2{j} = strs{j}((a{j}+1):end);
        s1 = [strs1{1} '_' strs1{2} '_' strs1{3} '_' strs1{4}];
        s2 = [strs2{1} '_' strs2{2} '_' strs2{3} '_' strs2{4}];
        
        % If these fields exist, use them to make the diff field.
        if exist([datadir 'tr_' s1 '_' bed{i} '.mat'], 'file') && ...
                exist([datadir 'tr_' s2 '_' bed{i} '.mat'], 'file')
            
            % Load them.
            load([datadir 'tr_' s1 '_' bed{i}]);
            load([datadir 'tr_' s2 '_' bed{i}]);
            tr = eval(['tr_' s1 '_' bed{i} ' - tr_' s2 '_' bed{i}]);
            
            % Make the new field and save it.
            sett.(bed{i}) = Settlement(tr, domain, 'ind');
            eval(['sett_' ss '_' bed{i} ' = sett.(bed{i});']);
            save([datadir 'sett_' ss '_' bed{i}],['sett_' ss '_' bed{i}]);
            waitbar((i+1)/5);
        end
    end
    
elseif ~isempty(strfind(s,'/'))
    % If two fields are being compared via division.

    for i = 1:length(bed)
        
        % Find the names of the two fields.
        a = strfind(strs, '/');
        j = 1; while isempty(a{j}), j = j+1; end
        strs1 = strs; strs2 = strs;
        strs1{j} = strs{j}(1:(a{j}-1)); strs2{j} = strs{j}((a{j}+1):end);
        s1 = [strs1{1} '_' strs1{2} '_' strs1{3} '_' strs1{4}];
        s2 = [strs2{1} '_' strs2{2} '_' strs2{3} '_' strs2{4}];
        
        % If these fields exist, use them to make the ratio field.
        if exist([datadir 'tr_' s1 '_' bed{i} '.mat'], 'file') && ...
                exist([datadir 'tr_' s2 '_' bed{i} '.mat'], 'file')
            
            % Load the data.
            load([datadir 'tr_' s1 '_' bed{i}]);
            load([datadir 'tr_' s2 '_' bed{i}]);
            tr = eval(['tr_' s1 '_' bed{i} ' / tr_' s2 '_' bed{i}]);
            
            % Make the new field and save it.
            sett.(bed{i}) = Settlement(tr, domain, 'ind');
            eval(['sett_' ss '_' bed{i} ' = sett.(bed{i});']);
            save([datadir 'sett_' ss '_' bed{i}],['sett_' ss '_' bed{i}]);
            waitbar((i+1)/5);
        end
    end
    
else
    % Othewise, give up and quit the function.
    error(['sett_' s '_gsc.mat doesn''t exist.']);
end

close(wb);

end
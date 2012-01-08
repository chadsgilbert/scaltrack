function varargout = pcolor_larvae(era, seas, behav, mort, varargin)
%PCOLOR_LARVAE plot larval settlement distributions from data folder.
%  PCOLOR_LARVAE compares two different model runs by plotting the resulting
%  larval distributions of each side-by-side.
%
%  PCOLOR_LARVAE(ERA, SEAS, BEHAV, MORT, OPTS) uses the string arguments to
%  decide which data to load and plot. To make a comparison, two values for one
%  (and only one) of these values must be constrasted. To choose these values,
%  provide one (and only one) of these values as a [1x2] cell array of strings
%  instead of just a string.
%
%  The OPTS arguments are optional, and defines the scaling and range of the 
%  color axis.
%
%  Example:
%  >> pcolor_larvae({'era1','era2'}, 'fal', 'py', 'm0', 1e6, [0 500]);
%  compares the model run in fall, with pycnocline-seeking, constant mortality,
%  and individually-varyin PLD across the pre- and post- settlement eras,
%  because two different options have been provided for the ERA. Era1 will be
%  plotted on the left and era2 on the right, following the order they are
%  provided in the cell array. The plot shows density of larvae per million, and
%  the color axis spans from 0 to 500 million larvae per km^2.
%
%See also: Settlement, Larvae, Domain, Bed, plot_settlement

% Assign the optional input arguments.
opts.scale = 1e6;
opts.caxis = [0 100];
for i = 1:2:(nargin-4)
     opts.(varargin{i}) = varargin{i+1};
end


% Create the load strings.
if iscell(era) && size(era,1) == 1 && size(era,2) == 3
    % Compare two eras and show the ratio.
    strs1 = {era{1}, seas, behav, mort};
    strs2 = {era{2}, seas, behav, mort};
    strs3 = {era{3}, seas, behav, mort};
    opts.compare = 'era';
    h=plot_3x3(strs1, strs2, strs3, opts);

elseif iscell(era) && size(era,1) == 2 && size(era,2) == 1
    % Compare two eras, top-by-bottom.
    strs1 = {era{1} , seas , behav , mort};
    strs2 = {era{2} , seas , behav , mort};
    opts.compare = 'era';
    h=plot_2x3(strs1,strs2,opts);

elseif iscell(era) && size(era,1) == 1 && size(era,2) == 2
    % Compare two eras, side-by-side.
    strs1 = {era{1} , seas , behav , mort};
    strs2 = {era{2} , seas , behav , mort};
    opts.compare = 'era';
    h=plot_3x2(strs1,strs2,opts);

elseif iscell(seas) && size(seas,1) == 1 && size(seas,2) == 2
    % Compare two seasons, top-by-bottom.
    strs1 = {era , seas{1} , behav , mort};
    strs2 = {era , seas{2} , behav , mort};
    opts.compare = 'season';
    h=plot_2x3(strs1,strs2,opts);

elseif iscell(seas) && size(seas,1) == 2 && size(seas,2) == 1
    % Compare two seasons, side-by-side.
    strs1 = {era , seas{1} , behav , mort};
    strs2 = {era , seas{2} , behav , mort};
    opts.compare = 'season';
    h=plot_3x2(strs1,strs2,opts);
    
elseif iscell(behav) && size(behav,1) == 1 && size(behav,2) == 2
    % Compare two behaviours, top-by-bottom.
    strs1 = {era , seas , behav{1} , mort};
    strs2 = {era , seas , behav{2} , mort};
    opts.compare = 'behaviour';
    h=plot_2x3(strs1,strs2,opts);

elseif iscell(behav) && size(behav,1) == 2 && size(behav,2) == 1
    % Compare two behaviours, side-by-side.
    strs1 = {era , seas , behav{1} , mort};
    strs2 = {era , seas , behav{2} , mort};
    opts.compare = 'behaviour';
    h=plot_3x2(strs1,strs2,opts);
    
elseif iscell(mort) && size(mort,1) == 1 && size(mort,2) == 2
    % Compare two mortality rates, top-by-bottom.
    strs1 = {era , seas , behav , mort{1}};
    strs2 = {era , seas , behav , mort{2}};
    opts.compare = 'mortality';
    h=plot_2x3(strs1,strs2,opts);

elseif iscell(mort) && size(mort,1) == 2 && size(mort,2) == 1
    % Compare two mortality rates, side-by-side.
    strs1 = {era , seas , behav , mort{1}};
    strs2 = {era , seas , behav , mort{2}};
    opts.compare = 'mortality';
    h=plot_3x2(strs1,strs2,opts);

elseif ischar([era seas behav mort])
    % Just plot one model run.
    strs = {era,seas,behav,mort};
    h=plot_3x1(strs,opts);

else
    error('Must provide one cell array of strings for comparison.')
end

switch nargout
    case 0
    case 1
        varargout{1} = h;
    otherwise
        error('Wrong number of output arguments requested.');
end

end

function h=plot_2x3(strs1,strs2,opts)
%PLOT_2X3 plots the results in a 2x3 matrix, with all the fixins' on top.
%  PLOT_2X3 gets called whenever a cell array like {'era1'; 'era2'} is passed in
%  to pcolor_larvae.m, making a nice plot for comparison of two model runs.
%
%  PLOT_2X3(S1, S2, OPTS) S! is a string for the top row and S2 is a string for
%  the bottom row. OPTS contains any specified options for the plot, such as the
%  opts.scale factor and color axis range.
%
%  Example: 
%  >> h=plot(s1, s2, opts)
%  plots the run referenced by string S1 and string S2, using the opts in the
%  opts struct.
%
%See also: pcolor_larvae, plot_3x2, plot_1x3, plot_3x1

strs_t = load_settlement(strs1);
strs_b = load_settlement(strs2);

% load the domain.
datadir = '~/School/oop/data/';
load([datadir 'domain.mat']);
load([datadir 'gsc']); load([datadir 'nep']); load([datadir 'sfl']);
bed = {'gsc', 'nep' 'sfl'};

% Now, make the figure.
h = figure;

if isnumeric(opts.caxis)
    cax = opts.caxis;
elseif iscell(opts.caxis)
    cax = opts.caxis{1};
else
    error('Invalid form for optional argument ''caxis''.');
end

h1=subplot(2,3,1); set(h1, 'pos', [.05 .50 .30 .45]);
sett = eval(['sett_' s1 '_gsc']);
plot_settlement(sett/opts.scale, domain, gsc, nep, sfl); caxis(cax); 
text(1.27e6, -.067e6, '(a)', 'fontsize', 14, 'backgroundcolor','white');
ylabel(sett.(opts.compare), 'fontsize', 14);
title(sett.bed, 'fontsize', 14);

h2=subplot(2,3,4); set(h2, 'pos', [.35 .50 .30 .45]);
sett = eval(['sett_' s1 '_nep']);
plot_settlement(sett/opts.scale, domain, gsc, nep, sfl); caxis(cax); 
text(1.27e6, -.067e6, '(b)', 'fontsize', 14, 'backgroundcolor','white');
title(sett.bed, 'fontsize', 14);

h3=subplot(2,3,5); set(h3, 'pos', [.65 .50 .30 .45]);
sett = eval(['sett_' s1 '_sfl']);
plot_settlement(sett/opts.scale, domain, gsc, nep, sfl); caxis(cax); 
text(1.27e6, -.067e6, '(c)', 'fontsize', 14, 'backgroundcolor','white');
title(sett.bed, 'fontsize', 14);

if isnumeric(opts.caxis)
    cax = opts.caxis;
elseif iscell(opts.caxis)
    cax = opts.caxis{2};
end

h4=subplot(2,3,4); set(h4, 'pos', [.05 .05 .30 .45]);
sett = eval(['sett_' s2 '_gsc']);
plot_settlement(sett/opts.scale, domain, gsc, nep, sfl); caxis(cax); 
text(1.27e6, -.067e6, '(d)', 'fontsize', 14, 'backgroundcolor','white');
ylabel(sett.(opts.compare), 'fontsize', 14);

h5=subplot(2,3,5); set(h5, 'pos', [.35 .05 .30 .45]);
sett = eval(['sett_' s2 '_nep']);
plot_settlement(sett/opts.scale, domain, gsc, nep, sfl); caxis(cax);
text(1.27e6, -.067e6, '(e)', 'fontsize', 14, 'backgroundcolor','white');

h6=subplot(2,3,6); set(h6, 'pos', [.65 .05 .30 .45]);
sett = eval(['sett_' s2 '_sfl']);
plot_settlement(sett/opts.scale, domain, gsc, nep, sfl); caxis(cax);
axis image
text(1.27e6, -.067e6, '(f)', 'fontsize', 14, 'backgroundcolor','white');

% Create the colorbar.
subplot(2,3,6); text(1.16e6, -0.27e6, 'Millions per  {km}^2', 'fontsize', 12);
axes('Position', [0.05 0.05 0.9 0.9], 'Visible', 'off');
c=colorbar('location','south'); caxis(cax);
set(c,'position',[.84 .06 .10 .03]);
if iscell(opts.caxis)
    cax = opts.caxis{1};
    axes('Position', [0.05 0.05 0.9 0.9], 'Visible', 'off');
    c=colorbar('location','south'); caxis(cax);
    set(c,'position',[.84 .06 .10 .03]);
end

set(h, 'pos', [50 50 1200 540]);

end

function h=plot_3x2(strs1,strs2,opts)
%PLOT_3X2 plots the results in a 2x3 matrix, with all the fixins' on top.
%  PLOT_3X2 gets called whenever a cell array like {'era1', 'era2'} is passed in
%  to pcolor_larvae.m, making a nice plot for comparison of two model runs.
%
%  PLOT_3X2(S1, S2, OPTS) S1 is a string for the left row and S2 is a string for
%  the right row. OPTS contains any specified options for the plot, such as the
%  opts.scale factor and color axis range.
%
%  Example: 
%  >> h=plot(s1, s2, opts)
%  plots the run referenced by string S1 and string S2, using the opts in the
%  opts struct.
%
%See also: pcolor_larvae, plot_2x3, plot_1x3, plot_3x1

% Load the settlement distribution data.
sett_l = load_settlement(strs1);
sett_r = load_settlement(strs2);

% load the domain.
datadir = '~/School/oop/data/';
load([datadir 'domain.mat']);
load([datadir 'gsc']); load([datadir 'nep']); load([datadir 'sfl']);

% Now, make the figure.
h = figure; set(h, 'pos', [0 0 700 800]); hold on;

% Plot the left column.
if     isnumeric(opts.caxis), cax = opts.caxis;
elseif iscell(opts.caxis),    cax = opts.caxis{1};
else   error('Invalid form for optional argument ''caxis''.');
end

if isnumeric(opts.scale), opts.scale = opts.scale;
elseif iscell(opts.scale), opts.scale = opts.scale{1};
else  error('Invalid form for optional argument ''opts.scale''.');
end

h1=subplot(3,2,1);
plot_settlement(sett_l.gsc/opts.scale, domain, gsc, nep, sfl); caxis(cax); 
text(1.27e6, -.067e6, '(a)', 'fontsize', 14, 'backgroundcolor','white');
title(sett_l.gsc.(opts.compare), 'fontsize', 14);
ylabel(sett_l.gsc.bed, 'fontsize', 14);
 
h2=subplot(3,2,3);
plot_settlement(sett_l.nep/opts.scale, domain, gsc, nep, sfl); caxis(cax);
text(1.27e6, -.067e6, '(b)', 'fontsize', 14, 'backgroundcolor','white');
ylabel(sett_l.nep.bed, 'fontsize', 14);

h3=subplot(3,2,5); 
plot_settlement(sett_l.sfl/opts.scale, domain, gsc, nep, sfl); caxis(cax);
text(1.27e6, -.067e6, '(c)', 'fontsize', 14, 'backgroundcolor','white');
ylabel(sett_l.sfl.bed, 'fontsize', 14);

% Plot the right column.
if isnumeric(opts.caxis), cax = opts.caxis;
elseif iscell(opts.caxis), cax = opts.caxis{2};
end

if isnumeric(opts.scale), opts.scale = opts.scale;
elseif iscell(opts.scale), opts.scale = opts.scale{2};
end

h4=subplot(3,2,2); 
plot_settlement(sett_r.gsc/opts.scale, domain, gsc, nep, sfl); caxis(cax);
text(1.27e6, -.067e6, '(d)', 'fontsize', 14, 'backgroundcolor','white');
%title(sett_r.gsc.(opts.compare), 'fontsize', 14);
title('Factor increase post-closures', 'fontsize', 14)

h5=subplot(3,2,4);
plot_settlement(sett_r.nep/opts.scale, domain, gsc, nep, sfl); caxis(cax);
text(1.27e6, -.067e6, '(e)', 'fontsize', 14, 'backgroundcolor','white');

h6=subplot(3,2,6); 
plot_settlement(sett_r.sfl/opts.scale, domain, gsc, nep, sfl); caxis(cax);
text(1.27e6, -.067e6, '(f)', 'fontsize', 14, 'backgroundcolor','white');

% Place the colorbar.
c=colorbar('location','south','xtick',cax);
set(c,'position',[.80 .01 .15 .025]);
text(1.145e6, -.265e6, 'Larvae per larva','fontsize', 12);
if iscell(opts.caxis)
    cax = opts.caxis{1};
    subplot(3,2,5);
    c=colorbar('location','south','xtick', cax);
    set(c,'position',[.36 .01 .15 .025]);
    text(1.145e6, -.265e6, 'Millions per {km}^2 ','fontsize', 12);
end

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
%  contains any specified options for the plot, such as the opts.scale factor and 
%  color axis range. If a minus sign is included in the string, then the
%  difference between two model runs will be plotted (and the settlement
%  distribution saved in the database for future reference).
%
%  Example:
%  >> h=plot({'era1','fal','py','m1-m0'}, opts)
%  plots the difference between the era1_fal_py_m1 and era1_fal_py_m0 runs.
%
%See also: pcolor_larvae, plot_3x2, plot_2x3, plot_3x1

sett = load_settlement(strs);

datadir = '~/School/oop/data/';
load([datadir 'domain.mat']);
load([datadir 'gsc']); load([datadir 'nep']); load([datadir 'sfl']);

% Now make the figure.
h = figure('position', [50 50 1200 285]);

% Plot the GSC
h1=subplot(2,3,1); set(h1, 'pos', [.05 .05 .30 .85]);
plot_settlement(sett.gsc/opts.scale, domain, gsc, nep, sfl); caxis(opts.caxis); 
text(1.27e6, -.067e6, '(g)', 'fontsize', 14, 'backgroundcolor','white');
if isfield(sett, opts.compare)
    ylabel(sett.(opts.compare), 'fontsize', 14);
else
    ylabel(opts.compare, 'fontsize', 14);
end
title(sett.bed, 'fontsize', 14);

% Plot the NEP
h2=subplot(2,3,2); set(h2, 'pos', [.35 .05 .30 .85]);
plot_settlement(sett.nep/opts.scale, domain, gsc, nep, sfl); caxis(opts.caxis); 
text(1.27e6, -.067e6, '(h)', 'fontsize', 14, 'backgroundcolor','white');
title(sett.bed, 'fontsize', 14);

% Plot the SFL
h3=subplot(2,3,3); set(h3, 'pos', [.65 .05 .30 .85]);
plot_settlement(sett.sfl/opts.scale, domain, gsc, nep, sfl); caxis(opts.caxis); 
text(1.27e6, -.067e6, '(i)', 'fontsize', 14, 'backgroundcolor','white');
title(sett.bed, 'fontsize', 14);
text(1.16e6, -0.27e6, 'Millions of larvae', 'fontsize', 12);

% Create the colorbar.
axes('Position', [0.05 0.05 0.9 0.9], 'Visible', 'off');
c=colorbar('location','south'); caxis(opts.caxis);
set(c,'position',[.85 .075 .09 .05]);

set(h, 'pos', [50 50 1200 285]);

end

function h=plot_3x1(strs,opts)
%PLOT_3X1 plots the results in a 3x1 matrix, with all the fixins' on top.
%  PLOT_3X1 gets called whenever no cell array like {'era1'; 'era2'} are passed 
%  in to pcolor_larvae.m. Instead, a 1x3 array of plots will be made for just
%  one single model run.
%
%  PLOT_3X1(STRS, OPTS) STRS is a string for the model run to be plotted. OPTS
%  contains any specified options for the plot, such as the opts.scale factor and 
%  color axis range. If a minus sign is included in the string, then the
%  difference between two model runs will be plotted (and the settlement
%  distribution saved in the database for future reference).
%
%  Example:
%  >> h=plot({'era1','fal','py','m1-m0'}, opts)
%  plots the difference between the era1_fal_py_m1 and era1_fal_py_m0 runs.
%
%See also: pcolor_larvae, plot_3x2, plot_2x3, plot_3x1, plot_1x3

wb = waitbar(0, 'Loading requested settlement data...');

% load the domain.
datadir = mfilename('fullpath'); inds = strfind(datadir,'/');
datadir = [datadir(1:inds(end)) 'data' filesep];

load([datadir 'domain.mat']);
load([datadir 'gsc']); load([datadir 'nep']); load([datadir 'sfl']);
bed = {'gsc', 'nep' 'sfl'};

waitbar(0.25, wb);

s = [strs{1} '_' strs{2} '_' strs{3} '_' strs{4}];
s(strfind(s,'-')) = 'v';

for i = 1:3
    if exist([datadir 'sett_' s '_' bed{i} '.mat'], 'file')
        load([datadir 'sett_' s '_' bed{i} '.mat']);
    else
        a = strfind(strs, '-');
        j = 1; while isempty(a{j}), j = j+1; end
        strs1 = strs; strs2 = strs;
        strs1{j} = strs{j}(1:(a{j}-1)); strs2{j} = strs{j}((a{j}+1):end);
        s1 = [strs1{1} '_' strs1{2} '_' strs1{3} '_' strs1{4}];
        s2 = [strs2{1} '_' strs2{2} '_' strs2{3} '_' strs2{4}];

        if exist([datadir 'l_' s1 '_' bed{i} '.mat'], 'file') && ...
                exist([datadir 'l_' s2 '_' bed{i} '.mat'], 'file')
            load([datadir 'l_' s1 '_' bed{i}]);
            load([datadir 'l_' s2 '_' bed{i}]);
            l = eval(['l_' s1 '_' bed{i} ' - l_' s2 '_' bed{i}]);
            sett = Settlement(l, domain, 'ind');
            eval(['sett_' s '_' bed{i} ' = sett;'])
            save([datadir 'sett_' s '_' bed{i}],['sett_' s '_' bed{i}]);
        else
            error('L doesn''t exist.');
        end
    end
    waitbar(i/4 + 0.25, wb)
end

close(wb);

% Now make the figure.
h = figure;
%set(h, 'pos', [50 50 385 800]);

h1=subplot(3,1,1);
sett = eval(['sett_' s '_gsc']);
plot_settlement(sett/opts.scale, domain, gsc, nep, sfl); caxis(opts.caxis); 
text(1.27e6, -.067e6, '(a)', 'fontsize', 14, 'backgroundcolor','white');
%title('Heterogeneous - Homogeneous','fontsize', 14);
%ylabel(sett.bed, 'fontsize', 14);

h2=subplot(3,1,2);
sett = eval(['sett_' s '_nep']);
plot_settlement(sett/opts.scale, domain, gsc, nep, sfl); caxis(opts.caxis); 
text(1.27e6, -.067e6, '(b)', 'fontsize', 14, 'backgroundcolor','white');
%ylabel(sett.bed, 'fontsize', 14);

h3=subplot(3,1,3); axis equal;
sett = eval(['sett_' s '_sfl']);
plot_settlement(sett/opts.scale, domain, gsc, nep, sfl); caxis(opts.caxis); 
text(1.27e6, -.067e6, '(c)', 'fontsize', 14, 'backgroundcolor','white');
%ylabel(sett.bed, 'fontsize', 14);


% Create the colorbar.
%text(1.155e6, -.26e6, 'Millions per {km}^2 ','fontsize', 12);
text(1.155e6, -.26e6, 'Factor Increase','fontsize', 12);
axes('Position', [0.05 0.05 0.9 0.9], 'visible', 'off');
c=colorbar('location','south','xtick',opts.caxis);
set(c,'position',[.66 .01 .30 .025]);
caxis(opts.caxis);

set(h1, 'pos', [.10 .61 .89 .30]);
set(h2, 'pos', [.10 .31 .89 .30]);
set(h3, 'pos', [.10 .01 .89 .30]);

set(h, 'pos', [50 50 350 800]);

end

function h=plot_3x3(strs1, strs2, strs3, opts)

% Load the settlement distribution data.
sett_l = load_settlement(strs1);
sett_c = load_settlement(strs2);
sett_r = load_settlement(strs3);

% load the domain.
datadir = '~/School/oop/data/';
load([datadir 'domain.mat']);
load([datadir 'gsc']); load([datadir 'nep']); load([datadir 'sfl']);

opts.scale = opts.scale;
cax = opts.caxis;

% Now, make the figure.
h = figure;

h1=subplot(3,3,1);
plot_settlement(sett_l.gsc/opts.scale, domain, gsc, nep, sfl);
caxis(cax);
text(1.27e6, -.067e6, '(a)', 'fontsize', 14, 'backgroundcolor','white');
title(sett_l.gsc.(opts.compare), 'fontsize', 14);
ylabel(sett_l.gsc.bed, 'fontsize', 14);

h2=subplot(3,3,2);
plot_settlement(sett_c.gsc/opts.scale, domain, gsc, nep, sfl); 
caxis(cax);
text(1.27e6, -.067e6, '(d)', 'fontsize', 14, 'backgroundcolor','white');
title(sett_c.gsc.(opts.compare), 'fontsize', 14);

h3=subplot(3,3,3); 
plot_settlement(sett_r.gsc/opts.scale, domain, gsc, nep, sfl); 
caxis(cax);
text(1.27e6, -.067e6, '(g)', 'fontsize', 14, 'backgroundcolor','white');
title('Factor increase', 'fontsize', 14);

h4=subplot(3,3,4);
plot_settlement(sett_l.nep/opts.scale, domain, gsc, nep, sfl); 
caxis(cax);
text(1.27e6, -.067e6, '(b)', 'fontsize', 14, 'backgroundcolor','white');
ylabel(sett_l.nep.bed, 'fontsize', 14);

h5=subplot(3,3,5);
plot_settlement(sett_c.nep/opts.scale, domain, gsc, nep, sfl); 
caxis(cax);
text(1.27e6, -.067e6, '(e)', 'fontsize', 14, 'backgroundcolor','white');

h6=subplot(3,3,6);
plot_settlement(sett_r.nep/opts.scale, domain, gsc, nep, sfl); 
caxis(cax);
text(1.27e6, -.067e6, '(h)', 'fontsize', 14, 'backgroundcolor','white');

h7=subplot(3,3,7);
plot_settlement(sett_l.sfl/opts.scale, domain, gsc, nep, sfl); 
caxis(cax);
text(1.27e6, -.067e6, '(c)', 'fontsize', 14, 'backgroundcolor','white');
ylabel(sett_l.sfl.bed, 'fontsize', 14);

h8=subplot(3,3,8); 
plot_settlement(sett_c.sfl/opts.scale, domain, gsc, nep, sfl); 
caxis(cax);
text(1.27e6, -.067e6, '(f)', 'fontsize', 14, 'backgroundcolor','white');

h9=subplot(3,3,9);
plot_settlement(sett_r.sfl/opts.scale, domain, gsc, nep, sfl); 
caxis(cax);
text(1.27e6, -.067e6, '(i)', 'fontsize', 14, 'backgroundcolor','white');

% Place the colorbar.
c=colorbar('location','south','xtick',cax);
set(c,'position',[.80 .01 .15 .025]);
text(1.145e6, -.265e6, 'Larvae per larva','fontsize', 12);
if iscell(opts.caxis)
    cax = opts.caxis{1};
    subplot(3,2,5);
    c=colorbar('location','south','xtick', cax);
    set(c,'position',[.36 .01 .15 .025]);
    text(1.145e6, -.265e6, 'Millions per {km}^2 ','fontsize', 12);
end

set(h, 'pos', [0 0 1200 800]);
% Set the axes positions.
set(h1, 'pos', [.05 .63 .31 .31]);
set(h2, 'pos', [.05 .32 .31 .31]); 
set(h3, 'pos', [.05 .01 .31 .31]);

set(h4, 'pos', [.36 .63 .31 .31]);
set(h5, 'pos', [.36 .32 .31 .31]);
set(h6, 'pos', [.36 .01 .31 .31]);

set(h7, 'pos', [.67 .63 .31 .31]);
set(h8, 'pos', [.67 .32 .31 .31]);
set(h9, 'pos', [.67 .01 .31 .31]);

end

function sett = load_settlement(strs)
% Load diff loads the string for each bed.
%
%  SETT = LOAD_SETTLEMENT(STRS)

wb = waitbar(0, 'Loading requested settlement data...');

% load the domain.
datadir = '~/School/oop/data/';
load([datadir 'domain.mat']);
bed = {'gsc', 'nep' 'sfl'};

waitbar(0.25, wb);


s = [strs{1} '_' strs{2} '_' strs{3} '_' strs{4}];
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
    
elseif exist([datadir 'l_' ss '_sfl.mat'], 'file')
    for i = 1:length(bed)
        load([datadir 'l_' ss '_' bed{i} '.mat']);
        l = eval(['l_' ss '_' bed{i} ';']);
        sett.(bed{i}) = Settlement(l, domain, 'ind', strs{4});
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
        if exist([datadir 'l_' s1 '_' bed{i} '.mat'], 'file') && ...
                exist([datadir 'l_' s2 '_' bed{i} '.mat'], 'file')
            
            % Load them.
            load([datadir 'l_' s1 '_' bed{i}]);
            load([datadir 'l_' s2 '_' bed{i}]);
            l = eval(['l_' s1 '_' bed{i} ' - l_' s2 '_' bed{i}]);
            
            % Make the new field and save it.
            sett.(bed{i}) = Settlement(l, domain, 'ind');
            eval(['sett_' ss '_' bed{i} ' = sett.(bed{i});']);
            save([datadir 'sett_' ss '_' bed{i}],['sett_' ss '_' bed{i}]);
            waitbar((i+1)/5);
        end
    end
    
elseif ~isempty(strfind(s,'/'))
    error('This is not good right now, you will ruin data if you use this.');
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
        if exist([datadir 'l_' s1 '_' bed{i} '.mat'], 'file') && ...
                exist([datadir 'l_' s2 '_' bed{i} '.mat'], 'file')
            
            % Load the data.
            load([datadir 'l_' s1 '_' bed{i}]);
            load([datadir 'l_' s2 '_' bed{i}]);
            l = eval(['l_' s1 '_' bed{i} ' / l_' s2 '_' bed{i}]);
            
            % Make the new field and save it.
            sett.(bed{i}) = Settlement(l, domain, 'ind');
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
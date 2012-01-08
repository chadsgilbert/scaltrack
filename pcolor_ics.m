function varargout = pcolor_ics(strs,varargin)
%PCOLOR_ICS plots the distribution of ics.
%  PCOLOR_ICS 
%
%  PCOLOR_ICS(STRS, OPT, VAL, ...) where STRS is a cell array of load strings
%  having the form: "era_seas", and the array is configured in the same way that
%  the spawning fields are to be plotted.
%
%  Options that can be specified are:
%  - 'scale', the scaling that is applied to the field. By default, spawning
%             fields are divided by 1e9.
%  - 'caxis', the colorbar axis. It is [0 1000] by default.
%
%  Example 1:
%  >> strs = {'era1_fal', 'era1_spr'; 'era2_fal', 'era2_spr'};
%  >> pcolor_ics(strs, 'scale', 1e10);
%  Plots the spawning fields in a 2 by 2 array, with the rows corresponding to
%  different eras and the columns to different seasons.
%
%  Example 2:
%  >> strs = {'era2-era1_fal', 'era2/era1_fall'};
%  >> pcolor_ics(strs);
%  Plots the difference between era2 and era2 in fall on the left and their
%  ratio on the right.
%
%See also: pcolor_larvae, pcolor_particles

% Assign the optional argument stuff.
opts.scale = 1e9;
opts.caxis = [0 1000];
opts.normalize = false;
for i = 1:2:(nargin-2)
    opts.(varargin{i}) = varargin{i+1};
end

if opts.normalize
    opts.scale = .01;
    opts.caxis = [-100 100];
end

if iscell(strs) && (size(strs,1) == 3) && (size(strs,2) == 2)
    plot_3x2(strs,opts);
elseif iscell(strs) && (size(strs,1) == 3) && (size(strs,2) == 2)
    plot_2x2(strs,opts);
elseif iscell(strs) && (size(strs,1) == 1) && (size(strs,2) == 2)
    plot_1x2(strs,opts);
elseif iscell(strs) && (size(strs,1)==1) && (size(strs,2)==2) || ischar(strs)
    plot_1x1(strs,opts);
else
    error('Invalid input arguments.')
end

% elseif iscell(era) && iscell(seas) && size(era,1) == 2 && size(seas,1) == 2
%     s11 = [era{1} '_' seas{1}];
%     s12 = [era{1} '_' seas{2}];
%     s21 = [era{2} '_' seas{1}];
%     s22 = [era{2} '_' seas{2}];
%     strs = {s11; s12; s21; s22};
%     plot_4x1(strs, opts);
%     
% elseif iscell(era) && iscell(seas) && size(era,2) == 2 && size(seas,1) == 2
%     s11 = [era{1} '_' seas{1}];
%     s12 = [era{2} '_' seas{1}];
%     s21 = [era{1} '_' seas{2}];
%     s22 = [era{2} '_' seas{2}];
%     strs = {s11 s12; s21 s22};
%     opts.ylabel = 'season';
%     opts.title = 'era';
%     plot_2x2(strs, opts);
%     
% elseif iscell(era) && iscell(seas) && size(era,1) == 2 && size(seas,2) == 2
%     s11 = [era{1} '_' seas{1}];
%     s12 = [era{1} '_' seas{2}];
%     s21 = [era{2} '_' seas{1}];
%     s22 = [era{2} '_' seas{2}];
%     strs = {s11 s12; s21 s22};
%     opts.ylabel = 'era';
%     opts.title = 'season';
%     plot_2x2(strs, opts);
%     
% elseif iscell(era) && iscell(seas) && size(era,2) == 2 && size(seas,2) == 2
%     s11 = [era{1} '_' seas{1}];
%     s12 = [era{1} '_' seas{2}];
%     s21 = [era{2} '_' seas{1}];
%     s22 = [era{2} '_' seas{2}];
%     strs = {s11 s12 s21 s22};
%     plot_1x4(strs, opts);
%     
% elseif iscell(seas) && size(seas,1) == 2 && size(seas,2) == 1
%     % Compare two seasons, side-by-side.
%     s1 = [era '_' seas{1}];
%     s2 = [era '_' seas{2}];
%     opts.compare = 'season';
%     plot_2x1(s1,s2,opts);
%     
% elseif iscell(seas) && size(seas,1) == 1 && size(seas,2) == 2
%     % compare two seasons, side-by-side.
%     s1 = [era '_' seas{1}];
%     s2 = [era '_' seas{2}];
%     opts.compare = 'season';
%     plot_1x2(s1,s2,opts);
% 
% elseif iscell(era) && size(era,1) == 2 && size(era,2) == 1
%     % Compare two eras, side-by-side.
%     s1 = [era{1} '_' seas];
%     s2 = [era{2} '_' seas];
%     opts.compare = 'era';
%     plot_2x1(s1,s2,opts);    
% 
% elseif iscell(era) && size(era,1) == 1 && size(era,2) == 2
%     % Compare two eras, side-by-side.
%     s1 = [era{1} '_' seas];
%     s2 = [era{2} '_' seas];
%     opts.compare = 'era';
%     plot_1x2(s1,s2,opts);
% 
% elseif strfind([era seas],'-')
%     % Compare by subtraction.
%     strs.era = era;
%     strs.season = seas;
%     if strfind(era,'-')
%         opts.compare = 'era';
%     else
%         opts.compare = 'season';
%     end
%     plot_1x1_diff(strs,opts);
%     
% elseif strfind([era seas],'/')
%     % Compare by division.
%     strs.era = era;
%     strs.season = seas;
%     if strfind(era,'/')
%         opts.compare = 'era';
%     else
%         opts.compare = 'season';
%     end
%     plot_1x1_rat(strs,opts);
% else
%     s = [era '_' seas];
%     plot_1x1(s,opts);
% end
    
switch nargout
    case 0
    case 1
        varargout{1} = h;
    otherwise
        error('Too many output arguments requested.')
end

end

function plot_1x1(s,opts)
%PLOT_1x1 plots a single ic thingy.

% Load the domain and bed data.
load('~/School/oop/data/domain.mat');
load('~/School/oop/data/gsc.mat');
load('~/School/oop/data/nep.mat');
load('~/School/oop/data/sfl.mat');

% Declare the strings.
datadir = '~/School/oop/data/';
icstr = ['n0_' s '_'];
beds = {'gsc' 'nep' 'sfl'};

% Load the beds.
for i = 1:length(beds)
    if exist([datadir icstr beds{i} '.mat'], 'file')
        load([datadir icstr beds{i} '.mat']);
    else
        error('File not found.')
    end
end

% Make the plot.
axes('position', [.05 .05 .90 .85]);
plot(domain);
plot(gsc); plot(eval([icstr 'gsc'])/opts.scale, 'smooth', true);
plot(nep); plot(eval([icstr 'nep'])/opts.scale, 'smooth', true);
plot(sfl); plot(eval([icstr 'sfl'])/opts.scale, 'smooth', true);
%axis equal;

% Place the colorbar.
caxis(opts.caxis);
c=colorbar('location','south');
set(c,'position',[.50 .075 .40 .05]);
text(1.15e6, -.275e6, 'Larvae per  {km}^2 (10^{9})','fontsize', 12);

set(gcf,'position', [50 50 600 430]);

end

function plot_1x1_rat(strs,opts)
%PLOT_1x1_RAT plots a ratio of two guys.

% Load the domain and bed data.
load('~/School/oop/data/domain.mat');
load('~/School/oop/data/gsc.mat');
load('~/School/oop/data/nep.mat');
load('~/School/oop/data/sfl.mat');

% Declare the strings.
datadir = '~/School/oop/data/';
beds = {'gsc' 'nep', 'sfl'};
if strcmp(opts.compare,'era')
    j = strfind(strs.era,'/');
    era = strs.era; era(j) = 'v';
    s = ['n0_' era '_' strs.season '_'];
    s1 = ['n0_' strs.era(1:j-1)   '_' strs.season '_'];
    s2 = ['n0_' strs.era(j+1:end) '_' strs.season '_'];
else
    j = strfind(strs.season,'/');
    season = strs.season; season(j) = 'v';
    s = ['n0_' strs.era '_' season '_'];
    s1 = ['n0_' strs.era '_' strs.season(1:j-1)   '_'];
    s2 = ['n0_' strs.era '_' strs.season(j+1:end) '_'];
end

disp(s)
disp(s1)
disp(s2)
        
% Load the beds.
for i = 1:length(beds)
    if exist([datadir s beds{i} '.mat'], 'file')
        load([datadir s beds{i} '.mat']);
    elseif exist([datadir s1 beds{i} '.mat'], 'file') && ...
            exist([datadir s2 beds{i} '.mat'], 'file')
        
        load([datadir s1 beds{i} '.mat']);
        load([datadir s2 beds{i} '.mat']);
        eval([s beds{i} ' = ' s1 beds{i} ' / ' s2 beds{i} ';']);
    else
        error('File not found.')
    end 
end

% Normalize the data.
if opts.normalize
    for i = 1:length(beds)
        eval(['u = mean(' s1 beds{i} '.u + ' s2 beds{i} '.u)/2;']);
        eval([s beds{i} ' = ' s beds{i} '/u;']);
    end
end

% Make the plot.
axes('position', [.01 .01 .98 .89]);
plot(domain); 
plot(gsc); plot(eval([s 'gsc'])/opts.scale, 'smooth', true);
plot(nep); plot(eval([s 'nep'])/opts.scale, 'smooth', true);
plot(sfl); plot(eval([s 'sfl'])/opts.scale, 'smooth', true);
text(1.27e6, -.067e6, '(b)', 'fontsize', 14, 'backgroundcolor','white');

% Place the colorbar.
caxis(opts.caxis);
c=colorbar('location','south');
set(c,'position',[.55 .02 .40 .05]);
if opts.normalize
    text(1.15e6, -.275e6, 'Percent difference','fontsize', 12);
else
    text(1.15e6, -.275e6, 'Larvae per larva','fontsize', 12);
end

set(gcf,'position', [50 50 360 270]);
%axis equal;

end

function plot_1x1_diff(strs,opts)
%PLOT_1x1_DIFF plots a diff of two guys.

% Load the domain and bed data.
load('~/School/oop/data/domain.mat');
load('~/School/oop/data/gsc.mat');
load('~/School/oop/data/nep.mat');
load('~/School/oop/data/sfl.mat');

% Declare the strings.
datadir = '~/School/oop/data/';
beds = {'gsc' 'nep', 'sfl'};
if strcmp(opts.compare,'era')
    j = strfind(strs.era,'-');
    era = strs.era; era(j) = 'v';
    s = ['n0_' era '_' strs.season '_'];
    s1 = ['n0_' strs.era(1:j-1)   '_' strs.season '_'];
    s2 = ['n0_' strs.era(j+1:end) '_' strs.season '_'];
else
    j = strfind(strs.season,'-');
    season = strs.season; season(j) = 'v';
    s = ['n0_' strs.era '_' season '_'];
    s1 = ['n0_' strs.era '_' strs.season(1:j-1)   '_'];
    s2 = ['n0_' strs.era '_' strs.season(j+1:end) '_'];
end

% Load the beds.
for i = 1:length(beds)
    if exist([datadir s beds{i} '.mat'], 'file')
        load([datadir s beds{i} '.mat']);
    elseif exist([datadir s1 beds{i} '.mat'], 'file') && ...
            exist([datadir s2 beds{i} '.mat'], 'file')
        load([datadir s1 beds{i} '.mat']);
        load([datadir s2 beds{i} '.mat']);
        eval([s beds{i} ' = ' s1 beds{i} ' - ' s2 beds{i} ';']);
    else
        error('File not found.')
    end 
end

% Normalize the data.
if opts.normalize
    for i = 1:length(beds)
        eval(['u = mean(' s1 beds{i} '.u + ' s2 beds{i} '.u)/2;']);
        eval([s beds{i} ' = ' s beds{i} '/u;']);
    end
end

% Make the plot.
axes('position', [.05 .05 .90 .85]);
plot(domain); 
plot(gsc); plot(eval([s 'gsc'])/opts.scale, 'smooth', true);
plot(nep); plot(eval([s 'nep'])/opts.scale, 'smooth', true);
plot(sfl); plot(eval([s 'sfl'])/opts.scale, 'smooth', true);

% Place the colorbar.
caxis(opts.caxis);
c=colorbar('location','south');
set(c,'position',[.50 .075 .40 .05]);
if opts.normalize
    text(1.15e6, -.275e6, 'Percent difference','fontsize', 12);
else
    text(1.15e6, -.275e6, 'Larvae per  {km}^2 (10^{9})','fontsize', 12);
end

set(gcf,'position', [50 50 600 430]);
axis equal;

end

function plot_1x2(s1,s2,opts)
%PLOT_1x2 plots an array of the guys.

% Load the domain and bed data.
load('~/School/oop/data/domain.mat');
load('~/School/oop/data/gsc.mat');
load('~/School/oop/data/nep.mat');
load('~/School/oop/data/sfl.mat');

% Declare the strings.
datadir = '~/School/oop/data/';
s1 = ['n0_' s1 '_'];
s2 = ['n0_' s2 '_'];
beds = {'gsc' 'nep' 'sfl'};

% Load the beds.
for i = 1:length(beds)
    if exist([datadir s1 beds{i} '.mat'], 'file')
        load([datadir s1 beds{i} '.mat']);
    else
        error(['File: ' icstr beds{i} '.mat does not exist.']);
    end
    if exist([datadir s2 beds{i} '.mat'], 'file')
        load([datadir s2 beds{i} '.mat']);
    else
        error(['File: ' icstr beds{i} '.mat does not exist.']);
    end
end

% Make the plot.
f = figure;

%axes('position', [.05 .05 .9 .85]);

h1=subplot(1,2,1); plot(domain);
plot(gsc); plot(eval([s1 'gsc'])/opts.scale, 'smooth', true);
plot(nep); plot(eval([s1 'nep'])/opts.scale, 'smooth', true);
plot(sfl); plot(eval([s1 'sfl'])/opts.scale, 'smooth', true);
set(h1,'position', [.05 .05 .45 .85]); caxis(opts.caxis);
k = eval([s1 'gsc']); title(k.(opts.compare),'fontsize',14);

h2=subplot(1,2,2); plot(domain);
plot(gsc); plot(eval([s2 'gsc'])/opts.scale, 'smooth', true);
plot(nep); plot(eval([s2 'nep'])/opts.scale, 'smooth', true);
plot(sfl); plot(eval([s2 'sfl'])/opts.scale, 'smooth', true);
set(h2,'position', [.50 .05 .45 .85]);
k = eval([s2 'gsc']); title(k.(opts.compare),'fontsize',14);


% Place the colorbar.
caxis(opts.caxis);
c=colorbar('location', 'south');
set(c,'position',[.75 .065 .175 .05]);
text(1.17e6, -.275e6, 'Larvae per  {km}^2 (10^{9})','fontsize', 12);
set(gcf,'position', [50 50 1120 400]);

end

function plot_2x2(strs,opts)
%PLOT_2x2 plots a 2x2 array of ICs.
%  PLOT_2x2 uses the database to find the ics files corresponding to the four
%  string passed in through the 2x2 cell array STRS and plots them according to
%  the options specified in the struct OPTS.
%
%  PLOT_2x2(STRS, OPTS)
%
%  Example:
%  >> plot(strs, opts)
%
% See also: plot_1x1, plot_1x2, plot_2x1, plot_1x4, plot_4x1

% Make the plot.
f = figure('position', [50 50 700 500]); hold on;

spawn = load_ics(strs);

% Plot in the top left.
h1=subplot(2,2,1); plot(domain);
plot(gsc); plot(spawn(1,1).gsc/opts.scale, 'smooth', true);
plot(nep); plot(spawn(1,1).nep/opts.scale, 'smooth', true);
plot(sfl); plot(spawn(1,1).sfl/opts.scale, 'smooth', true);
caxis(opts.caxis);
text(1.27e6, -.067e6, '(a)', 'fontsize', 14, 'backgroundcolor','white');
title(eval(['n0_' strs{1,1} '_gsc.(opts.title)']), 'fontsize', 14);
ylabel(eval(['n0_' strs{1,1} '_gsc.(opts.ylabel)']), 'fontsize', 14);

% Plot in the top right.
h2=subplot(2,2,2); plot(domain);
disp(eval(['n0_' strs{2,1} '_gsc']))
plot(gsc); plot(spawn(1,2).gsc/opts.scale, 'smooth', true);
plot(nep); plot(spawn(1,2).nep/opts.scale, 'smooth', true);
plot(sfl); plot(spawn(1,2).sfl/opts.scale, 'smooth', true);
caxis(opts.caxis);
text(1.27e6, -.067e6, '(b)', 'fontsize', 14, 'backgroundcolor','white');
title(eval(['n0_' strs{1,2} '_gsc.(opts.title)']), 'fontsize', 14);

% Plot in the bottom left.
h3=subplot(2,2,3); plot(domain);
disp(eval(['n0_' strs{2,1} '_gsc']))
plot(gsc); plot(spawn(2,1).gsc/opts.scale, 'smooth', true);
plot(nep); plot(spawn(2,1).nep/opts.scale, 'smooth', true);
plot(sfl); plot(spawn(2,1).sfl/opts.scale, 'smooth', true);caxis(opts.caxis);
text(1.27e6, -.067e6, '(c)', 'fontsize', 14, 'backgroundcolor','white');
ylabel(eval(['n0_' strs{2,1} '_gsc.(opts.ylabel)']), 'fontsize', 14);

% Plot in the bottom right.
h4=subplot(2,2,4); plot(domain);
plot(gsc); plot(spawn(2,2).gsc/opts.scale, 'smooth', true);
plot(nep); plot(spawn(2,2).nep/opts.scale, 'smooth', true);
plot(sfl); plot(spawn(2,2).sfl/opts.scale, 'smooth', true);caxis(opts.caxis);
text(1.27e6, -.067e6, '(d)', 'fontsize', 14, 'backgroundcolor','white');

% Move the subfigures into position.
set(h1,'position', [.05 .45 .47 .47]);
set(h2,'position', [.52 .45 .47 .47]);
set(h3,'position', [.05 .01 .47 .47]);
set(h4,'position', [.52 .01 .47 .47]);

% Place the colorbar.
c=colorbar('location', 'south');
set(c,'position',[.800 .01 .15 .040]);
text(1.145e6, -.265e6, 'Billions per {km}^2','fontsize', 12);


end

function plot_3x2(strs,opts)
%PLOT_3x2 plots a 2x2 array of ICs.
%  PLOT_2x2 uses the database to find the ics files corresponding to the four
%  string passed in through the 2x2 cell array STRS and plots them according to
%  the options specified in the struct OPTS.
%
%  PLOT_3x2(STRS, OPTS)
%
%  Example:
%  >> plot(strs, opts)
%
% See also: plot_1x1, plot_1x2, plot_2x1, plot_1x4, plot_4x1

% Make the plot.
f = figure('position', [50 50 700 500]); hold on;

spawn = load_ics(strs);

% Plot in the top left.
h1=subplot(3,2,1); plot(domain);
plot(gsc); plot(spawn(1,1).gsc/opts.scale, 'smooth', true);
plot(nep); plot(spawn(1,1).nep/opts.scale, 'smooth', true);
plot(sfl); plot(spawn(1,1).sfl/opts.scale, 'smooth', true);
caxis(opts.caxis);
text(1.27e6, -.067e6, '(a)', 'fontsize', 14, 'backgroundcolor','white');

% Plot in the top right.
h2=subplot(3,2,2); plot(domain);
plot(gsc); plot(spawn(1,2).gsc/opts.scale, 'smooth', true);
plot(nep); plot(spawn(1,2).nep/opts.scale, 'smooth', true);
plot(sfl); plot(spawn(1,2).sfl/opts.scale, 'smooth', true);
caxis(opts.caxis);
text(1.27e6, -.067e6, '(b)', 'fontsize', 14, 'backgroundcolor','white');

% Plot in the middle left.
h3=subplot(3,2,3); plot(domain);
plot(gsc); plot(spawn(2,1).gsc/opts.scale, 'smooth', true);
plot(nep); plot(spawn(2,1).nep/opts.scale, 'smooth', true);
plot(sfl); plot(spawn(2,1).sfl/opts.scale, 'smooth', true);caxis(opts.caxis);
text(1.27e6, -.067e6, '(c)', 'fontsize', 14, 'backgroundcolor','white');


% Plot in the middle right.
h4=subplot(3,2,4); plot(domain);
plot(gsc); plot(spawn(2,2).gsc/opts.scale, 'smooth', true);
plot(nep); plot(spawn(2,2).nep/opts.scale, 'smooth', true);
plot(sfl); plot(spawn(2,2).sfl/opts.scale, 'smooth', true);caxis(opts.caxis);
text(1.27e6, -.067e6, '(d)', 'fontsize', 14, 'backgroundcolor','white');

% Plot in the bottom left.
h5=subplot(3,2,5); plot(domain);
plot(gsc); plot(spawn(2,1).gsc/opts.scale, 'smooth', true);
plot(nep); plot(spawn(2,1).nep/opts.scale, 'smooth', true);
plot(sfl); plot(spawn(2,1).sfl/opts.scale, 'smooth', true);caxis(opts.caxis);

% Plot in the bottom right.
h6=subplot(3,2,6); plot(domain);
plot(gsc); plot(spawn(2,2).gsc/opts.scale, 'smooth', true);
plot(nep); plot(spawn(2,2).nep/opts.scale, 'smooth', true);
plot(sfl); plot(spawn(2,2).sfl/opts.scale, 'smooth', true);caxis(opts.caxis);
text(1.27e6, -.067e6, '(d)', 'fontsize', 14, 'backgroundcolor','white');

% Move the subfigures into position.
set(h1,'position', [.05 .45 .47 .47]);
set(h2,'position', [.52 .45 .47 .47]);
set(h3,'position', [.05 .01 .47 .47]);
set(h4,'position', [.52 .01 .47 .47]);

% Place the colorbar.
c=colorbar('location', 'south');
set(c,'position',[.800 .01 .15 .040]);
text(1.145e6, -.265e6, 'Billions per {km}^2','fontsize', 12);


end

function spawn = load_ics(strs)

% Load the domain and bed data.
load('~/School/oop/data/domain.mat');
load('~/School/oop/data/gsc.mat');
load('~/School/oop/data/nep.mat');
load('~/School/oop/data/sfl.mat');

% Declare the strings.
datadir = '~/School/oop/data/';
beds = {'gsc' 'nep', 'sfl'};

spawn = struct;

% Load the beds.
for i = 1:length(beds)
    for j = 1:size(strs,1)
        for k = 1:size(strs,2)
            if exist([datadir 'n0_' strs{j,k} '_' beds{i} '.mat'], 'file')
                % If the Spawnfield exists, load it.
                load([datadir 'n0_' strs{j,k} '_' beds{i} '.mat']);
                spawn(j,k).(beds{i}) = eval(['n0_' strs{j,k} '_' beds{i} ';']);
            
            elseif strfind(strs{j,k},'-')
                % If two fields are to be subtracted, load them and subtract.
                s = strs{j,k};
                l = strfind(s,'-');
                s(l) = 'v';
                s1 = ['n0_' s(1:(l-1)) '_' beds{i}];
                s2 = ['n0_' s((l+1):end) '_' beds{i}];
                load([datadir s1 '.mat']);
                load([datadir s2 '.mat']);
                spawn(j,k).(beds{i}) = eval([s1 ' - ' s2 ';']);
                eval(['n0_' s '_' beds{i} '= spawn(j,k).(beds{i});']);
                save([datadir 'n0_' s '_' beds{i}], ['n0_' s '_' beds{i}]);
                
            elseif strfind(strs{j,k},'/')
                % If two fields are to be divided, load them and divide.
                s = strs{j,k};
                l = strfind(s,'/');
                s(l) = 'd';
                s1 = ['n0_' s(1:(l-1)) '_' beds{i}];
                s2 = ['n0_' s((l+1):end) '_' beds{i}];
                load([datadir s1 '.mat']);
                load([datadir s2 '.mat']);
                spawn(j,k).(beds{i}) = eval([s1 ' / ' s2 ';']);
                eval(['n0_' s '_' beds{i} '= spawn(j,k).(beds{i});']);
                save([datadir 'n0_' s '_' beds{i}], ['n0_' s '_' beds{i}]);

            else
                error(['File: n0_' strs{j,k} '_' beds{i} '.mat not found.']);
            end
        end
    end
end

end
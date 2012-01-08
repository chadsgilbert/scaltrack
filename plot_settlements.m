% plot_settlements.m

load data/domain;
load data/gsc; load data/nep; load data/sfl;

%% Flat vs. Era 2 (Pycnocline-seeking, Fall, m0)

% h = figure;
% 
% % Flat
% h1=subplot(2,3,1); load data/sett_flat_fal_py_gsc_ind.mat;
% plot_settlement(sett_flat_fal_py_gsc_ind, domain, gsc, nep, sfl);
% 
% h2=subplot(2,3,2); load data/sett_flat_fal_py_nep_ind.mat;
% plot_settlement(sett_flat_fal_py_nep_ind, domain, gsc, nep, sfl);
% 
% h3=subplot(2,3,3); load data/sett_flat_fal_py_sfl_ind.mat;
% plot_settlement(sett_flat_fal_py_sfl_ind, domain, gsc, nep, sfl);
% 
% % Era2
% h4=subplot(2,3,4); load data/sett_era2_fal_py_gsc_ind.mat;
% plot_settlement(sett_era2_fal_py_gsc_ind, domain, gsc, nep, sfl);
% 
% h5=subplot(2,3,5); load data/sett_era2_fal_py_nep_ind.mat;
% plot_settlement(sett_era2_fal_py_nep_ind, domain, gsc, nep, sfl);
% 
% h6=subplot(2,3,6); load data/sett_era2_fal_py_sfl_ind.mat;
% plot_settlement(sett_era2_fal_py_sfl_ind, domain, gsc, nep, sfl);
% 
% % Position the frames appropriately.
% set(h,  'pos', [0 0 1200 611]);
% p1n = [.05 .55 .30 .40]; set(h1, 'pos', p1n);
% p2n = [.35 .55 .30 .40]; set(h2, 'pos', p2n);
% p3n = [.65 .55 .30 .40]; set(h3, 'pos', p3n);
% p4n = [.05 .15 .30 .40]; set(h4, 'pos', p4n);
% p5n = [.35 .15 .30 .40]; set(h5, 'pos', p5n);
% p6n = [.65 .15 .30 .40]; set(h6, 'pos', p6n);
% axes('Position', [0.05 0.05 0.9 0.9], 'Visible', 'off');
% c=colorbar('location','south'); caxis([0 1e2]); 
% xlabel(c,'Number of larvae (millions)');
% set(c,'position',[.05 .05 .90 .03]);
% 
% pdfprint('settlements_flat_vs_era2_py_fal_ind','figures');


%% Flat vs. Era 2 in GSC (Pycnocline-seeking, Fall, m0)

h = figure;

% Flat
h1=subplot(2,3,1); load data/sett_flat_fal_py_gsc_ind.mat;
plot_settlement(sett_flat_fal_py_gsc_ind, domain, gsc, nep, sfl);

% Era2
h2=subplot(2,3,4); load data/sett_era2_fal_py_gsc_ind.mat;
plot_settlement(sett_era2_fal_py_gsc_ind, domain, gsc, nep, sfl);

% Position the frames appropriately.
set(h,  'pos', [0 0 500 690]);
p1n = [.01 .50 .98 .49]; set(h1, 'pos', p1n);
p2n = [.01 .01 .98 .49]; set(h2, 'pos', p2n);
c=colorbar('location','south'); set(c,'position',[.675 .025 .25 .03]);
xlabel(c,'Millions of larvae');

pdfprint('settlements_flat_vs_era2_py_fal_ind_gsc','figures');

%% Flat vs. Era 2 in NEP (Pycnocline-seeking, Fall, m0)

h = figure;

% Flat
h1=subplot(2,3,1); load data/sett_flat_fal_py_nep_ind.mat;
plot_settlement(sett_flat_fal_py_nep_ind, domain, gsc, nep, sfl);

% Era2
h2=subplot(2,3,4); load data/sett_era2_fal_py_nep_ind.mat;
plot_settlement(sett_era2_fal_py_nep_ind, domain, gsc, nep, sfl);

% Position the frames appropriately.
set(h,  'pos', [0 0 500 690]);
p1n = [.01 .50 .98 .49]; set(h1, 'pos', p1n);
p2n = [.01 .01 .98 .49]; set(h2, 'pos', p2n);
c=colorbar('location','south'); set(c,'position',[.675 .025 .25 .03]);
xlabel(c,'Millions of larvae');

pdfprint('settlements_flat_vs_era2_py_fal_ind_nep','figures');

%% Flat vs. Era 2 in SFL (Pycnocline-seeking, Fall, m0)

h = figure;

% Flat
h1=subplot(2,3,1); load data/sett_flat_fal_py_sfl_ind.mat;
plot_settlement(sett_flat_fal_py_sfl_ind, domain, gsc, nep, sfl);

% Era2
h2=subplot(2,3,4); load data/sett_era2_fal_py_sfl_ind.mat;
plot_settlement(sett_era2_fal_py_sfl_ind, domain, gsc, nep, sfl);

% Position the frames appropriately.
set(h,  'pos', [0 0 500 690]);
p1n = [.01 .50 .98 .49]; set(h1, 'pos', p1n);
p2n = [.01 .01 .98 .49]; set(h2, 'pos', p2n);
c=colorbar('location','south'); set(c,'position',[.675 .025 .25 .03]);
xlabel(c,'Millions of larvae');

pdfprint('settlements_flat_vs_era2_py_fal_ind_s','figures');


%% Spring vs. Fall in GSC (Pycnocline-seeking, Era2, m0)

h = figure;

% Flat
h1=subplot(2,3,1); load data/sett_era2_spr_py_gsc_ind.mat;
plot_settlement(sett_era2_spr_py_gsc_ind, domain, gsc, nep, sfl);

% Era2
h2=subplot(2,3,4); load data/sett_era2_fal_py_gsc_ind.mat;
plot_settlement(sett_era2_fal_py_gsc_ind, domain, gsc, nep, sfl);

% Position the frames appropriately.
set(h,  'pos', [0 0 500 690]);
p1n = [.01 .50 .98 .49]; set(h1, 'pos', p1n);
p2n = [.01 .01 .98 .49]; set(h2, 'pos', p2n);
c=colorbar('location','south'); set(c,'position',[.675 .025 .25 .03]);
xlabel(c,'Millions of larvae');

pdfprint('settlements_spr_vs_fal_py_era2_ind_gsc','figures');

%% Spring vs. Fall in NEP (Pycnocline-seeking, Era2, m0)

h = figure;

% Flat
h1=subplot(2,3,1); load data/sett_era2_spr_py_nep_ind.mat;
plot_settlement(sett_era2_spr_py_nep_ind, domain, gsc, nep, sfl);

% Era2
h2=subplot(2,3,4); load data/sett_era2_fal_py_nep_ind.mat;
plot_settlement(sett_era2_fal_py_nep_ind, domain, gsc, nep, sfl);

% Position the frames appropriately.
set(h,  'pos', [0 0 500 690]);
p1n = [.01 .50 .98 .49]; set(h1, 'pos', p1n);
p2n = [.01 .01 .98 .49]; set(h2, 'pos', p2n);
c=colorbar('location','south'); set(c,'position',[.675 .025 .25 .03]);
xlabel(c,'Millions of larvae');

pdfprint('settlements_spr_vs_fal_py_era2_ind_nep','figures');

%% Spring vs. Fall in SFL (Pycnocline-seeking, Era2, m0)

h = figure;

% Flat
h1=subplot(2,3,1); load data/sett_era2_spr_py_sfl_ind.mat;
plot_settlement(sett_era2_spr_py_sfl_ind, domain, gsc, nep, sfl);

% Era2
h2=subplot(2,3,4); load data/sett_era2_fal_py_sfl_ind.mat;
plot_settlement(sett_era2_fal_py_sfl_ind, domain, gsc, nep, sfl);

% Position the frames appropriately.
set(h,  'pos', [0 0 500 690]);
p1n = [.01 .50 .98 .49]; set(h1, 'pos', p1n);
p2n = [.01 .01 .98 .49]; set(h2, 'pos', p2n);
c=colorbar('location','south'); set(c,'position',[.675 .025 .25 .03]);
xlabel(c,'Millions of larvae');

pdfprint('settlements_spr_vs_fal_py_era2_ind_sfl','figures');



% %% Spring vs. Fall (Pycnocline-seeking, Era1, m0)
% 
% h = figure;
% 
% % Fall
% h1=subplot(3,2,1); load data/sett_era1_fal_py_gsc_ind.mat;
% plot_settlement(sett_era1_fal_py_gsc_ind, domain, gsc, nep, sfl);
% 
% h3=subplot(3,2,3); load data/sett_era1_fal_py_nep_ind.mat;
% plot_settlement(sett_era1_fal_py_nep_ind, domain, gsc, nep, sfl);
% 
% h5=subplot(3,2,5); load data/sett_era1_fal_py_sfl_ind.mat;
% plot_settlement(sett_era1_fal_py_sfl_ind, domain, gsc, nep, sfl);
% 
% % Spring
% h2=subplot(3,2,2); load data/sett_era1_spr_py_gsc_ind.mat;
% plot_settlement(sett_era1_spr_py_gsc_ind, domain, gsc, nep, sfl);
% 
% h4=subplot(3,2,4); load data/sett_era1_spr_py_nep_ind.mat;
% plot_settlement(sett_era1_spr_py_nep_ind, domain, gsc, nep, sfl);
% 
% h6=subplot(3,2,6); load data/sett_era1_spr_py_sfl_ind.mat;
% plot_settlement(sett_era1_spr_py_sfl_ind, domain, gsc, nep, sfl);
% 
% % Position the frames appropriately.
% set(h,  'pos', [0 0 700 800]);
% p1n = [.10 .61 .44 .29]; set(h1, 'pos', p1n);
% p2n = [.55 .61 .44 .29]; set(h2, 'pos', p2n);
% p3n = [.10 .31 .44 .29]; set(h3, 'pos', p3n);
% p4n = [.55 .31 .44 .29]; set(h4, 'pos', p4n);
% p5n = [.10 .01 .44 .29]; set(h5, 'pos', p5n);
% p6n = [.55 .01 .44 .29]; set(h6, 'pos', p6n);
% 
% pdfprint('settlements_py_era1_ind','figures');

%% Spring vs. Fall (Pycnocline-seeking, Era2, m0)
% 
% h = figure;
% 
% % Fall
% h1=subplot(3,2,1); load data/sett_era2_fal_py_gsc_ind.mat;
% plot_settlement(sett_era2_fal_py_gsc_ind, domain, gsc, nep, sfl);
% 
% h3=subplot(3,2,3); load data/sett_era2_fal_py_nep_ind.mat;
% plot_settlement(sett_era2_fal_py_nep_ind, domain, gsc, nep, sfl);
% 
% h5=subplot(3,2,5); load data/sett_era2_fal_py_sfl_ind.mat;
% plot_settlement(sett_era2_fal_py_sfl_ind, domain, gsc, nep, sfl);
% 
% % Spring
% h2=subplot(3,2,2); load data/sett_era2_spr_py_gsc_ind.mat;
% plot_settlement(sett_era2_spr_py_gsc_ind, domain, gsc, nep, sfl);
% 
% h4=subplot(3,2,4); load data/sett_era2_spr_py_nep_ind.mat;
% plot_settlement(sett_era2_spr_py_nep_ind, domain, gsc, nep, sfl);
% 
% h6=subplot(3,2,6); load data/sett_era2_spr_py_sfl_ind.mat;
% plot_settlement(sett_era2_spr_py_sfl_ind, domain, gsc, nep, sfl);
% 
% % Position the frames appropriately.
% set(h,  'pos', [0 0 700 800]);
% p1n = [.10 .61 .44 .29]; set(h1, 'pos', p1n);
% p2n = [.55 .61 .44 .29]; set(h2, 'pos', p2n);
% p3n = [.10 .31 .44 .29]; set(h3, 'pos', p3n);
% p4n = [.55 .31 .44 .29]; set(h4, 'pos', p4n);
% p5n = [.10 .01 .44 .29]; set(h5, 'pos', p5n);
% p6n = [.55 .01 .44 .29]; set(h6, 'pos', p6n);
% 
% pdfprint('settlements_py_era2_ind','figures');
% 
% 
% %% Era1 vs. Era 2 (Pycnocline-seeking, Fall, m0)
% 
% h = figure;
% 
% % Era1
% h1=subplot(3,2,1); load data/sett_era1_fal_py_gsc_ind.mat;
% plot_settlement(sett_era1_fal_py_gsc_ind, domain, gsc, nep, sfl);
% 
% h3=subplot(3,2,3); load data/sett_era1_fal_py_nep_ind.mat;
% plot_settlement(sett_era1_fal_py_nep_ind, domain, gsc, nep, sfl);
% 
% h5=subplot(3,2,5); load data/sett_era1_fal_py_sfl_ind.mat;
% plot_settlement(sett_era1_fal_py_sfl_ind, domain, gsc, nep, sfl);
% 
% % Era2
% h2=subplot(3,2,2); load data/sett_era2_fal_py_gsc_ind.mat;
% plot_settlement(sett_era2_fal_py_gsc_ind, domain, gsc, nep, sfl);
% 
% h4=subplot(3,2,4); load data/sett_era2_fal_py_nep_ind.mat;
% plot_settlement(sett_era2_fal_py_nep_ind, domain, gsc, nep, sfl);
% 
% h6=subplot(3,2,6); load data/sett_era2_fal_py_sfl_ind.mat;
% plot_settlement(sett_era2_fal_py_sfl_ind, domain, gsc, nep, sfl);
% 
% % Position the frames appropriately.
% set(h,  'pos', [0 0 700 800]);
% p1n = [.10 .61 .44 .29]; set(h1, 'pos', p1n);
% p2n = [.55 .61 .44 .29]; set(h2, 'pos', p2n);
% p3n = [.10 .31 .44 .29]; set(h3, 'pos', p3n);
% p4n = [.55 .31 .44 .29]; set(h4, 'pos', p4n);
% p5n = [.10 .01 .44 .29]; set(h5, 'pos', p5n);
% p6n = [.55 .01 .44 .29]; set(h6, 'pos', p6n);
% 
% pdfprint('settlements_py_fal_ind','figures');
% 
% %% Era1 vs. Era 2 (Pycnocline-seeking, Spring, m0)
% 
% h = figure;
% 
% % Era1
% h1=subplot(3,2,1); load data/sett_era1_spr_py_gsc_ind.mat;
% plot_settlement(sett_era1_spr_py_gsc_ind, domain, gsc, nep, sfl);
% 
% h3=subplot(3,2,3); load data/sett_era1_spr_py_nep_ind.mat;
% plot_settlement(sett_era1_spr_py_nep_ind, domain, gsc, nep, sfl);
% 
% h5=subplot(3,2,5); load data/sett_era1_spr_py_sfl_ind.mat;
% plot_settlement(sett_era1_spr_py_sfl_ind, domain, gsc, nep, sfl);
% 
% % Era2
% h2=subplot(3,2,2); load data/sett_era2_spr_py_gsc_ind.mat;
% plot_settlement(sett_era2_spr_py_gsc_ind, domain, gsc, nep, sfl);
% 
% h4=subplot(3,2,4); load data/sett_era2_spr_py_nep_ind.mat;
% plot_settlement(sett_era2_spr_py_nep_ind, domain, gsc, nep, sfl);
% 
% h6=subplot(3,2,6); load data/sett_era2_spr_py_sfl_ind.mat;
% plot_settlement(sett_era2_spr_py_sfl_ind, domain, gsc, nep, sfl);
% 
% % Position the frames appropriately.
% set(h,  'pos', [0 0 700 800]);
% p1n = [.10 .61 .44 .29]; set(h1, 'pos', p1n);
% p2n = [.55 .61 .44 .29]; set(h2, 'pos', p2n);
% p3n = [.10 .31 .44 .29]; set(h3, 'pos', p3n);
% p4n = [.55 .31 .44 .29]; set(h4, 'pos', p4n);
% p5n = [.10 .01 .44 .29]; set(h5, 'pos', p5n);
% p6n = [.55 .01 .44 .29]; set(h6, 'pos', p6n);
% 
% pdfprint('settlements_py_spr_ind','figures');
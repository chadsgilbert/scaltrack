% plot_ics


load data/gsc; load data/nep; load data/sfl;
load domain;

%% Flat vs Era2 (Fall)

h = figure;

h1=subplot(2,1,1);
plot(domain); hold on; plot(gsc); plot(nep); plot(sfl);
load data/n0_flat_fal_gsc.mat; plot(n0_flat_fal_gsc); caxis([0 2e12]);
load data/n0_flat_fal_nep.mat; plot(n0_flat_fal_nep); caxis([0 2e12]);
load data/n0_flat_fal_sfl.mat; plot(n0_flat_fal_sfl); caxis([0 2e12]);

h2=subplot(2,1,2);
plot(domain); hold on; plot(gsc); plot(nep); plot(sfl);
load data/n0_era2_fal_gsc.mat; plot(n0_era2_fal_gsc); caxis([0 2e12]);
load data/n0_era2_fal_nep.mat; plot(n0_era2_fal_nep); caxis([0 2e12]);
load data/n0_era2_fal_sfl.mat; plot(n0_era2_fal_sfl); caxis([0 2e12]);

set(h,  'pos', [0 0 500 690]);
p1n = [.01 .50 .98 .49]; set(h1, 'pos', p1n);
p2n = [.01 .01 .98 .49]; set(h2, 'pos', p2n);

c=colorbar('location','south'); set(c,'position',[.675 .025 .25 .03]);
xlabel(c,'Larvae per km (10^{12})'); caxis([0 2e12]);

pdfprint('ics_flat_vs_era2_fal','figures');

%% Era1 vs Era2 (Fall)

h = figure;

h1=subplot(2,1,1);
plot(domain); hold on; plot(gsc); plot(nep); plot(sfl);
load data/n0_era1_fal_gsc.mat; plot(n0_era1_fal_gsc); caxis([0 2e12]);
load data/n0_era1_fal_nep.mat; plot(n0_era1_fal_nep); caxis([0 2e12]);
load data/n0_era1_fal_sfl.mat; plot(n0_era1_fal_sfl); caxis([0 2e12]);

h2=subplot(2,1,2);
plot(domain); hold on; plot(gsc); plot(nep); plot(sfl);
load data/n0_era2_fal_gsc.mat; plot(n0_era2_fal_gsc); caxis([0 2e12]);
load data/n0_era2_fal_nep.mat; plot(n0_era2_fal_nep); caxis([0 2e12]);
load data/n0_era2_fal_sfl.mat; plot(n0_era2_fal_sfl); caxis([0 2e12]);

set(h,  'pos', [0 0 500 690]);
p1n = [.01 .50 .98 .49]; set(h1, 'pos', p1n);
p2n = [.01 .01 .98 .49]; set(h2, 'pos', p2n);

c=colorbar('location','south'); set(c,'position',[.675 .025 .25 .03]);
xlabel(c,'Larvae per km (10^{12})'); caxis([0 2e12]);

pdfprint('ics_era1_vs_era2_fal','figures');

%% Spring vs. Fall (Era2)

h = figure;

h1=subplot(2,1,1);
plot(domain); hold on; plot(gsc); plot(nep); plot(sfl);
load data/n0_era2_spr_gsc.mat; plot(n0_era2_spr_gsc); caxis([0 2e12]);
load data/n0_era2_spr_nep.mat; plot(n0_era2_spr_nep); caxis([0 2e12]);
load data/n0_era2_spr_sfl.mat; plot(n0_era2_spr_sfl); caxis([0 2e12]);

h2=subplot(2,1,2);
plot(domain); hold on; plot(gsc); plot(nep); plot(sfl);
load data/n0_era2_fal_gsc.mat; plot(n0_era2_fal_gsc); caxis([0 2e12]);
load data/n0_era2_fal_nep.mat; plot(n0_era2_fal_nep); caxis([0 2e12]);
load data/n0_era2_fal_sfl.mat; plot(n0_era2_fal_sfl); caxis([0 2e12]);

set(h,  'pos', [0 0 500 690]);
p1n = [.01 .50 .98 .49]; set(h1, 'pos', p1n);
p2n = [.01 .01 .98 .49]; set(h2, 'pos', p2n);

c=colorbar('location','south'); set(c,'position',[.675 .025 .25 .03]);
xlabel(c,'Larvae per km (10^{12})'); caxis([0 2e12]);

pdfprint('ics_spr_vs_fal_era2','figures');
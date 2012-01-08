function plot_settlement(settlement, domain, gsc, nep, sfl)
%PLOT_SETTLEMENT plots the settlement distribution of one model run.
%  PLOT_SETTLEMENT makes a pcolor plot of the settlement distribution of
%  particles or larvae (depending on which sim is being plotted), by using a
%  ready-made Settlement object to make the plot.
%
%  This function is not intended to be versatile; it is a support function that
%  is used in several other mfiles, where convenient.
%
%  PLOT_SETTLEMENT(SETTOBJ, DOMOBJ, GSC, NEP, SFL) where SETTOBJ is a Settlement
%  object, DOMOBJ is a domain object, GSC, NEP and SFL are the three Bed 
%  objects, makes the plot.
%
%  Example:
%  >> plot_settlement(settlement, domain, gsc, nep, sfl);
%  plots the settlement.
%
%See also: Settlement, Domain, Bed

hold on; 
plot(domain,'set_dim',false);
plot(gsc); 
plot(nep); 
plot(sfl);
pcolor(settlement);
axis([domain.xvec(1) domain.xvec(end) domain.yvec(1) domain.yvec(end)]);

end
function plot(this)
%PLOT overloads PLOT for the CTIMESERIES class.
%
%  PLOT plots a CTIMESERIES object, with the labels right and everything.
%
%  PLOT(THIS) is the only call it takes. This iwll plot the timeseries with the
%  mean, error bars, and labels all done up just right.

% Only label and reshape the axes if the plot is new. Otherwise leav'em alone.
isheld = ishold;

% Make the plot.
errorbar(this.x, this.y, this.e, 'k', 'linewidth', 2); hold on;
scatter(this.x, this.y, 50, 'k', 'filled');
% if (max(this.x)-min(this.x)) > 700 
%     datetick('x', 'yy');
% else
%     datetick('x', 'm');
% end
    
    

% If it's a new figure, format it appropriately.
if ~isheld
    set(gcf,'position', [20 20 1200 500])
    if ~isempty(this.xax), xlabel([this.xax ' [' this.xunits ']']); end
    if ~isempty(this.yax), ylabel([this.yax ' [' this.yunits ']']); end
    if ~isempty(this.name), title(this.name); end
    
    switch this.xunits
        case 'months'
            set(gca, 'xtick', this.x);
            monthlabels=cell(size(this.x));
            for i = 1:12:ceil(length(this.x))
                monthlabels(i:i+11) = get_month_array('m');
            end
            set(gca, 'xticklabel', monthlabels);
        case 'years'
            set(gca, 'xtick', this.x);
            yearlabels = num2cell(mod(this.x,100));
            set(gca, 'xticklabel', yearlabels);
        otherwise
            set(gca, 'xtick', this.x);
    end
    axis([this.x(1)-0.5 this.x(end)+0.5 0 max(this.range)])
    
    hold off;
end

end
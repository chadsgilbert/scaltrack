function formatwindow(this, isheld, fld)
%FORMATWINDOW formats the window nicely, but only if a new plot is being made.

if ~isheld, set(gcf,'position', [20 20 1200 500]); end

% Add pts near the start and end of the year, to make sure it all gets plotted.
minx = datenum(min(this.year),1,15);
maxx = datenum(max(this.year),12,15);
ys = get_yrange(this,fld);
scatter([minx maxx], [mean(ys) mean(ys)], 'w.');

if max(this.year) == min(this.year)
    % Decorate with monthly tick labels.
    for m = 1:12
        xlin = datenum(this.year,m,1);
        line([xlin xlin], ys, 'linestyle', '--', 'color', [0.5 0.5 0.5]);
    end
    datetick('x', 'm')
else
    % Decorate with yearly tick labels.
    for y = min(this.year):max(this.year)
        xlin = datenum(y,1,1);
        line([xlin xlin], ys, 'linestyle', '--', 'color', [0.5 0.5 0.5]);
    end
    datetick('x', 'yy')
end

axis([datenum(min(this.year),1,1) datenum(max(this.year),12,31) ...
    get_yrange(this,fld)]);

end

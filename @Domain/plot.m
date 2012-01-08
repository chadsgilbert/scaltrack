function varargout = plot(this, varargin)
%PLOT overloads PLOT for the Domain class.
%  PLOT plots the bathymetric contours of the domain on a nicely formatted
%  figure window.
%
%  PLOT(DOMOBJ) makes the map in x/y coordinates using the projection from 
%  FVCOM.
%
%  F = PLOT(...) returns the figure handle, only if requested.
%
%  PLOT(..., OPT, VAL) appending an option OPT and a corresponding value VAL
%  changes the default plotting options. Optional arguments and their values
%  are:
%    'plot_ca'  - Decide whether to plot the losed areas (t/f). Default: false.
%    'm_map'    - Decide whether to plot in x/y or lon/lat (t/f). Default: x/y. 
%                 If using m_map, set projection using "m_proj" before plotting.
%    'plot_icj' - decide whether to plot the icj_line (t/f). Default: false.
%    'linecolor'- an rgb valued array. Default: [0 0 0].
%    'set_dim'  - Decide whether to set the dimension on the figure window to
%                 match the property 'plot_dimensions'. Default: true.
%    
%  Example:
%  >> dom = Domain(xydom);
%  >> plot(dom)
%  Plots the domain object dom.
%
%  >> m_proj('lambert','lon',[-71 -65],'lat',[39.5 42.5]);
%  >> m_grid('box','on','tickdir','out','fontsize', 20, ...
%        'xtick', [-71 -70 -69 -68 -67 -66 -65], ...
%        'ytick', [40 41 42], ...
%        'xticklabels', [-71 -70 -69 -68 -67 -66 -65], ...
%        'yticklabels', [40 41 42] );
%  >>plot(domain);
%  Plots the domain using m_map, with the 'Lambert' projection.
%
%See also: Domain

% Set the default options.
opts.plot_ca = false;       % Toggle whether to plot the closed areas.
opts.m_map = false;         % Toggle whether to plot using m_map.
opts.plot_icj = false;      % Toggle whether to plot the ICJ line.
opts.linecolor = [0 0 0];   % Choose a line color to use in the plot.
opts.set_dim = true;        % Toggle whether to use the default dimensions.

% Loop through the optional input arguments and assign their values.
for i = 1:2:(nargin-1)
    opts.(varargin{i}) = varargin{i+1};
end

% Remember the previous state of 'hold'.
isheld = ishold; hold on;

% Make the bathymetry plot.
if opts.m_map
    % ... Using m_map.
    m_contourf(this.xvec, this.yvec, -this.dpth, [0 0]); colormap('gray');
    m_contour(this.xvec, this.yvec, this.dpth, ...
        this.contour_depths, 'color', opts.linecolor);
    
else
    % ... in regular x/y coordinates.
    contour(this.xvec, this.yvec, this.dpth, ...
        this.contour_depths, 'color', opts.linecolor);
    for i = 1:length(this.land)
        fill(this.land{i}(1,:), this.land{i}(2,:), 'k');
    end
    set(gca, 'xtick', [], 'ytick', [], 'box', 'on');
    
end

% Add the closed areas to the plot.
if opts.plot_ca && opts.m_map
    % ... using m_map.
    for i = 1:length(this.ca)
        m_plot(this.ca{i}(1,:), this.ca{i}(2,:), ...
            'r', 'linewidth', 2);
    end
    
elseif opts.plot_ca && ~opts.m_map
    % ... in regular x/y coordinates.
    for i = 1:length(this.ca)
        plot(this.ca{i}(1,:), this.ca{i}(2,:), 'r', 'linewidth', 2);
    end
    
end

% Plot the icj line.
if opts.plot_icj && opts.m_map
    % ... using m_map.
    if isempty(this.ib)
        icj_lon = [-67.46806-.01, -65.69972-.01];
        icj_lat = [ 42.51889-.01,  40.45139-.01];
        m_plot(icj_lon, icj_lat, 'k--');
        m_text(-65.7, 40.3, 'ICJ line', 'fontsize', 14);
    else
        for i = 1:length(this.ib)
            m_plot(this.ib{i}(1,:), this.ib{i}(2,:), 'k--');
        end
    end
        
elseif opts.plot_icj && ~opts.m_map
    %... in regular x/y coordinates.
    for i = 1:length(this.ib)
        plot(this.ib{i}(1,:), this.ib(2,:), 'k--');
    end
end

% reshape the figure window so that the map looks all pretty-like.
if opts.set_dim
    set(gcf, 'position', this.plot_dimensions);
    set(gca, 'position', [.05 .05 .9 .9]);
end

% Reset the previous state of 'hold'
if ~isheld, hold off; end

% Return the figure handle only if requested.
if ismember(nargout, 1)
    varargout{1} = gca; 
end

end
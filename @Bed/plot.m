function varargout = plot(this, varargin)
%PLOT overloads PLOT for the Bed class.
%  PLOT plots the outline of a bed and fills in the middle and stuff like that.
%
%  PLOT(BEDOBJ) plots the outline of the bed.
%
%  PLOT(BEDOBJ, 'fill', VAL) if VAL is true, fills the bed with grey shading and
%  if false, leaves the bed unfilled. Default: true.
%
%  PLOT(BEDOBJ, 'zoom', VAL) if VAL is true, zooms the plot in on the bed being
%  plotted. If false, leaves the axis as is. Default: false.
%
%  PLOT(BEDOBJ, 'label', VAL) if VAL is true, places a text label in the middle
%  of the bed. Default: false.
%
%  PLOT(BEDOBJ, 'm_map', VAL) if VAL is true, plots the bed in lat/lon
%  coordinates using m_map instead of 
%
%  Example:
%    >> load nep025_4x4
%    >> plot(Bed(nep), 'fill', true, 'zoom', true)
%    plots the NEP, fills it in with grey and zooms in on it.
%
%See also: Bed, scatter, zoom

% Set the default options.
opts.fill = [0.8 0.8 0.8];  % To fill the bed.
opts.iszoom = false;        % Decide whether to zoom in on the bed.
opts.label = false;         % Decide whether to label the bed.
opts.m_map = false;         % Plot using standard MATLAB (F) or with m_map (T).
opts.plot_gap = true;       % Plot gaps within the beds (i.e. GSC).

% Loop through the optional input arguments and assign their values.
for i = 1:2:(nargin-1)
    opts.(varargin{i}) = varargin{i+1};
end

% Remember the "hold" state of gcf from before the function was called.
isheld = ishold; hold on;

% Fill the bed.
if isnumeric(opts.fill) && opts.m_map
    % Use m_map functions to fill for lat/lon coordinates.
    m_patch(this.border_ll(1,:), this.border_ll(2,:), opts.fill);
    if opts.plot_gap
        for i = 1:length(this.gap)
            m_patch(this.gap_ll{i}(1,:), this.gap_ll{i}(2,:), [1 1 1]);
        end
    end
    
elseif isnumeric(opts.fill) && ~opts.m_map
    % Use matlab builtins to fill for x/y coordinates.
    fill(this.border(1,:), this.border(2,:), [0.7 0.7 0.7]);
    if opts.plot_gap
        for i = 1:length(this.gap)
            fill(this.gap{i}(1,:), this.gap{i}(2,:), [1 1 1]);
        end
    end
end % Filled the bed.

% Plot the border.
if opts.m_map
    % In lat/lon.
    m_plot(this.border_ll(1,:), this.border_ll(2,:), 'k');
    if opts.plot_gap
        for i = 1:length(this.gap)
            m_plot(this.gap_ll{i}(:,1), this.gap_ll{i}(:,2), 'k');
        end
    end
    
elseif ~opts.m_map
    % In x/y.
    plot(this.border(1,:), this.border(2,:), 'k--', 'linewidth', 2);
    if opts.plot_gap
        for i = 1:length(this.gap)
            plot(this.gap{i}(1,:), this.gap{i}(2,:), 'k--', 'linewidth', 2);
        end
    end
end % Plotted the border.

% Label the bed.
if opts.label && opts.m_map
    
    switch this.name
        case 'GSC'
            m_text(-69.3, 41.0, 'GSC', 'fontsize', 20);
        case 'NEP'
            m_text(-66.7, 41.9, 'NEP', 'fontsize', 20);
        case 'SFL'
            m_text(-67.1, 41.1, 'SF' , 'fontsize', 20);
        otherwise
            warning('chadoop:Bed:plot','Bed not recognized.')
    end
    
elseif opts.label && ~opts.m_map
    
    text(this.labelpos(1), this.labelpos(2), this.name, 'fontsize', 20);
    
end

if opts.iszoom, zoom(this); end     % Zoom in on the bed.
if ~isheld, hold off; end           % Reset the hold state.

% Assign the output arguments.
switch nargout
    case 0
        
    case 1
        varargout{1} = gcf;
    otherwise
        error('Too many output arguments requested.')
end

end
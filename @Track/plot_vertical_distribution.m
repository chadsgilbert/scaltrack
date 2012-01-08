function varargout = plot_vertical_distribution(varargin)
%PLOT_VERTICAL_DISTRIBUTION plot distribution of particles rel. to pycnocline
%  PLOT_VERTICAL_DISTRIBUTION makes a contour plot of particle density as a
%  function of depth. The depth is not absolute depth, but depth above or below
%  the local pycnocline.
%
%  PLOT_VERTICAL_DISTRIBUTION(TROBJ, DVEC, TVEC) uses the Track object TROBJ to
%  find the density of particles at each point specified by DVEC and TVEC. DVEC
%  specifies the depths at which to estimate particle density in a [mx1] vector,
%  and TVEC specifies the times at which to estimate the distribution in a [1xn]
%  vector.
%
%  PLOT_VERTICAL_DISTRIBUTION(V_DISP, DVEC, TVEC) uses a vertical distribution,
%  already computed (perhaps by GET_VERTICAL_DISTRIBUTION), to make the plot.
%  This will be faster, since the vertical distribution is not re-computed each 
%  time.
%
%  Example:
%  >> dvec = (5:5:60)';
%  >> tvec = 0:1:60;
%  >> plot_vertical_distribution(tr_obj, dvec, tvec);
%  makes a plot like that in figure 5 of Gilbert et al. (2010).
%
%See also: Track, get_vertical_distribution

% Check and assign the input arguments.
if (nargin == 3) && isnumeric(varargin{1})
    % If the vertical distribution is given as an argument, just plot it.
    v_disp = varargin{1};
    dvec = reshape(varargin{2}, length(varargin{2}), 1);
    tvec = reshape(varargin{3}, 1, length(varargin{3}));
elseif (nargin == 3) && isa(varargin{1}, 'Track')
    % If a Track object is given as an argument, get distribution, then plot it.
    dvec = reshape(varargin{2}, length(varargin{2}), 1);
    tvec = reshape(varargin{3}, 1, length(varargin{3}));
    [v_disp,pct] = get_vertical_distribution(varargin{1}, dvec, tvec);
else
    error('Invalid input arguments passed to plot_vertical_distribution.');
end

% Make the plot.
[cout,H] = contourf(tvec, dvec, v_disp, [0 0.001 0.01 0.02 0.05]);
cb = colorbarf(cout, H, 'vert');
set(cb,'yticklabel',{'','0%','0.1%','1%','2%','5%',''});
caxis([0 0.05]);
xlabel('Time (days)', 'fontname', 'Arial', 'fontsize', 12)
ylabel('Depth relative to pycnocline (m)', 'fontname', 'Arial', 'fontsize', 12)
c=colormap('gray');
colormap(flipud(c))
axis([tvec(1) tvec(end) min(dvec) max(dvec)])
set(gca, 'Fontname', 'Arial', 'Fontsize', 12)

% Assign the output arguments.
switch nargout
    case 0
        % This space intentionally left blank.
    case 1
        varargout{1} = v_disp;
    case 2
        varargout{1} = v_disp;
        varargout{2} = pct;
    otherwise
        error('Wrong number of output arguments requested.');
end

end
function varargout = plot(this, varargin)
%PLOT overloads plot for the Track class.
%  PLOT makes a plot of the distribution of particles represented by the Track.
%  The primary purpose and default behaviour of this method is to plot the
%  settlement distribution of particles as a density contour. Alternatively, the
%  distribution can be plotted for any time, and can also be made as a scatter
%  plot instead of a pcolor.
%
%  PLOT(TROBJ) plots the settlement distribution as a pcolor plot.
%
%  PLOT(TROBJ, 'scatter', {OPTS}) makes it a scatter instead of a pcolor. Any
%  number of formatting options for the scatter plot can follow in the OPTS
%  cell. E.g.plot(tr, 'scatter', {50, 'rs', 'filled'}) will plot the scatter
%  points at size 50 filled red squares. Pass in an empty cell in order to use
%  the default scatter plot.
%
%  PLOT(TROBJ, 'pld', PLD) makes the plot for the settlement time(s) listed in
%  IPLD. This can be one number, which will be taken as the settlement time for
%  all particles, or it can be a vector with each element corresponding to one
%  particle.
%
%  PLOT(TROBJ, 'ipld', IPLD) is the same as the 'pld', but lists settlement
%  times in terms of time-steps instead of days.
%
%  Options can be combined if compatible. If both 'pld' and 'ipld' are 
%  specified, the last one in the list will be used.
%
%  Example:
%  >> plot(tdobj, 'scatter', {'filled'}, 'pld', 35)
%
%See also: scatter, pcolor, get_pld, get_ipld

disp('See scatter and pcolor')

% func = @(this.x,this.y,this.u)pcolor;
% 
% for i = 1:2:(nargin-1)
%     switch varargin{i}
%         case 'scatter'
%             
%         case 'pcolor'
%             
%         case 'pld'
%             
%         case 'ipld'
%             
%         otherwise
%             error('Invalid option specified.')
%     end
% end
% 
% func =

end
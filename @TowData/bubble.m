function bubble(varargin)
%BUBBLE overloads plot for the TowData class.
%  BUBBLE plots the positions and estimated density of scallops in a 2D map. That
%  is, it's a bubble plot.
%
%  By default, BUBBLE will try to plot the bubbles on x/y coordinates, using the
%  standardized desnity estimate U. If these values do not exist in the object,
%  then lat/lon and a sum along the columns of sizef will be used. This
%  behaviour can be overridden using extra arguments.
%
%  BUBBLE(TOWOBJ) where TOWOBJ is a TowData object, makes a bubble plot of the tow
%  data.
%
%  Example:
%    >> bubble(TowData(file))
%    plots the tow samples and uses the size and color of the plotted points
%    to reflect the number of scallops at each location.
%
%See also: plot, scatter

plot(varargin)

end
function scatter(varargin)
%SCATTER overloads plot for the TowData class.
%  PLOT plots the positions and estimated density of scallops in a 2D map. That
%  is, it's a bubble plot.
%
%  By default, SCATTER will try to plot the bubbles on x/y coordinates, using the
%  standardized desnity estimate U. If these values do not exist in the object,
%  then lat/lon and a sum along the columns of sizef will be used. This
%  behaviour can be overridden using extra arguments.
%
%  SCATTER(TOWOBJ) where TOWOBJ is a TowData object, makes a bubble plot of the tow
%  data.
%
%  Example:
%    >> plot(TowData(file))
%    plots the tow samples and uses the size and color of the plotted points
%    to reflect the number of scallops at each location.
%
%See also: plot, bubble

plot(varargin)

end
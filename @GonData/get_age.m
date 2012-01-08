function age = get_age(this)
%GET_AGE estimate the age of the scallop, based on its shell height.
%  GET_AGE uses the estimated Von Bertalanffy curve from Shumway and Parsons.
%  Blake dug it out from one of the chapters and I am re-using that result here.
%
%  AGE = GET_AGE(THIS) returns the age of each scallop sampled in the current 
%  GonData object, THIS.
%
%  Example:
%    get_age(this(1))
%    returns the age of the first scallop sampled.
%
%See also: 

% Von Bertalanffy curve from Blake, from Shumway and Parsons:
% Lt = 145.5*(1-exp(-0.38*(t-1.5)));

% The inverse of this function is:
age = (log(1 - (this.height/145.5)))/(-0.38) + 1.5;
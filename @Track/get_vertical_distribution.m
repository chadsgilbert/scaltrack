function varargout = get_vertical_distribution(this, dvec, tvec)
%GET_VERTICAL_DSITRIBUTION returns the distribution of larvae in the water col.
%  GET_VERTICAL DISTRIBUTION uses a Track object to compute make a time-series
%  plot of the relative number of larvae located at each depth in the water
%  column. It's like a histogram time-series.
%
%  V = GET_VERTICAL_DISTRIBUTION(TRACKOBJ, DVEC, TVEC) takes a Track object
%  (TRACKOBJ), a vector [mx1] of the depths at which to measure larval density 
%  (DVEC) and a vector [1xn] of the times at which to measure the larval density
%  (TVEC) and returns a [mxn] matrix listing the relative density of larvae at
%  each (depth,time) pair.
%
%  Example:
%  >> dvec = 0:5:60;
%  >> tvec = 0:1:60;
%  >> v_disp = get_vertical_distribution(tr, dvec, tvec)
%  returns the density of larvae every 5 meters from sea surface down to 60m, 
%  every day for sixty days.
%
%See also: Track, plot_vertical_distribution

ivec = ceil((tvec+1)*24/12.42); % The indices of each time in tvec.
vDisp = NaN(length(dvec),length(tvec));
pct = NaN(1,length(ivec));

j = 1;
for i = ivec
    p = this.p(:,i);
    z = this.z(:,i);
    ind = find( ~isnan(p) & ~isnan(z) & p ~= 0 & z~=0 );
    v = histc( this.z(ind,i) - this.p(ind,i), dvec);
    v(isnan(v)) = 0;
    pct(j) = sum(v)/size(this.z,1);
    v = v./sum(v);
    vDisp(:,j) = v;
    j = j+1;
end

switch nargout
    case 0
        % This space intentionally left blank.
    case 1
        varargout{1} = vDisp;
    case 2
        varargout{1} = vDisp;
        varargout{2} = pct;
    otherwise
        error('Wrong number of output arguments requested.');
end

end
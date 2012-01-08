function varargout = get_krige(varargin)
%KRIGE krige tow data.
%  KRIGE estimates the density of scallops at a given list of locations using a
%  standard kriging procedure with an exponential empirical variogram. The
%  krige is isotropic, and is done in 2D; depth and time are ignored.
%
%  This is a wrapper for the R script: "td_krige.r". R and the R library "geoR"
%  must be installed on the host machine in order for this method to work.
%  R can be otained here: http://cran.r-project.org/ .
%  Then you can install geoR by running the command 
%    > "install.package("geoR",dependencies=TRUE)"
%  at the R prompt, or by searching the package in an R GUI or online.
%
%  If run on a windows machine, an additional requirement is the MATLAB-R 
%  interface, "rlink". This can be obtained from File Exchange.
%
%  GET_KRIGE(TDOBJ, BED) kriges the data stored in the TowData object, TDOBJ 
%  onto the x0 and y0 fields of the object, BED.
%
%  GET_KRIGE(TDOBJ, X0, Y0) kriges the data stored in the TowData object, TDOBJ 
%  onto the x/y coordinate pairs given by X0 and Y0.
%
%  U = GET_KRIGE(...) returns the density estiamte at each location.
%
%  [U,V] = GET_KRIGE(...) also returns the corresponding error term at each 
%  point.
%
%  Example:
%    >> load nep025_4x4
%    >> U = krige(TowData(file), nep)
%  returns the estimated scallop density at each location in the NEP.
%
%See also: TowData

% Assign the input arguments.
iargs = cellfun(@class,varargin, 'uniformoutput', false);
switch strcat(iargs{:})
    case 'TowDataBed'
        this = varargin{1};
        bed = varargin{2};
        x0 = bed.x0;
        y0 = bed.y0;
    case 'TowDatastruct'
        this = varargin{1};
        bed = varargin{2};
        x0 = bed.x0(1:end/64);
        y0 = bed.y0(1:end/64);
    case 'TowDatastructchar'
        this = varargin{1};
        bed = varargin{2};
        x0 = bed.x0(1:end/64);
        y0 = bed.y0(1:end/64);
    case 'TowDatadoubledouble'
        this = varargin{1};
        x0 = varargin{2};
        y0 = varargin{3};
    case 'TowDatadoubledoublechar'
        this = varargin{1};
        x0 = varargin{2};
        y0 = varargin{3};
    otherwise
        error('Wrong number of input arguments.')
end

% Write some tmp files for R to read in.
save('-ascii',[tempdir '/locx'],'x0');
save('-ascii',[tempdir '/locy'],'y0');

[x,y,u] = get_predpts(this, bed);
u = log(u+1);
save('-ascii',[tempdir '/towx'],'x');
save('-ascii',[tempdir '/towy'],'y');
save('-ascii',[tempdir '/towu'],'u');

% Run the actual program.
privpath = [fileparts(mfilename('fullpath')) filesep 'private' filesep];
[status,result] = system(['Rscript ' privpath 'td_krige.r']);
if (status ~= 0), disp(result); error('Failure in R.'); end

% Read in the result from R.
load([tempdir '/pred_krige']);
load([tempdir '/err_variance']);

U = exp(pred_krige) - 1;
V = err_variance;

% Assign the output arguments.
switch nargout
    case {0,1}
        varargout{1} = U;
    case 2
        varargout{1} = U;
        varargout{2} = V;
    case 3
        varargout{1} = U;
        varargout{2} = x0;
        varargout{3} = y0;
    otherwise
        error('Too many output arguments requested.')
end

end

function [x,y,u] = get_predpts(this, bed)

x = this.x;
y = this.y;
u = this.u;

% Eliminate any duplicates by finding nearby points and averaging them.
i = 1;
while i < length(x)
    % Find and index anything too close to the point (x(i), y(i)).
    ind = ~(( ((x(i)-x).^2 + (y(i)-y).^2) > 1e6) | x(i)==x)';
    
    % If something matches, eliminate it and average the "u"'s.
    if sum(ind) > 0
        %disp(['eliminating record ' num2str(find(ind==1))])
        x = x(~ind);
        y = y(~ind);
        u(i) = mean([u(ind); u(i)]);
        u = u(~ind);
    end
    i = i+1;
end

x = [x; bed.border(1,:)'];
y = [y; bed.border(2,:)'];
u = [u; this.contour_threshold*ones(size(bed.border(1,:)'))];

for i = 1:length(bed.gap)
    x = [x; bed.gap{i}(1,:)'];
    y = [y; bed.gap{i}(2,:)'];
    u = [u; this.contour_threshold*ones(size(bed.gap{i}(1,:)'))];
end

end
function td = import_towdata(file)
%IMPORT_TOWDATA imports tow data from a file and makes a struct of it.
%  IMPORT_TOWDATA takes a text or .mat file and finds the data that are needed
%  to make a proper TowData object using its comstructor.
%
%  IMPORT_TOWDATA(FILE)
%
%  IMPORT_TOWDATA({FILE1, FILE2, ... FILEN})
%
%  Example:
%    >> file = 'path/to/file';
%    >> import_towdata(file)
%    returns a towdata struct that is compatible with the TowData class 
%    constructor.
%
%See also: TowData, eliminate_dups, get_subset

% Check the argument.
ismatcell = iscell(file) && ~isempty(strfind(file{1},'.mat'));
istxtcell = iscell(file) && isempty(strfind(file{1},'.mat'));
ismatfile = ~iscell(file) && ~isempty(strfind(file,'.mat'));
istxtfile = ~iscell(file) && isempty(strfind(file,'.mat'));

if ismatcell
    % Input was a cell array of .mat files.
    load(file{1})
    towdata = scallops;
    for i = 2:length(file)
        load(file{i})
        towdata.year  = [towdata.year;  scallops.year  ];
        towdata.lat   = [towdata.lat;   scallops.lat   ];
        towdata.lon   = [towdata.lon;   scallops.lon;  ];
        towdata.depth = [towdata.depth; scallops.depth ];
        towdata.sizef = [towdata.sizef; scallops.sizef ];
        towdata.org   = [towdata.org;   scallops.org   ];
        if isfield(towdata,'x')
            towdata.yield = [towdata.yield; scallops.yield];
            towdata.x     = [towdata.x;     scallops.x    ];
            towdata.y     = [towdata.y;     scallops.y    ];
            towdata.u     = [towdata.u;     scallops.u    ];
        end
    end
    td = towdata;
elseif istxtcell
    % Input was a cell array ot text files to be read.
    % TODO: Allow importing straight from text file.
elseif ismatfile
    % Input was a single .mat file.
    load(file)
    td = scallops;
elseif istxtfile
    % Input was a single .txt file.
    % TODO: implement this.
else
    error('Invalid input argument.');
end

end
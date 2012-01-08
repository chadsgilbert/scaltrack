function varargout = wait_for_file(file,varargin)
%WAIT_FOR_FILE halt MATLAB to wait for an external process to finish.
%  WAIT_FOR_FILE stops execution of MATLAB until a file (specified) is found, or
%  until a limit (specified) is reached. This is useful for cases in which an
%  external program is expected to produce a result in a file on the OS, which
%  MATLAB will then load into the workspace.
%
%  WAIT_FOR_FILE(FILE) waits for the file and returns once it is found.
%
%  WAIT_FOR_FILE(FILE, MAXTIME) where MAXTIME is an integer, tells how many
%  seconds MATLAB should wait before giving up.

% Read the input arguments.
switch nargin
    case 1
        tmax = 10;
    case 2
        tmax = varargin{1};
    otherwise
        error('Wrong number of input arguments.')
end

% Wait until the file shows up.
for i = 1:tmax
    if exist(file,'file'), break; end
    pause(1);
end



% Assign the output arguments.
switch nargout
    case 0
    case 1
        % Try to load the file.
        try
            ofile = load(file);
        catch e
            error('File still not found. External process still not finished.');
        end
        varargout{1} = ofile;
    otherwise
        error('Wrong number of output arguments.')
end
    
end
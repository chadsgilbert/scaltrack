function varargout = get_matrix(era,seas,behav,mort,pld)
%GET_MATRIX make a connectivity matrix from results in data folder.
%  GET_MATRIX makes and returns a matrix of larval connectivity.
%
%  GET_MATRIX(ERA, SEAS, BEHAV, MORT, PLD) are all strings. Use cell arrays
%  instead to make several matrices at once. They will be returned in a cell
%  array also.
%
%  Example:
%  >> get_matrix('era1', 'fal', 'py', 'm0', 'ind')
%  returns the corresponding matrix
%
%  >> get_matrix({'era1' 'era2' 'flat'}, {'spr'; 'fal'}, ...
%        {'py' 'pa'}, {'m0','m1'}, {'const','ind})
%  returns a cell array containing all 48 matrices in a 5D cell array.
%
%See also: Larvae, get_larval_exchange

% Check for non-cell arguments and repair them.
if ~iscell(era)  , era   = {era};   end
if ~iscell(seas) , seas  = {seas};  end
if ~iscell(behav), behav = {behav}; end
if ~iscell(mort) , mort  = {mort};  end
if ~iscell(pld)  , pld   = {pld};   end

% Load domain data.
load('data/gsc'); load('data/nep'); load('data/sfl'); load('data/uha');

C = cell(length(era),length(seas),length(behav),length(mort),length(pld));

% Compute the matrices.
for i = 1:length(era)
    for j = 1:length(seas)
        for k = 1:length(behav)
            for l = 1:length(mort)
                for m = 1:length(pld)
                    s=[era{i} '_' seas{j} '_' behav{k} '_' mort{l}];
                    if exist(['data/c_' s '_' pld{m} '.mat'], 'file')
                        % If the matrix already exists, load it up.
                        load(['data/c_' s '_' pld{m} '.mat'])
                        C = eval(['c_' s '_' pld{m}]);
                    elseif exist(['data/l_' s '_gsc.mat'], 'file')
                        % If the 'Larvae' exists, use it to make the matrix.
                        
                        % GSC.
                        load(['data/l_' s '_gsc.mat']);
                        larv = eval(['l_' s '_gsc']);
                        c(1,1) = get_larval_exchange(larv, gsc, pld{m});
                        c(2,1) = get_larval_exchange(larv, nep, pld{m});
                        c(3,1) = get_larval_exchange(larv, sfl, pld{m});
                        c(4,1) = get_larval_exchange(larv, uha, pld{m});
                        
                        % NEP.
                        load(['data/l_' s '_nep.mat']);
                        larv = eval(['l_' s '_nep']);
                        c(1,2) = get_larval_exchange(larv, gsc, pld{m});
                        c(2,2) = get_larval_exchange(larv, nep, pld{m});
                        c(3,2) = get_larval_exchange(larv, sfl, pld{m});
                        c(4,2) = get_larval_exchange(larv, uha, pld{m});
                        
                        % SFL.
                        load(['data/l_' s '_sfl.mat']);
                        larv = eval(['l_' s '_sfl']);
                        c(1,3) = get_larval_exchange(larv, gsc, pld{m});
                        c(2,3) = get_larval_exchange(larv, nep, pld{m});
                        c(3,3) = get_larval_exchange(larv, sfl, pld{m});
                        c(4,3) = get_larval_exchange(larv, uha, pld{m});
                        
                        % Save before continuing.
                        eval(['c_' s '_' pld{m} ' = c;']);
                        save(['data/c_' s '_' pld{m} '.mat'], ...
                            ['c_' s '_' pld{m}]);
                        C{i,j,k,l,m} = c;
                        
                    else
                        error('Required larvae guys do not exist.')
                    end
                end
            end
        end
    end
end

% If c is only one matrix large, then return it as a matrix, instead of a cell.
if ndims(C) == 2 && (size(C,1)==1 && size(C,2)==1)
    C = C{:};
end

switch nargout
    case {0,1}
        varargout{1} = C;
    otherwise
        error('Wrong number of output arguments.');
end

end
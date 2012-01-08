function [ipld,pld] = read_pld(this,arg)
%READ_PLD figures out the appropriate value for ipld and this.pld and returns
%them.
%
%  There are several different options:
%    'ind'   - PLD should be determined individually based on Q10.
%    'const' - PLD is constant, and is assumed to be 35 days.
%    number  - PLD is constant and specified by the number given.
%    vector  - PLD is determined individually, and is given in the vector.

if ischar(arg)
    if strcmp(arg,'ind')
        ipld = get_ipld(this,2,13.7,68);
        pld = {'ind','Q_10 = 2','T_0 = 13.7','PLD_0 = 35'};
    elseif strcmp(arg,'const')
        ipld = 68*ones(size(this.x(:,1)));
        pld = {'const','PLD_0 = 35'};
    else
        error('Invalid settlement type.')
    end
elseif iscell(arg)
    if length(arg) == 3
        ipld = get_ipld(this, arg{:});
        pld = {'ind',['Q_10 = ' num2str(arg{1})], ...
            ['T_0 = ' num2str(arg{2})], ...
            ['PLD_0 = ' num2str(arg{3})]};
    elseif length(arg) == 1
        ipld = arg*ones(size(this.x(:,1)));
        pld = {'const',['PLD_0 = ' num2str(arg)]};
    else
        error('Invalid pld parameters.')
    end
elseif isnumeric(arg)
    ipld = arg;
    if length(ipld) == 1
        pld = 'const';
    else
        pld = 'ind';
    end
end

end

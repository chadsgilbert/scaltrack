function months = get_month_array(varargin)
%GET_MONTH_ARRAY makes a struct, each element of which is the first three
%letters of a month of the year. These come in order. eg mon = get_month_struct;
% mon{1} is 'jan' and mon{5} is 'may'.
%
%  GET_MONTH_ARRAY(FORMAT). There are four possible formats:
%
%     mmmm    full name of the month, according to the calendar locale, e.g.
%             "March", "April" in the UK and USA English locales. 
%     mmm     first three letters of the month, according to the calendar 
%             locale, e.g. "Mar", "Apr" in the UK and USA English locales. 
%     mm      numeric month of year, padded with leading zeros, e.g. ../03/..
%             or ../12/.. 
%     m       capitalized first letter of the month, according to the
%             calendar locale; for backwards compatibility.

if nargin == 0
    months = {'jan' 'feb' 'mar' 'apr' 'may' 'jun' ...
        'jul' 'aug' 'sep' 'oct' 'nov' 'dec'};
elseif nargin == 1
    switch varargin{1}
        case 'm'
            months = {'J' 'F' 'M' 'A' 'M' 'J' 'J' 'A' 'S' 'O' 'N' 'D'};
        case 'mm'
            months = 1:12;
        case 'mmm'
            months = {'jan' 'feb' 'mar' 'apr' 'may' 'jun' ...
                'jul' 'aug' 'sep' 'oct' 'nov' 'dec'};
        case 'mmmm'
            months = {'January' 'February' 'March' 'April' 'May' 'June' ...
                'July' 'August' 'September' 'October' 'November' 'December'};
        otherwise
            error('Invalid format requested')
    end
else
    error('Wrong number of input arguments')
end

function disp(this)
%DISP display a summary of contents of the GONDATA object.
%  DISP summarizes the contents of the GONDATA object on screen.
%
%  Example
%    disp(GonData)
%    displays GonData.
%
%See also: plot, struct, subsref

disp('GonData object.');

disp(['    # of records: ' ...
    num2str(length(this.year))]);

disp(['          Depths: ' ...
    num2str(floor(min(this.dpth))) '-' num2str(ceil(max(this.dpth))) ' m']);

disp(['      Size-range: ' ...
   num2str(floor(min(this.height))) '-' ceil(num2str(max(this.height))) ' mm']);

disp(['           Years: ' ...
    num2str(min(this.year)) '-' num2str(max(this.year))]);

sex = unique(this.sex);
if length(sex)==1
    disp(['           Sexes: ' this.sex{1}]);
elseif length(sex)==2
    disp(['           Sexes: ' sex{1} ' and ' sex{2}])
else
    error('More than 2 sexes reported in GonData.sex')
end

end
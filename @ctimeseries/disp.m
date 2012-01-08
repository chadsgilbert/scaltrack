function disp(this)
%DISP overloads DISP for the CTIMESERIES class.

disp('ctimeseries object.');
disp(['Years: ' datestr(min(this.x),'yyyy') '-' datestr(max(this.x),'yyyy')]);
disp(['Value: ' this.yax ' (' this.yunits ')']);

end
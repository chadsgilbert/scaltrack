# td_krige.r
# Call this using: $ Rscript td_krige.r
# Where era can be {all0, era1, era2}, 
#       bed can be {gsc, nep, sf}, 
#       siz can be {s, m, l, a}
#
# The script loads the scallop tow data and makes it into a 'geodata' object,
# then uses this to krige using the "krige.conv" function included witht the R 
# package "geoR".
#
# The data files loaded here were generated in MATLAB by running: 
# "script_towdata.m".
#
# (Remember: 'u' is log-transformed right now. it will need to be transfored 
# back later.)

# Author: Chad Gilbert
# Date: August 10, 2010

# Load and format the Tow data.
library(geoR)
x <- read.table("/tmp/towx")
y <- read.table("/tmp/towy")
u <- read.table("/tmp/towu")
tow <- as.geodata(data.frame(x,y,u), coords.col=1:2, data.col=3)

# Load and format the locations for prediction points.
x0 <- read.table("/tmp/locx")
y0 <- read.table("/tmp/locy")
predpts <- data.frame(x0,y0)

# Get and fit the variogram.
tow.var <- variog(tow, estimator.type="classic")
tow.var.fit <- variofit(tow.var, ini.cov.pars=c(5.0,10000.0), cov.model="exponential", fix.nugget=FALSE, nugget=4.0)

# Do the krige.
kcontrol <- krige.control(cov.pars=c(4.0,10000.0), nugget=4.0)
krige <- krige.conv(tow, loc=predpts, krige=kcontrol)

# Output the result to a text file for reading in via MATLAB.
write(krige$predict, file="/tmp/pred_krige", ncolumns=1)
write(krige$krige.var, file="/tmp/err_variance", ncolumns=1)
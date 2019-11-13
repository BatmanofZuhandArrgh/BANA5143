*1 Combining data sets from different sources;
data FAA1;
Filename FAA1xls '/home/u42905097/Class 2/FAA1.txt';
infile FAA1xls delimiter='09'x;
input Aircraft $ Duration NoPassengers Speed_ground Speed_air Height Pitch Distance;
run;

data FAA2;
Filename FAA2xls '/home/u42905097/Class 2/FAA2.txt';
infile FAA2xls delimiter='09'x;
input Aircraft $ NoPassengers Speed_ground Speed_air Height Pitch Distance;
run;

proc sort data=faa1;
by Aircraft;
run;

proc sort data = faa2;
by Aircraft;
run;

data FAACombined;
set FAA1 FAA2;
by Aircraft;
run;

title '1. Combination';
proc print data=FAACombined;
run;

*2. Performing the completeness check of each variable – examine if missing values are present;
title '2. Completeness check';
proc means data = FAACombined nmiss;
by Aircraft;
var duration NoPassengers Speed_ground Speed_air Height Pitch Distance;
run;

*3. Performing the validity check of each variable – examine if abnormal values are present;
title '3. Validity check';
data FAAValidity;
set faacombined;
if Duration>40 or Duration=. then ValidDuration = 1;
else ValidDuration = 0;
if Speed_ground <30 or Speed_ground>140 then ValidSpeed_ground = 0;
else ValidSpeed_ground = 1;
if (Speed_air >=30 and Speed_air<=140) or Speed_air=. then ValidSpeed_air = 1;
*if Speed_air=. then ValidSpeed_air = 1;
else ValidSpeed_air = 0;
if Height>6 then ValidHeight = 1;
else ValidHeight = 0;
if Distance<6000 then ValidDistance = 1;
else ValidDistance = 0;
run;

proc print data=FAAValidity;
run;

*4. Cleaning the data based on the results of Steps 2 and 3;
title '4. Data Cleaning';
data FAACleaned;
set FAAValidity;
if ValidDuration=1 and ValidSpeed_ground=1 and ValidSpeed_air=1 and ValidHeight=1
and ValidDistance = 1;
drop ValidDuration ValidSpeed_ground ValidSpeed_air ValidHeight ValidDistance;
run;

proc print data = FAACleaned;
run;

*5. Summarizing the distribution of each variable (what tables and figures will you present?);
title '5. Distributions of variable';
proc means data = faacleaned n mean median nmiss std range q1 q3;
by Aircraft;
Var Duration NoPassengers Speed_ground Speed_air Height Pitch Distance;
run;

proc univariate data = faacleaned plot;
by Aircraft;
var Duration NoPassengers Speed_ground Speed_air Height Pitch Distance;
run;

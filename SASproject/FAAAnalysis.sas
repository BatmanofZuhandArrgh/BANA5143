TITLE "CHAPTER 1: ";
*1 Combining data sets from different sources;

proc import datafile='/home/u42905097/Class 2/FAA1.xls' out=FAA1
dbms = xls
replace;
getnames=yes;
run;


proc import datafile='/home/u42905097/Class 2/FAA2.xls' out=FAA2
dbms = xls
replace;
getnames=yes;
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

options missing = '';
data Faacombined1;
   set Faacombined;
   if missing(cats(of _all_)) then delete;
run;

proc sort data=faacombined1 nodupkey;
by speed_ground height;
run;

proc sort data=faacombined1;
by aircraft;
run;

title '1. Combination';
proc print data=FAACombined1;
run;

proc contents data= faacombined1;
run;


*2. Performing the completeness check of each variable – examine if missing values are present;
title '2. Completeness check';

proc means data = FAACombined1 n nmiss;
var duration no_pasg Speed_ground Speed_air Height Pitch Distance;
run;

*3. Performing the validity check of each variable – examine if abnormal values are present;

title '3. Validity check';
data FAAValidity;
set faacombined1;
if Duration>40 then ValidDuration = 1;
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

proc print data = FAAValidity;
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

proc contents data = FAACleaned;
run;


*5. Summarizing the distribution of each variable (what tables and figures will you present?);
title '5. Distributions of variable';
proc sort data = FAACleaned;
by aircraft;
run;

proc means data = FAACleaned noprint;
by aircraft;
output out=FAASummaryMean 
mean(duration speed_ground) = MeanDuration MeanSpeed_Ground
mean(no_pasg Speed_air Height Pitch Distance) = MeanNo_Pasg MeanSpeed_Air MeanHeight MeanPitch MeanDistance;
run;

proc means data = FAACleaned noprint;
by aircraft;
output out=FAASummaryStddev
std(duration speed_ground) = StdDuration StdSpeed_Ground
std(no_pasg Speed_air Height Pitch Distance) = StdNo_Pasg StdSpeed_Air StdHeight StdPitch StdDistance;
run;

proc print data = FAASummaryMean;
title Summary Mean for variables;
run;

proc print data = FAASummaryStddev;
title Summary Standard Deviation for variables;
run;

%macro summary(dataset, variable);
proc means data = &dataset n nmiss mean median std min max;
var &variable;
title Summary Statistics for &variable in &dataset;
run;
%mend summary;

%summary(FAACleaned, duration);
%summary(FAACleaned, speed_ground);
%summary(FAACleaned, speed_air);
%summary(FAACleaned, height);
%summary(FAACleaned, pitch);
%summary(FAACleaned, distance);

TITLE "CHAPTER 2: ";

%macro xyplot(dataset, variable);
proc plot data = &dataset;
plot distance*&variable;
title Plot between &variable and Landing distance in &dataset;
run;
%mend xyplot;

%xyplot(FAACleaned, duration);
%xyplot(FAACleaned, speed_ground);
%xyplot(FAACleaned, speed_air);
%xyplot(FAACleaned, height);
%xyplot(FAACleaned, pitch);
%xyplot(FAACleaned, no_pasg);

proc corr data=faacleaned;
var duration speed_ground no_pasg Speed_air Height;
with distance;
run;

TITLE "CHAPTER 3: ";
proc reg data = faacleaned;
model distance = speed_ground speed_air;
plot distance*speed_air="*" distance*speed_ground="+"/overlay;
run;

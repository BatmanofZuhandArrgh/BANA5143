data Dataset;
infile '/home/u42905097/Class 1/AAUP_data.txt' delimiter=',';
input FICE 'College name'n $ State $ Type $ 'Full professor salary'n 'Associate professor salary'n 'Assistant professor salary'n 'All ranks salary'n 
'Full professor Compensation'n 'Associate professor compensation'n 'Assistant professor compensation'n 'All ranks compensation'n 
'Number of Full professors'n 'Number of Associate professors'n 'Number of Assistant professors'n 'Number of Instructors'n 'Number of Faculty'n;
run;

title "PROBLEM 1";
title "a. Reading and printing all of the dataset";
proc print data=Dataset;
run;

title "b. Create a data set containing only FICE, State, all average salaries and average compensations.";
data Datasetcopy;
set dataset;
drop 'College name'n Type 'Number of Full professors'n 'Number of Associate professors'n
'Number of Assistant professors'n 'Number of Instructors'n 'Number of Faculty'n;
run;

proc print data=datasetcopy;
run;

title "c. Create 2 subdata setwhose college are from AK and AL separately";
data DatasubsetAK;
set dataset; 
where State = 'AK';
'Full professor income'n = 'Full professor salary'n + 'Full professor compensation'n;
'Assistant professor income'n = 'Assistant professor salary'n + 'Assistant professor compensation'n;
'Associate professor income'n = 'Associate professor salary'n + 'Associate professor compensation'n;
'All ranks income'n = 'All ranks salary'n + 'All ranks compensation'n;
drop 'Full professor compensation'n'Full professor salary'n 'Associate professor salary'n 'Assistant professor salary'n 'All ranks salary'n 
'Associate professor compensation'n 'Assistant professor compensation'n 'All ranks compensation'n;
run;

title "AK Colleges";
proc print data =datasubsetak;
run;

data DatasubsetAL;
set dataset; 
where State = 'AL';
'Full professor income'n = 'Full professor salary'n + 'Full professor compensation'n;
'Assistant professor income'n = 'Assistant professor salary'n + 'Assistant professor compensation'n;
'Associate professor income'n = 'Associate professor salary'n + 'Associate professor compensation'n;
'All ranks income'n = 'All ranks salary'n + 'All ranks compensation'n;
drop 'Full professor compensation'n'Full professor salary'n 'Associate professor salary'n 'Assistant professor salary'n 'All ranks salary'n 
'Associate professor compensation'n 'Assistant professor compensation'n 'All ranks compensation'n;
run;

title "AL Colleges";
proc print data =datasubsetal;
run;
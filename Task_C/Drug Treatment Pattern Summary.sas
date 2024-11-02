data trt1;
length cat$10. pre$15.;
set b1.treatment_pattern;
if num_cat eq 0 then cat='0';
else if num_cat=1 then cat='1';
else if num_cat>=2 then cat='2 or More';
if num_presc LE 2 then pre='0-2';
else if num_presc=3 then pre='3';
else if num_presc=4 then pre='4';
else if num_presc>=5 then pre='5 or More';
run;


/*Duplicated the observations to  estimate the totals*/
data trt2;
set trt1;
output;
cohort='Total';
cohortN=9;
Cohortn1=9;
output;
run;


      

proc sql;
select count(distinct patient_id) into :code1-:code4 
from trt2 
group by cohortn
order by cohortn;
quit;

      
proc freq data=trt2;
table cohort*cohortn*pre/ nocol norow nopercent out=cohortpre(rename=(pre=cat));
run;

proc freq data=trt2 order=formatted;
table cohort*cohortn*cat/ nocol norow nopercent out=cohortcat;
run;



/*get count and percent of num_presc and num_cat*/
data trt3;
length col1$70. value$20.;
set cohortcat(in=a) cohortpre(in=b);
if a then do;col1='Number of different AF treatment category received';orde=1;end;
if b then orde=2;
if cohortn=1 then value=put(count,3.)||'('||put(count/&code1*100,5.2)||')';
else if cohortn=2  then value=put(count,3.)||'('||put(count/&code2*100,5.2)||')';
else if cohortn=3  then value=put(count,3.)||'('||put(count/&code3*100,5.2)||')';
else if cohortn=9  then value=put(count,3.)||'('||put(count/&code4*100,5.2)||')';
run;


      
proc sort data=trt3;
by col1 cat orde;
run;

      
proc transpose data=trt3 out=trt4;
by col1 cat orde;
id cohortn;
var value;
run;


      
proc sort data=trt4;
by  cat orde;
run;



/* filling missing values with 0 using do loop*/
data combined;
set trt4  ;
by  cat ;
rename '1'n=NOAC '2'n=Warfarin '3'n=Aspirin '9'n=Total;
if cat='0-2' then do;col1= 'Number of prescription';arrange=2;end;
if cat in ('0','1','2 or More') then do; arrange=1;orde=1;end;
if cat in ('0-2','3','4','5 or More') then do;orde=2;end;
if cat in ('3','4','5 or More') then do;arrange=3;orde=2;end;
run;


      

proc sort data=combined out=trt6;
by  orde arrange  cat ;
run;


      
title 'Drug treament pattern Summary';
Title2 'AF Patients treated with Aspirin, Warfarin or NOAC';
 ods pdf file='/home/u62744457/Task C/drug_trt-ptrn.pdf' style=journal; 


proc report data=combined headline headskip split='|' missing spacing=1 wrap style(header)={just=c}
style(report)=[rules=group frame=hsides];
column (arrange orde col1 cat NOAC Warfarin Aspirin Total);
define arrange/ order noprint ;
define orde/ order noprint;
define col1/ 'Parameter' order ;
define cat / 'category' order ;
define NOAC/ group 'NOAC| (N=194)' style(column)=[just=c] style(header)=[just=c];
define Warfarin/ group 'Warfarin| (N=28)' style(column)=[just=c] style(header)=[just=c];
define Aspirin/ group 'Aspirin| (N=60)' style(column)=[just=c] style(header)=[just=c];
define Total/ group 'Total| (N=282)' style(column)=[just=c] style(header)=[just=c];
compute after col1;
line '';
endcomp;
run;


      
title;
ods pdf close;

option missing=0;

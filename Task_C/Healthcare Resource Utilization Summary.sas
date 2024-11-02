data total;
set b1.hru;
output;
cohort='Total';
output;
run;

/*Categorize cohort to the three drug varients*/
Data hru2;
length cohort_cat $9. Encounter_type$40.;
set total;
if cohort in ('Total') then	do;
cohortN=9;
Cohortn1=9;
end;
Encounter_type=propcase(encounter_type);
run;


proc sql;
select count(distinct patient_id) into :code1-:code4 from hru2 group by cohortn
order by cohortn;
quit;

proc freq data=hru2 order=formatted;
table cohortn*encounter_type/ nocol norow nopercent out=cohorthru;
run;

data hru3;
length col1$40. value$20.;
set cohorthru;
col1='Healthcare visit: Encounter type';
if cohortn=1 then value=put(count,3.)||'('||put(count/&code1*100,5.2)||')';
else if cohortn=2  then value=put(count,3.)||'('||put(count/&code2*100,5.2)||')';
else if cohortn=3  then value=put(count,3.)||'('||put(count/&code3*100,5.2)||')';
else if cohortn=9  then value=put(count,3.)||'('||put(count/&code4*100,5.2)||')';
run;

proc sort data=hru3;
by col1 encounter_type ;

proc transpose data=hru3 out=hru_transpose;
by col1 encounter_type;
id cohortn;
var value;
run;


/* filling missing values with 0 using do loop*/
data hru_final;
set hru_transpose;
by  col1 encounter_type ;
array colx(*) '1'n '2'n '3'n '9'n ;
do i = 1 to dim(colx);
if colx(i)='' then colx(i)='0(0)';
end;
rename '1'n=NOAC '2'n=Warfarin '3'n=Aspirin '9'n=Total;
run;

 title 'Healthcare Resource Utilisation Summary';
Title2 'AF Patients recived  Aspirin, Warfarin or NOAC';
ods pdf file='/home/u62744457/Task C/HRU_sum.pdf' style=journal;

proc report data=hru_final headline headskip split='|' missing spacing=1 wrap style(header)={just=c}
style(report)=[rules=group frame=hsides];
column (col1 encounter_type NOAC Warfarin Aspirin Total);
define col1/ 'Parameter' order ;
define encounter_type / 'Encounter Visits' order ;
define NOAC/ group "NOAC| (N=&code1)" style(column)=[just=c] style(header)=[just=c];
define Warfarin/ group "Warfarin| (N=&code2)" style(column)=[just=c] style(header)=[just=c];
define Aspirin/ group "Aspirin| (N=&code3)" style(column)=[just=c] style(header)=[just=c];
define Total/ group "Total| (N=&code4)" style(column)=[just=c] style(header)=[just=c];
break after col1/skip;
compute before col1;
line ' ';
endcomp;
run;

title;
ods pdf close;
run;

proc sql;
select count(distinct patient_id) into :code1 from strokesort where cohort1n=1;
select count(distinct patient_id) into :code2 from strokesort where cohort1n=2;
%put &code1 &code2;


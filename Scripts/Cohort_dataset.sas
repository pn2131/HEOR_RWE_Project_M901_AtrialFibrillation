libname b1 "/home/u62744457/Task B/B1";

/*inclusion criteria 2*/
data condition1; /*making a new table called condition1*/
set b1.condition;
format condition_date mmddyy10.; 
where substr(code, 1, 3) in ('I48') and 
'01jan2007'd <= condition_date <='01jan2019'd; 
run;

/*inclusion criteria 3 - patient who took NOAC/Warfarin/Aspirin during the index period - 01Jan2017 to 01Jan2021 */
data medication1;
set b1.medication;
length cohort $20;
format request_date mmddyy10.;
if ndc in (3089421 636297747) or Index (upcase(medication_name), "APIXABAN")
then do;
Cohort="NOAC";
CohortN=1;
end;
else if ndc in (5970108) or Index(upcase(medication_name), "DABIGATRAN") 
then do;
Cohort="NOAC";
CohortN=1;
end;
else if ndc in (50458577) or Index(upcase(medication_name), "RIVAROXABAN") 
then do;
Cohort="NOAC";
CohortN=1;
end;
else if ndc in (31722327) or Index(upcase(medication_name), "WARFARIN")
then do;
Cohort="Warfarin";
CohortN=2;
end;
else if ndc in (2802100) or Index(upcase(medication_name), "ASPIRIN") 
then do;
Cohort="Aspirin";
CohortN=3;
end;
run;

/*inclusion criteria 3 continued - Index period - 01Jan2017 to 01Jan2021 */
proc sort data=medication1 out=medication2 /* we don't want any duplocates, so --> */ nodupkey;
where /*remove missing char values*/ (Cohort not= '') and ('01Jan2017'd <=request_date <='01Jan2021'd);
by Cohort patient_id medication_name;
run;


/*Creating a table with inclusion and exclusion criterias
Inclusion Criteria:
1: Age > 18, 
2: Condition of AF (ICD10 Code initial 3 characters: "I48"),
3: Taken specific medications etc.
Exclusion Criteria
1: Fracture Exclusion (M81,I97)
2: Fluoroscopy of Heart – Exclude (Procedure Codes: B215YZZ B2151ZZ B2151ZZ )*/
proc sql;
create table COHORT2 as                                                    /*MAKE THIS COHORT1. IT CAME 1ST.*/
select distinct a.patient_id, a.gender, a.death_date, a.death_flag, a.race, a.birth_date, b.request_date, b.cohort,
b.CohortN, (b.request_date-a.birth_date +1)/ 365 as age 
from b1.patient as a 
inner join medication2 as b 
on a.patient_id=b.patient_id 
where calculated age>=18 
and a.patient_id in (select distinct patient_id from condition1) 
and a.patient_id in (select distinct patient_id from medication1) 
and a.patient_id not in (select distinct patient_id from b1.condition where substr(code, 1, 3) in ('M81', 'I97')) 
and a.patient_id not in (select distinct patient_id from b1.procedure where code in ('B215YZZ', 'B2151ZZ', 'B2151ZZ'));
quit;

/* Making a seperate table for grouping Warfarin+Aspirin
For 1. Summary of Stroke & Bleeding Occurrence - Binary Analysis & 
2. Summary of Change in CV Parameters from Index Date to Last available observations */
data cohort1;                                                          /*MAKE THIS COHORT2. IT CAME 2ND.*/
set cohort2;
death_flag=input(death_flag, best12.);
format death_date mmddyy10. age 4.2;    /*age is formatted as 4.2 which indicates that age should be displayed as a numeric variable with a total width of 4 characters, and with 2 decimal places.*/ 
if cohortN=1 then cohort1n=1;
else cohort1n=2;
if age=<18 then delete;
years=year(request_date);
run;

 /*Creating variables
 1. Stroke*/
data stroke;
set b1.condition;
strok1=substr(code, 1, 3);
strok2=substr(code, 1, 4);
if strok1 in ('I63','I69', 'G45') or strok2 in ('I693', 'G459') then stroke=1;
else stroke=2;
if stroke=2 then delete;
run;

/* 2. bleed*/
data bleed;
set b1.condition;
substr3 = substr(code, 1, 3);
substr4 = substr(code, 1, 4);
Substr5=substr(code,1,5);
if substr3 in ('I60', 'I61', 'I62','D62','R58') or 
substr4 in ('I690', 'I691', 'I692', 'S064','S065', 'S066', 'S068', 'I850', 'I983',
'K226', 'K228', 'K250', 'K252',
'K254', 'K256', 'K260', 'K262', 'K264', 'K266', 'K270', 'K272', 'K274',
'K276', 'K280', 'K282', 'K284', 'K286', 'K290',  'K625', 'K920', 'K921', 'K922',  
'H448', 'H356', 'H313', 'H210', 'H113', 'H052', 'H470', 'H431', 'I312', 
'N020', 'N021', 'N022', 'N023', 'N024', 'N025', 'N026', 'N027', 'N028', 'N029', 'N421', 'N831', 'N857',
'N920', 'N923', 'N930', 'N938', 'N939', 'M250', 
'R233', 'R040', 'R041', 'R042', 'R048', 'R049', 'T792', 'T810', 'N950', 'R310', 'R311', 'R318',
'T455', 'Y442', 'D683') or substr5 in ('K2211','K3181', 'K5521','H3572')then bleed = 1;
 else bleed = 2;
 if bleed = 2 then delete;
run;

/* 3. Congestive heart failure*/
data chf;
set b1.condition;
chff=substr(code, 1, 3);
if chff in ('I50') then
chf=1;
else
chf=2;
if chf=2 then
delete;
run;

/* 4. Hypertension*/
data hyp;
set b1.condition;
hyper=substr(code, 1, 3);
if hyper in ('I10', 'I11', 'I12', 'I13', 'I14', 'I15') then hyp=1;
else hyp=2;
if hyp=2 then delete;
run;

/* 5. Diabetics*/
data diab;
set b1.condition;
diabe=substr(code, 1, 3);
if diabe in ('E10', 'E11', 'E12', 'E13', 'E14') then diab=1;
else diab=2;
if diab=2 then delete;
run;

/* 6. Vascular disease */
data vscd;
set b1.condition;
vascul1=substr(code, 1, 3);
vascul2=substr(code,1,4);
if vascul1 in ('I21', 'I70', 'I71', 'I72', 'I73') or vascul2 in ('I252') then vscd=1;
else vscd=2;
if vscd=2 then delete;
run;

/* 7. abnormal renal function */
data abrenal;
set b1.condition;
abr=substr(code, 1, 4);
if abr in ('N183', 'N184') then abrenal=1;
else abrenal=2;
if abrenal=2 then delete;
run;


/* 8. abnormal liver functions */
data abliver;
set b1.condition;
abl1=substr(code, 1, 3);
abl2=substr(code, 1, 4);
if abl1 in ('C22','B15', 'B16', 'B17', 'B18', 'B19', 'K70', 'K77') or abl2 in ('I983','I982' 'Z944','D684') then abliver=1;
else abliver=2;
if abliver=2 then delete;
run;

/* 9. alcoholism */
data alco;
set b1.condition;
alcohol1=substr(code, 1, 3);
alcohol2=substr(code,1,4);
if alcohol1 in ('F10', 'K70', 'X65', 'Y15', 'Y90', 'Y91') or alcohol2 in ('E244','G312', 'G621', 'G721', 'I426', 'K292', 'Z502', 'Z714', 'Z721','K860') then alco=1;
else alco=2;
if alco=2 then delete;
run;


/* 10. nsaid */
data Nsaid;
set b1.medication;
if medication_name in ('Bromfenac','Celecoxib','Diclofenac','Etodolac','Fenoprofenac','Flurbiprofen','Ibuprofen','Indomethacin','Ketoprofen','Ketorolac','Naproxen',
'Meclofenamate','Mefenamic acid','Meloxicam','Nabumetone','Oxaprozin','Piroxicam','Sulindac','Tolmetin') then nsaid=1;
else nsaid=2;
if nsaid=2 then delete;
run;


/* 11. antiplatlets  */
data antipl;
set b1.medication;
if medication_name in ('Aspirin','Clopidogrel','Prasugrel',
'Ticlopidine','Cilostazol','Abciximab','Tirofiban','Dipyridamole','Ticagrelor') then antipl=1;
else antipl=2;
if antipl=2 then delete;
run;

      
/*Creating the table combining all 11 variales*/
proc sql;
create table b1.combined as select distinct a.*, b.stroke as stroke,c.bleed as bleed, 
d.chf, e.hyp, f.diab,g.vscd,h.abrenal, i.abliver, j.alco,k.nsaid,l.antipl 
from cohort1 as a
left join work.stroke as b on a.patient_id=b.patient_id
left join work.bleed as c on a.patient_id=c.patient_id
left join work.chf as d on a.patient_id=d.patient_id
left join work.hyp as e on a.patient_id=e.patient_id
left join work.diab as f on a.patient_id=f.patient_id
left join work.vscd as g on a.patient_id=g.patient_id
left join work.abrenal as h on a.patient_id=h.patient_id
left join work.abliver as i on a.patient_id=i.patient_id
left join work.alco as j on a.patient_id=j.patient_id
left join work.nsaid as k on a.patient_id=k.patient_id
left join work.antipl as l on a.patient_id=l.patient_id;
quit;

        
data b1.cohort_age;
set b1.combined;
length agecat$10;
if .z<age< 65 then do;
agecat='<65';
end;
if 65=<age<75 then do;
agecat='65=< to 75';
age1=1;
end;
if age GE 75 then DO;
Agecat='75<';
age1=2;
end;
if upcase(gender)='FEMALE' then female=1;
run;


/*adding HASBLED and CHA2DS2)*/
data b1.cohortfinal;
set b1.cohort_age;
Gender=propcase(gender);
Race=propcase(race);
if stroke=1 then stroke1=2;else stroke1=0;
CHAD2D=sum(chf, hyp, diab, vscd, stroke1, age1, female);
if nsaid=1 or antipl=1 then drugtherapy=1;
HASBLED=sum(hyp, abrenal, abliver, stroke, bleed, age1, drugtherapy, alco);
run;

      
/*FINAL COHORT TABLE*/
data b1.cohortdata(keep= age AgeCat birth_date Bleed CHA2DS2 cohort cohort1n CohortN
death_date death_flag gender HASBLED Index_Date patient_id race STROK Year);
set b1.cohortfinal;
rename request_date=Index_date CHAD2D=CHA2DS2 Years=Year
Stroke=STROK;
run;

libname b2 "/home/u62744457/Task B/B2";
 proc compare base=b2.cohort compare=b1.cohortdata out=COMPARE;
run;

**************************************;

/* proc contents data = b2.cohort; */
/* run; */
/*  */
/* proc contents data = b1.cohortdata; */
/* run;  */
       




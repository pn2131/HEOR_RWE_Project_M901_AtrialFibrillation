proc sql;
Create table b1.HRU as select a.patient_id, a.cohort, a.cohortN,
a.cohort1n, b.encounter_type from b1.cohortdata as a left join
b1.encounter as b on a.patient_id=b.patient_id;
quit;

proc compare base=b2.hru compare=b1.HRU out=compare;
run;

/* ******************************  (^-^) */
/* proc printto log='/home/u62744457/Task B/B1/hru.sas7bdat.txt'; */

/* proc printto log='/home/u62744457/Task B/B1/hru.sas7bdat.pdf'; */

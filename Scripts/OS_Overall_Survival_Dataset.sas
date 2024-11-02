      

data Event;
set b1.cohortdata;
If death_date ne . then
do;
CNSR=0;
Event=1;
ADT=death_date;
EVNTDESC="Death";
end;
Else If death_date eq missing and last_followup ne . then
do;
CNSR=1;
Event=0;
ADT=last_followup;
EVNTDESC="No Event: Censored at Last Activity Date";
end;
Else If death_date eq . and last_followup eq . then
do;
CNSR=1;
Event=0;
ADT=index_date;
EVNTDESC="No Event: Censored at Index Date";
end;
run;
   

PROC SQL;
Create table b1.os1 as select a.patient_id, a.cohort, a.cohortN,
a.index_date as start_date format mdy.,b.cnsr,b.evntdesc,b.adt from b1.cohortdata as a
left join
work.event as b on a.patient_id=b.patient_id ;
quit;


data b1.os;
set b1.os1;
format follow_up mdy.;
aval=(ADT-Start_date+1) /(365/12);
follow_up=start_date;
run;

Proc compare base=b2.os compare=b1.os out=compare;
run;


/* (^-^) */
/* proc printto log='/home/u62744457/Task B/B1/os.sas7bdat.pdf'; */

      




 
 




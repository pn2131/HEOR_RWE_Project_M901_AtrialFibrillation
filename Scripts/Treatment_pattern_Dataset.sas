Proc sql;
create table medication_category as select * from b1.medication as a 
where patient_id 
in (select distinct patient_id from b1.cohortdata) ;
quit;
    
data category1;
set medication_category;
length category$ 30.;
where '01jan2017'd<request_date<'01jan2021'd;
if propcase(medication_name) in ('Bromfenac','Celecoxib','Diclofenac','Etodolac','Fenoprofenac',
'Flurbiprofen','Ibuprofen','Indomethacin','Ketoprofen','Ketorolac','Naproxen','Meclofenamate',
'Mefenamic acid','Meloxicam','Nabumetone','Oxaprozin','Piroxicam','Sulindac','Tolmetin')
then category='nsaid';
if propcase(medication_name) in ('Aspirin','Clopidogrel','Prasugrel','Ticlopidine',
'Cilostazol','Abciximab','Tirofiban','Dipyridamole','Ticagrelor')
then category='antiplt';
if propcase(medication_name) in ('Omeprazole','Pantoprazole','Lansoprazole','Rabeprazole','Esomeprazole','Dexiansoprazole')
then category='PPI';
if propcase(medication_name) in ('Cimetidine','Ranitidine','Famotidine','Nizatidine','Roxatidine','Lafutidine')
then category='h2';
if propcase(medication_name) in ('Quinidine','Procainamidde','Mexiletine','Propafenone',
'Flecainide','Amiodarone','Bretylium','Dronedarone','Propranolol',
'Atenolol','Esmolol','Verapamil','Diltiazem','Sotalol')
then category='antiarrythmic';
if propcase(medication_name) in ('Digoxin')
then category='Digoxin';
if propcase(medication_name) in ('Atrovastatin','Fluvastatin','Lovastatin','Pitavastatin',
'Pravastatin','Roxuvastatin','Simavastatin')
then category='Statins';
run;

/*creating trt_pattern dataset */
proc sql;
create table b1.treatment_pattern 
as select distinct a.patient_id, b.cohort1n, b.cohortN, b.cohort,
Count(a.encounter_id) as Num_Presc, count(category) as Num_cat
from category1 as a
inner join b1.cohortdata as b on a.patient_id=b.patient_id   
group by a.patient_id, b.cohort1n, b.cohortN, b.cohort;
quit;
     
proc compare base=b2.trt_pattern compare=b1.treatment_pattern out=compared;
run;
 
/*  (^-^) */
/* proc printto log='/home/u62744457/Task B/B1/treatment_pattern.pdf'; */


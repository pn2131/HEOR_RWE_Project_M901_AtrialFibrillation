/* HEOR PROJECT
PRIYANKA NALKAR */
*********************************************************************************************************************************
TASK A
*********************************************************************************************************************************
/* Assign library for imported files/tables to manipulate later  */;

libname HEOR_A "/home/u62744457/HEOR_DATA";
/* Importing allery.csv. It will be stored in work library */
proc import datafile="/home/u62744457/HEOR_DATA/Task A/allergy.csv" 
  dbms=csv 
  out=allergy_import 
  replace;
  guessingrows=max; 
  run; 
proc contents data=allergy_import;
  run; 
data HEOR_A.allergyChar;
  set work.allergy_import (rename=(patient_id=Charpatient_id encounter_id=Charencounter_id));  
  drop Charpatient_id Charencounter_id;
  patient_id=put(Charpatient_id, comma12.);
  encounter_id=put(Charencounter_id, comma12.);
  Format patient_id comma12.;
  Format encounter_id comma12.;
  run;
proc contents data=HEOR_A.allergyChar;
run;  

/* Importing condition.csv. */
proc import datafile="/home/u62744457/HEOR_DATA/Task A/condition.csv" 
  dbms=csv 
  out=condition_import 
  replace;
  guessingrows=max;
  run;  
proc contents data=condition_import;
  run;
  
data HEOR_A.conditionChar;
  set work.condition_import (rename=(diagnosis_rank=Chardiagnosis_rank encounter_id=Charencounter_id patient_id=Charpatient_id));
  drop Chardiagnosis_rank Charencounter_id Charpatient_id;
  diagnosis_rank=put(Chardiagnosis_rank, best12.);
  patient_id=put(Charpatient_id, best12.);
  encounter_id=put(Charencounter_id, best12.);
  Format diagnosis_rank comma12.;
  Format patient_id comma12.;
  Format encounter_id comma12.;
  run;
proc contents data=HEOR_A.conditionChar;
run;

/* Importing encounter.csv */
proc import datafile="/home/u62744457/HEOR_DATA/Task A/encounter.csv" 
  dbms=csv 
  out=encounter_import 
  replace;
  guessingrows=max;
  run; 
proc contents data=encounter_import;
  run;
data HEOR_A.encounterChar;
  set work.encounter_import (rename=(discharge_disposition_code=Chardischarge_disposition_code encounter_id=Charencounter_id patient_id=Charpatient_id));
  drop Chardischarge_disposition_code Charencounter_id Charpatient_id;
  discharge_disposition_code=put(Chardischarge_disposition_code, best12.);
  patient_id=put(Charpatient_id, best12.);
  encounter_id=put(Charencounter_id, best12.);
  Format discharge_disposition_code comma12.;
  Format patient_id comma12.;
  Format encounter_id comma12.;
  run;
proc contents data=HEOR_A.encounterChar;
run;

/* Importing lab.csv. */
proc import datafile="/home/u62744457/HEOR_DATA/Task A/lab.csv" 
  dbms=csv 
  out=lab_import 
  replace;
  guessingrows=max;
  run;  
proc contents data=lab_import;
  run;
data HEOR_A.labChar;
  set work.lab_import (rename=(encounter_id=Charencounter_id patient_id=Charpatient_id));
  drop Charencounter_id Charpatient_id;
  patient_id=put(Charpatient_id, best12.);
  encounter_id=put(Charencounter_id, best12.);
  Format patient_id comma12.;
  Format encounter_id comma12.;
  run;
proc contents data=HEOR_A.labChar;
run;
  
/* Importing location.csv. this has no numeric variabes*/
proc import datafile="/home/u62744457/HEOR_DATA/Task A/location.csv" 
  dbms=csv 
  out=location_import 
  replace;
  guessingrows=max;
  run; 
proc contents data=location_import;
  run;
data HEOR_A.locationChar;
  set work.location_import;
  run;
proc contents data=HEOR_A.locationChar;
  run;

/* Importing medication.csv. */
proc import datafile="/home/u62744457/HEOR_DATA/Task A/medication.csv" 
  dbms=csv 
  out=medication_import 
  replace;
  guessingrows=max;
  run;  
proc contents data=medication_import;
  run;
data HEOR_A.medicationChar;
  set work.medication_import (rename=(encounter_id=Charencounter_id patient_id=Charpatient_id ndc=Charndc));
  drop Charencounter_id Charpatient_id Charndc;
  ndc=put(Charndc, best12.);
  patient_id=put(Charpatient_id, best12.);
  encounter_id=put(Charencounter_id, best12.);
  Format ndc comma12.;
  Format patient_id comma12.;
  Format encounter_id comma12.;
  run;
proc contents data=HEOR_A.medicationChar;
run;
  
/* Import patient.csv */
proc import datafile="/home/u62744457/HEOR_DATA/Task A/patient.csv" 
  dbms=csv 
  out=patient_import 
  replace;
  guessingrows=max;
  run; 
proc contents data=patient_import;
  run;
data HEOR_A.patientChar;
  set work.patient_import (rename=(death_flag=Chardeath_flag patient_id=Charpatient_id zip_code=Charzip_code));
  drop Chardeath_flag Charpatient_id Charzip_code;
  death_flag=put(Chardeath_flag, best12.);
  patient_id=put(Charpatient_id, best12.);
  zip_code=put(Charzip_code, best12.);
  Format death_flag comma12.;
  Format patient_id comma12.;
  Format zip_code comma12.;
  run;
proc contents data=HEOR_A.patientChar;
  run;

/* Importing practitioner.csv. No numeric variables */
proc import datafile="/home/u62744457/HEOR_DATA/Task A/practitioner.csv" 
  dbms=csv 
  out=practitioner_import 
  replace;
  guessingrows=max;
  run; 
proc contents data=practitioner_import;
  run;
data HEOR_A.practitionerChar;
  set work.practitioner_import;
  run;
proc contents data=HEOR_A.practitionerChar;
  run;
  
/* Importing procedure.csv */
proc import datafile="/home/u62744457/HEOR_DATA/Task A/procedure.csv" 
  dbms=csv 
  out=procedure_import 
  replace;
  guessingrows=max;
  run; 
proc contents data=procedure_import;
  run;
data HEOR_A.procedureChar;
  set work.procedure_import (rename=(encounter_id=Charencounter_id patient_id=Charpatient_id));
  drop Charencounter_id Charpatient_id;
  patient_id=put(Charpatient_id, best12.);
  encounter_id=put(Charencounter_id, best12.);
  Format patient_id comma12.;
  Format encounter_id comma12.;
  run;
proc contents data=HEOR_A.procedureChar;
  run;

/* Importing vital_sign.csv. */
proc import datafile="/home/u62744457/HEOR_DATA/Task A/vital_sign.csv" 
  dbms=csv 
  out=vital_sign_import 
  replace;
  guessingrows=max;
  run;  
proc contents data=vital_sign_import;
  run;
data HEOR_A.vitalChar;
  set work.vital_sign_import (rename=(value=Charvalue encounter_id=Charencounter_id patient_id=Charpatient_id));
  drop Charvalue Charencounter_id Charpatient_id;
  value=put(Charvalue, best12.);
  patient_id=put(Charpatient_id, best12.);
  encounter_id=put(Charencounter_id, best12.);
  Format value comma12.;
  Format patient_id comma12.;
  Format encounter_id comma12.;
  run;
proc contents data=HEOR_A.vitalChar;
  run;
 

*************************************************************************************************************************************************************************************************;

/* use proc compare for QA */
libname Task_A"/home/u62744457/HEOR_DATA/Task A";


proc compare base=Task_A.allergy compare=heor_a.allergyChar;
  run;
  
proc compare base=Task_A.condition compare=heor_a.conditionChar;
  run;
  
proc compare base=Task_A.encounter compare=heor_a.encounterChar;
  run;
  
proc compare base=Task_A.lab compare=heor_a.labChar;
  run;
  
proc compare base=Task_A.location compare=heor_a.locationChar;
  run;
  
proc compare base=Task_A.medication compare=heor_a.medicationChar;
  run;
  
proc compare base=Task_A.patient compare=heor_a.patientChar;
  run;
  
proc compare base=Task_A.practitioner compare=heor_a.practitionerChar;
  run;
  
proc compare base=Task_A.procedure compare=heor_a.procedureChar;
  run;
  
proc compare base=Task_A.vital_sign compare=heor_a.vitalChar;
  run;

/* convert all HEOR_A files to xpt*/
libname HEOR_A xport "/home/u62744457/submission xpt files/allergychar.xpt";
proc cport data=heor_a.allergychar file="/home/u62744457/submission xpt files/allergychar.xpt";
run;

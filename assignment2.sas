/****************************************************************
Name: 207 Assignment 2.sas
Created by: Kitt McVey
Creation date: 11042026
Purpose: To complete Assignment 1
*****************************************************************/
libname kitt "/home/u64421158/207 - Repro";
OPTIONS FMTSEARCH=(kitt);
OPTIONS MERGENOBY=warn NODATE NONUMBER FORMCHAR="|----|+|---+=|-/\<>*";
OPTIONS FORMDLIM='_';


PROC CONTENTS DATA=kitt.adult POSITION;
RUN;

PROC FORMAT library=kitt;
VALUE  YESNO
       1                      = "YES"
       2                      = "NO";
VALUE AB1X
       -9                     = "NOT ASCERTAINED"
       -8                     = "DON'T KNOW"
       -7                     = "REFUSED"
       -1                     = "INAPPLICABLE"
       1                      = "EXCELLENT"
       2                      = "VERY GOOD"
       3                      = "GOOD"
       4                      = "FAIR"
       5                      = "POOR";
VALUE AAGEP
       -9                     = "NOT ASCERTAINED"
       -8                     = "DON'T KNOW"
       -7                     = "REFUSED"
       -5                     = "ADULT/HOUSEHOLD INFO NOT COLLECTED"
       -2                     = "PROXY SKIPPED"
       -1                     = "INAPPLICABLE"
       18                     = "18-25 YEARS"
       26                     = "26-29 YEARS"
       30                     = "30-34 YEARS"
       35                     = "35-39 YEARS"
       40                     = "40-44 YEARS"
       45                     = "45-49 YEARS"
       50                     = "50-54 YEARS"
       55                     = "55-59 YEARS"
       60                     = "60-64 YEARS"
       65                     = "65-69 YEARS"
       70                     = "70-74 YEARS"
       75                     = "75-79 YEARS"
       80                     = "80-84 YEARS"
       85                     = "85+ YEARS";
VALUE  INSANYF
       -9                     = "NOT ASCERTAINED"
       -1                     = "INAPPLICABLE"
       1                      = "CURRENTLY UNINSURED"
       2                      = "UNINS. ANY PAST 12 MO"
       3                      = "INSURED ALL PAST 12 MO";
VALUE POVLLF
       1                      = "0-99% FPL"
       2                      = "100-199% FPL"
       3                      = "200-299% FPL"
       4                      = "300% FPL AND ABOVE";
RUN;



DATA kitt.assign2data;
set kitt.adult;
LABEL
DOCT_YR       =  "VISITED DOCTOR IN PAST 12 MOS"
ER            =  "ER VISIT WITHIN THE PAST YEAR"
SRAGE_P1      =  "SELF-REPORTED AGE (PUF 1 YR RECODE)"
INSANY        =  "ANY INS IN LAST 12 MOS"
POVLL         =  "POVERTY LEVEL"
AB1           =  "GENERAL HEALTH CONDITION"
RISK3         =  "EVER DIAGNOSED WITH ANY CHRONIC RISK FACTOR (ASTHMA, DIABETES, HEART DISEASE)"
AH153_1       =  "REASON WENT TO ER: MEDICAL/MENTAL HEALTH EMERGENCY"
AH153_2       =  "REASON WENT TO ER: DIFFICULTY GETTING APPT WITH HEALTH PRO"
AH153_3       =  "REASON WENT TO ER: ONLY OPTION FOR TREATMENT"
AH153_91      =  "REASON WENT TO ER: OTHER";
FORMAT
ER DOCT_YR RISK3 AH153_1 AH153_2 AH153_3 AH153_91 YESNO. SRAGE_P1 AAGEP. INSANY INSANYF. POVLL POVLLF. AB1 AB1X.;
RUN;

PROC MEANS DATA=kitt.assign2data N MEDIAN Q1 Q3;
RUN;

PROC SURVEYFREQ DATA=kitt.assign2data VARMETHOD=jackknife;
    WEIGHT RAKEDW0;
    REPWEIGHT RAKEDW1-RAKEDW80/JKCOEFS=1;
    TABLE ER DOCT_YR RISK3 SRAGE_P1 INSANY POVLL AB1;
RUN;

/* Table 1*/
proc surveyfreq data=kitt.assign2data VARMETHOD=jackknife;
    WEIGHT RAKEDW0;
    REPWEIGHT RAKEDW1-RAKEDW80/JKCOEFS=1;
	table (DOCT_YR) * (ER RISK3 SRAGE_P1 INSANY POVLL AB1) / row;
run;
/* recode variables for Table 2 */
DATA kitt.table2data;
    SET kitt.assign2data;

    /* Convert invalid/nonresponse codes to missing values */
    IF DOCT_YR NOT IN (1, 2) THEN DOCT_YR = .;
    IF ER NOT IN (1, 2) THEN ER = .;
    IF POVLL NOT IN (1, 2, 3, 4) THEN POVLL = .;
    IF INSANY NOT IN (1, 2, 3) THEN INSANY = .;
    IF AB1 NOT IN (1, 2, 3, 4, 5) THEN AB1 = .;
    IF RISK3 NOT IN (1, 2) THEN RISK3 = .;
    IF AH153_1 NOT IN (1, 2) THEN AH153_1 = .;
    IF AH153_2 NOT IN (1, 2) THEN AH153_2 = .;
    IF AH153_3 NOT IN (1, 2) THEN AH153_3 = .;

    /* Age groups collapsed from SRAGE_P1 */
    IF SRAGE_P1 < 18 THEN AGEGRP = .;
    ELSE IF SRAGE_P1 < 30 THEN AGEGRP = 1;
    ELSE IF SRAGE_P1 < 45 THEN AGEGRP = 2;
    ELSE IF SRAGE_P1 < 65 THEN AGEGRP = 3;
    ELSE AGEGRP = 4;

    FORMAT DOCT_YR ER RISK3 AH153_1 AH153_2 AH153_3 YESNO.
           POVLL POVLLF. INSANY INSANYF. AB1 AB1X.;

    /* Complete cases on exposure, outcome (ER), and covariates */
    IF NMISS(DOCT_YR, ER, AGEGRP, INSANY, AB1, POVLL, RISK3) = 0;

    /* Flag for the reason analyses: ER visitors who answered all 3 reasons */
    IF ER = 1 AND NMISS(AH153_1, AH153_2, AH153_3) = 0 THEN REASON_SAMPLE = 1;
    ELSE REASON_SAMPLE = 0;
RUN;


/*************************************************
Table 2 Overall: ER visit (yes/no), full sample
*************************************************/
TITLE "Table 2 Overall: Doctor's visit by ER visit";
PROC SURVEYFREQ DATA=kitt.table2data VARMETHOD=JACKKNIFE;
    WEIGHT RAKEDW0;
    REPWEIGHTS RAKEDW1-RAKEDW80 / JKCOEFS=1;
    TABLES DOCT_YR*ER / ROW COL;
RUN;

TITLE "Table 2 Overall: Crude OR";
PROC SURVEYLOGISTIC DATA=kitt.table2data VARMETHOD=JACKKNIFE;
    WEIGHT RAKEDW0;
    REPWEIGHTS RAKEDW1-RAKEDW80 / JKCOEFS=1;
    CLASS DOCT_YR (REF='NO') / PARAM=REF;
    MODEL ER(EVENT='YES') = DOCT_YR;
RUN;

TITLE "Table 2 Overall: Adjusted OR";
PROC SURVEYLOGISTIC DATA=kitt.table2data VARMETHOD=JACKKNIFE;
    WEIGHT RAKEDW0;
    REPWEIGHTS RAKEDW1-RAKEDW80 / JKCOEFS=1;
    CLASS DOCT_YR (REF='NO')
          AGEGRP (REF='1')
          INSANY (REF='INSURED ALL PAST 12 MO')
          AB1 (REF='EXCELLENT')
          POVLL (REF='300% FPL AND ABOVE')
          RISK3 (REF='NO')
          / PARAM=REF;
    MODEL ER(EVENT='YES') = DOCT_YR AGEGRP INSANY AB1 POVLL RISK3;
RUN;

PROC SURVEYFREQ DATA=kitt.table2data VARMETHOD=JACKKNIFE;
    WHERE REASON_SAMPLE = 1;
    WEIGHT RAKEDW0;
    REPWEIGHTS RAKEDW1-RAKEDW80 / JKCOEFS=1;
    TABLES DOCT_YR*(AH153_1 AH153_2 AH153_3) / ROW COL;
RUN;


/* Crude odds ratios */
TITLE "Table 2: Crude OR - Reason 1 (medical/mental health emergency)";
PROC SURVEYLOGISTIC DATA=kitt.table2data VARMETHOD=JACKKNIFE;
    WHERE REASON_SAMPLE = 1;
    WEIGHT RAKEDW0;
    REPWEIGHTS RAKEDW1-RAKEDW80 / JKCOEFS=1;
    CLASS DOCT_YR (REF='NO') / PARAM=REF;
    MODEL AH153_1(EVENT='YES') = DOCT_YR;
RUN;

TITLE "Table 2: Crude OR - Reason 2 (difficulty getting appointment)";
PROC SURVEYLOGISTIC DATA=kitt.table2data VARMETHOD=JACKKNIFE;
    WHERE REASON_SAMPLE = 1;
    WEIGHT RAKEDW0;
    REPWEIGHTS RAKEDW1-RAKEDW80 / JKCOEFS=1;
    CLASS DOCT_YR (REF='NO') / PARAM=REF;
    MODEL AH153_2(EVENT='YES') = DOCT_YR;
RUN;

TITLE "Table 2: Crude OR - Reason 3 (only option for treatment)";
PROC SURVEYLOGISTIC DATA=kitt.table2data VARMETHOD=JACKKNIFE;
    WHERE REASON_SAMPLE = 1;
    WEIGHT RAKEDW0;
    REPWEIGHTS RAKEDW1-RAKEDW80 / JKCOEFS=1;
    CLASS DOCT_YR (REF='NO') / PARAM=REF;
    MODEL AH153_3(EVENT='YES') = DOCT_YR;
RUN;


/* Adjusted odds ratios */
TITLE "Table 2: Adjusted OR - Reason 1 (medical/mental health emergency)";
PROC SURVEYLOGISTIC DATA=kitt.table2data VARMETHOD=JACKKNIFE;
    WHERE REASON_SAMPLE = 1;
    WEIGHT RAKEDW0;
    REPWEIGHTS RAKEDW1-RAKEDW80 / JKCOEFS=1;
    CLASS DOCT_YR (REF='NO')
          AGEGRP (REF='1')
          INSANY (REF='INSURED ALL PAST 12 MO')
          AB1 (REF='EXCELLENT')
          POVLL (REF='300% FPL AND ABOVE')
          RISK3 (REF='NO')
          / PARAM=REF;
    MODEL AH153_1(EVENT='YES') = DOCT_YR AGEGRP INSANY AB1 POVLL RISK3;
RUN;

TITLE "Table 2: Adjusted OR - Reason 2 (difficulty getting appointment)";
PROC SURVEYLOGISTIC DATA=kitt.table2data VARMETHOD=JACKKNIFE;
    WHERE REASON_SAMPLE = 1;
    WEIGHT RAKEDW0;
    REPWEIGHTS RAKEDW1-RAKEDW80 / JKCOEFS=1;
    CLASS DOCT_YR (REF='NO')
          AGEGRP (REF='1')
          INSANY (REF='INSURED ALL PAST 12 MO')
          AB1 (REF='EXCELLENT')
          POVLL (REF='300% FPL AND ABOVE')
          RISK3 (REF='NO')
          / PARAM=REF;
    MODEL AH153_2(EVENT='YES') = DOCT_YR AGEGRP INSANY AB1 POVLL RISK3;
RUN;

TITLE "Table 2: Adjusted OR - Reason 3 (only option for treatment)";
PROC SURVEYLOGISTIC DATA=kitt.table2data VARMETHOD=JACKKNIFE;
    WHERE REASON_SAMPLE = 1;
    WEIGHT RAKEDW0;
    REPWEIGHTS RAKEDW1-RAKEDW80 / JKCOEFS=1;
    CLASS DOCT_YR (REF='NO')
          AGEGRP (REF='1')
          INSANY (REF='INSURED ALL PAST 12 MO')
          AB1 (REF='EXCELLENT')
          POVLL (REF='300% FPL AND ABOVE')
          RISK3 (REF='NO')
          / PARAM=REF;
    MODEL AH153_3(EVENT='YES') = DOCT_YR AGEGRP INSANY AB1 POVLL RISK3;
RUN;

TITLE;
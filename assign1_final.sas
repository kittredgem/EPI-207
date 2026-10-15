/****************************************************************
Name: 207 Assignment 1.sas
Created by: Kitt McVey
Creation date: 09242026
Purpose: To complete Assignment 1
*****************************************************************/
libname kitt "/home/u64421158/207 - Repro";
OPTIONS FMTSEARCH=(kitt);
OPTIONS MERGENOBY=warn NODATE NONUMBER FORMCHAR="|----|+|---+=|-/\<>*";
OPTIONS FORMDLIM='_';


PROC CONTENTS DATA=kitt.teen15 POSITION;
RUN;

PROC CONTENTS DATA=kitt.teen14 POSITION;
RUN;

PROC FORMAT;
VALUE  YESNO
       1                      = "YES"
       2                      = "NO";
VALUE  OMBSRTNP1X
	   1       				  = "Hispanic"
       2       				  = "Non-Hispanic white"
       3, 5, 7 				  = "Asian/other";
VALUE  SRSEX
       1                      = "MALE"
       2                      = "FEMALE";
VALUE  POVLLF
       1                      = "0-99% FPL"
       2                      = "100-199% FPL"
       3                      = "200-299% FPL"
       4                      = "300% FPL AND ABOVE";
VALUE  AHEDUCPF
       -9                     = "NOT ASCERTAINED"
       1                      = "NO FORMAL EDUCATION OR GRADE 1-8"
       2                      = "GRADE 9-11"
       3                      = "GRADE 12/H.S. DIPLOMA"
       4                      = "SOME COLLEGE"
       5                      = "AA/AS DEGREE OR VOCATIONAL SCHOOL"
       7                      = "BA OR BS DEGREE/SOME GRAD SCHOOL"
       9                      = "MA OR MS DEGREE"
       10                     = "PH.D. OR EQUIVALENT";
VALUE  TE8X
       -9                     = "NOT ASCERTAINED"
       -8                     = "DON'T KNOW"
       -7                     = "REFUSED"
       -1                     = "INAPPLICABLE"
        0                     = "0 DAYS"
1                     = "1 DAYS"
2                     = "2 DAYS"
3                     = "3 DAYS"
4                     = "4 DAYS"
5                     = "5 DAYS"
6                     = "6 DAYS"
7                     = "7 DAYS";
VALUE  INS64F
       -1                     = "SKIPPED - AGE >= 65"
       1                      = "UNINSURED"
       2                      = "MEDI-CAL (MEDICAID)"
       3                      = "CHIP"
       4                      = "MEDICARE"
       5                      = "EMPLOYMENT-BASED"
       6                      = "PRIVATELY PURCHASED"
       7                      = "OTHER PUBLIC";
/* Recoding of education variable to match paper */
VALUE EDU
       1                      = "NO FORMAL EDUCATION OR GRADE 1-8"
       2                      = "GRADE 12/H.S. DIPLOMA"
       3                      = "COLLEGE AND ABOVE";
/* Recoding of physical activity variable to match paper */
VALUE ACT
       1                      = "Regular physical activity 7 days a week"
       2                      = "Regular physical activity not happening 7 days a week";
RUN;



DATA kitt.both;
    SET kitt.teen14 (in=a)
        kitt.teen15 (in=b);

    IF a THEN year = 2014;
    ELSE IF b THEN year = 2015;
    
    if TE49 = 7 then act = 1;
    else if TE49  in (0,1,2,3,4,5,6) then act = 2;

    if AHEDTC_P1 = 1 then edu = 1;
    else if AHEDTC_P1 in (2, 3) then edu = 2;
    else if AHEDTC_P1 in (4, 5, 7, 9, 10) then edu = 3;
   
    ***Create new weight variables;
    fnwgt0 = rakedw0/2;
    ARRAY a_origwgts[80] rakedw1-rakedw80;
    ARRAY a_newwgts[160] fnwgt1-fnwgt160;
    DO i = 1 to 80;
        IF year=2014 THEN DO;
            a_newwgts[i] = a_origwgts[i]/2;
            a_newwgts[i+80] = rakedw0/2;
        END;
        ELSE IF year=2015 THEN DO;
            a_newwgts[i]    = rakedw0/2;
            a_newwgts[i+80] = a_origwgts[i]/2;
        END;

    END;
   
LABEL
OMBSRTN_P1    =  "OMB/CURRENT DOF RACE - ETHNICITY (PUF 1 YR RECODE)"
TE66          =  "EVER SMOKED ELECTRONIC CIGARETTES"
TE22          =  "EVER HAD MORE THAN FEW SIPS OF ALCOHOLIC DRINK"
SRSEX         =  "SELF-REPORTED GENDER"
SRAGE_P       =  "AGE (PUF RECODE)"
POVLL         =  "POVERTY LEVEL"
FV5DAY        =  "5+ FRUIT/VEGS. A DAY"
BMI_P         =  "BODY MASS INDEX (PUF RECODE)"
TC38          =  "EVER SMOKED CIGARETTES"
TE49          =  "# OF DAYS TYPICAL WEEK TEEN PHYSICALLY ACTIVE 60 MIN OR MORE"
AHEDTC_P1     =  "ADULT EDUCATIONAL ATTAINMENT (PUF 1 YR RECODE)"
INS64         =  "TYPE OF CURRENT HEALTH COVERAGE SOURCE - UNDER 65";

FORMAT
OMBSRTN_P1 OMBSRTNP1X. TE66 TE22 FV5DAY TC38 YESNO. SRSEX SRSEX. POVLL POVLLF.
TE49 TE8X. AHEDTC_P1 AHEDUCPF. INS64 INS64F. edu EDU. act ACT.;
RUN;

/* Table 1 creation */
PROC MEANS DATA=kitt.both N MEDIAN Q1 Q3;
VAR SRAGE_P;
RUN;

PROC SURVEYFREQ DATA=kitt.both VARMETHOD=jackknife;
    WEIGHT fnwgt0;
    REPWEIGHT fnwgt1-fnwgt160/JKCOEFS=0.9999;
    TABLE TE66 TE22 SRSEX POVLL FV5DAY TC38 TE49 AHEDTC_P1 INS64 SRAGE_P OMBSRTN_P1;
RUN;

proc surveyfreq data=kitt.both;
    WEIGHT fnwgt0;
    REPWEIGHT fnwgt1-fnwgt160/JKCOEFS=0.9999;
	table (TE66) * (edu SRSEX OMBSRTN_P1 TE22 POVLL FV5DAY TC38 TE49 AHEDTC_P1 INS64 act) / row;
run;

proc surveymeans data=kitt.both mean stderr;
    WEIGHT fnwgt0;
    REPWEIGHT fnwgt1-fnwgt160/JKCOEFS=0.9999;
    domain TE66;
    var SRAGE_P BMI_P;
run;

/* Table 2 */
data work.table2;
    set kitt.both;

    if OMBSRTN_P1 = 1 then race3 = 1;
    else if OMBSRTN_P1 = 2 then race3 = 2;
    else if OMBSRTN_P1 in (3,5,7) then race3 = 3;
    else race3 = .;

    /* Remove formats to use numeric reference/event values */
    format TE66 TE22 SRSEX race3 TC38 POVLL edu INS64;

    /* Convert negative nonresponse codes to missing */
    array analysis_vars
        TE66 TE22 SRSEX SRAGE_P BMI_P TC38 POVLL edu INS64;

    do k = 1 to dim(analysis_vars);
        if analysis_vars[k] < 0 then analysis_vars[k] = .;
    end;

    drop k;
run;

/* MODEL 1: OVERALL */
title "Model 1: Overall";
proc surveylogistic data=work.table2 varmethod=jackknife;
    weight FNWGT0;
    repweights FNWGT1-FNWGT160 / jkcoefs=0.9999;

    class TE66(ref='2') / param=ref;
    model TE22(event='1') = TE66;
run;


/* MODEL 1: BOYS AND GIRLS */
title "Model 1: By sex";
proc surveylogistic data=work.table2 varmethod=jackknife;
    weight FNWGT0;
    repweights FNWGT1-FNWGT160 / jkcoefs=0.9999;
    domain SRSEX;

    class TE66(ref='2') / param=ref;
    model TE22(event='1') = TE66;
run;


/* MODEL 1: ETHNICITY GROUPS */
title "Model 1: By ethnicity";
proc surveylogistic data=work.table2 varmethod=jackknife;
    weight FNWGT0;
    repweights FNWGT1-FNWGT160 / jkcoefs=0.9999;
    domain race3;

    class TE66(ref='2') / param=ref;
    model TE22(event='1') = TE66;
run;


/* MODEL 2: OVERALL */
title "Model 2: Overall";
proc surveylogistic data=work.table2 varmethod=jackknife;
    weight FNWGT0;
    repweights FNWGT1-FNWGT160 / jkcoefs=0.9999;

    class TE66(ref='2') SRSEX race3 / param=ref;
    model TE22(event='1') = TE66 SRAGE_P SRSEX race3;
run;


/* MODEL 2: BOYS AND GIRLS */
title "Model 2: By sex";
proc surveylogistic data=work.table2 varmethod=jackknife;
    weight FNWGT0;
    repweights FNWGT1-FNWGT160 / jkcoefs=0.9999;
    domain SRSEX;

    class TE66(ref='2') race3 / param=ref;
    model TE22(event='1') = TE66 SRAGE_P race3;
run;


/* MODEL 2: ETHNICITY GROUPS */
title "Model 2: By ethnicity";
proc surveylogistic data=work.table2 varmethod=jackknife;
    weight FNWGT0;
    repweights FNWGT1-FNWGT160 / jkcoefs=0.9999;
    domain race3;

    class TE66(ref='2') SRSEX / param=ref;
    model TE22(event='1') = TE66 SRAGE_P SRSEX;
run;


/* MODEL 3: OVERALL */
title "Model 3: Overall";
proc surveylogistic data=work.table2 varmethod=jackknife;
    weight FNWGT0;
    repweights FNWGT1-FNWGT160 / jkcoefs=0.9999;

    class TE66(ref='2') SRSEX race3 TC38 POVLL edu INS64
          / param=ref;

    model TE22(event='1') =
        TE66 SRAGE_P SRSEX race3 BMI_P TC38 POVLL edu INS64;
run;


/* MODEL 3: BOYS AND GIRLS */
title "Model 3: By sex";
proc surveylogistic data=work.table2 varmethod=jackknife;
    weight FNWGT0;
    repweights FNWGT1-FNWGT160 / jkcoefs=0.9999;
    domain SRSEX;

    class TE66(ref='2') race3 TC38 POVLL edu INS64
          / param=ref;

    model TE22(event='1') =
        TE66 SRAGE_P race3 BMI_P TC38 POVLL edu INS64;
run;


/* MODEL 3: ETHNICITY GROUPS */
title "Model 3: By ethnicity";
proc surveylogistic data=work.table2 varmethod=jackknife;
    weight FNWGT0;
    repweights FNWGT1-FNWGT160 / jkcoefs=0.9999;
    domain race3;

    class TE66(ref='2') SRSEX TC38 POVLL edu INS64
          / param=ref;

    model TE22(event='1') =
        TE66 SRAGE_P SRSEX BMI_P TC38 POVLL edu INS64;
run;

title
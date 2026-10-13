/****************************************************************
Name: 207 Assignment 1.sas
Created by: Kitt McVey
Creation date: 09242026
Purpose: To complete Assignment 1
*****************************************************************/
libname kitt '/home/u64421158/207 - Repro';
OPTIONS FMTSEARCH=(kitt);
OPTIONS MERGENOBY=warn NODATE NONUMBER FORMCHAR="|----|+|---+=|-/\<>*"; 
OPTIONS FORMDLIM='_';

/****check datasets for contents****/
PROC CONTENTS DATA=kitt.teen15 POSITION;
RUN;

PROC CONTENTS DATA=kitt.teen14 POSITION;
RUN;

/****label and format****/
PROC FORMAT;
VALUE  YESNO
       1                      = "YES"
       2                      = "NO";
VALUE  OMBSRTNP1X
       1                      = "HISPANIC"
       2                      = "WHITE, NON-HISPANIC (NH)"
       3                      = "OTHER RACE"
       5                      = "ASIAN ONLY, NH"
       7                      = "TWO OR MORE RACES, NH";
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
RUN;

/****compile both datasets****/
DATA kitt.both;
    SET kitt.teen14 (in=a)
        kitt.teen15 (in=b);

    IF a THEN year = 2014;
    ELSE IF b THEN year = 2015;
    
/****create new weight variables****/
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
    
/****labels and formats****/
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
TE49 TE8X. AHEDTC_P1 AHEDUCPF. INS64 INS64F.;
RUN;


/****get median for continuous variables****/
PROC MEANS DATA=kitt.both N MEDIAN Q1 Q3;
VAR SRAGE_P BMI_P;
RUN;

/****create freq tables to check consistency with paper****/
PROC SURVEYFREQ DATA=kitt.both VARMETHOD=jackknife;
    WEIGHT fnwgt0;
    REPWEIGHT fnwgt1-fnwgt160/JKCOEFS=0.9999;
    TABLE TE66 TE22 SRSEX POVLL FV5DAY TC38 TE49 AHEDTC_P1 INS64 SRAGE_P OMBSRTN_P1;
RUN;

/****get freq by strata for table 1****/
PROC SURVEYFREQ DATA=kitt.both VARMETHOD=jackknife;
    WEIGHT fnwgt0;
    REPWEIGHT fnwgt1-fnwgt160/JKCOEFS=0.9999;
    TABLE TE66 * (TE22 SRSEX POVLL FV5DAY TC38 TE49 AHEDTC_P1 INS64 SRAGE_P OMBSRTN_P1);
RUN;

/****Table 1 using %macro****/

options nodate nocenter ls = 147 ps = 47 orientation = landscape;

/** change this to location where you saved the .sas files**/
%let MacroDir=/home/u64421158/Table 1 Macro;

filename tab1  "&MacroDir./Table1.sas";
%include tab1;

/***********************/
/****UTILITY SASJOBS****/
/***********************/
filename tab1prt  "&MacroDir./Table1Print.sas";
%include tab1prt;

filename npar1way  "&MacroDir./Npar1way.sas";
%include npar1way;

filename CheckVar  "&MacroDir./CheckVar.sas";
%include CheckVar;

filename Uni  "&MacroDir./Univariate.sas";
%include Uni;

filename Varlist  "&MacroDir./Varlist.sas";
%include Varlist;

filename Words  "&MacroDir./Words.sas";
%include Words;

filename Append  "&MacroDir./Append.sas";
%include Append;

/** specify folder in which to store results***/

%let results=/home/u64421158/207 - Repro;


/*** Example 1 of macro call ***/
%Table1(DSName=kitt.both,
        GroupVar=TE66,
        NumVars=SRAGE_P BMI_P,
        FreqVars=TE22 SRSEX POVLL FV5DAY TC38 TE49 AHEDTC_P1 INS64 SRAGE_P OMBSRTN_P1,
        Median=Y,
        Total=RC,
        P=N,
        FreqCell=N(CP),
        Missing=Y,
        Print=Y,
        Label=L,
        Out=Test,
        Out1way=)

*options mprint  symbolgen mlogic;
RUN;

ods pdf file="&results.\Sample1_Table1_output.pdf";
title 'Sample characteristics and mortality outcome by treatment';
%Table1Print(DSname=test,Space=Y)
ods pdf close;
RUN;



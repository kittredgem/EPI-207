/****************************************************************
Name: 207 Assignment 3.sas
Created by: Kitt McVey
Creation date: 11162026
Purpose: To complete Assignment 3
*****************************************************************/
libname kitt "/home/u64421158/207 - Repro/assignment3";
OPTIONS FMTSEARCH=(kitt);
OPTIONS MERGENOBY=warn NODATE NONUMBER FORMCHAR="|----|+|---+=|-/\<>*";
OPTIONS FORMDLIM='_';

PROC FORMAT;
VALUE  YESNO
       1                      = "YES"
       2                      = "NO";
VALUE  POVLLF
       1                      = "0-99% FPL"
       2                      = "100-199% FPL"
       3                      = "200-299% FPL"
       4                      = "300% FPL AND ABOVE";
VALUE  POVLL_2cat
       1                      = "0-99% FPL & 100-199% FPL"
       2                      = "200-299% FPL & 300% FPL AND ABOVE";
VALUE  SRSEX
       1                      = "MALE"
       2                      = "FEMALE";
VALUE  AC135_P1F
       -9                     = "NOT ASCERTAINED"
       -8                     = "DON'T KNOW"
       -7                     = "REFUSED"
       -5                     = "ADULT/HOUSEHOLD INFO NOT COLLECTED"
       -2                     = "PROXY SKIPPED"
       -1                     = "INAPPLICABLE"
       1                      = "0 DAYS"
       2                      = "1-29 DAYS"
       3                      = "30 DAYS OR MORE";
VALUE  AC137_P1F
       -9                     = "NOT ASCERTAINED"
       -8                     = "DON'T KNOW"
       -7                     = "REFUSED"
       -5                     = "ADULT/HOUSEHOLD INFO NOT COLLECTED"
       -2                     = "PROXY SKIPPED"
       -1                     = "INAPPLICABLE"
       1                      = "0 DAYS"
       2                      = "1-29 DAYS"
       3                      = "30 DAYS OR MORE";
VALUE  AC139_P1F
       -9                     = "NOT ASCERTAINED"
       -8                     = "DON'T KNOW"
       -7                     = "REFUSED"
       -5                     = "ADULT/HOUSEHOLD INFO NOT COLLECTED"
       -2                     = "PROXY SKIPPED"
       -1                     = "INAPPLICABLE"
       1                      = "0 DAYS"
       2                      = "1-29 DAYS"
       3                      = "30 DAYS OR MORE";
VALUE  AC141_P1F
       -9                     = "NOT ASCERTAINED"
       -8                     = "DON'T KNOW"
       -7                     = "REFUSED"
       -5                     = "ADULT/HOUSEHOLD INFO NOT COLLECTED"
       -2                     = "PROXY SKIPPED"
       -1                     = "INAPPLICABLE"
       1                      = "0 DAYS"
       2                      = "1-29 DAYS"
       3                      = "30 DAYS OR MORE";
VALUE  RACEDFP1X
       -9                     = "NOT ASCERTAINED"
       -8                     = "DON'T KNOW"
       -7                     = "REFUSED"
       -5                     = "ADULT/HOUSEHOLD INFO NOT COLLECTED"
       -2                     = "PROXY SKIPPED"
       -1                     = "INAPPLICABLE"
       1                      = "LATINO"
       2                      = "NON-LATINO OTHER, ONE RACE"
       3                      = "NON-LATINO AMERICAN INDIAN/ALASKAN NATIVE"
       4                      = "NON-LATINO ASIAN"
       5                      = "NON-LATINO AFR. AMER."
       6                      = "NON-LATINO WHITE"
       8                      = "NON-LATINO, TWO+ RACES";
VALUE RACEDFP1X_4cat
       1                      = "NON-LATINO WHITE"
       2                      = "NON-LATINO AFR. AMER."
       3                      = "LATINO"
       4                      = "NON-LATINO OTHER";
VALUE  ACE_A
       -9                     = "NOT ASCERTAINED"
       -8                     = "DON'T KNOW"
       -7                     = "REFUSED"
       -5                     = "ADULT/HOUSEHOLD INFO NOT COLLECTED"
       -2                     = "PROXY SKIPPED"
       -1                     = "INAPPLICABLE"
       1                      = "0 ACE"
       2                      = "1 ACE"
       3                      = "2 ACE"
       4                      = "3 ACE"
       5                      = "4+ ACE";
VALUE  ACE_A_3cat
       1                      = "0 ACE"
       2                      = "1-3 ACE"
       3                      = "4+ ACE";
VALUE  ESMKCURF
       -9                     = "NOT ASCERTAINED"
       1                      = "CURRENT E-CIGARETTE SMOKER"
       2                      = "NOT A CURRENT E-CIGARETTE SMOKER";
VALUE  AHEDCP1X
       -9                     = "NOT ASCERTAINED"
       -8                     = "DON'T KNOW"
       -7                     = "REFUSED"
       -5                     = "ADULT/HOUSEHOLD INFO NOT COLLECTED"
       -2                     = "PROXY SKIPPED"
       -1                     = "INAPPLICABLE"
       1                      = "NO FORMAL EDUCATION OR GRADE 1-8"
       2                      = "GRADE 9-11"
       3                      = "GRADE 12/H.S. DIPLOMA"
       4                      = "SOME COLLEGE"
       5                      = "VOCATIONAL SCHOOL"
       6                      = "AA OR AS DEGREE"
       7                      = "BA OR BS DEGREE/SOME GRAD SCHOOL"
       8                      = "MA OR MS DEGREE"
       9                      = "PH.D. OR EQUIVALENT";
VALUE AHEDCP1X_3cat
       1                      = "GRADE 12/H.S. DIPLOMA OR LESS"
       2                      = "SOME COLLEGE OR VOCATIONAL SCHOOL OR AA OR AS DEGREE"
       3                      = "COLLEGE DEGREE OR HIGHER";
VALUE  UR_CL2F
       -9                     = "NOT ASCERTAINED"
       1                      = "URBAN"
       2                      = "RURAL";
VALUE  OCCMN2F
       -9                     = "NOT ASCERTAINED"
       -8                     = "DON'T KNOW"
       -7                     = "REFUSED"
       -5                     = "ADULT/HOUSEHOLD INFO NOT COLLECTED"
       -2                     = "PROXY SKIPPED"
       -1                     = "INAPPLICABLE"
       1                      = "MANAGEMENT, BUSINESS, AND FINANCIAL OCCUPATIONS"
       2                      = "COMPUTER, ENGINEERING, AND SCIENCE OCCUPATIONS"
       3                      = "EDUCATION, LEGAL, COMMUNITY SERVICE, ARTS, AND MEDIA OCCUPATIONS"
       4                      = "HEALTHCARE PRACTITIONERS AND TECHNICAL OCCUPATIONS"
       5                      = "SERVICE OCCUPATIONS"
       6                      = "SALES AND RELATED OCCUPATIONS"
       7                      = "OFFICE AND ADMINISTRATIVE SUPPORT OCCUPATIONS"
       8                      = "FARMING, FISHING, AND FORESTRY OCCUPATIONS"
       9                      = "CONSTRUCTION AND EXTRACTION OCCUPATIONS"
       10                     = "INSTALLATION, MAINTENANCE, AND REPAIR OCCUPATIONS"
       11                     = "PRODUCTION OCCUPATIONS"
       12                     = "TRANSPORTATION AND MATERIAL MOVING OCCUPATIONS"
       13                     = "MILITARY SPECIFIC OCCUPATIONS"
       14                     = "OCCUPATION CODED AS NOT IN LABOR FORCE"
       99                     = "COULD NOT BE CODED";
VALUE  OCCMN2F_5cat
       1                      = "MANAGEMENT, BUSINESS, AND FINANCIAL OCCUPATIONS OR COMPUTER, ENGINEERING, AND SCIENCE OCCUPATIONS OR EDUCATION, LEGAL, COMMUNITY SERVICE, ARTS, AND MEDIA OCCUPATIONS OR HEALTHCARE PRACTITIONERS AND TECHNICAL OCCUPATIONS"
       2                      = "SERVICE OCCUPATIONS"
       3                      = "SALES AND RELATED OCCUPATIONS OR OFFICE AND ADMINISTRATIVE SUPPORT OCCUPATIONS"
       4                      = "FARMING, FISHING, AND FORESTRY OCCUPATIONS OR CONSTRUCTION AND EXTRACTION OCCUPATIONS OR INSTALLATION, MAINTENANCE, AND REPAIR OCCUPATIONS OR PRODUCTION OCCUPATIONS OR TRANSPORTATION AND MATERIAL MOVING OCCUPATIONS OR MILITARY SPECIFIC OCCUPATIONS"
       5                      = "OCCUPATION CODED AS NOT IN LABOR FORCE OR INAPPLICABLE";
VALUE  AAGEP
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

DATA kitt.all;
    SET kitt.adult_2021 (IN=a)
        kitt.adult_2022 (IN=b)
        kitt.adult_2023 (IN=c)
        kitt.adult_2024 (IN=d)
        kitt.adult_2025 (IN=e);

/* CREATING THE WEIGHTS */        
    ARRAY orig{80} rakedw1-rakedw80;
    ARRAY fnw{400} fnwgt1-fnwgt400;
    fnwgt0 = rakedw0 / 5;
    DO i = 1 TO 400;
        fnw{i} = rakedw0 / 5;
    END;

    IF a THEN offset = 0;
    ELSE IF b THEN offset = 80;
    ELSE IF c THEN offset = 160;
    ELSE IF d THEN offset = 240;
    ELSE IF e THEN offset = 320;
    DO i = 1 TO 80;
        fnw{i + offset} = orig{i} / 5;
    END;
    YEAR = 2021 + offset/80;

    DROP i offset;

/* RE-COSING VARIABLES */  
IF POVLL IN (1,2) THEN POVLL_2cat = 1;
	ELSE IF POVLL IN (3,4) THEN POVLL_2cat = 2;
    ELSE POVLL_2cat = .;
IF RACEDF_P1 IN (6) THEN RACEDF_P1_4cat = 1;
	ELSE IF RACEDF_P1 IN (5) THEN RACEDF_P1_4cat = 2;
	ELSE IF RACEDF_P1 IN (1) THEN RACEDF_P1_4cat = 3;
	ELSE IF RACEDF_P1 IN (2,3,4,7,8) THEN RACEDF_P1_4cat = 4;
    ELSE RACEDF_P1_4cat = .;
IF AHEDC_P1 IN (1,2,3) THEN AHEDC_P1_3cat = 1;
	ELSE IF AHEDC_P1 IN (4,5,6) THEN AHEDC_P1_3cat = 2;
	ELSE IF AHEDC_P1 IN (7,8,9) THEN AHEDC_P1_3cat = 3;
    ELSE AHEDC_P1_3cat = .; 
IF ACE_A IN (1) THEN ACE_A_3cat = 1;
	ELSE IF ACE_A IN (2,3,4) THEN ACE_A_3cat = 2;
	ELSE IF ACE_A IN (5) THEN ACE_A_3cat = 3;
    ELSE ACE_A_3cat = .;
IF OCCMAIN2 IN (1:4) THEN OCCMAIN2_5cat = 1;
    ELSE IF OCCMAIN2 IN (5) THEN OCCMAIN2_5cat = 2;
    ELSE IF OCCMAIN2 IN (6,7) THEN OCCMAIN2_5cat = 3;
    ELSE IF OCCMAIN2 IN (8:13) THEN OCCMAIN2_5cat = 4;
    ELSE IF OCCMAIN2 IN (-1,14) THEN OCCMAIN2_5cat = 5;
    ELSE OCCMAIN2_5cat = .;
IF AC135_P1 IN (2,3) OR
   AC137_P1 IN (2,3) OR
   AC139_P1 IN (2,3) OR
   AC141_P1 IN (2,3) OR
   ESMKCUR = 1
THEN  NONCIGTOBNICPRO= 1;
ELSE IF AC135_P1 IN (1,-1) AND
        AC137_P1 IN (1,-1) AND
        AC139_P1 IN (1,-1) AND
        AC141_P1 IN (1,-1) AND
        ESMKCUR = 2
THEN  NONCIGTOBNICPRO= 2;
ELSE NONCIGTOBNICPRO = .;
        
LABEL
POVLL            =  "POVERTY LEVEL"
POVLL_2cat       =  "POVERTY LEVEL RECODED"
SRSEX            =  "SELF-REPORTED GENDER"
AC135_P1         =  "FREQUENCY OF SMOKELESS TOBACCO PRODUCT USE IN PAST 30 DAYS (PUF 1 YR RECODE)"
AC137_P1         =  "FREQUENCY OF SMOKE CIGARILLO/LITTLE CIGAR USE IN PAST 30 DAYS (PUF 1 YR RECODE)"
AC139_P1         =  "FREQUENCY OF BIG CIGAR USE IN PAST 30 DAYS (PUF 1 YR RECODE)"
AC141_P1         =  "FREQUENCY OF HOOKAH WATER PIPE USE IN PAST 30 DAYS (PUF 1 YR RECODE)"
RACEDF_P1        =  "FORMER DOF RACE - ETHNICITY (PUF 1 YR RECODE)"
RACEDF_P1_4cat   =  "FORMER DOF RACE - ETHNICITY (PUF 1 YR RECODE) RECODE"
ACE_A            =  "ADVERSE CHILDHOOD EXPERIENCES SCALE"
ACE_A_3cat       =  "ADVERSE CHILDHOOD EXPERIENCES SCALE RECODE"
ESMKCUR          =  "CURRENT E-CIGARETTE SMOKER"
UR_CLRT2         =  "RURAL AND URBAN - CLARITAS (BY ZIPCODE) (2 LVLS)"
AHEDC_P1         =  "EDUCATIONAL ATTAINMENT (PUF 1 YR RECODE)"
AHEDC_P1_3cat    =  "EDUCATIONAL ATTAINMENT (PUF 1 YR RECODE) RECODE"
SRAGE_P1         =  "SELF-REPORTED AGE (PUF 1 YR RECODE)"
DSTRS30          =  "LIKELY HAS HAD PSYCHOLOGICAL DISTRESS IN THE PAST MONTH"
OCCMAIN2         =  "MAIN OCCUPATION - RECODE (CENSUS 2010 OCC. CLASSIFICATION SCH.)"
OCCMAIN2_5cat    =  "MAIN OCCUPATION - RECODE (CENSUS 2010 OCC. CLASSIFICATION SCH.) RECODE"
NONCIGTOBNICPRO  =  "SMOKELESS TOBACCO OR CIGARRILO OR BIG CIGAR OR HOOKAH WATER OR E-CIGARETTE USE IN PAST 30 DAYS"
YEAR             =  "YEAR OF CHIS DATA SET";

FORMAT
POVLL POVLLF. POVLL_2cat POVLL_2cat. SRSEX SRSEX. AC135_P1 AC135_P1F. AC137_P1 AC137_P1F. AC139_P1 AC139_P1F.
AC141_P1 AC141_P1F. RACEDF_P1 RACEDF_P1X. RACEDF_P1_4cat RACEDFP1X_4cat. ACE_A  ACE_A. ACE_A_3cat ACE_A_3cat. ESMKCUR ESMKCURF.
UR_CLRT2 UR_CL2F. AHEDC_P1 AHEDCP1X. AHEDC_P1_3cat AHEDCP1X_3cat. SRAGE_P1 AAGEP. DSTRS30 YESNO. OCCMAIN2 OCCMN2F. OCCMAIN2_5cat OCCMN2F_5cat. NONCIGTOBNICPRO YESNO.;
RUN;

/* TABLE 1*/
PROC SURVEYFREQ DATA=kitt.all VARMETHOD=jackknife;
    WEIGHT fnwgt0;
    REPWEIGHTS fnwgt1-fnwgt400 / JKCOEFS=1;
    TABLES NONCIGTOBNICPRO SRAGE_P1 SRSEX RACEDF_P1_4cat AHEDC_P1_3cat ACE_A_3cat UR_CLRT2 DSTRS30 OCCMAIN2_5cat YEAR / ROW NOWT;
RUN;

/* TABLE 1 SPLIT UP BY EXPOSURE */
PROC SURVEYFREQ DATA=kitt.all VARMETHOD=jackknife;
    WEIGHT fnwgt0;
    REPWEIGHTS fnwgt1-fnwgt400 / JKCOEFS=1;
    TABLES POVLL_2cat * (NONCIGTOBNICPRO SRAGE_P1 SRSEX RACEDF_P1_4cat AHEDC_P1_3cat ACE_A_3cat UR_CLRT2 DSTRS30 OCCMAIN2_5cat YEAR) / ROW NOWT;
RUN;

/* Table 2: crude OR */
PROC SURVEYLOGISTIC DATA=kitt.all VARMETHOD=JACKKNIFE;
    WEIGHT fnwgt0;
    REPWEIGHTS fnwgt1-fnwgt400 / JKCOEFS=1;
    FORMAT POVLL_2cat NONCIGTOBNICPRO;
    CLASS POVLL_2cat (REF='2') / PARAM=REF;
    MODEL NONCIGTOBNICPRO (EVENT='1') = POVLL_2cat;
RUN;


/* Table 2: adjusted OR */
PROC SURVEYLOGISTIC DATA=kitt.all VARMETHOD=JACKKNIFE;
    WEIGHT fnwgt0;
    REPWEIGHTS fnwgt1-fnwgt400 / JKCOEFS=1;
    FORMAT POVLL_2cat NONCIGTOBNICPRO
       SRAGE_P1 SRSEX RACEDF_P1_4cat
       AHEDC_P1_3cat ACE_A_3cat UR_CLRT2;
    CLASS
        POVLL_2cat      (REF='2')
        SRAGE_P1        (REF='18')
        SRSEX           (REF='1')
        RACEDF_P1_4cat  (REF='1')
        AHEDC_P1_3cat   (REF='3')
        ACE_A_3cat      (REF='1')
        UR_CLRT2        (REF='1')
        YEAR            (REF='2021')
        / PARAM=REF;
    MODEL NONCIGTOBNICPRO (EVENT='1') =
        POVLL_2cat
        SRAGE_P1
        SRSEX
        RACEDF_P1_4cat
        AHEDC_P1_3cat 
        ACE_A_3cat
        UR_CLRT2
        YEAR;
RUN;

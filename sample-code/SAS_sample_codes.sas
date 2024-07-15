/*Define the path*/
%let path=C:\Users\npadgett\Documents\github\surverygenmod2;  

/*READ IN DATA FILE*/
proc import datafile="&path.\sample_data.csv"
out=sampleData
dbms=csv replace;
run;

/*Continuous outcome using surveyreg*/
proc surveyreg data=sampleData;
model OUTCOME_EXPENSES=AGE FEMALE OTHER EDUCATION_16PLUS  EDUCATION_UNDER8  
                       HEALTH12_EXCELLENT HEALTH12_VERYGOOD HEALTH12_FAIR HEALTH12_POOR;
weight WGT;
strata STRATA / nocollapse;
cluster PSU;  
ods output Effects=linearmodel;
run;

/*Continuous outcome using surveygenmod2*/

%include "&path.\surveygenmod2.sas";

%surveygenmod( 
	data=sampleData, 
	y=OUTCOME_EXPENSES, 
	x= AGE FEMALE OTHER EDUCATION_16PLUS  EDUCATION_UNDER8  HEALTH12_EXCELLENT HEALTH12_VERYGOOD HEALTH12_FAIR HEALTH12_POOR,  
  domain=, 
	dist=normal, 
	link=, 
	weight=WGT, 
	strata=, 
	cluster=PSU, 
	fpc=, 
	scale=deviance, 
	intercept=y, 
	vadjust=n,
  output=,
	output2=
);


/*Binary outcome using surveygenmod2*/
%surveygenmod(
  data=sampleData, 
  y=OUTCOME_INCOME, 
  x= AGE FEMALE OTHER EDUCATION_16PLUS  EDUCATION_UNDER8  HEALTH12_EXCELLENT HEALTH12_VERYGOOD HEALTH12_FAIR HEALTH12_POOR,  
  domain=, 
  dist=poisson, 
  link=log, 
  weight=WGT, 
  strata=, 
  cluster=PSU, 
  fpc=, 
  scale=, 
  intercept=y, 
  vadjust=n,
  output=,
  output2=
);



/*Saving parameter estimates and parameter (co)variance matrix*/
%surveygenmod(
  data=sampleData, 
  y=OUTCOME_INCOME, 
  x= AGE FEMALE OTHER EDUCATION_16PLUS  EDUCATION_UNDER8  HEALTH12_EXCELLENT HEALTH12_VERYGOOD HEALTH12_FAIR HEALTH12_POOR,  
  domain=, 
  dist=poisson, 
  link=log, 
  weight=WGT, 
  strata=, 
  cluster=PSU, 
  fpc=, 
  scale=, 
  intercept=y, 
  vadjust=n,
  output= paramEst,
  output2= vcovEst
);

/*Use saved paramEst/vcovEst in Wald-type test */

%include "&path.\surveyglobal_p.sas";

/*Wald-type test on the effect of health*/
%surveyglobalp(
  b=paramEst, 
  bcov=covEst, 
  variables= HEALTH12_EXCELLENT HEALTH12_VERYGOOD HEALTH12_FAIR HEALTH12_POOR, 
  output= waldtestResukt, 
  label='Education'
);

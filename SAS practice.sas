%web_drop_table(WORK.IMPORT);


FILENAME REFFILE '/home/u48771386/clinical trials practical/SAS Activity/heart kaggle.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.IMPORT;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.IMPORT; RUN;


%web_open_table(WORK.IMPORT);


/*Univariate command*/

proc univariate data=work.import;
class slope  sex;
var age;
qqplot age;
run;

/*Anova command for dataset*/
proc anova data=work.import;
class chol age;
model work.import=chol age chol*age;
title 'anova';
run;

ods noproctitle;
ods graphics / imagemap=on;

proc glm data=WORK.IMPORT plots(only)=(boxplot);
	class age chol;
	model trestbps=age / ss1 ss3;
	lsmeans age / adjust=tukey pdiff=all alpha=0.05 cl plots=(meanplot(cl) 
		diffplot);
	output out=work.Nwayanova_stats p=predicted lclm=lclm uclm=uclm r=residual 
		student=student stdr=stdr / alpha=0.05;
quit;

/* regression command*/
proc reg data=work.import;
model trestbps=chol age/r p influence;
run;




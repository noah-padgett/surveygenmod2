%macro surveyglobalp(b=, bcov=, variables=, output=, label=, mi_num=);
/**************************************xstart=, xend=
******************* *
The distributions available in %surveygenmod macro are:
* NORMAL, GAMMA, IG (INVERSE GAUSSIAN), POISSON, NEGBIN (NEGATIVE BINOMIAL) BINOMIAL (AND MULTINOMIAL), ZIP AND ZINB.
***************************************
******************* *
* The link functions available in %surveyglm macro are:
* IDENTITY, INV (INVERSE), INV2 (INVERSE SQUARED), LOG, LOGIT (GENERALIZED LOGIT).
***************************************
*******************/
%if &b= %then %do;
%put ERROR: The prameter estimates and degrees of freedom matrix must be supplied;
%end; 
%if &bcov= %then %do;
%put ERROR: The prameter variance-covariance matrix must be supplied;
%end; 


proc iml;
	*Input data;
	 use &b;
	 read all var{"B2"} into B[colname=varname];
	 read all var{"DF"} into df[colname=varname];
	 read all var{"VARNAME1"} into vnames[colname=varname];
	 use &bcov;
	 read all into Bcov[colname=varname];
	 x = {&variables} ;
	 nvar = ncol(Bcov);
	 nL = length(x);
	 B = B[1:nvar,1];
	 L = I(nvar);
	 idx=loc(element(vnames, x));
	 L = L[ idx, 1:nvar];
	 *L = L[ do( &xstart, &xend, 1) , 1:nvar];
	 fstat = t(L * B) * inv( L * Bcov * t(L) ) * (L * B) ;
	 df1 = nrow(L);
	 df2 = df[1,1];
	 pvalue = 1-probf(fstat[1,1], df1, df2);

	 label = {&label};
	 imputation= {&mi_num};

	print fstat[label="F" format=12.4]  
			df1[label="df1" format=12.4]
			df2[label="df2" format=12.4]
			pvalue[label="Pr > f" format=pvalue6.4];

 	create &output var{label fstat df1 df2 pvalue imputation};
 	append;
 	close &output;
quit;

%mend;

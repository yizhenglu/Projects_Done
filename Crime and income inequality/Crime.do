clear all
use "/Users/yizhenglu/Downloads/467论文/Crime.dta"
using "467.log"

/*
*Copy these if you firstly run from R studio.
replace Death_Penality = 1 in 31
replace Death_Penality = 1 in 32
replace Death_Penality = 0 in 33
replace Death_Penality = 0 in 34
replace Death_Penality = 0 in 35
 replace Death_Penality = 1 in 61


 replace Death_Penality = 0 in 62


 replace Death_Penality = 0 in 63


 replace Death_Penality = 0 in 64


 replace Death_Penality = 0 in 65

 replace Death_Penality = 1 in 96


 replace Death_Penality = 1 in 97


 replace Death_Penality = 1 in 98


 replace Death_Penality = 0 in 99



 replace Death_Penality = 0 in 100

gen White_per = (White_alone/Population)*100
gen Black_per = (Black_or_African_American_alone/Population)*100
gen Asia_per = (Asian_alone/Population)*100
*/


destring Gini,replace
gen White_per = (White_alone/Population)*100
gen Black_per = (Black_or_African_American_alone/Population)*100
gen Asia_per = (Asian_alone/Population)*100
gen Population_density = Population/Sq_Mi
encode State, gen(State_id)

/* Run this if you need to get Table 2 and Table 3 
collapse (mean) Gini, by(State)
sort Gini
list in 1/10
list in 41/50

Run this if you need to get Tabl 4 and Table 5
collapse (mean) Violent_Crime_rate, by(State)
sort Violent_Crime_rate
list in 1/10
list in 41/50
collapse (mean) Gini Violent_Crime_rate Property_crime_rate Unemployment_rate_above16 poverty_rate_18to64 Law_enforcement_10000 non_family_mean_income family_mean_income LTHS_25over High_ed25over,by(State)


*/

/*
To create Figure 1&2 You need run this
collapse (mean) Gini Violent_Crime_rate Property_crime_rate Unemployment_rate_above16 poverty_rate_18to64 Law_enforcement_10000 non_family_mean_income family_mean_income LTHS_25over High_ed25over Population_density,by(State)
graph twoway (scatter Violent_Crime_rate Gini, mlabel(State))

Figure 2
graph twoway (scatter Violent_Crime_rate poverty_rate_18to64, mlabel(State))

Figure 3

graph twoway (scatter Violent_Crime_rate Unemployment_rate_above16, mlabel(State))
*/


/*
The collapse function helps me change the panel data to 5-years mean cross sectional data.
Becasue Dr.Boyd and I discussed about the minor change in gini coefficient may cause gini is not statistically significant.
*/

gen family_mean_income_10000= family_mean_income/10000

bysort Year: sum  Death_Penality Gini Violent_Crime_rate  Robbery_rate  Unemployment_rate_20_24  poverty_rate_18to64 Law_enforcement_10000  family_mean_income_10000 LTHS_25over High_ed25over Population_density Black_per Asia_per White_per 





collapse (mean) Death_Penality Gini Violent_Crime_rate Burglary_rate Property_crime_rate Robbery_rate Unemployment_rate_above16 Unemployment_rate_20_24 below_pov18 poverty_rate_18to64 Law_enforcement_10000 family_mean_income_10000 LTHS_25over High_ed25over Population_density Black_per Asia_per White_per,by(State)


sum Death_Penality Gini Violent_Crime_rate  Robbery_rate  Unemployment_rate_20_24  poverty_rate_18to64 Law_enforcement_10000  family_mean_income_10000 LTHS_25over High_ed25over Population_density Black_per Asia_per White_per
/*
The death penalty of Maryland, Illiniois, and Connectitcut changed their death penalty policy from 2010 to 2014. Therefore, I consider the CT and IL as 0 
which means the death penalty still have death penalty. Becasue the mean of Death_Penality of the two states are lower than 0.5 , so I will denote it to 0. 
Instead, Marland abolished the death penalty earlier, therefore the mean of deatth penality is above 0.6, I will denote the death penality of Maryland to 1.
*/


replace Death_Penality = 0 in 7

replace Death_Penality = 0 in 13

replace Death_Penality = 1 in 20


gen ln_pop = ln(Population_density)

/*
box cox for violent
need to be log
*/

boxcox Violent_Crime_rate Gini Unemployment_rate_20_24	poverty_rate_18to64	Law_enforcement_10000  family_mean_income_10000 LTHS_25over High_ed25over ln_pop Black_per Asia_per White_per Death_Penality,model(lhsonly) lrtest nolog 

gen ln_vio = ln(Violent_Crime_rate)

/* 
First model for Violent_Crime_rate
*/


reg ln_vio  Gini
eststo on_gini


reg ln_vio  Gini Unemployment_rate_20_24
eststo on_gini_1

reg ln_vio  Gini Unemployment_rate_20_24 poverty_rate_18to64
eststo on_gini_2

reg ln_vio  Gini Unemployment_rate_20_24 poverty_rate_18to64 Law_enforcement_10000
eststo on_gini_3

reg ln_vio Gini Unemployment_rate_20_24 poverty_rate_18to64	Law_enforcement_10000   family_mean_income_10000  
eststo on_gini_4

reg ln_vio Gini Unemployment_rate_20_24	poverty_rate_18to64 Law_enforcement_10000   family_mean_income_10000  LTHS_25over
eststo on_gini_5


reg ln_vio Gini Unemployment_rate_20_24	poverty_rate_18to64 Law_enforcement_10000   family_mean_income_10000  LTHS_25over High_ed25over
eststo on_gini_6

reg ln_vio Gini Unemployment_rate_20_24	poverty_rate_18to64 Law_enforcement_10000   family_mean_income_10000  LTHS_25over High_ed25over ln_pop
eststo on_gini_7

reg ln_vio Gini Unemployment_rate_20_24	poverty_rate_18to64 Law_enforcement_10000   family_mean_income_10000  LTHS_25over High_ed25over ln_pop Black_per 
eststo on_gini_8

reg ln_vio Gini Unemployment_rate_20_24	poverty_rate_18to64 Law_enforcement_10000   family_mean_income_10000  LTHS_25over High_ed25over ln_pop Black_per Asia_per 
eststo on_gini_9

reg ln_vio Gini Unemployment_rate_20_24	poverty_rate_18to64 Law_enforcement_10000   family_mean_income_10000  LTHS_25over High_ed25over ln_pop Black_per Asia_per White_per 

eststo on_gini_10

reg ln_vio Gini Unemployment_rate_20_24	poverty_rate_18to64 Law_enforcement_10000   family_mean_income_10000  LTHS_25over High_ed25over ln_pop Black_per Asia_per White_per Death_Penality

eststo on_gini_11

reg ln_vio Gini Unemployment_rate_20_24	poverty_rate_18to64 Law_enforcement_10000   family_mean_income_10000  LTHS_25over High_ed25over ln_pop Black_per Asia_per White_per Death_Penality if State !="ALASKA"

eststo on_gini_12

esttab on_gini on_gini_1 on_gini_2 on_gini_3 on_gini_4 on_gini_5 on_gini_6 , star (* .1 ** .05 *** .01) staraux se(3) stats(N r2_a rmse F rss, labels(N AdjR-Sqr SEE F-ratio SSR))

esttab on_gini_7 on_gini_8 on_gini_9 on_gini_10 on_gini_11 on_gini_12, star (* .1 ** .05 *** .01) staraux se(3) stats(N r2_a rmse F rss, labels(N AdjR-Sqr SEE F-ratio SSR))
/*
Multicollinearity
Violent_Crime_rate: Removed LTHS_25over, family_mean_income，poverty_rate_18to64

*/


reg ln_vio Gini Unemployment_rate_20_24	poverty_rate_18to64 Law_enforcement_10000   family_mean_income_10000  LTHS_25over High_ed25over ln_pop Black_per Asia_per White_per Death_Penality if State !="ALASKA"
vif 


corr ln_vio Gini Unemployment_rate_20_24	poverty_rate_18to64 Law_enforcement_10000   family_mean_income_10000  LTHS_25over High_ed25over ln_pop Black_per Asia_per White_per Death_Penality


gen ln_fmincome = ln(family_mean_income_10000)

gen ln_pov = ln(poverty_rate_18to64)
/*
I tired to transform the poverty_rate_18to64 and family_mean_income in to ln form.
There still be a multicollinearity issue.

*/
reg ln_vio Gini Unemployment_rate_20_24	poverty_rate_18to64 Law_enforcement_10000   ln_fmincome  LTHS_25over High_ed25over ln_pop Black_per Asia_per White_per Death_Penality if State !="ALASKA"
eststo st_vio
vif 

reg ln_vio Gini Unemployment_rate_20_24	ln_pov Law_enforcement_10000 family_mean_income_10000  LTHS_25over High_ed25over ln_pop Black_per Asia_per White_per Death_Penality if State !="ALASKA"
eststo nd_vio

vif
reg ln_vio Gini Unemployment_rate_20_24	ln_pov Law_enforcement_10000   ln_fmincome  LTHS_25over High_ed25over ln_pop Black_per Asia_per White_per Death_Penality  if State !="ALASKA"
eststo rd_vio
vif

esttab st_vio nd_vio rd_vio, star (* .1 ** .05 *** .01) staraux se(3) stats(N r2_a rmse F rss, labels(N AdjR-Sqr SEE F-ratio SSR))


/*
To find the best model, 

*/

reg ln_vio Gini Law_enforcement_10000   High_ed25over ln_pop Black_per Asia_per Death_Penality  if State !="ALASKA"
vif

eststo Best_Vio1







/*
Heteroscedicity test
Violent_Crime_rate:


*/


reg ln_vio Gini Unemployment_rate_20_24	poverty_rate_18to64 Law_enforcement_10000   family_mean_income_10000  LTHS_25over High_ed25over ln_pop Black_per Asia_per White_per Death_Penality
estat hettest, fstat rhs
estat imtest, white

reg ln_vio Gini Law_enforcement_10000  High_ed25over ln_pop Black_per Asia_per Death_Penality  if State !="ALASKA"
estat hettest, fstat rhs
estat imtest, white



/*
__________________________
*/

/*
boxcox for rob
Robbery_rate no need to transform
*/




boxcox Robbery_rate Gini Unemployment_rate_20_24	poverty_rate_18to64	Law_enforcement_10000  family_mean_income_10000 LTHS_25over High_ed25over ln_pop Black_per Asia_per White_per Death_Penality,model(lhsonly) lrtest nolog 
 

reg Robbery_rate Gini
eststo Rob_1

reg Robbery_rate Gini Unemployment_rate_20_24 
eststo Rob_2

reg Robbery_rate Gini Unemployment_rate_20_24 poverty_rate_18to64
eststo Rob_3


reg Robbery_rate Gini Unemployment_rate_20_24	poverty_rate_18to64 Law_enforcement_10000
eststo Rob_4

reg Robbery_rate Gini Unemployment_rate_20_24	poverty_rate_18to64 Law_enforcement_10000 family_mean_income_10000
eststo Rob_5

reg Robbery_rate Gini Unemployment_rate_20_24	poverty_rate_18to64 Law_enforcement_10000 family_mean_income_10000 LTHS_25over 
eststo Rob_6
reg Robbery_rate Gini Unemployment_rate_20_24	poverty_rate_18to64 Law_enforcement_10000   family_mean_income_10000  LTHS_25over High_ed25over
eststo Rob_7


reg Robbery_rate Gini Unemployment_rate_20_24	poverty_rate_18to64 Law_enforcement_10000   family_mean_income_10000  LTHS_25over High_ed25over ln_pop 
eststo Rob_8

reg Robbery_rate Gini Unemployment_rate_20_24	poverty_rate_18to64 Law_enforcement_10000   family_mean_income_10000  LTHS_25over High_ed25over ln_pop Black_per
eststo Rob_9

reg Robbery_rate Gini Unemployment_rate_20_24	poverty_rate_18to64 Law_enforcement_10000   family_mean_income_10000  LTHS_25over High_ed25over ln_pop Black_per Asia_per
eststo Rob_10

reg Robbery_rate Gini Unemployment_rate_20_24	poverty_rate_18to64 Law_enforcement_10000   family_mean_income_10000  LTHS_25over High_ed25over ln_pop Black_per Asia_per White_per
eststo Rob_11
 
reg Robbery_rate Gini Unemployment_rate_20_24	poverty_rate_18to64 Law_enforcement_10000   family_mean_income_10000  LTHS_25over High_ed25over ln_pop Black_per Asia_per White_per Death_Penality
eststo Rob_12

reg Robbery_rate Gini Unemployment_rate_20_24	poverty_rate_18to64 Law_enforcement_10000   family_mean_income_10000  LTHS_25over High_ed25over ln_pop Black_per Asia_per White_per Death_Penality if State!="ALASKA"
eststo Rob_13

esttab Rob_1 Rob_2 Rob_3 Rob_4 Rob_5 Rob_6 Rob_7 , star (* .1 ** .05 *** .01) staraux se(3) stats(N r2_a rmse F rss, labels(N AdjR-Sqr SEE F-ratio SSR))

esttab Rob_8 Rob_9 Rob_10 Rob_11 Rob_12 Rob_13, star (* .1 ** .05 *** .01) staraux se(3) stats(N r2_a rmse F rss, labels(N AdjR-Sqr SEE F-ratio SSR))

/*
Multicollinearity
poverty_rate_18to64 and family_mean_income
LTHS_25over  High_ed25over
High_ed25over family_mean_income
*/

reg Robbery_rate Gini Unemployment_rate_20_24	poverty_rate_18to64 Law_enforcement_10000   family_mean_income_10000  LTHS_25over High_ed25over ln_pop Black_per Asia_per White_per Death_Penality if State !="ALASKA"
vif

corr Robbery_rate Gini Unemployment_rate_20_24	poverty_rate_18to64 Law_enforcement_10000   family_mean_income_10000  LTHS_25over High_ed25over ln_pop Black_per Asia_per White_per Death_Penality


reg Robbery_rate Gini Unemployment_rate_20_24	poverty_rate_18to64 Law_enforcement_10000   ln_fmincome  LTHS_25over High_ed25over ln_pop Black_per Asia_per White_per Death_Penality if State !="ALASKA"
eststo st_Rob


reg Robbery_rate Gini Unemployment_rate_20_24	ln_pov Law_enforcement_10000 family_mean_income_10000  LTHS_25over High_ed25over ln_pop Black_per Asia_per White_per Death_Penality if State !="ALASKA"
eststo nd_Rob

reg Robbery_rate Gini Unemployment_rate_20_24	ln_pov Law_enforcement_10000   ln_fmincome  LTHS_25over High_ed25over ln_pop Black_per Asia_per White_per Death_Penality  if State !="ALASKA"
vif
eststo rd_Rob



esttab st_Rob nd_Rob rd_Rob ,star (* .1 ** .05 *** .01) staraux se(3) stats(N r2_a rmse F rss, labels(N AdjR-Sqr SEE F-ratio SSR))



reg Robbery_rate Gini Unemployment_rate_20_24 Law_enforcement_10000 High_ed25over ln_pop Black_per Asia_per Death_Penality  if State !="ALASKA"
vif

eststo Best_Rob1


esttab rd_vio Best_Vio1 rd_Rob Best_Rob1 ,star (* .1 ** .05 *** .01) staraux se(3) stats(N r2_a rmse F rss, labels(N AdjR-Sqr SEE F-ratio SSR))


/*
Heteroscedicity test
Robbery_rate


*/



reg Robbery_rate Gini Unemployment_rate_20_24	poverty_rate_18to64	Law_enforcement_10000  family_mean_income_10000 LTHS_25over High_ed25over ln_pop Black_per Asia_per White_per Death_Penality
estat hettest, fstat rhs
estat imtest, white


reg Robbery_rate Gini Unemployment_rate_20_24 Law_enforcement_10000 High_ed25over ln_pop Black_per Asia_per Death_Penality  if State !="ALASKA"
estat hettest, fstat rhs
estat imtest, white
log close

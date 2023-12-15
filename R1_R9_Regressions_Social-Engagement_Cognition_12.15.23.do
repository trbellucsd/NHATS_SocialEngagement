use "C:\Users\12022\OneDrive - Johns Hopkins\Documents\NHATS\Social Engagement and Cognition\NHATS_SocialEngagement-Analysis.dta", clear

*Declare the data a longitudinal dataset
xtset spid time

************
*PERFORM FINAL FULLY-ADJUSTED REGRESSIONS
************

*Executive function (clock-drawing)
mixed cog_exec_R c.socengage_BL##i.time c.age_cont_BL i.female_BL i.race_eth_BL i.unmarried_BL i.hsgrad_BL c.income_BL i.depressed_BL i.anxiety_BL c.cond_num9_BL i.eversmoker_BL if r1dresid == 1 & dementia_BL == 0 || spid:

	*test overall significance of interaction
	testparm c.socengage_BL#time
	*the overall interaction is statistically significant

*Memory (word recall)
mixed cog_memory_R c.socengage_BL##i.time c.age_cont_BL i.female_BL i.race_eth_BL i.unmarried_BL i.hsgrad_BL c.income_BL i.depressed_BL i.anxiety_BL c.cond_num9_BL i.eversmoker_BL if r1dresid == 1 & dementia_BL == 0 || spid:

*Orientation (date and president)
mixed cog_orient_R c.socengage_BL##i.time c.age_cont_BL i.female_BL i.race_eth_BL i.unmarried_BL i.hsgrad_BL c.income_BL i.depressed_BL i.anxiety_BL c.cond_num9_BL i.eversmoker_BL if r1dresid == 1 & dementia_BL == 0 || spid:

************
*SECONDARY REGRESSIONS OF INTEREST
************
*Total cognition
meologit cognition_R c.socengage_BL##i.time c.age_cont_BL i.female_BL i.race_eth_BL i.unmarried_BL i.hsgrad_BL c.income_BL i.depressed_BL i.anxiety_BL c.cond_num9_BL i.eversmoker_BL if r1dresid == 1 & dementia_BL == 0 || spid:

*Possible/probable dementia
melogit pdementia_R c.socengage_BL##i.time c.age_cont_BL i.female_BL i.race_eth_BL i.unmarried_BL i.hsgrad_BL c.income_BL i.depressed_BL i.anxiety_BL c.cond_num9_BL i.eversmoker_BL if r1dresid == 1 & dementia_BL == 0 || spid:

*Probable dementia only
melogit dementia_R c.socengage_BL##i.time c.age_cont_BL i.female_BL i.race_eth_BL i.unmarried_BL i.hsgrad_BL c.income_BL i.depressed_BL i.anxiety_BL c.cond_num9_BL i.eversmoker_BL if r1dresid == 1 & dementia_BL == 0 || spid:

save "C:\Users\12022\OneDrive - Johns Hopkins\Documents\NHATS\Social Engagement and Cognition\NHATS_SocialEngagement-Analysis.dta", replace


************
*GENERATE DESCRIPTIVE CHARACTERISTICS
************
use "C:\Users\12022\OneDrive - Johns Hopkins\Documents\NHATS\Social Engagement and Cognition\NHATS_SocialEngagement-Analysis.dta", clear
save "C:\Users\12022\OneDrive - Johns Hopkins\Documents\NHATS\Social Engagement and Cognition\NHATS_SocialEngagement-Analysis_TEMP.dta", replace
quietly mixed cog_orient_R c.socengage_BL##i.time c.age_cont_BL i.female_BL i.race_eth_BL i.unmarried_BL i.hsgrad_BL c.income_BL i.depressed_BL i.anxiety_BL c.cond_num9_BL i.eversmoker_BL if r1dresid == 1 & dementia_BL == 0 || spid:
keep if e(sample)
*collapse to get characteristics for unique respondents
collapse socengage_BL age_cont_BL female_BL race_eth_BL unmarried_BL hsgrad_BL income_BL depressed_BL anxiety_BL cond_num9_BL eversmoker_BL, by(spid)
sum socengage_BL if e(sample), det
sum age_cont_BL if e(sample), det
tab female_BL if e(sample)
tab race_eth_BL if e(sample)
tab unmarried_BL if e(sample)
tab hsgrad_BL if e(sample)
sum income_BL if e(sample), det
tab depressed_BL if e(sample)
tab anxiety_BL if e(sample)
sum cond_num9_BL if e(sample), det
tab eversmoker_BL if e(sample)

**************
*Create scatter plot
**************
/*
use "C:\Users\12022\OneDrive - Johns Hopkins\Documents\NHATS\Social Engagement and Cognition\NHATS_SocialEngagement-Analysis.dta", clear

*create a categorical version of social engagement based on quartiles.
xtile soceng_4cat = socengage_BL, n(4)

twoway (scatter cog_exec time, mcolor("salmon" "chartreuse4" "mediumpurple4" "cyan3") msize(medsmall) mlabel(soceng_4cat)) /// 
       (lfit cog_exec time if soceng_4cat == 1, color("salmon") lwidth(medthick)) ///
       (lfit cog_exec time if soceng_4cat == 2, color("chartreuse4") lwidth(medthick)) ///
       (lfit cog_exec time if soceng_4cat == 3, color("mediumpurple4") lwidth(medthick)) ///
       (lfit cog_exec time if soceng_4cat == 4, color("cyan3") lwidth(medthick)),///
    (rcap hi(cog_exec + _se) lo(cog_exec - _se) if soceng_4cat == 1, color("salmon")) ///
       (rcap hi(cog_exec + _se) lo(cog_exec - _se) if soceng_4cat == 2, color("chartreuse4")) ///
       (rcap hi(cog_exec + _se) lo(cog_exec - _se) if soceng_4cat == 3, color("mediumpurple4")) ///
       (rcap hi(cog_exec + _se) lo(cog_exec - _se) if soceng_4cat == 4, color("cyan3")), ///   
xlabel("Years Since Baseline") ylabel("EF") legend(label(1 "Q1" 2 "Q2" 3 "Q3" 4 "Q4")) ///
       title("Scatter plot with Linear Regression Lines") yline(0) xline(0)
*/

**************
*Create marginal effects graphs
**************
*Helpful resource: https://stats.oarc.ucla.edu/stata/seminars/interactions-stata/

*Simple slope: when a continuous IV interacts with an MV, its slope at a particular level of an MV
	*I.e., the slope of social engagement at a particular point in time.

*Interpreting significance levels:

	*Interaction term significance: 
		*Tests the difference of simple slopes.
		*The difference in the simple slopes of social engagement for time 1 versus time 2, or versus time 3, or time 4, etc.
		*The relationship between social engagement and cognitive function is different for each time point.
		*The relationship of social engagement on cognitive performance varies by time.
		*I.e., the slope of social engagement at a particular point in time is different from the slope of social engagement at a different time point.

	*Marginal effect significance:
		*Tests whether each simple slope is different from zero.
		*I.e., the slope of social engagement at a particular point in time is different from zero.

use "C:\Users\12022\OneDrive - Johns Hopkins\Documents\NHATS\Social Engagement and Cognition\NHATS_SocialEngagement-Analysis.dta", clear

*re-run the regression for executive function graph
mixed cog_exec_R c.socengage_BL##i.time c.age_cont_BL i.female_BL i.race_eth_BL i.unmarried_BL i.hsgrad_BL c.income_BL i.depressed_BL i.anxiety_BL c.cond_num9_BL i.eversmoker_BL if r1dresid == 1 & dementia_BL == 0 || spid:
*obtain the simple slope of social engagement over values of time
*use "dydx" which stands for the partial derivative, aka the slope of social engagement
margins, dydx(socengage_BL) over(time)
marginsplot, title("Impact of Social Engagement on Executive Function over 8 Years", size(medium)) xtitle("Time") ytitle("Marginal Effect of Social Engagement") noci
*significance denotes the relationship of social engageemnt on cognitive performance at particular values of time (simple slopes/effects)

*re-run the regression for memory graph
mixed cog_memory_R c.socengage_BL##i.time c.age_cont_BL i.female_BL i.race_eth_BL i.unmarried_BL i.hsgrad_BL c.income_BL i.depressed_BL i.anxiety_BL c.cond_num9_BL i.eversmoker_BL if r1dresid == 1 & dementia_BL == 0 || spid:
*obtain the simple slope of social engagement over values of time
*use "dydx" which stands for the partial derivative, aka the slope of social engagement
margins, dydx(socengage_BL) over(time)
marginsplot, title("Impact of Social Engagement on Memory over 8 Years", size(medium)) xtitle("Time") ytitle("Marginal Effect of Social Engagement") noci
*significance denotes the relationship of social engageemnt on cognitive performance at particular values of time (simple slopes/effects)

*re-run the regression for orientation graph
mixed cog_orient_R c.socengage_BL##i.time c.age_cont_BL i.female_BL i.race_eth_BL i.unmarried_BL i.hsgrad_BL c.income_BL i.depressed_BL i.anxiety_BL c.cond_num9_BL i.eversmoker_BL if r1dresid == 1 & dementia_BL == 0 || spid:
*obtain the simple slope of social engagement over values of time
*use "dydx" which stands for the partial derivative, aka the slope of social engagement
margins, dydx(socengage_BL) over(time)
marginsplot, title("Impact of Social Engagement on Orientation over 8 Years", size(medium)) xtitle("Time") ytitle("Marginal Effect of Social Engagement") noci
*significance denotes the relationship of social engageemnt on cognitive performance at particular values of time (simple slopes/effects)

export delimited using "C:\Users\12022\OneDrive - Johns Hopkins\Documents\NHATS\Social Engagement and Cognition\NHATS_SocialEngagement-Analysis.csv", replace
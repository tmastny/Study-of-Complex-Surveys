# BRFSS_NE

This repo is my foray into complex survey analysis. Right now it is just a way to keep track of some ideas.

I'm still trying to grasp the clusters, nested strata, and weights used in complex survey design so I can effectively analyze the survey.

One goal is to work completely through this example:

https://www.r-bloggers.com/analyzing-public-health-data-in-r/

Part of that package includes work with

https://www.google.com/search?ei=mpr7WeewEMXgjwTBu5z4BQ&q=GIS+maps+in+r&oq=GIS+maps+in+r&gs_l=psy-ab.3..0i67k1j0l9.141284.142548.0.142651.13.8.0.0.0.0.178.353.0j2.2.0....0...1.1.64.psy-ab..11.2.352...0i131k1.0.IWtSNVVnz_0


Moreover, I definitely need to look into the `lodown` package for downloading complex survey data.

## Bayesian/Gelman references

Link is broken at the moment, but should be able to find the paper easy enough.

http://andrewgelman.com/2014/05/28/bayesian-nonparametric-weighted-sampling-inference/#comments


## Packages and future tools to look into

There is `srvyr`
https://github.com/gergness/srvyr

a tidy implementation of 

https://cran.r-project.org/web/packages/survey/index.html

based on the textbook. 

## NHIS

I should consider National Health Interview Survey. In particular, it seems to ask whether or not the person is insurance. I could use various predictors of health to determine if they are insured. 

See here for a discussion of survey analysis in Stan: https://groups.google.com/forum/#!topic/stan-users/nSgDmGt0cCo


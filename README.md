# Study of Complex Surveys

This repo is my foray into complex survey analysis. Right now it is just a way to keep track of some ideas.

I'm still trying to grasp the clusters, nested strata, and weights used in complex survey design so I can effectively analyze the survey.

One goal is to work completely through this example:

https://www.r-bloggers.com/analyzing-public-health-data-in-r/

Part of that package includes work with

https://www.google.com/search?ei=mpr7WeewEMXgjwTBu5z4BQ&q=GIS+maps+in+r&oq=GIS+maps+in+r&gs_l=psy-ab.3..0i67k1j0l9.141284.142548.0.142651.13.8.0.0.0.0.178.353.0j2.2.0....0...1.1.64.psy-ab..11.2.352...0i131k1.0.IWtSNVVnz_0


Moreover, I definitely need to look into the `lodown` package for downloading complex survey data.

Another Example:
https://hagutierrezro.blogspot.com/2017/01/gelman-mrp-in-r-what-is-this-all-about.html


## Bayesian/Gelman references

Link is broken at the moment, but should be able to find the paper easy enough.

http://andrewgelman.com/2014/05/28/bayesian-nonparametric-weighted-sampling-inference/#comments

Sampling weights and `brms`:

https://groups.google.com/forum/#!topic/brms-users/3y3Dlby57Zg

Article on graphical weights: 

http://www.scielo.org.co/pdf/rce/v37n2/v37n2a03.pdf

And a recent paper:

https://arxiv.org/abs/1710.00959


## Packages and future tools to look into

There is `srvyr`
https://github.com/gergness/srvyr

a tidy implementation of 

https://cran.r-project.org/web/packages/survey/index.html

based on the textbook. 

## NHIS

I should consider National Health Interview Survey. In particular, it seems to ask whether or not the person is insurance. I could use various predictors of health to determine if they are insured. 

See here for a discussion of survey analysis in Stan: https://groups.google.com/forum/#!topic/stan-users/nSgDmGt0cCo

## Mapping Survey data:

https://stackoverflow.com/questions/23318243/how-to-make-beautiful-borderless-geographic-thematic-heatmaps-with-weighted-sur

## Great article on Overestimation in Survey samples

http://www.stat.columbia.edu/~gelman/surveys.course/Hemenway1997.pdf

From http://andrewgelman.com/wp-content/uploads/2015/12/surveys_course_outline.pdf

# Forecasting elections with non-representative polls

http://www.stat.columbia.edu/~gelman/research/published/forecasting-with-nonrepresentative-polls.pdf

# Gaussian Processes

This probably shouldn't go in this repo, but oh well:

http://katbailey.github.io/post/gaussian-processes-for-dummies/

Great blog resource:

https://matthewdharris.com/2016/05/16/gaussian-process-hyperparameter-estimation/

https://matthewdharris.com/2016/04/27/gaussian-process-in-feature-space/

https://blog.dominodatalab.com/fitting-gaussian-process-models-python/

http://newton.cx/~peter/2014/03/elementary-gaussian-processes-in-python/

http://www.cs.ox.ac.uk/people/yarin.gal/website/blog_3d801aa532c1ce.html


# Mailing List about Bayesian Surveys

https://groups.google.com/forum/#!topic/stan-users/wZUb1KclmB4

In particular, there are two examples of survey analyses using Stan.

And here:

https://groups.google.com/forum/#!topic/stan-users/v4CoBWUehwU

Why isn't there a distribution that knows the total population as a parameter? Or rather, what if the inference into a population mean is a decision problem?

I need to do more reason on population weights and how they are included in actual surveys.


## Survey data on NE

https://www.cfra.org/sites/www.cfra.org/files/publications/NE-KS-Tax-Policy_0.pdf


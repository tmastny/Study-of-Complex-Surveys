# Chapter 7 Notes
Tim  
11/16/2017  


## US Elections


```r
library(tidyverse)
library(survey)
data(api)

clus2_design <- svydesign(id=~dnum+snum, fpc=~fpc1+fpc2, data=apiclus2)

pop.types <- data.frame(stype=c("E","H","M"), Freq=c(4421,755,1018))
ps_design <- postStratify(clus2_design, strata=~stype, population=pop.types)

svytotal(~enroll, clus2_design, na.rm=TRUE)
svymean(~api00, clus2_design, na.rm=TRUE)
```

```
##          total     SE
## enroll 2639273 799638
##         mean     SE
## api00 670.81 30.099
```

```r
svytotal(~enroll, ps_design, na.rm=TRUE)
svymean(~api00, ps_design, na.rm=TRUE)
```

```
##          total     SE
## enroll 3074076 292584
##       mean     SE
## api00  673 28.832
```

And the actual results for the population:


```r
apipop %>% 
  summarise(total=sum(enroll, na.rm=TRUE), mean = mean(api00, na.rm=TRUE))
```

```
##     total     mean
## 1 3811472 664.7126
```

Note that the poststratified mean can be found just by applying the weights. Finding the standard error is the part that requires additional computation. Computation that a (multilevel) model could do. 


```r
# poststratification weight is total pop of strata divided by
# population sampled
ps_weight = c(4421/100, 755/50, 1018/50)
tot_pop = 6194

apiclus2 %>% as.tibble() %>%
  group_by(stype) %>%
  summarise(tot_enroll=sum(enroll, na.rm=TRUE), tot_api00=sum(api00, na.rm=TRUE)) %>%
  summarise(ps_tot_enroll=sum(tot_enroll*ps_weight), 
            ps_mean_api00=sum(tot_api00*ps_weight)/tot_pop)
```

```
## # A tibble: 1 x 2
##   ps_tot_enroll ps_mean_api00
##           <dbl>         <dbl>
## 1       1745001      513.6228
```

It isn't perfect, but we also aren't trying to correct for clustering.

## Poststratification on Stratified Samples

Let's try the poststratification on stratified surveys:


```r
strat_design <- svydesign(id=~1, strata=~stype, fpc=~fpc, data=apistrat)
svytotal(~enroll, strat_design, na.rm=TRUE)
svymean(~api00, strat_design, na.rm=TRUE)
```

```
##          total     SE
## enroll 3687178 114642
##         mean     SE
## api00 662.29 9.4089
```

By hand: 


```r
apistrat %>% as.tibble() %>%
  group_by(stype) %>%
  summarise(tot_enroll=sum(enroll, na.rm=TRUE), tot_api00=sum(api00, na.rm=TRUE)) %>%
  summarise(ps_tot_enroll=sum(tot_enroll*ps_weight), 
            ps_mean_api00=sum(tot_api00*ps_weight)/tot_pop)
```

```
## # A tibble: 1 x 2
##   ps_tot_enroll ps_mean_api00
##           <dbl>         <dbl>
## 1       3687178      662.2874
```

We get exactly the same answers.

## Alternative Poststratification procedures





# MRP Primer
Tim  
11/9/2017  


## Data and references

## Poststrat full example


```r
library(tidyverse)
library(lme4)
library(brms)
library(rstan)

rstan_options(auto_write=TRUE)
options(mc.cores=parallel::detectCores())
```

```r
marriage.data <- foreign::read.dta('gay_marriage_megapoll.dta', convert.underscore=TRUE)
```

## Data Cleaning

Kastellec does a lot of variable recoding and in some ways I'm not sure the tidy way is much better, but we'll try:




```r
individual.model <- glmer(formula = yes.of.all ~ 
                            (1|race.female) + (1|age.cat) +
                            (1|edu.cat) + (1|age.edu.cat) + 
                            (1|state) + (1|region) + (1|poll) +
                            p.relig.full + p.kerry.full, 
                          data=marriage.data, family=binomial(link="logit"))
```


```r
#create vector of state ranefs and then fill in missing ones
state.ranefs <- array(NA,c(51,1))
dimnames(state.ranefs) <- list(c(Statelevel$sstate),"effect")
for(i in Statelevel$sstate){
    state.ranefs[i,1] <- ranef(individual.model)$state[i,1]
}
#set states with missing REs (b/c not in data) to zero
state.ranefs[,1][is.na(state.ranefs[,1])] <- 0
```

1. Each observation in the Census is a certain demographic group, identified by the following characteristics:


```r
Census %>% as.tibble() %>% 
  dplyr::select(crace.female, cage.cat, cedu.cat, cage.edu.cat, cstate)

Census %>% as.tibble() %>% 
  dplyr::select(cregion, cp.relig.full, cp.kerry.full)
```

```
## # A tibble: 4,896 x 5
##    crace.female cage.cat cedu.cat cage.edu.cat cstate
##  *        <dbl>    <int>    <int>        <dbl>  <chr>
##  1            1        1        1            1     AK
##  2            1        2        1            5     AK
##  3            1        3        1            9     AK
##  4            1        4        1           13     AK
##  5            1        1        2            2     AK
##  6            1        2        2            6     AK
##  7            1        3        2           10     AK
##  8            1        4        2           14     AK
##  9            1        1        3            3     AK
## 10            1        2        3            7     AK
## # ... with 4,886 more rows
## # A tibble: 4,896 x 3
##    cregion cp.relig.full cp.kerry.full
##  *   <chr>         <dbl>         <dbl>
##  1    west      15.44313          35.5
##  2    west      15.44313          35.5
##  3    west      15.44313          35.5
##  4    west      15.44313          35.5
##  5    west      15.44313          35.5
##  6    west      15.44313          35.5
##  7    west      15.44313          35.5
##  8    west      15.44313          35.5
##  9    west      15.44313          35.5
## 10    west      15.44313          35.5
## # ... with 4,886 more rows
```

2. Each observation's demographics are noted as a percent of the state's population


```r
Census %>% as.tibble() %>% 
  dplyr::select(cpercent.state)
```

```
## # A tibble: 4,896 x 1
##    cpercent.state
##  *          <dbl>
##  1    0.022005467
##  2    0.017764583
##  3    0.019743662
##  4    0.016162474
##  5    0.045141835
##  6    0.064037323
##  7    0.047120914
##  8    0.009942512
##  9    0.033832815
## 10    0.057440393
## # ... with 4,886 more rows
```

3. For each observation's demographics, our model tells us their estimated support for gay marriage:


```r
cellpred <- invlogit(fixef(individual.model)["(Intercept)"] 
                     + ranef(individual.model)$race.female[Census$crace.female,1]
                     + ranef(individual.model)$age.cat[Census$cage.cat,1] 
                     + ranef(individual.model)$edu.cat[Census$cedu.cat,1]
                     + ranef(individual.model)$age.edu.cat[Census$cage.edu.cat,1] 
                     + state.ranefs[Census$cstate,1]   
                     + ranef(individual.model)$region[Census$cregion,1] 
                     + (fixef(individual.model)["p.relig.full"] *Census$cp.relig.full)
                     + (fixef(individual.model)["p.kerry.full"] *Census$cp.kerry.full)
)
str(cellpred)
```

```
##  Named num [1:4896] 0.352 0.244 0.184 0.114 0.385 ...
##  - attr(*, "names")= chr [1:4896] "AK" "AK" "AK" "AK" ...
```

4. Next, we take the weighted average of the proportion of support for gay marriage. 


```r
cellpredweighted <- cellpred * Census$cpercent.state
```

5. Next, we average reach cell within each state to get the predicted state outcome: 


```r
statepred <- tibble(
  stateabv = unique(Census$cstate),
  pred.support = 100*as.vector(tapply(cellpredweighted,Census$cstate,sum))
)
```



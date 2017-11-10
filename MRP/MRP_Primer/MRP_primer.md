# MRP Primer
Tim  
11/9/2017  


## Data and references

I'll be working through Kastellec et al's MRP primer. The paper and datasets are hosted [at his website](http://www.princeton.edu/~jkastell/mrp_primer.html). 

I have a few goals in this exercise:

1. Verify Kastellec's findings.

2. Attempt a full Bayesian modeling uses `Stan` and `brms`. 

3. Compare

    a. multilevel vs. fixed effects models

    b. results before and after poststratification
  

## Reproduce and Verify

Our goal is to estimate public opinion on gay marriage using this poll:


```r
library(tidyverse)
library(arm)
marriage.data <- foreign::read.dta('gay_marriage_megapoll.dta', convert.underscore=TRUE)
marriage.data %>% as.tibble()
```

```
## # A tibble: 6,548 x 27
##             poll poll.firm poll.year    id statenum     statename
##  *         <chr>     <chr>     <int> <int>    <int>        <fctr>
##  1 Gall2005Aug22      Gall      2005 80001       21      michigan
##  2 Gall2005Aug22      Gall      2005 80002       10       georgia
##  3 Gall2005Aug22      Gall      2005 80003       31      new york
##  4 Gall2005Aug22      Gall      2005 80004       28 new hampshire
##  5 Gall2005Aug22      Gall      2005 80005       42         texas
##  6 Gall2005Aug22      Gall      2005 80006       12      illinois
##  7 Gall2005Aug22      Gall      2005 80007       48     wisconsin
##  8 Gall2005Aug22      Gall      2005 80008       42         texas
##  9 Gall2005Aug22      Gall      2005 80009       41     tennessee
## 10 Gall2005Aug22      Gall      2005 80010       48     wisconsin
## # ... with 6,538 more rows, and 21 more variables: region.cat <int>,
## #   female <int>, race.wbh <int>, edu.cat <int>, age.cat <int>,
## #   age.cat6 <int>, age.edu.cat6 <int>, educ <int>, age <int>,
## #   democrat <int>, republican <int>, black <int>, hispanic <int>,
## #   weight <dbl>, yes.of.opinion.holders <int>, yes.of.all <int>,
## #   state <chr>, state.initnum <int>, region <chr>, no.of.all <dbl>,
## #   no.of.opinion.holders <dbl>
```

## Disaggregration 

The simplest way to gauge politic opinion is to disaggregrate the data. Break down the national survey into states and calculate the percentage saying `yes.of.all`. That calculation is very simple with `dplyr`:


```r
marriage.opinion <- marriage.data %>%
  group_by(statename) %>%
  summarise(support = mean(yes.of.all))
marriage.opinion
```

```
## # A tibble: 50 x 2
##               statename   support
##                  <fctr>     <dbl>
##  1              alabama 0.1284404
##  2              arizona 0.4296875
##  3             arkansas 0.1071429
##  4           california 0.4624809
##  5             colorado 0.3923077
##  6          connecticut 0.3623188
##  7             delaware 0.1764706
##  8 district of columbia 0.2857143
##  9              florida 0.3227666
## 10              georgia 0.2692308
## # ... with 40 more rows
```

Let's map it. First we setup our mapping tools.


```r
library(maps)
library(mapdata)
library(ggmap)
states <- map_data("state")

ditch_the_axes <- theme(
  axis.text = element_blank(),
  axis.line = element_blank(),
  axis.ticks = element_blank(),
  panel.border = element_blank(),
  panel.grid = element_blank(),
  axis.title = element_blank()
  )
```

Next, we need to combine our state level data with the national map `states`.


```r
state_opinion <- states %>%
  inner_join(marriage.opinion, by=c('region' = 'statename')) %>% 
  as.tibble()

ggplot(data=state_opinion, aes(x = long, y = lat, group = group)) +
  geom_polygon(aes(fill = support), color = "black") +
  coord_fixed(1.3) + 
  theme_bw() +
  ditch_the_axes + 
  scale_fill_gradient2(low = 'red', mid = 'white', high = 'blue',
                       midpoint = 0.5)
```

![](MRP_primer_files/figure-html/unnamed-chunk-4-1.png)<!-- -->

White indicates majority support, with colors trending towards blue indicate increased support. Red colors are states below majority support. Another useful way to look at the map is to the set the color midpoint at the mean 0.3026129.

Alternatively, we can look at an graph sorted by the level of support. Providing an alternative to maps is recommended by Gelman. 


```r
marriage.opinion %>% na.omit() %>%
  ggplot(aes(x=support, y=reorder(statename, support))) +
  geom_point() + 
  geom_vline(xintercept = mean(marriage.opinion$support), linetype=2)
```

![](MRP_primer_files/figure-html/unnamed-chunk-5-1.png)<!-- -->



## Combining Data

Likewise, we may want to use other state level predictors from other sources:


```r
Statelevel <- foreign::read.dta("state_level_update.dta",convert.underscore = TRUE)
Statelevel <- Statelevel[order(Statelevel$sstate.initnum),]
Statelevel %>% as.tibble()
```

```
## # A tibble: 51 x 44
##    sstate.initnum sstate  sstatename ideology professional.index
##  *          <int>  <chr>       <chr>    <dbl>              <dbl>
##  1              1     AK      Alaska       NA              0.227
##  2              2     AL     Alabama    -23.1              0.071
##  3              3     AR    Arkansas    -18.3              0.106
##  4              4     AZ     Arizona    -18.2              0.232
##  5              5     CA  California     -6.2              0.626
##  6              6     CO    Colorado     -8.6              0.202
##  7              7     CT Connecticut     -4.4              0.190
##  8              8     DC        D.C.       NA                 NA
##  9              9     DE    Delaware    -12.2              0.148
## 10             10     FL     Florida    -17.1              0.223
## # ... with 41 more rows, and 39 more variables: professional.cat <int>,
## #   salary <dbl>, totalday <dbl>, staffper <dbl>, citizen.init <int>,
## #   year.adoption <int>, consitutional.init <int>, signature <int>,
## #   usage <int>, legislative.insulation <int>, p.evang <dbl>,
## #   p.mormon <dbl>, p.cath <dbl>, p.metroarea <dbl>, adjinc.cap <dbl>,
## #   pblack <dbl>, phisp <dbl>, p65over <dbl>, phighsch <dbl>,
## #   pbachelors <dbl>, demcontrol <int>, pdemocrat <dbl>,
## #   polarization <dbl>, divided <dbl>, kerry.04 <dbl>, gore.00 <dbl>,
## #   clinton.92 <dbl>, mondale.84 <dbl>, dukakis.88 <dbl>,
## #   humphrey.68 <dbl>, mcgovern.72 <dbl>, population <int>,
## #   court.type <chr>, court.elected <int>, berry.citizen <dbl>,
## #   berry.government <dbl>, Bryan.1896 <dbl>, tempculture <chr>,
## #   state.culture <chr>
```

Finally, we need to load in the US census for poststratification:


```r
Census <- foreign::read.dta("poststratification 2000.dta",convert.underscore = TRUE)
Census <- Census[order(Census$cstate),]
Census$cstate.initnum <-  match(Census$cstate, Statelevel$sstate)
Census %>% as.tibble()
```

```
## # A tibble: 4,896 x 10
##    crace.WBH cage.cat cedu.cat cfemale cstate .freq cfreq.state
##  *     <int>    <int>    <int>   <int>  <chr> <int>       <dbl>
##  1         1        1        1       0     AK   467       21222
##  2         1        2        1       0     AK   377       21222
##  3         1        3        1       0     AK   419       21222
##  4         1        4        1       0     AK   343       21222
##  5         1        1        2       0     AK   958       21222
##  6         1        2        2       0     AK  1359       21222
##  7         1        3        2       0     AK  1000       21222
##  8         1        4        2       0     AK   211       21222
##  9         1        1        3       0     AK   718       21222
## 10         1        2        3       0     AK  1219       21222
## # ... with 4,886 more rows, and 3 more variables: cpercent.state <dbl>,
## #   cregion <chr>, cstate.initnum <int>
```

An important warning with poststratification techniques is that you need demographic information for every intersection of your model predictors. For example, if your model predicts opinion based on gender, race, age, and education you will need to know the number of African American females aged 18 to 29 years old who are college graduates. Do we have that information?


```r
Census %>%
  group_by(crace.WBH, cage.cat, cedu.cat, cfemale) %>%
  summarise(count = sum(.freq)) %>%
  filter(crace.WBH==2, cfemale==1, cage.cat==1)
```

```
## # A tibble: 4 x 5
## # Groups:   crace.WBH, cage.cat, cedu.cat [4]
##   crace.WBH cage.cat cedu.cat cfemale count
##       <int>    <int>    <int>   <int> <int>
## 1         2        1        1       1 31516
## 2         2        1        2       1 42996
## 3         2        1        3       1 50071
## 4         2        1        4       1 13421
```

Next, we need to create a list of indicator variables to poststratify the survey. First, on the mega-poll level, we recode some of the indicator variables and bring some data in from the State level statistics.


```r
# from 1 for white males to 6 for hispanic females
marriage.data$race.female <- (marriage.data$female *3) + marriage.data$race.wbh

# from 1 for 18-29 with low edu to 16 for 65+ with high edu
marriage.data$age.edu.cat <- 4 * (marriage.data$age.cat -1) + marriage.data$edu.cat

# proportion of evangelicals in respondent's state
marriage.data$p.evang.full <- Statelevel$p.evang[marriage.data$state.initnum]

# proportion of mormon's in respondent's state
marriage.data$p.mormon.full <-Statelevel$p.mormon[marriage.data$state.initnum]

# combined evangelical + mormom proportions
marriage.data$p.relig.full <- marriage.data$p.evang.full + marriage.data$p.mormon.full

# kerry's % of 2-party vote in respondent's state in 2004
marriage.data$p.kerry.full <- Statelevel$kerry.04[marriage.data$state.initnum]
```

As an aside, I really dislike this coding scheme as it seems to make the interpretation of the categorical quantities very difficult to understand. I'd like to try an alterative reformulation of the indicators later, or have a function to convert them a la `tidybayes` to easily understand. 

Next, we code the system census in the same way.


```r
Census$crace.female <- (Census$cfemale *3) + Census$crace.WBH 
Census$cage.edu.cat <- 4 * (Census$cage.cat -1) + Census$cedu.cat 
Census$cp.evang.full<-  Statelevel$p.evang[Census$cstate.initnum]
Census$cp.mormon.full <- Statelevel$p.mormon[Census$cstate.initnum]
Census$cp.relig.full <- Census$cp.evang.full + Census$cp.mormon.full
Census$cp.kerry.full <-  Statelevel$kerry.04[Census$cstate.initnum]
```

## Fitting a regression

We'll start with fitting the multilevel model specified in the paper. 


```r
individual.model <- glmer(formula = yes.of.all ~ 
                            (1|race.female) + (1|age.cat) +
                            (1|edu.cat) + (1|age.edu.cat) + 
                            (1|state) + (1|region) + (1|poll) +
                            p.relig.full + p.kerry.full, 
                          data=marriage.data, family=binomial(link="logit"))
```

```r
display(individual.model)
```

```
## glmer(formula = yes.of.all ~ (1 | race.female) + (1 | age.cat) + 
##     (1 | edu.cat) + (1 | age.edu.cat) + (1 | state) + (1 | region) + 
##     (1 | poll) + p.relig.full + p.kerry.full, data = marriage.data, 
##     family = binomial(link = "logit"))
##              coef.est coef.se
## (Intercept)  -1.41     0.54  
## p.relig.full -0.02     0.00  
## p.kerry.full  0.02     0.01  
## 
## Error terms:
##  Groups      Name        Std.Dev.
##  state       (Intercept) 0.04    
##  age.edu.cat (Intercept) 0.09    
##  race.female (Intercept) 0.23    
##  poll        (Intercept) 0.21    
##  region      (Intercept) 0.20    
##  edu.cat     (Intercept) 0.36    
##  age.cat     (Intercept) 0.55    
##  Residual                1.00    
## ---
## number of obs: 6341, groups: state, 49; age.edu.cat, 16; race.female, 6; poll, 5; region, 5; edu.cat, 4; age.cat, 4
## AIC = 7459.4, DIC = 7276
## deviance = 7357.7
```

This model estimates the mean (via offsets using group-level intercepts) for each cross-classification of demographics and states; the exact poststratification we are interested in.  

Analyzing the coefficients, we first see that an individual's religion indicates they would be less inclined to support gay marriage with a certainty. This result is expeted. However, voting for Kerry in the previous elect has an estimated positive effect, although the confidence interval includes zero. This is suprisingly since republicans tend to not support gay marriage and tend to be more religious.

Let's take a look at the actual group-level intercepts.


```r
tibble(Intercept = ranef(individual.model)$race.female$`(Intercept)`,
       se = se.ranef(individual.model)$race.female[,1]) %>%
  mutate(race = c('White male', 'White female', 'Black male', 'Black female',
                  'Hispanic male', 'Hispanic female'))
```

```
## # A tibble: 6 x 3
##     Intercept        se            race
##         <dbl>     <dbl>           <chr>
## 1 -0.21042113 0.1083258      White male
## 2 -0.08701421 0.1454965    White female
## 3  0.04904728 0.1472961      Black male
## 4  0.23019439 0.1080291    Black female
## 5 -0.22601647 0.1362808   Hispanic male
## 6  0.24575666 0.1485544 Hispanic female
```

The standard error on the estimates is fairly large. However, some estimates have a confidence interval just above (or below) zero. Looking at the statistics, men support gay marriage less on average than women in each strata. Moreover, whites seem to support gay marriage less than any other race, with the notable except of Hispanic men. 





## Poststratifying




Note to self: I want to create a scatterplot with state abbreviations using `geom_text` comparing disaggregrate to multilevel. In fact, I want to compare them against both MRP and MR.


```r
unique(Census$cstate)
```

```
##  [1] "AK" "AL" "AR" "AZ" "CA" "CO" "CT" "DC" "DE" "FL" "GA" "HI" "IA" "ID"
## [15] "IL" "IN" "KS" "KY" "LA" "MA" "MD" "ME" "MI" "MN" "MO" "MS" "MT" "NC"
## [29] "ND" "NE" "NH" "NJ" "NM" "NV" "NY" "OH" "OK" "OR" "PA" "RI" "SC" "SD"
## [43] "TN" "TX" "UT" "VA" "VT" "WA" "WI" "WV" "WY"
```


## Comparing model to full Bayesian


We'll fit the model to flat priors without better information and to match the MLE estimate.

Based on an initial attempted fit, I think I'll need to provide some priors to get quick convergence. 


```r
# library(brms)
# individual.model <- brm(yes.of.all ~ 
#                             (1|race.female) + (1|age.cat) +
#                             (1|edu.cat) + (1|age.edu.cat) + 
#                             (1|state) + (1|region) + (1|poll) +
#                             p.relig.full + p.kerry.full, 
#                           data=marriage.data, family=binomial(link="logit"))
```

```r
# display(individual.model)
# summary(individual.model)
```







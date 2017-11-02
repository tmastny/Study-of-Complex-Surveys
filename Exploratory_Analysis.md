# Exploratory Data Analysis of Omaha BRFSS Survey
Tim Mastny  
November 2, 2017  



## Looking at the data.


```r
library(tidyverse)
d <- read_csv('Behavioral_Risk_Factors__Selected_Metropolitan_Area_Risk_Trends__SMART__MMSA_Prevalence_Data__2011_to_Present_.csv')

d %>% as.tibble()
```

```
## # A tibble: 554 x 27
##     Year Locationabbr
##    <int>        <int>
##  1  2015        36540
##  2  2015        36540
##  3  2015        36540
##  4  2015        36540
##  5  2015        36540
##  6  2015        36540
##  7  2015        36540
##  8  2015        36540
##  9  2015        36540
## 10  2015        36540
## # ... with 544 more rows, and 25 more variables: Locationdesc <chr>,
## #   Class <chr>, Topic <chr>, Question <chr>, Response <chr>,
## #   Break_Out <chr>, Break_Out_Category <chr>, Sample_Size <dbl>,
## #   Data_value <dbl>, Confidence_limit_Low <dbl>,
## #   Confidence_limit_High <dbl>, Display_order <int>,
## #   Data_value_unit <chr>, Data_value_type <chr>,
## #   Data_Value_Footnote_Symbol <chr>, Data_Value_Footnote <chr>,
## #   DataSource <chr>, ClassId <chr>, TopicId <chr>, LocationID <int>,
## #   BreakoutID <chr>, BreakOutCategoryID <chr>, QuestionID <chr>,
## #   RESPONSEID <chr>, GeoLocation <chr>
```

How many years and where?


```r
unique(d$Year)
```

```
## [1] 2015 2014 2013 2012 2011
```

```r
unique(d$Locationabbr)
```

```
## [1] 36540
```

```r
unique(d$Locationdesc)
```

```
## [1] "Omaha-Council Bluffs, NE-IA Metropolitan Statistical Area"
```



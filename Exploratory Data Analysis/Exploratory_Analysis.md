# Exploratory Data Analysis of Omaha BRFSS Survey
Tim Mastny  
November 2, 2017  



## Looking at the data.


```r
library(tidyverse)
d <- read_csv("~/git_tests/BRFSS_NE/Behavioral_Risk_Factors__Selected_Metropolitan_Area_Risk_Trends__SMART__MMSA_Prevalence_Data__2011_to_Present_.csv")

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

Let's take a look at some of the data:


```r
d %>%
  select(Class, Question, Response, Sample_Size)
```

```
## # A tibble: 554 x 4
##                          Class
##                          <chr>
##  1               Health Status
##  2               Health Status
##  3               Health Status
##  4               Health Status
##  5               Health Status
##  6               Health Status
##  7               Health Status
##  8 Health Care Access/Coverage
##  9 Health Care Access/Coverage
## 10 Health Care Access/Coverage
## # ... with 544 more rows, and 3 more variables: Question <chr>,
## #   Response <chr>, Sample_Size <dbl>
```

```r
unique(d$Class)
```

```
##  [1] "Health Status"                "Health Care Access/Coverage" 
##  [3] "Hypertension Awareness"       "Cholesterol Awareness"       
##  [5] "Chronic Health Indicators"    "Demographics"                
##  [7] "Overweight and Obesity (BMI)" "Tobacco Use"                 
##  [9] "Alcohol Consumption"          "Fruits and Vegetables"       
## [11] "Physical Activity"            "Injury"                      
## [13] "Immunization"                 "Oral Health"                 
## [15] "Women's Health"               "Prostate Cancer"             
## [17] "Colorectal Cancer Screening"  "HIV-AIDS"
```

```r
str(unique(d$Question))
```

```
##  chr [1:72] "Health Status (variable calculated from one or more BRFSS questions)" ...
```

We are dealing with a Survey of 72 questions. I will need to look at some supplementary material to make sense of that. 


```r
d %>%
  select(Response, Sample_Size, Break_Out)
```

```
## # A tibble: 554 x 3
##                 Response Sample_Size Break_Out
##                    <chr>       <dbl>     <chr>
##  1   Fair or Poor Health         598   Overall
##  2             Excellent         729   Overall
##  3             Very good        1463   Overall
##  4                  Good        1233   Overall
##  5                  Fair         445   Overall
##  6                  Poor         153   Overall
##  7 Good or Better Health        3425   Overall
##  8                   Yes        3718   Overall
##  9                    No         297   Overall
## 10                   Yes        2448   Overall
## # ... with 544 more rows
```





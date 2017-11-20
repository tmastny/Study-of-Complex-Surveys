# Chapter 2 Notes
Tim  
11/5/2017  


## US Elections


```r
library(tidyverse)
library(survey)
data(election)
d <- election

d %>% as.tibble()
```

```
## # A tibble: 4,600 x 8
##      County TotPrecincts PrecinctsReporting   Bush Kerry Nader  votes
##  *   <fctr>        <int>              <int>  <int> <int> <int>  <int>
##  1   Alaska          439                439 151876 86064  3890 241830
##  2  Autauga           22                 22  15212  4774    74  20060
##  3  Baldwin           50                 50  52910 15579   371  68860
##  4  Barbour           24                 24   5893  4826    26  10745
##  5     Bibb           16                 16   5471  2089    12   7572
##  6   Blount           26                 26  17364  3932    92  21388
##  7  Bullock           27                 27   1494  3210     3   4707
##  8   Butler           27                 27   4978  3409    13   8400
##  9  Calhoun           53                 53  29806 15076   182  45064
## 10 Chambers           24                 24   7618  5346    42  13006
## # ... with 4,590 more rows, and 1 more variables: p <dbl>
```

```r
# srsdesc <- svydesign(id=~1, data=d[in.srs,] , fpc=~fpc)
```






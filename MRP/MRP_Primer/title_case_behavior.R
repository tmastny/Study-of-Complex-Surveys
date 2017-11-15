
####
# Actually, thinking about this, I think it makes most sense to avoid
# inconsistent cases like title case and force everything to be upper or lower
####

stringr::str_to_title("district of columbia")
# [1] "District Of Columbia"

tools::toTitleCase("district of columbia")
# [1] "District of Columbia"


# The second one is more useful when you consider most mapping tools 
# in R use the term "District of Columbia". Most style guides (Chicago,
# MLA, APA) do not capitalize 'of' in title case.

# For example:

library(albersusa)
library(ggalt)
us <- usa_composite()
us_map <- fortify(us, region="name")
unique(us_map[us_map$id == 'District of Columbia', 'id'])
# [1] "District of Columbia"

library(maps)
states <- map_data("state")
unique(states[states$region == 'district of columbia', 'region'])
# [1] "district of columbia"



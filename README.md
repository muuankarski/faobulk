# faobulk R package

Search and download FAOSTAT bulk download files


```r

library(faobulk)
datalist <- get_datalist()
head(datalist)
# # A tibble: 6 x 12
# DatasetCode DatasetName        Topic                       DatasetDescription                    Contact    Email      DateUpdate CompressionForm… FileType FileSize FileRows FileLocation             
# <chr>       <chr>              <chr>                       <chr>                                 <chr>      <chr>      <chr>      <chr>            <chr>    <chr>    <chr>    <chr>                    
# 1 AE          ASTI R&D Indicato… All government and nonprof… ASTI collects primary time-series da… Nienke Be… asti@cgia… 2015-11-03 zip              csv      13KB     1525     http://fenixservices.fao…
# 2 AF          ASTI R&D Indicato… All government, higher edu… ASTI collects primary time-series da… Nienke Be… asti@cgia… 2015-11-03 zip              csv      12KB     1437     http://fenixservices.fao…
# 3 BC          Food Balance: Com… Most crop and livestock pr… Commodity balances show balances of … Mr. Salar… faostat@f… 2018-01-16 zip              csv      46296KB  7695363  http://fenixservices.fao…
# 4 BL          Food Balance: Com… Most crop and livestock pr… Food supply data is some of the most… Mr. Salar… faostat@f… 2018-01-17 zip              csv      16605KB  2868088  http://fenixservices.fao…
# 5 CC          Food Balance: Foo… Most crop and livestock pr… Food supply data is some of the most… Mr. Salar… faostat@f… 2018-02-05 zip              csv      31283KB  4583938  http://fenixservices.fao…
# 6 CISP        Investment: Count… Agriculture, forestry and … The Country Investment Statistics Pr… Mukesh Sr… Mukesh.Sr… 2018-12-19 zip              csv      546KB    66029    http://fenixservices.fao…

datalist[grepl("production", datalist$DatasetName, ignore.case = TRUE),
         c("DatasetCode","DatasetName","Topic")]
# A tibble: 8 x 3
# DatasetCode DatasetName                      Topic                                                                             
# <chr>       <chr>                            <chr>                                                                             
# 1 FO          Forestry: Forestry Production a… Forestry and logging, Manufacture of wood and wood products, Manufacture of pulp,…
# 2 QA          Production: Live Animals         Most crop and livestock products under agricultural activity.                     
# 3 QC          Production: Crops                Most crop products under agricultural activity.                                   
# 4 QD          Production: Crops processed      Most crop products and processed crops under agricultural activity.               
# 5 QI          Production: Production Indices   Most crop products and processed crops under agricultural activity.               
# 6 QL          Production: Livestock Primary    Agriculture holdings and enterprises for processing of animals.                   
# 7 QP          Production: Livestock Processed  Agriculture holdings and enterprises for processing of animals.                   
# 8 QV          Production: Value of Agricultur… NA  

dat <- get_data(DatasetCode = "FO")

library(dplyr)
dat %>% count(item)
# # A tibble: 79 x 2
# item                                         n
# <chr>                                    <int>
# 1 Cartonboard                              16906
# 2 Case materials                           16683
# 3 Chemical wood pulp                       31221
# 4 Chemical wood pulp, sulphate, bleached   26967
# 5 Chemical wood pulp, sulphate, unbleached 21963
# 6 Chemical wood pulp, sulphite, bleached   22591
# 7 Chemical wood pulp, sulphite, unbleached 17864
# 8 Dissolving wood pulp                     21365
# 9 Fibreboard                               36263
# 10 Fibreboard, compressed (1961-1994)       14539
# # ... with 69 more rows

dat %>% count(element)
# # A tibble: 5 x 2
# element              n
# <chr>            <int>
# 1 Export Quantity 322396
# 2 Export Value    333213
# 3 Import Quantity 422161
# 4 Import Value    434775
# 5 Production      402115

dat %>% count(unit)
# # A tibble: 3 x 2
# unit          n
# <chr>     <int>
# 1 1000 US$ 767988
# 2 m3       595677
# 3 tonnes   550995

dat_tmp <- dat %>% 
  filter(item == "Cartonboard",
         element == "Export Quantity",
         unit == "tonnes",
         !grepl("World|Europe|Asia|America", area)) 
library(ggplot2)
library(scales)
ggplot() +
  
  ## LINES ##
  
  # All countries but Nordic Countries
  geom_line(data = dat_tmp %>% 
              filter(!grepl("Sweden|Finland|Norway|Denmark|Iceland", area)),
            color = alpha("black", 1/10),
            aes(x = year, y = value, group = area)) +
  # Nordic Countries
  geom_line(data = dat_tmp %>% 
              filter(grepl("Sweden|Finland|Norway|Denmark|Iceland", area)),
            color = alpha("red", 1/2),
            aes(x = year, y = value, group = area)) +
  scale_y_continuous(labels = comma, trans = "log") +
  
  ## LABELS ##
  
  # Top five countries from All countries but Nordic Countries
  geom_text(data = dat_tmp %>% 
              filter(!grepl("Sweden|Finland|Norway|Denmark|Iceland", area),
                     year == max(year)) %>% 
              arrange(desc(value)) %>% 
              slice(1:5),
            color = "black",
            aes(x = year, y = value, group = area, label = area)) +
  # Nordic Countries
  geom_text(data = dat_tmp %>% 
              filter(grepl("Sweden|Finland|Norway|Denmark|Iceland", area),
                     year == max(year)),
            color = "red",
            aes(x = year, y = value, group = area, label = area))

```



### Disclaimer

This package is in no way officially related to or endorsed by FAO.

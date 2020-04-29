---
title: "The Big Ones"
author: "Russell Bauer"
date: "4/28/2020"
output:
  pdf_document: default
  html_document:
    df_print: paged
editor_options: 
  chunk_output_type: console
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## The Big Ones

The big ones, where you’re going to make the big money with the best contracts, are really just Delta, United, American, FedEx, and UPS.  OK, let's look at what proportion of flights in NYC for the year 2013 were one of these "big ones".  "Carrier" field is the name of the airline: 

* "DL" for Delta
* "UA" for United
* "AA" for American
* "FX" for Federal Express Corporation
* "5X" for United Parcel Service

### Import Libraries

```{r libraries, echo=TRUE}
library(nycflights2013)
library(tidyverse)
```

## Including Plots

You can also embed plots, for example:

```{r pressure, echo=FALSE}
plot(pressure)
```

Note that the `echo = FALSE` parameter was added to the code chunk to prevent printing of the R code that generated the plot.

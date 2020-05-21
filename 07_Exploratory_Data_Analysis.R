library(tidyverse)

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut))

diamonds %>%
  count(cut)

ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = carat), binwidth = 0.5)

diamonds %>% 
  count(cut_width(carat, 0.5))

# Let's play with cut_interval and cut_number

diamonds %>% 
  count(cut_number(carat, 5))

diamonds %>% 
  count(cut_interval(carat, 5))

smaller <- diamonds %>% 
  filter(carat < 3)

ggplot(data = smaller, mapping = aes(x = carat)) +
  geom_histogram(binwidth = 0.1)

ggplot(data = smaller, mapping = aes(x = carat, color = cut)) +
  geom_freqpoly(binwidth = 0.1)

# 7.3.2 Typical values

ggplot(data = smaller, mapping = aes(x = carat)) +
  geom_histogram(binwidth = 0.01)

ggplot(data = faithful, mapping = aes(x = eruptions)) + 
  geom_histogram(binwidth = 0.25)

# 7.3.3 Unusual values

ggplot(diamonds) + 
  geom_histogram(mapping = aes(x = y), binwidth = 0.5)

ggplot(diamonds) + 
  geom_histogram(mapping = aes(x = y), binwidth = 0.5) +
  coord_cartesian(ylim = c(0, 50))

unusual <- diamonds %>% 
  filter(y < 3 | y > 20) %>% 
  select(price, x, y, z) %>%
  arrange(y)
unusual

# 7.3.4 Exercises

# 1. Explore the distribution of each of the x, y, and z variables in diamonds. 

ggplot(diamonds) +
  geom_histogram(mapping = aes(x = x), binwidth = 0.1) +
  coord_cartesian(xlim = c(0, 10))

ggplot(diamonds) +
  geom_histogram(mapping = aes(x = y), binwidth = 0.1) +
  coord_cartesian(xlim = c(0, 10))

ggplot(diamonds) +
  geom_histogram(mapping = aes(x = z), binwidth = 0.1) +
  coord_cartesian(xlim = c(0, 10))

mean(diamonds$x)
sd(diamonds$x)
mean(diamonds$y)
sd(diamonds$y)
mean(diamonds$z)
sd(diamonds$z)

# What do you learn? 
# x and y have about same mean and sd and so it doesn't matter which one is length
# and which one width.  z is depth.

# Think about a diamond and how you might decide which dimension is the 
# length, width, and depth.
# 
# 2. Explore the distribution of price. Do you discover anything unusual or surprising?
# (Hint: Carefully think about the binwidth and make sure you try a wide range of values.)

ggplot(diamonds) +
  geom_histogram(mapping = aes(x = price), binwidth = 100)

ggplot(diamonds) +
  geom_histogram(mapping = aes(x = price), binwidth = 100) +
  coord_cartesian(xlim = c(500, 2500))

# this zooms in on the price = $1500. There is a definite drop is number at this price.
# I do not know why this is.

# 3. How many diamonds are 0.99 carat? How many are 1 carat? 
# What do you think is the cause of the difference?

sum(diamonds$carat == 1)
sum(diamonds$carat == 0.99)

# 1 carat sounds better than saying 0.99, so a cut that is close to 1 is made full 1.

# 4. Compare and contrast coord_cartesian() vs xlim() or ylim() 
# when zooming in on a histogram. 
# What happens if you leave binwidth unset? 
# What happens if you try and zoom so only half a bar shows?
#   
ggplot(diamonds) +
  geom_histogram(mapping = aes(x = price), binwidth = 100) +
  coord_cartesian(xlim = c(500, 2500))

# above zooms in on x values from 500 to 2500

ggplot(diamonds) +
  geom_histogram(mapping = aes(x = price), binwidth = 100) 

ggplot(diamonds) +
  geom_histogram(mapping = aes(x = price), binwidth = 100) +
  coord_cartesian(ylim = c(0, 1000))

# above cuts off the y axis at 1000 - actually looks like slightly above 1000.

ggplot(diamonds) +
  geom_histogram(mapping = aes(x = price))

# without binwidth defaults to using bins - bins defaults to 30.

# 7.4 Missing values

diamonds2 <- diamonds %>% 
  filter(between(y, 3, 20))

# I like to look at the outliers

diamonds %>% filter(y < 3 | y > 20)

diamonds2 <- diamonds %>% 
  mutate(y = ifelse(y < 3 | y > 20, NA, y))

?case_when()

diamonds3 <- diamonds %>% 
  mutate(y = case_when(
    y >=3 & y <= 20 ~ y))

all_equal(diamonds2, diamonds3)

# This throws an error as NA is logical not numeric

# diamonds3 <- diamonds %>% 
#   mutate(y = case_when(
#     y < 3 | y > 20  ~ NA,
#     y >=3 & y <= 20 ~ 5))

# this gives all y NA
# if outlier assign NA
# if not than default will assign NA

# diamonds3 <- diamonds %>% 
#   mutate(y = case_when(
#   y < 3 | y > 20  ~ NA))
# 
# all_equal(diamonds2, diamonds3)

ggplot(data = diamonds2, mapping = aes(x = x, y = y)) + 
  geom_point()

ggplot(data = diamonds2, mapping = aes(x = x, y = y)) + 
  geom_point(na.rm = TRUE)

library(nycflights13)

nycflights13::flights %>% 
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + sched_min / 60
  ) %>% 
  ggplot(mapping = aes(sched_dep_time)) + 
  geom_freqpoly(mapping = aes(colour = cancelled), binwidth = 1/4)

head(flights$sched_dep_time)

flights2 <- flights %>%
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + sched_min / 60)

head(flights2$sched_dep_time)

# Above I just wanted to see how sched_dep_time is mutated.  Easy to folow code but
# I wanted to see explicitly


# 7.4.1 Exercises
# 
# 1. What happens to missing values in a histogram?

ggplot(data = diamonds2, mapping = aes(x = y)) + 
  geom_histogram()

# got warning 
# Warning message:
# Removed 9 rows containing non-finite values (stat_bin). 

?geom_histogram

# What happens to missing values in a bar chart? Why is there a difference?

ggplot(data = diamonds2, mapping = aes(x = y)) +
  geom_bar()

# got message
# Warning message:
# Removed 9 rows containing non-finite values (stat_count).  

# Doesn't say removed.  I suppose that is a category or bin?

? geom_bar

# geom_bar doesn't have binwidth.  geom_histogram does so input needs to be numeric.
# NA is not numeric.

# 2. What does na.rm = TRUE do in mean() and sum()?
  
mean(diamonds2$y)  # get NA here
mean(diamonds2$y, na.rm = TRUE) # gives mean of all non-NA values
sum(diamonds2$y) # get NA
sum(diamonds$y, na.rm = TRUE) # get sum of all non-NA values.

# 7.5 Covariation

ggplot(data = diamonds, mapping = aes(x = price)) + 
  geom_freqpoly(mapping = aes(colour = cut), binwidth = 500)

ggplot(diamonds) + 
  geom_bar(mapping = aes(x = cut))

ggplot(data = diamonds, mapping = aes(x = price, y = ..density..)) + 
  geom_freqpoly(mapping = aes(colour = cut), binwidth = 500)

ggplot(data = diamonds, mapping = aes(x = cut, y = price)) +
  geom_boxplot()

ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot()

ggplot(data = mpg) +
  geom_boxplot(mapping = aes(x = reorder(class, hwy, FUN = median), y = hwy))

ggplot(data = mpg) +
  geom_boxplot(mapping = aes(x = reorder(class, hwy, FUN = median), y = hwy)) +
  coord_flip()

# 7.5.1.1 Exercises

# 1. Use what you’ve learned to improve the visualisation of the departure times of 
# cancelled vs. non-cancelled flights.
# 
# 2. What variable in the diamonds dataset is most important for predicting the price of 
# a diamond? 
# How is that variable correlated with cut? 
# Why does the combination of those two relationships lead to lower quality diamonds 
# being more expensive?
#   
# 3. Install the ggstance package, and create a horizontal boxplot.
# How does this compare to using coord_flip()?
#   
# 4. One problem with boxplots is that they were developed in an era of much smaller 
# datasets and tend to display a prohibitively large number of “outlying values”. 
# One approach to remedy this problem is the letter value plot. 
# Install the lvplot package, and try using geom_lv() to display the distribution of 
# price vs cut. 
# What do you learn? 
# How do you interpret the plots?
#   
# 5.Compare and contrast geom_violin() with a facetted geom_histogram(), or a coloured geom_freqpoly(). What are the pros and cons of each method?
#   
# 6. If you have a small dataset, it’s sometimes useful to use geom_jitter() to see the relationship between a continuous and categorical variable. The ggbeeswarm package provides a number of methods similar to geom_jitter(). List them and briefly describe what each one does.

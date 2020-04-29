library(nycflights13)
library(tidyverse)

# 5.1.2 nycglights13
flights

# 5.2 Filter rows with filter()

jan1 <- filter(flights, month == 1, day == 1)
(dec25 <- filter(flights, month == 12, day == 25))

# 5.2.1 Comparisons

filter(flights, month == 11 | month == 12)

nov_dec <- filter(flights, month %in% c(11, 12))
# same thing with pipes
nov_dec <- flights %>% filter(month %in% c(11, 12))

filter(flights, !(arr_delay > 120 | dep_delay > 120))
filter(flights, arr_delay <= 120, dep_delay <= 120)
# both with pipes
flights %>% filter(!(arr_delay > 120 | dep_delay > 120))
flights %>% filter(arr_delay <= 120, dep_delay <= 120)

df <- tibble(x = c(1, NA, 3))

filter(df, x > 1)

filter(df, is.na(x) | x > 1)

# 5.2.4 Exercises

# Had an arrival delay of two or more hours
flights %>% filter(arr_delay >= 120)

# Flew to Houston (IAH or HOU)
flights %>% filter(dest == "IAH" | dest == "HOU")

# Were operated by United ("UA"), American ("AA"), or Delta ("DL")
flights %>% filter(carrier %in% c("UA", "AA", "DL")) %>% select("flight", "carrier")

# Departed in summer (July, August, and September)
flights %>% filter(month %in% c(7, 8, 9)) %>% select("flight", "month")

# Arrived more than two hours late, but didn’t leave late
temp <- flights %>% filter(dep_delay <= 0 & arr_delay >= 120) %>% select("flight", "dep_delay", "arr_delay")

# Were delayed by at least an hour, but made up over 30 minutes in flight
flights %>% filter(dep_delay >= 60 & arr_delay - dep_delay < -30) %>% 
  mutate(makeup = arr_delay - dep_delay) %>%
  select("flight", "dep_delay", "arr_delay", "makeup")
  
# Departed between midnight and 6am (inclusive)
flights %>% filter(dep_time <= 600) %>% select("flight", "dep_time") %>%
  print(n=15)

# 5.3 Arrange row with arronge()

arrange(flights, year, month, day) %>% select("flight", "year", "month", "day")

arrange(flights, desc(dep_delay)) %>% select("flight", "year", "month", "day", "dep_delay")

df <- tibble(x = c(5, 2, NA))
arrange(df, x)

arrange(df, desc(x))

# 5.3.1. Exercises
# How could you use arrange() to sort all missing values to the start? (Hint: use is.na()).
df %>% arrange(!is.na(x))

# Sort flights to find the most delayed flights. Find the flights that left earliest.
flights %>% arrange(desc(dep_delay), desc(arr_delay)) %>% select("flight", "dep_delay", "arr_delay")
flights %>% arrange(dep_time) %>% select("flight", "dep_time") %>% print()

# Sort flights to find the fastest (highest speed) flights.
flights %>% mutate(speed = distance / air_time * 60.0) %>% arrange(desc(speed)) %>% select("flight", "speed")

# Which flights travelled the farthest? Which travelled the shortest?
flights %>% arrange(desc(distance)) %>% select("flight", "distance")
flights %>% arrange(distance) %>% select("flight", "distance")
 
select(flights, year, month, day) 
select(flights, year:day)
select(flights, -(year:day))
rename(flights, tail_num = tailnum)
select(flights, time_hour, air_time, everything())

# 5.4.1 Exercises

# 1. Brainstorm as many ways as possible to select dep_time, dep_delay, arr_time, and arr_delay from flights.
flights %>% select(dep_time, dep_delay, arr_time, arr_delay)
flights %>% select(starts_with("dep"), starts_with("arr"))
flights %>% select(ends_with("time"), ends_with("delay")) # doesn't work since other fields end in time.
flights %>% select(-c(year, month, day, sched_dep_time, sched_arr_time, carrier,
                      flight, tailnum, origin, dest, air_time, distance, hour, minute,
                      time_hour)) # this is dumb way since more are removed than kept.
# Can't think of anything else right now.

# 2. What happens if you include the name of a variable multiple times in a select() call?
flights %>% select(dep_time, dep_time)  
nothing - just still list once.

# 3. What does the one_of() function do? Why might it be helpful in conjunction with this vector?
  
vars <- c("year", "month", "day", "dep_delay", "arr_delay")

# I don't know.  Help says it is retired in favor of all_of() and any_of()
# I don't understand what these do from documentation

# 4. Does the result of running the following code surprise you? How do the select helpers deal with case by default? How can you change that default?
  
select(flights, contains("TIME"))
# yes, because I figure it would be case sensitive.  One could use regular expression if you want that.
# But, in a way this is nice and probably more want one wants.

# 5.5 Add new variables with mutate()

flights_sml <- select(flights, 
                      year:day, 
                      ends_with("delay"), 
                      distance, 
                      air_time
)

mutate(flights_sml,
       gain = dep_delay - arr_delay,
       speed = distance / air_time * 60
)

transmute(flights,
          gain = dep_delay - arr_delay,
          hours = air_time / 60,
          gain_per_hour = gain / hours
)

transmute(flights,
          dep_time,
          hour = dep_time %/% 100,
          minute = dep_time %% 100
)

(x <- 1:10)
lag(x)
lead(x)
x
cumsum(x)
cummean(x)
y <- c(1, 2, 2, NA, 3, 4)
min_rank(y)
min_rank(desc(y))
row_number(y)
dense_rank(y)
percent_rank(y)
cume_dist(y)

# 5.5.2 Exercises
# 
# 1. Compare air_time with arr_time - dep_time. What do you expect to see? What do you see?
# What do you need to do to fix it?
flights %>% mutate(air_time_calc = arr_time - dep_time) %>% 
  select(air_time, air_time_calc, arr_time, dep_time)  
# air_time is in minutes and air_time_calc is in HHMM format. 
# so to fix it convert arr_time and dep_time to minutes after midnight
flights %>% mutate(arr_time_H = arr_time %/% 100,
                   arr_time_M = arr_time %% 100,
                   arr_time_min = arr_time_H * 60 + arr_time_M,
                   dep_time_H = dep_time %/% 100,
                   dep_time_M = dep_time %% 100,
                   dep_time_min = dep_time_H * 60 + dep_time_M,
                   air_time_calc = arr_time_min - dep_time_min
                   ) %>%
  select(air_time, arr_time,arr_time_min,
         dep_time, dep_time_min, air_time_calc)
# Do we need time zone change?  Time taxiing?

# 2. Compare dep_time, sched_dep_time, and dep_delay.
flights %>% select(dep_time, sched_dep_time, dep_delay)
# How would you expect those three numbers to be related?
# looks right: dep_time = sched_dep_time + dep_delay.  To check this have to convert to minute etc.
#   
# 3. Find the 10 most delayed flights using a ranking function.
# How do you want to handle ties? Carefully read the documentation for min_rank().
flights %>% mutate(rank = min_rank(dep_delay)) %>% select(flight, dep_delay, rank) %>%
  arrange(rank)

# 4. What does 1:3 + 1:10 return? Why?
1:3 + 1:10

# 5  What trigonometric functions does R provide?
??trigonometric

# 5.6 

by_day <- group_by(flights, year, month, day)
summarise(by_day, delay = mean(dep_delay, na.rm = TRUE))
# do same thing with pipes
flights %>% group_by(year, month, day) %>%
  summarize(delay = mean(dep_delay, na.rm = TRUE))


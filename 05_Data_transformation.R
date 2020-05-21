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
# nothing - just still list once.

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

not_cancelled %>% 
  group_by(dest) %>% 
  summarise(distance_sd = sd(distance)) %>% 
  arrange(desc(distance_sd))

# Now the book introduces pipe so now they use it too.

# 5.6.1 Conbining multiple operations with the pipe

delays <- flights %>% 
  group_by(dest) %>% 
  summarise(
    count = n(),
    dist = mean(distance, na.rm = TRUE),
    delay = mean(arr_delay, na.rm = TRUE)
  ) %>% 
  filter(count > 20, dest != "HNL")

not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay))

delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = mean(arr_delay)
  )
ggplot(data = delays, mapping = aes(x = delay)) + 
  geom_freqpoly(binwidth = 10)

by_dest <- group_by(flights, dest)
delay <- summarise(by_dest,
                   count = n(),
                   dist = mean(distance, na.rm = TRUE),
                   delay = mean(arr_delay, na.rm = TRUE)
)
delay <- filter(delay, count > 20, dest != "HNL")

# Using pipes
delays <- flights %>% 
  group_by(dest) %>% 
  summarise(
    count = n(),
    dist = mean(distance, na.rm = TRUE),
    delay = mean(arr_delay, na.rm = TRUE)
  ) %>% 
  filter(count > 20, dest != "HNL")

ggplot(data = delay, mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1/3) +
  geom_smooth(se = FALSE)

not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay))

delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = mean(arr_delay)
  )

ggplot(data = delays, mapping = aes(x = delay)) + 
  geom_freqpoly(binwidth = 10)

delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = mean(arr_delay, na.rm = TRUE),
    n = n()
  )

ggplot(data = delays, mapping = aes(x = n, y = delay)) + 
  geom_point(alpha = 1/10)

delays %>% 
  filter(n > 25) %>% 
  ggplot(mapping = aes(x = n, y = delay)) + 
  geom_point(alpha = 1/10)

# Baseball 
batting <- as_tibble(Lahman::Batting)

batters <- batting %>% 
  group_by(playerID) %>% 
  summarise(
    ba = sum(H, na.rm = TRUE) / sum(AB, na.rm = TRUE),
    ab = sum(AB, na.rm = TRUE)
  )

batters %>% 
  filter(ab > 100) %>% 
  ggplot(mapping = aes(x = ab, y = ba)) +
  geom_point() + 
  geom_smooth(se = FALSE)

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(
    avg_delay1 = mean(arr_delay),
    avg_delay2 = mean(arr_delay[arr_delay > 0]) # the average positive delay
  )

not_cancelled %>% 
  group_by(dest) %>% 
  summarise(distance_sd = sd(distance)) %>% 
  arrange(desc(distance_sd))

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(
    first = min(dep_time),
    last = max(dep_time)
  )

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(
    first_dep = first(dep_time), 
    last_dep = last(dep_time)
  )

not_cancelled %>% 
  group_by(year, month, day) %>% 
  mutate(r = min_rank(desc(dep_time))) %>% 
  filter(r %in% range(r))

not_cancelled %>% 
  group_by(dest) %>% 
  summarise(carriers = n_distinct(carrier)) %>% 
  arrange(desc(carriers))

not_cancelled %>% 
  count(dest)

not_cancelled %>% 
  count(tailnum, wt = distance)

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(n_early = sum(dep_time < 500))

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(hour_prop = mean(arr_delay > 60))

# 5.6.5 Grouping by multiple variables
daily <- group_by(flights, year, month, day)
(per_day   <- summarise(daily, flights = n()))

(per_month <- summarise(per_day, flights = sum(flights)))

(per_year  <- summarise(per_month, flights = sum(flights)))

daily %>% 
  ungroup() %>%             # no longer grouped by date
  summarise(flights = n())  # all flights


# 5.6.7 Exercises
# 1. Brainstorm at least 5 different ways to assess the typical delay characteristics 
# of a group of flights. 
# Consider the following scenarios:
# A flight is 15 minutes early 50% of the time, and 15 minutes late 50% of the time.
 
# A flight is always 10 minutes late.
 
# A flight is 30 minutes early 50% of the time, and 30 minutes late 50% of the time.
 
# 99% of the time a flight is on time. 1% of the time it’s 2 hours late.
# consistancy is important.  So problem with early 50% and late 50%.  But if smaller
# time like 15 minutes not so bad.  A flight always 10 minutes late would be the best
# of the above.  Even better than the 99% on time but 1% 2 hours late.
# Which is more important: arrival delay or departure delay?
#   
# Come up with another approach that will give you the same output as not_cancelled %>% count(dest) and not_cancelled %>% count(tailnum, wt = distance) (without using count()).
not_cancelled %>% count(dest)
# following gives same result without count
not_cancelled %>% group_by(dest) %>% summarise(n = n()) 

not_cancelled %>% count(tailnum, wt = distance)
# following gives same result without count.
not_cancelled %>% group_by(tailnum) %>% summarise(d = sum(distance))

# 3. Our definition of cancelled flights (is.na(dep_delay) | is.na(arr_delay) ) is slightly suboptimal. Why? Which is the most important column?
# if the flight is cancelled then both will be false.  but with | first is checked and 
# if false then second is also checked.  We could just check one.  arr_delay more important
# Check - dep_delay is more important - plane could had crashed. So to get cancelled 
# dep_delay

# 4. Look at the number of cancelled flights per day. Is there a pattern?
# Is the proportion of cancelled flights related to the average delay?

cancelled_per_day <- flights %>% group_by(year, month, day) %>% 
  mutate(can = (is.na(dep_delay))) %>%
  summarise(n = n(), num_can = sum(can))

ggplot(cancelled_per_day, mapping = aes(x = n, y = num_can)) +
  geom_point()

# Following copied from solutions:

cancelled_and_delays <-
  flights %>%
  mutate(cancelled = (is.na(arr_delay) | is.na(dep_delay))) %>%
  group_by(year, month, day) %>%
  summarise(
    cancelled_prop = mean(cancelled),
    avg_dep_delay = mean(dep_delay, na.rm = TRUE),
    avg_arr_delay = mean(arr_delay, na.rm = TRUE)
  ) %>%
  ungroup()

ggplot(cancelled_and_delays) +
  geom_point(aes(x = avg_dep_delay, y = cancelled_prop))

# 5. Which carrier has the worst delays? Challenge:
# can you disentangle the effects of bad airports vs. bad carriers? 
# Why/why not? (Hint: think about 
# flights %>% group_by(carrier, dest) %>% summarise(n()))

not_cancelled %>% group_by(carrier) %>% 
  mutate(delay = (sum(dep_delay) + sum(arr_delay))) %>%
  summarise(ave_delay = mean(delay)) %>%
  arrange(desc(ave_delay))

not_cancelled %>% group_by(carrier, origin, dest) %>% 
  mutate(delay = (sum(dep_delay) + sum(arr_delay))) %>%
  summarise(ave_delay = mean(delay)) %>%
  arrange(desc(ave_delay))

not_cancelled %>% group_by(carrier, dest) %>% summarise(n())

# Solutions compares carriers with same origin and dest.  
# They mentioned

# What does the sort argument to count() do. When might you use it?
#   
  
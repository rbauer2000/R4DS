library(tidyverse)

as_tibble(iris)

tibble(
  x = 1:5, 
  y = 1, 
  z = x ^ 2 + y
)

tb <- tibble(
  `:)` = "smile", 
  ` ` = "space",
  `2000` = "number"
)
tb

tribble(
  ~x, ~y, ~z,
  #--|--|----
  "a", 2, 3.6,
  "b", 1, 8.5
)

tibble(
  a = lubridate::now() + runif(1e3) * 86400,
  b = lubridate::today() + runif(1e3) * 30,
  c = 1:1e3,
  d = runif(1e3),
  e = sample(letters, 1e3, replace = TRUE)
)

nycflights13::flights %>% 
  print(n = 10, width = Inf)

package?tibble

nycflights13::flights %>% 
  View()

df <- tibble(
  x = runif(5),
  y = rnorm(5)
)

df$x
df[["x"]]
df[[1]]
df %>% .$x
df %>% .[["x"]]
df %>% .[[1]]
df %>% .[[2]]
df %>% .[[2]][[3]] # doesn't work
df[[2]][[3]]

class(as.data.frame(tb))
class(tb)

# 10.5 Exercises
# 
# 1. How can you tell if an object is a tibble? 
# (Hint: try printing mtcars, which is a regular data frame).
# 
#
# 2. Compare and contrast the following operations on a data.frame and equivalent tibble. 
# What is different? Why might the default data frame behaviours cause you frustration?

df <- data.frame(abc = 1, xyz = "a")
df$x
df[, "xyz"]
df[, c("abc", "xyz")]

tb <- tibble(abc = 1, xyz = "a")
tb$x
tb[, "xyz"]
tb[, c("abc", "xyz")]

# tb$x gave error.  df$x filled in xya and gave that column.  tibbles gives type of
# column for example <dbl> or <chr>

# 3. If you have the name of a variable stored in an object, e.g. var <- "mpg",
# how can you extract the reference variable from a tibble?

df[[var]]
# 
# 4. Practice referring to non-syntactic names in the following data frame by:
# 
#     1. Extracting the variable called 1.
# 
#     2. Plotting a scatterplot of 1 vs 2.
# 
#     3. Creating a new column called 3 which is 2 divided by 1.
# 
#     4. Renaming the columns to one, two and three.
# 
annoying <- tibble(
  `1` = 1:10,
  `2` = `1` * 2 + rnorm(length(`1`))
  )

annoying

# annoying$1 # This doesn't work

annoying[[1]]

annoying$`1`

ggplot(annoying) + geom_point(aes(x = `1`, y = `2`))

annoying <- annoying %>% mutate(`3`= `2` / `1`)

annoying <- rename(annoying, one = `1`, two = `2`, three = `3`) 

annoying

# 5. What does tibble::enframe() do? When might you use it?

# Convert vectores to data frames (tibble).
# Examples from help page

?tibble::enframe()
enframe(1:3)
enframe(c(a = 5, b = 7))
enframe(list(one = 1, two = 2:3, three = 4:6))
deframe(enframe(3:1))
deframe(tibble(a = 1:3))
deframe(tibble(a = as.list(1:3)))


# 6. What option controls how many additional column names are printed at the footer 
# of a tibble?

?print.tbl

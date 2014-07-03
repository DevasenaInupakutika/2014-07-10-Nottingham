## Iteration and flow control

### Iteration

Iteration works as in other procedural languages

- `for (var in seq) expr`
- `while (cond) expr`
- `repeat expr`

where

- `expr` is a valid R expression, contained in `{` `}` if composed by
  multiple expressions.
- `cond` is a `logical` of length, or an expression that is evaluated
  to a logical. (It is also possible to use a `numeric` of length 1,
  where 0 corresponds to `FALSE` and any other number to `TRUE`).
- `seq` is a `vector` or a `list`.
- `var` is a variable that takes the values of `seq` throughout the
  iterations and can be used in `expr`.

Examples:


```{r}
for (i in 1:3) print(i + 1)
```

```
[1] 4
[1] 5
[1] 6
```

```{r}
k<-3
while(k > 0) { print(k^2)
+     k <- k - 1  
+ }
```

```
[1] 9
[1] 4
[1] 1

```
Above `while` loop syntax can be re-written using `;` as seperator:

```{r}
k<-3
while(k>0){ print(k^2); k<-k-1 }
```

```
[1] 9
[1] 4
[1] 1

```
A common use of `for` is `for (i in 1:n)`, where `n` is the length of
a `vector` or a `list`. In such situations, it is safer to use
`seq_len(n)`:


```r
x <- numeric()
n <- length(x)

for (i in 1:n) print(i)
```

```
## [1] 1
## [1] 0
```

```r

for (i in seq_len(n)) print(i)
```

 
### Conditions

`if (cond) expr1 else expr2`, with `cond` and `expr[1|2]` as defined
above. The else clause is optional.

It is also possible to nest `else/if` conditions:

```
if (cond1) {
        do1
} else if (cond2) {
        do2
} else {
        do3
}
```

Example:

```{r}
k<-3
repeat {
+     print(k)
+     if (k == 0) 
+         break
+     k <- k - 1
+ }
```
```
[1] 3
[1] 2
[1] 1
[1] 0
```

Above code can be written as below:

```{r}
k<-3
repeat{print(k); if(k==0) break; k<-k-1}
```
```
[1] 3
[1] 2
[1] 1
[1] 0
```

### `ifelse`

The vectorised `ifelse` function takes three expressions as arguments:
`test`, `yes` and `no`. All values of the `test` expression that
evaluate to `TRUE` are replaced by the corresponding value of `yes`
(possibly repeated) or the corresponding value of `no` otherwise.

```{r}
x<-1:5
ifelse(x < 3, 1, 2)
```

```
[1] 1 1 2 2 2
```

```{r}
ifelse(x < 3, 10:15, 20:25)
```

```
[1] 10 11 22 23 24
```

```{r}
ifelse(x < 3, 10:15, -1)
```

```
[1] 10 11 -1 -1 -1
```

If `test` argument has dimensions, they will be retained in the output:

```{r}
m <- matrix(1:6, ncol = 2)
m
```
```
[,1] [,2]
[1,]    1    4
[2,]    2    5
[3,]    3    6
```

```{r}
ifelse(m < 2, m, c(10, 11, 12))
```

```
  [,1] [,2]
[1,]    1   10
[2,]   11   11
[3,]   12   12
```

### `switch`

`switch`'s first argument is an expression, followed by any number of
additional arguments.

- If the first expression is evaluated to a numeric, the corresponding
  following argument is evaluated and returned.

```{r}
switch(1+0,1,2,3)
switch(1+1,1,2,3)
```

```
[1] 1
[1] 2

```


- If the expression evaluates to a character, the matching name of the
  following arguments is evaluated and returned.


```r
switch(letters[1 + 0], a = 1, b = 2, c = 3)
switch(letters[1 + 2], a = 1, b = 2, c = 3)
```

where

```{r}
letters
 [1] "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s"
[20] "t" "u" "v" "w" "x" "y" "z"

```
Hence, *R* outputs:

```
[1] 1
[1] 3
```
See `?switch` for details about mixing named and unnamed supplementary
arguments and partial matching.

We will see another `switch` example below, in the section about
functions.

### `*apply` and friends

When one wants to apply a function over the elements/dimensions of an
object:

| function | input | output |
|----------|-------|--------|
| sapply   | list/vector  | vector |
| lapply   | list/vector  | list   |
| apply    | matrix/array | vector/matrix [*] |

[*] will actually depend on the subscripts the function will applied
over.

- Retrieve the length of each element of a `list`: `sapply` the function `length` on each element of the list.

```{r}
l <- list(1:4, letters, month.name)
sapply(l, length)
```
```
[1]  4 26 12
```

- Same as above, but returning a list.


```{r}
lapply(l, length)
```

```
[[1]]
[1] 4

[[2]]
[1] 26

[[3]]
[1] 12

```

- Lets generate 3 sequences from 1 to 3, 4, and 5: apply function
  `seq_len` along the vector `c(3, 4, 5)`, to call `seq_len(3)`,
  `seq_len(4)` and `seq_len(5)`. Below, as the output can not be
  returned as a simple vector, the output is a `list`, even when using
  `sapply`.

```{r}
lapply(c(3, 4, 5), seq_len)
sapply(c(3, 4, 5), seq_len)
```

```
> lapply(c(3, 4, 5), seq_len)
[[1]]
[1] 1 2 3

[[2]]
[1] 1 2 3 4

[[3]]
[1] 1 2 3 4 5

> help(seq_len)
> sapply(c(3, 4, 5), seq_len)
[[1]]
[1] 1 2 3

[[2]]
[1] 1 2 3 4

[[3]]
[1] 1 2 3 4 5
```


- Let's calculate the median of the rows and columns of a matrix:
  `apply` the function `median` over the rows (margin 1) and columns
  (margin 2) of `m`. Below, we generate a matrix of dimensions 6 by 5
  for 30 values sampled from a normal distribution `N(0, 1)` (see
  `?rnorm` for details).

```{r}
m <- matrix(rnorm(30), nrow = 6)
apply(m, 1, median)
apply(m, 2, median)
```

```
> m <- matrix(rnorm(30), nrow = 6)
> m
           [,1]       [,2]        [,3]       [,4]        [,5]
[1,] -2.2018684  1.6770545  0.24876071  1.0915058  0.11045387
[2,]  0.6575207 -1.6319877 -0.05396000 -0.9937107 -0.08506051
[3,]  0.6657212 -0.7088570 -0.06921994  1.3706288 -0.61537400
[4,]  0.2106825  0.4240768  1.57644723  0.2479895  1.64603645
[5,]  0.7657549 -1.9663065  0.54054186 -0.7005409  0.87205985
[6,] -1.0964438 -0.5700402  0.34767485  1.7363004  0.80191600
> apply(m,1,median)
[1]  0.24876071 -0.08506051 -0.06921994  0.42407677  0.54054186  0.34767485
> apply(m,2,median)
[1]  0.4341016 -0.6394486  0.2982178  0.6697476  0.4561849
> 
```
If we wanted to do the same thing with the `mean`, we would rather
want to use `rowMeans` and `colMeans`, which are much faster. See
later for details.

### Other `apply` functions

- `vapply`: same as `sapply`, but with pre-specified type of the
  return value.
- `mapply`: a multivariate version of `sapply` that applies a function
  `FUN` using the set of arguments passed to `apply` as function
  arguments to `FUN`.


```{r}
mapply(rep, 1:4, 4:1)
```
```
> mapply(rep,1:4,4:1)
[[1]]
[1] 1 1 1 1

[[2]]
[1] 2 2 2

[[3]]
[1] 3 3

[[4]]
[1] 4
```

- `tapply`: applies a function to each cell of a ragged array. Below,
  sums the values of `x` after sub-setting them based on grouping
  defined in `k`. (See also `by` below).


```{r}
x <- 1:12
k <- rep(letters[1:3], 4)
tapply(x, k, sum)
```

```
> x<-1:12
> k<-rep(letters[1:3],4)
> k
 [1] "a" "b" "c" "a" "b" "c" "a" "b" "c" "a" "b" "c"
> x
 [1]  1  2  3  4  5  6  7  8  9 10 11 12
> tapply(x,k,sum)
 a  b  c 
22 26 30 

```

- `rapply`: recursive version of `lapply`.

### Similar functions

- `replicate`: repeats the evaluation of an expression.
- `aggregate`: splits the data into subsets, computes summary
  statistics for each, and returns the result in a convenient form.
- `split`: splits data into groups defined by a `factor`.
- `by`: similar that `tapply` for data frames.

| to apply over | of objects | use function |
|---------------|------------|--------------|
| rows, cols    | matrices, arrays, data frames| `apply` |
| elements      | vector or list | `sapply` or `lapply`  |
| subsets defined by factors | vectors, lists, data frames | `tapply`, `by`, `split`  + `apply`, `aggregate` |

Reference:
[R Grouping functions](http://stackoverflow.com/questions/3505701/r-grouping-functions-sapply-vs-lapply-vs-apply-vs-tapply-vs-by-vs-aggrega)
on Stack Overflow.

### The `plyr` package

The [`plyr`](http://plyr.had.co.nz/) package provides its own set of
apply like functions. The `plyr` functions follows a simple naming
convention: `XYply` where `X` and `Y` describe the input and output
structures respectively, and can replaced by `a` (for an `array`), `l`
(for a `list`) or `d` (for a `data.frame`).

Good reference: [The Split-Apply-Combine Strategy for Data Analysis](http://www.jstatsoft.org/v40/i01), JSS, 40(1) pp. 1-29 (2011).

### `for` or `apply`

The `apply` family of functions are not faster than for loops as long
as initialisation is accounted for (see section on benchmaking for
details). Their main benefits are conciseness and straightforward
parallelisation (next section).

Reference: [R Help Desk article (May 2008)](http://cran.r-project.org/doc/Rnews/Rnews_2008-1.pdf)

### Parallel `apply`

- Applicable when repeating independent computations a certain number
  of times; results just need to be combined after parallel executions
  are done.
- A cluster of nodes: generate multiple workers listening to the
  master; these workers are new processes that can run on the current
  machine or a similar one with an identical R installation. Should
  work on all `R` platforms (as in package `snow`).
- The R process is forked to create new R processes by taking a
  complete copy of the masters process, including workspace (pioneered
  by package `multicore`). Does not work on Windows.
- Package `parallel`, first included in R 2.14.0 builds on CRAN
  packages `multicore` and `snow`.

The `parallel` package provides a direct parallel alternatives for
`apply` functions with `mclapply`, `mcmapply`, ... (`mutlicore`) and
`parLapply`, `parSapply`, `parApply`, ... (`snow`)

Examples:
[R-parallel](https://github.com/lgatto/R-parallel/tree/master/src)
slides.

Reference:
- `parallel` vignette: `vignette("parallel")`
- CRAN Task View: [High-Performance and Parallel Computing with R](http://cran.r-project.org/web/views/HighPerformanceComputing.html)
- Book: [Parallel R](http://shop.oreilly.com/product/0636920021421.do)
- The [`foreach`](http://cran.r-project.org/web/packages/foreach/index.html) package

<!-- ## TODO -->
<!-- - `melt`, `reshape2` -->
<!-- - `with` -->

## Writing function

Writing functions is very easy and a recommended way for code
abstraction. To create a new function, one needs to define:

1. A **name** that will be used to call the function (but see
   anonymous functions later); in the code chunk below, we call our
   function `myfun`.
2. A set of input formal **arguments**, that are defined in the
   parenthesis of the function constructor. The `myfun` example has
   two arguments, called `x` and `y`.
3. A function **body** (its code), defined between `{` and `}` below.
4. A **return** statement, that represents the output of the
   function. If no explicit return statement is provided, the last
   statement of the function is return by default.

```{r}
myfun <- function(x, y) {
    a <- x^2
    b <- sqrt(y)
    res <- a/b
    return(res)
}

```
> myfun(2,1)
[1] 4
> myfun(4,2)
[1] 11.31371

```

**Note:** that functions only support single value returns, i.e. `return(x,
y)` is an error.  To return multiple values, one needs to return a
`list` with the respective return variables like `return(list(x, y))`.


Calling `myfun(1)` would fail because argument `y` is not assigned a
value. One can assign default argument values when defining the function.


```{r}
myfun2 <- function(x, y = 2) {
    a <- x^2
    b <- sqrt(y)
    res <- a/b
    return(res)
}

myfun2(4, 2)
myfun2(4)
```


Note that the functions above are vectorised (they work with vectors
of arbitrary lengths), as their body is composed entirely if
vectorised functions.

```
> myfun(c(4, 4), c(1, 2))
[1] 16.00000 11.31371
> 
```

### A example with `switch`


```{r}
centre <- function(x, type) {
    switch(type, mean = mean(x), median = median(x), trimmed = mean(x, trim = 0.1))
}
x <- rcauchy(10)
centre(x, "mean")
centre(x, "median")
centre(x, "trimmed")
```


### The `...` argument

When an arbitrary number of arguments is to be passed to a function
(see `?cat` or `?rm` for examples) or if some arguments need to be
passed down to an inner function, one can use the special `...`
arguments.


```{r}
plot1toN <- function(n, ...) plot(1, n, ...)
```


### Anonymous functions

It is often handy to define functions on the fly, without binding them
to specific names (item 1. above missing). These are called anonymous
functions and are generally used as one-time arguments to `apply`
functions.


```{r}
m <- matrix(rnorm(12), ncol = 4)
apply(m, 1, function(x) sum(x^2))
```

### Scoping

In addition to what we have seen above, a function has also its very
own environment, in which its arguments are stored and its body is
evaluated. The functions arguments are copies of the initial
variables, so that the original ones stay unchanged.


```{r}
x <- 1
f <- function(x) {
    x <- x + 1
    return(x)
}
f(x)
```

```
## [1] 2
```

```{r}
x  ## unchanged
```

```
## [1] 1
```

A functions however can access variables defined outside of their
environment, for instance variables in the global environment.


```{r}
g <- function() {
    x <- x + 1
    return(x)
}
x <- 1
g()
```

```
## [1] 2
```

```{r}
x  ## unchanged
```


```
## [1] 1
```


In this case, if `x` does not exists


```{r}
rm(x)
g()
```

```
## Error: object 'x' not found
```


The general `R` semantic is a *pass-by-value*: it is the value of a
variable input, i.e. a copy that is manipulated and potentially
modified in the functions itself. As such, an `R` function will never
modify the global variables (unless explicitly specified). This
differs from other programming language that have a
*pass-by-reference* semantic, where it is the actual variable that is
passed as input to the function, and any manipulation and update of
the variable is persistent after the function exits.

The latter behaviour can be emulated in `R` by using
`environments`. Indeed, `environments` are not copied and modified in
place:




```{r}
myenv <- new.env()
myenv$x <- 1
updatex <- function(e, newx) assign("x", newx, envir = e)
myenv$x
updatex(myenv, 10)
myenv$x
```

```
> myenv <- new.env()
> myenv$x <- 1
> updatex <- function(e, newx) assign("x", newx, envir = e)
> myenv$x
[1] 1
> updatex(myenv, 10)
> myenv$x
[1] 10

```

This can be useful to avoid multiple copies when very large objects
are manipulated. Note however that this is an unexpected in terms of
normal behaviour.


### Exercise




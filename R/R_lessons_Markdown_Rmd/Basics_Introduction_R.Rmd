```library(knitr)
{r, echo=FALSE}
knitr::opts_chunk$set(results='hide')
```
# Nottingham Bootcamp R materials - 
--------------------------------------------------

* Its really important that you know what you did. More journals/grants/etc. are also making it important for them to know what you did.
* A lot of scientific code is NOT reproducible.
* If you keep a lab notebook, why are we not as careful with our code. 
* We edit each others manuscripts, but we don't edit each other's code. 
* If you write your code with "future you" in mind, you will save yourself and others a lot of time.

# Very basics of R

R is a versatile, open source programming/scripting language that's useful both for statistics but also data science. Inspired by the programming language S.  

* Open source software under GPL.  
* Superior (if not just comparable) to commercial alternatives. R has over 5,000 user contributed packages at this time. It's widely used both in academia and industry.  
* Available on all platforms.  
* Not just for statistics, but also general purpose programming.  
* Is object oriented and functional.  
* Large and growing community of peers.  

__Commenting__

Use `#` signs to comment. Comment liberally in your R scripts. Anything to the right of a # is ignored by R.  

__Assignment operator__

`<-` is the assignment operator. Assigns values on the right to objects on the left. Mostly similar to `=` but not always. Learn to use `<-` as it is good programming practice. Using `=` in place of `<-` can lead to issues down the line.

__Package management__

`install.packages("package-name")` will download a package from one of the CRAN mirrors assuming that a binary is available for your operating system. If you have not set a preferred CRAN mirror in your options(), then a menu will pop up asking you to choose a location.

Use `old.packages()` to list all your locally installed packages that are now out of date. `update.packages()` will update all packages in the known libraries interactively. This can take a while if you haven't done it recently. To update everything without any user intervention, use the `ask = FALSE` argument.

In RStudio, you can also do package management through Tools -> Install Packages.

Updating packages can sometimes make changes, so if you already have a lot of code in R, don't run this now. Otherwise let's just go ahead and update our packages so things are up to date.


```{r, eval=FALSE}
update.packages(ask = FALSE)
```

## Introduction to R and RStudio

Let's start by learning about our tool.  

_Point out the different windows in R._ 
* Console, Scripts, Environments, Plots
* Avoid using shortcuts. 
* Code and workflow is more reproducible if we can document everything that we do.
* Our end goal is not just to "do stuff" but to do it in a way that anyone can easily and exactly replicate our workflow and results.

## Basic Operations

R can be used as a glorified calculator. Try typing below commands directly into RStudio console. Then start typing this into the editor, and save your script. Use the run button, or press `CMD`+`Enter` (`Ctrl`+`Enter` on Windows).

You can get output from R simply by typing in math
	
```{r}
3 + 5
12/7
2 + 2
5 * 4
2^3
```

R knows order of operations:

```{r}
2 + 3 * 4/(5 + 3) * 15/2^2 + 3 * 4^2
```

or by typing words, with the command `print`

```{r}
print("hello world")
```

We can annotate our code (comment or take notes) by typing "#". Everything to the right of # is ignored by R

Try it with and without the #

```{r}
# Print out hello world
print("hello world")
```

"hello world"

```{r}
Print out hello world
print("hello world")
```

Error: unexpected symbol in "Print out"


We can save our results to an object, if we give it a name

```{r}
a     <- 60 * 60
hours <- 365 * 24
```

Now what is 'a' and 'hours'

```{r}
a 
hours 
```
## Functions

R has built-in functions.

```{r}
# Notice that this is a comment.  Anything behind a # is 'commented out' and
# is not run.

sqrt(144)
log(1000)
sum(1, 2, 3)
sqrt(2)
x <- 2
x^2

```
Get help by typing a question mark in front of the function's name, or `help(function_name)`:

```{r}
help(log)
?log
```
Note syntax highlighting when typing this into the editor. Also note how we pass *arguments* to functions. Finally, see how you can *nest* one function inside of another (here taking the square root of the log-base-10 of 1000).

```{r}
log(1000)
log(1000, base = 10)
sqrt(log(1000, base = 10))

```

## Workspace

All these variables live in your works the global environment. They can be listed with `ls()`. Variables can be deleted with `rm()`. `ls()` and `rm()` are functions that take an input (as in `rm(x)`; `ls()` is called without any explicit input values) and either return a value (`ls()` returns the names of all existing variables) or have side effects (`rm(x)` deletes the variable `x`).

```{r}
**environment()**
```
```{r}
<environment: R_GlobalEnv>
```

```{r}
ls()
```
```{r}
 [1] "a"                "dat"              "f"                "hd"              
 [5] "list1"            "list2"            "m"                "my_list"         
 [9] "rain"             "rownames_vector"  "star_wars_matrix" "w"               
[13] "x"                "xlist"            "xx"               "y"               
[17] "z"          
```

```{r}
> rm(rain)
> ls()
 [1] "a"                "dat"              "f"                "hd"              
 [5] "list1"            "list2"            "m"                "my_list"         
 [9] "rownames_vector"  "star_wars_matrix" "w"                "x"               
[13] "xlist"            "xx"               "y"                "z"    

```

## Working directory

`R` is running in a directory, called the working directory. That's
where `R` expects to find and save files. The working directory can be
queried with the `getwd()` function. It does not take any inputs
(there is nothing inside the `()` and returns the name the current
working directory).


```{r}
getwd()
```


The working directory can also be updated with
`setwd("path/to/workingdir")`, where `"path/to/workingdir"` points to
the new working directory. The working directory is typically your
current project dorectory, where input data, source code, result
files, figures, ... are stored.

It is of course possible to access and store files in other
directories by specifying the full path. 

## Packages

`R` comes with a *limited* functionality. Thousands of third-party
**packages** can be downloaded from dedicated on-line repositories
(like CRAN) and automatically installed with
`install.packages("newpackage")`. Packages are installed in specific
directories called **libraries** and can be loaded using
`library("newpackage")`.


```{r}
install.packages("devtools")
library("devtools")
```


It is of course possible to download and install packages using
`install.packages(, repos = NULL)`. However, this will force you to
handle all dependencies (and there can be many) manually too.


It is also possible to install packages from
[github](https://github.com/) using functionality from the package we
have just installed. We first need to load the package with the
`library` function to be able to use the functions that it
provides.


To see what packages are available, one can use `installed.packages()`.


```{r}
allpkgs <- installed.packages()
nrow(allpkgs)
```



```{r}
head(allpkgs)
```


## Help

`R` comes with a extensive help system. Type `help.start()` to start
the HTML version of `R`'s online documentation. Each function comes
with its dedicated manual that can be accessed using `help("rm")` or
`?rm.`. Reading the `rm` manual, we see that we can provide it with a
`list` input, i.e. *a character vector naming objects to be
removed*. Below, we generate this list of variable (object) names with
`ls()` and pass it directly as input to `rm()` to get a clean
workspace.


```{r}
ls()
```

```
## [1] "a"                "dat"              "f"                "hd"              
 [5] "list1"            "list2"            "m"                "my_list"         
 [9] "rownames_vector"  "star_wars_matrix" "w"                "x"               
[13] "xlist"            "xx"               "y"                "z"            
```

```{r}
rm(list = ls())
ls()
```

```
## character(0)
```


To get all the details about a package and its documentation:


```{r}
packageDescription("devtools")
help(package = "devtools")
```


Some packages provide an additional piece of documentation called a
`vignette`. It is generally displayed as a `pdf` file or, more
recently, as `html` pages. Vignettes are written as `LaTeX` (or
`markdown`) documents with interleaved code chunks. These are
evaluated and replaced by their output. These documents generally
present a high-level overview of the package's functionality, as
opposed to individual manual pages, that provide detailed information
about a single object.

To find out if a package has vignettes, use `vignette(package =
"packagename")`. To load a specific vignette, use
`vignette("vignettename", package = "packagename")` or
`vignette("vignettename")`.

## Session information


```{r}
sessionInfo()
```
```
> sessionInfo()
R version 3.0.2 (2013-09-25)
Platform: x86_64-apple-darwin10.8.0 (64-bit)

locale:
[1] en_GB.UTF-8/en_GB.UTF-8/en_GB.UTF-8/C/en_GB.UTF-8/en_GB.UTF-8

attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base     

loaded via a namespace (and not attached):
[1] tools_3.0.2
> 
```

```{r}
version
```
```
               _                           
platform       x86_64-apple-darwin10.8.0   
arch           x86_64                      
os             darwin10.8.0                
system         x86_64, darwin10.8.0        
status                                     
major          3                           
minor          0.2                         
year           2013                        
month          09                          
day            25                          
svn rev        63987                       
language       R                           
version.string R version 3.0.2 (2013-09-25)
nickname       Frisbee Sailing             
```

## Data types and structures

|          | dimensions  | content types |
|----------|-------------|---------------|
| `vector` | 1: `length` | 1             |
| `matrix` | 2: `dim`    | 1             |
| `array`  | n: `dim`    | 1             |
| `list`   | 1: `length` | `length()`    |
| `data.frame` | 2: `dim`| `ncol()`      |

Is the data a collection of scalars of same *type* (defined later)?
 - yes:
   - linear?
     - yes `vector`
	 - no `matrix` or `array` (if > 2 dimensions)
 - no: `list`
   - elements of same length (and generally `vectors`): `data.frame`


__Understanding basic data types in R__

To make the best of the R language, you'll need a strong understanding of the basic data types and data structures and how to operate on those.

Very Important to understand because these are the objects you will manipulate on a day-to-day basis in R. Dealing with object conversions is one of the most common sources of frustration for beginners.

Everything in R is an object.

R has 6 (although we will not discuss the raw class for this workshop) atomic classes.

* character
* numeric (real or decimal)
* integer
* logical
* complex

__Example	Type__

* “a”, “swc”	character
* 2, 15.5	numeric
* 2 (Must add a L at end to denote integer)	integer
* TRUE, FALSE	logical
* 1+4i	complex

`typeof()` - what is it?  
`length()` - how long is it? What about two dimensional objects?  
`attributes()` - does it have any metadata?  

```{r}
# Example
x <- "dataset"
typeof(x)
attributes(x)

y <- 1:10
typeof(y)
length(y)
attributes(y)

z <- c(1L, 2L, 3L)
typeof(z)
```

R has many __data structures__. These include

* atomic vector
* list
* matrix
* data frame
* factors
* tables


### Vectors

A vector is the most common and basic data structure in `R` and is pretty much the workhorse of R. Technically, vectors can be one of two types:

* atomic vectors
* lists

although the term "vector" most commonly refers to the atomic type not lists.


**Atomic Vectors**

A vector can be a vector of elements that are most commonly `character`, `logical`, `integer` or `numeric`.

You can create an empty vector with `vector()` (By default the mode is `logical`. You can be more explicit as shown in the examples below.) It is more common to use direct respective constructor functions to initialise R data structures such as  `vector()`, `matrix()`,`list()`, `character()`, `numeric()`, `data.frame()` etc.

```{r}
x <- vector()
# with a length and type
vector("character", length = 10)
character(5) ## character vector of length 5
numeric(5)
logical(5)
```

Various examples:

```{r}
x <- c(1, 2, 3)
x
length(x)
```

`x` is a numeric vector. These are the most common kind. They are numeric objects and are treated as double precision real numbers. To explicitly create integers, add an `L` at the end.

```{r}
x1 <- c(1L, 2L, 3L)
```

You can also have logical vectors. 

```{r}
y <- c(TRUE, TRUE, FALSE, FALSE)
```

Finally you can have character vectors:

```{r}
z <- c("Sarah", "Tracy", "Jon")
```

**Examine your vector**  

```{r}
typeof(z)
length(z)
class(z)
str(z)
```

Question: Do you see a property that's common to all these vectors above?

**Add elements**

```{r}
z <- c(z, "Matt")
z
```

More examples of vectors

```{r}
x <- c(0.5, 0.7)
x <- c(TRUE, FALSE)
x <- c("a", "b", "c", "d", "e")
x <- 9:100
x <- c(1+0i, 2+4i)
```

You can also create vectors as a sequence of numbers

```{r}
series <- 1:10
seq(10)
seq(1, 10, by = 0.1)
```

`Inf` is infinity. You can have either positive or negative infinity.

```{r}
1/0
```

`NaN` means Not a number. It's an undefined value.

```{r}
0/0
```

Each object can have __attributes__. Attributes can be part of an object of R. These include:

* names
* dimnames
* dim
* class
* attributes (contain metadata)
* comment

You can also glean other attribute-like information such as length (works on vectors and lists) or number of characters (for character strings).

```{r}
length(1:10)
nchar("Nottingham Bootcamp")
```

What happens when you mix types?

R will create a resulting vector that is the least common denominator. The coercion will move towards the one that's easiest to __coerce__ to.

Guess what the following do without running them first

```{r}
xx <- c(1.7, "a") 
xx <- c(TRUE, 2) 
xx <- c("a", TRUE) 
```

This is called implicit coercion. You can also coerce vectors explicitly using the `as.<class_name>`. Example

```{r}
as.numeric()
as.character()
```

## Vectorised operations


```r
x <- c(1, 2, 3)
y <- c(3, 2, 1)
x + y
```

```
## [1] 4 4 4
```

```r
x^2
```

```
## [1] 1 4 9
```

```r
sqrt(x)
```

```
## [1] 1.000 1.414 1.732
```



```r
x <- c("a", "b", "c")
paste(x, 1:3, sep = ".")
```

```
## [1] "a.1" "b.2" "c.3"
```


### Recycling


```r
x <- c(1, 2, 3, 4)
y <- c(1, 2)
x + y
```

```
## [1] 2 4 4 6
```

```r
z <- c(1, 2, 3)
x + z
```

```
## Warning: longer object length is not a multiple of shorter object length
```

```
## [1] 2 4 6 5
```



```r
x <- c(1, 2, 3, 4)
x[2:3] <- 10
x
```

```
## [1]  1 10 10  4
```



```r
x <- c("a", "b", "c")
paste(x, 1, sep = ".")
```

```
## [1] "a.1" "b.1" "c.1"
```


## Generating vectors

- `seq` and **argument matching by position and name**


```r
seq(1, 10, 2)
seq(1, 3, length = 7)
```


- `:`


```r
1:10
```


- **Exercise**: Using `rep`, how to generate 
  - 3 repetitions of 1 to 10: 1, 2, ..., 9, 10, 1, 2, ..., 9, 10, 1, 2, ..., 9, 10
  - repeating numbers 1 to 10 each 3 times: 1, 1, 1, 2, 2, 2, ..., 9, 9, 9, 10, 10, 10

- `rnorm`, `runif`, ... to draw values from specific distributions.


```r
summary(rnorm(100))
runif(10)
```


- `sample` to create permutations of vectors. 


```r
sample(LETTERS[1:5])
sample(LETTERS[1:5], 10, replace = TRUE)
```



### Matrix

Matrices are a special vector in R. They are not a separate type of object but simply an atomic vector with dimensions added on to it. Matrices have rows and columns.

```{r}
m <- matrix(nrow = 2, ncol = 2)
m
dim(m)
```

Matrices are filled column-wise.

```{r}
m <- matrix(1:6, nrow = 2, ncol = 3)
```

Other ways to construct a matrix

```{r}
m      <- 1:10
dim(m) <- c(2, 5)
```

This takes a vector and transform into a matrix with 2 rows and 5 columns.

Another way is to bind columns or rows using `cbind()` and `rbind()`.

```{r}
x <- 1:3
y <- 10:12
cbind(x, y)
rbind(x, y)
```

#### Note: 
For `rbind`, number of columns of result is not a multiple of vector length.
For `cbind`, number of rows of result is not a multiple of vector length.


You can also use the `byrow` argument to specify how the matrix is filled. From R's own documentation:

```{r}
mdat <- matrix(c(1,2,3, 11,12,13), nrow = 2, ncol = 3, byrow = TRUE,
               dimnames = list(c("row1", "row2"),
                               c("C.1", "C.2", "C.3")))
mdat
```

OR


```{r}
m <- c(1, 2, 3, 4, 5, 6)
dim(m) <- c(2, 3)  ## always rows first
m
```

```
##      [,1] [,2] [,3]
## [1,]    1    3    5
## [2,]    2    4    6
```

```{r}
class(m)  ## a matrix
```

```
## [1] "matrix"
```

```{r}
mode(m)  ## of numerics
```

```
## [1] "numeric"
```


Or, using the appropriate constructor and defining the number of columns and/or of rows:


```{r}
m <- matrix(c(1, 2, 3, 4, 5, 6), ncol = 2)
m <- matrix(c(1, 2, 3, 4, 5, 6), nrow = 3)
m <- matrix(c(1, 2, 3, 4, 5, 6), ncol = 2, nrow = 3)
```


What happens if
- the number elements does not match?
- the number of cols/rows don't match the number of elements?

Accessing/subsetting is the same as vectors, keeping in mind that we have 2 dimensions:


```{r}
m[1:2, 1:2]
m[, 2:3]
m[1, 1] <- 10
m
m[, -1]
```


Naming matrices' rows and columns


```{r}
colnames(m) <- letters[1:3]
rownames(m) <- LETTERS[1:2]
## or provideDimnames(m, base = list(letters, LETTERS))
m
m["A", "c"]
```


Dimensions can also have their own names:


```{r}
M <- matrix(c(4, 8, 5, 6, 4, 2, 1, 5, 7), nrow=3)
dimnames(M) <- list(year =
                    c(2005, 2006, 2007),
                    "mode of transport" =
                    c("plane", "bus", "boat"))
```


## Simplification/dropping of dimensions


```{r}
m[-1, ]  ## becomes a vector
m[-1, , drop = FALSE]  ## remains a matrix
m[, -(1:2)]  ## becomes a vector
m[, -(1:2), drop = FALSE]  ## remains a matrix
```

In `R`, there is no such thing as a columns/row vector:


```{r}
x <- 1:6
t(x)  ## becomes a matrix
dim(t(x))
dim(t(t(x)))
```


## Array

Like a matrix with > 2 dimensions. 


```{r}
x <- 1:30
dim(x) <- c(5, 3, 2)
## or array(1:30, dim = c(5, 3, 2))
x
```

### List

In R lists act as containers. Unlike atomic vectors, the contents of a list are not restricted to a single mode and can encompass any mixture of data types. Lists are sometimes called recursive vectors, because a list can contain other lists. This makes them fundamentally different from atomic vectors.

A list is a special type of vector. Each element can be a different type.

Create lists using `list()` or coerce other objects using `as.list()`

```{r}
x <- list(1, "a", TRUE, 1+4i)
x

x <- 1:10
x <- as.list(x)
length(x)
```

1. What is the class of `x[1]`?
2. How about `x[[1]]`?

```{r}
xlist <- list(a = "Nottingham Bootcamp", b = 1:10, data = head(iris))
xlist
```

1. What is the length of this object? What about its structure?

Lists can be extremely useful inside functions. You can “staple” together lots of different kinds of results into a single object that a function can return.

A list does not print to the console like a vector. Instead, each element of the list starts on a new line.

Elements are indexed by double brackets. Single brackets will still return a(nother) list.

### Difference between `[` and `[[`

The former returns a sub-set of the list, the latter an individual elements


```{r}
class(xlist[2])
class(xlist[[2]])
```


Hence


```{r}
class(xlist[2:3])
class(xlist[[2:3]])
```


### Vector modes: numerics, character, logical, factor

Vectors are of one unique type:

          | mode | class  | typeof |
----------|------|--------|--------| 
character | character | character | character |
logical   | logical | logical | logical |
numeric   | numeric | integer or numeric | integer of double | 
factor    | numeric | factor | integer | 



```r
typeof(c(1, 10, 1))
typeof(c(1L, 10L, 1L))
typeof(c(1L, 10, 1))
typeof(letters)
typeof(c(TRUE, FALSE))  ## TRUE and FALSE are reserved words
```

### Factors

Factors are special vectors that represent categorical data. Factors can be ordered or unordered and are important for modelling functions such as `lm()` and `glm()` and also in `plot` methods.

Factors can only contain pre-defined values.

Factors are pretty much integers that have labels on them. While factors look (and often behave) like character vectors, they are actually integers under the hood, and you need to be careful when treating them like strings. Some string methods will coerce factors to strings, while others will throw an error.

Sometimes factors can be left unordered. Example: male, female.

Other times you might want factors to be ordered (or ranked). Example: low, medium, high.

Underlying it's represented by numbers 1, 2, 3.

They are better than using simple integer labels because factors are what are called self describing. male and female is more descriptive than 1s and 2s. Helpful when there is no additional metadata.

Which is male? 1 or 2? You wouldn't be able to tell with just integer data. Factors have this information built in.

Factors can be created with `factor()`. Input is generally a character vector.

```{r}
x <- factor(c("yes", "no", "no", "yes", "yes"))
x
```

`table(x)` will return a frequency table.

If you need to convert a factor to a character vector, simply use

```{r}
as.character(x)
```

In modelling functions, it is important to know what the baseline level is. This is the first factor but by default the ordering is determined by alphabetical order of words entered. You can change this by specifying the levels (another option is to use the function level).

```{r}
x <- factor(c("yes", "no", "yes"), levels = c("yes", "no"))
x
```

### Data frame

A data frame is a very important data type in R. It's pretty much the de facto data structure for most tabular data and what we use for statistics.

Data frames can have additional attributes such as `rownames()`, which can be useful for annotating data, like subject_id or sample_id. But most of the time they are not used.

Some additional information on data frames:

* Usually created by `read.csv()` and `read.table()`.
* Can convert to matrix with `data.matrix()`
* Coercion will be forced and not always what you expect.
* Can also create with `data.frame()` function.
* Find the number of rows and columns with `nrow(dat)` and `ncol(dat)`, respectively.
* Rownames are usually 1..n.

## __Combining data frames__

```{r}
dat <- data.frame(id = letters[1:10], x = 1:10, y = 11:20)
dat
```

### __Useful functions__

* `head()` - see first 6 rows
* `tail()` - see last 6 rows
* `dim()` - see dimensions
* `nrow()` - number of rows
* `ncol()` - number of columns
* `str()` - structure of each column
* `names()` - will list the names attribute for a data frame (or any object really), which gives the column names.
* A data frame is a special type of list where every element of the list has same length.

See that it is actually a special list:

```{r}
is.list(iris)
class(iris)
```

| Dimensions | Homogenous | Heterogeneous |
| ------- | ---- | ---- |
| 1-D | atomic vector | list |
| 2_D | matrix | data frame |

Later on we'll go over how we load our own data, but for now, let's use a built-in data frame called `mtcars`. This data was extracted from the 1974 Motor Trend US magazine, and comprises fuel consumption and 10 aspects of automobile design and performance for 32 automobiles (1973–74 models). We can load this built-in data with `data(mtcars)`. By the way, running `data()` without any arguments will list all the available built-in datasets included with R.

Let's load the data first. Type the name of the object itself (`mtcars`) to view the entire data frame. *Note: doing this with large data frames can cause you trouble.*


```r
data(mtcars)
class(mtcars)
mtcars
```

There are several built-in functions that are useful for working with data frames.
* `head()` prints the first few lines of a large data frame.
* `length()` tells you the number of features (variables, columns) in a data frame.
* `dim()` returns a two-element vector containing the number of rows and the number of columns in a data frame.
* `str()` displays the structure of a data frame, printing out details and a preview of every column.
* `summary()` works differently depending on what kind of object you pass to it. Passing a data frame to the `summary()` function prints out some summary statistics about each column (min, max, median, mean, etc.)


```r
head(mtcars)
length(mtcars)
dim(mtcars)
dim(mtcars)[1]  # number of rows (individual cars in the survey)
dim(mtcars)[2]  # number of columns (number of variables measured)
str(mtcars)
```

We can access individual variables within a data frame using the `$` operator, e.g., `mydataframe$specificVariable`. Let's print out the number of cylinders for every car, and calculate the average miles per gallon for ever car in the dataset (using the built-in `mean()` function).


```r
# display the number of cylinders for each car.
mtcars$cyl
# first display MPG for all vehicles, then calculate the average.
mtcars$mpg
mean(mtcars$mpg)
```

We can also access certain rows or columns of a dataset by providing multiple indices using the syntax `mydataframe[rows, columns]`. Let's get the first 4 rows and the first two rows (MPG and # cylinders) from the dataset:


```r
head(mtcars)
mtcars[1:4, 1:2]
```

We can also use the `subset()` function to return a subset of the data frame that meets a specific condition. The first argument is the data frame you want to subset. The second argument is a condition you must satisfy. If you want to satisfy *all* of multiple conditions, you can use the "and" operator, `&`. The "or" operator `|` (the pipe character, usually shift-backslash) will return a subset that meet *any* of the conditions.

The commands below will:

0. Return only cars with 6 cylinder engines.
0. Return only cars with greater than 6 cylinders.
0. Return only the cars that get at least 20 miles per gallon or have a displacement volume of less than 100cc.
0. Return cars with 6 cylinder engines, but using the `select=` argument, only the MPG and displacement columns. Note the syntax there -- we're passing a vector of variables created with the `c()` function to the `select=` argument, which only returns certain columns.
0. Return cars that have greater than or equal to 6 cylinders *and* get at least 15 miles per gallon, but display only the MPG, cylinders, and qsec columns (qsec is the 1/4 mile time).

Try some subsetting on your own.


```r
subset(mtcars, cyl == 6)
subset(mtcars, cyl > 6)
subset(mtcars, mpg >= 20 | disp < 100)
subset(mtcars, cyl == 6, select = c(mpg, disp))
subset(mtcars, cyl >= 6 & mpg >= 15, select = c(mpg, cyl, qsec))
```

The `with()` function is particularly helpful. Let's say you wanted to compute some (senseless) value by computing the MPG times the number of cylinders divided by the car's displacement. You could access the dataset's variables using the `$` notation, or you could use `with()` to temporarily *attach* the data frame, and call the variables directly. The first argument to `with()` is the name of the data frame, and the second argument is all the stuff you'd like to do with the particular features in that data frame.

Try typing the following commands:


```r
# Display the number of cylinders.
mtcars$cyl
with(mtcars, cyl)

# Compute the senseless value described above. Both return the same results.
mtcars$mpg * mtcars$cyl/mtcars$disp
with(mtcars, mpg * cyl/disp)
```

### Data Frames Example

Generate a `data.frame` of patient data, including their first names,
surnames, age, gender, weights and whether they give consent for their
data to be made public.


```{r}
age <- c(50, 21, 35, 45, 28,
         31, 42, 33, 57, 62)
weight <- c(70.8, 67.9, 75.3, 61.9, 72.4,
            69.9, 63.5, 71.5, 73.2, 64.8)
firstName <- c("Adam", "Eve", "John", "Mary",
               "Peter", "Paul", "Joanna", "Matthew",
               "David", "Sally")
secondName <- c("Jones", "Parker", "Evans",
                "Davis", "Baker", "Daniels",
                "Edwards", "Smith", "Roberts", "Wilson")
consent <- c(TRUE, TRUE, FALSE, TRUE, FALSE,
             FALSE, FALSE, TRUE, FALSE, TRUE)
gender <- c("Male", "Female", "Male", "Female",
            "Male", "Male", "Female", "Male",
            "Male", "Female")
patients <- data.frame(firstName, secondName,
                       gender = factor(gender),
                       age, weight, consent,
                       stringsAsFactors=FALSE)
rm(age, consent, firstName, gender, secondName, weight)
```


By default, `character`s are converted to `factor`s when generating
`data.frame`s; use `stringsAsFactors = FALSE` to keep the `characters`
as is and convert to `factor`s explicitly.

Extract subsets of interest: patients that have given consent, male
patients, males that have given consent, those that are below the
average weight, order the `data.frame` by patient age, ...


```{r}
patients[patients$consent, ]
patients[patients$gender == "Male", ]
patients[patients$gender == "Male" & patients$consent, ]
```



```{r}
avgw<- mean(patients$weight)
patients[patients$weight < avgw, ]
```



```{r}
patients[order(patients$age), ]
```

### __Indexing__

Vectors have positions, these positions are ordered and can be called using name_vector[index]

```{r}
letters[2]
```



### __Functions__

A function is a saved object that takes inputs to perform a task. 
Functions take in information and return desired outputs.

output = name_of_function(inputs)

```{r}
x <- 1:10
y <- sum(x)
```

### __Help__

All functions come with a help screen. 
It is critical that you learn to read the help screens since they provide important information on what the function does, 
how it works, and usually sample examples at the very bottom.

###  Environments

An `environment` is and un-ordered collection of symbols, or
associative arrays. They are implemented as hash tables.


```{r}
e <- new.env()
e
```

```
## <environment: 0x7fc42c53acd0>
```

```{r}
e$a <- 1
e$a
```

```
## [1] 1
```

```{r}
ls()  ## list content of global environment
```

```
[1] "a"                "dat"              "e"                "f"               
 [5] "hd"               "list1"            "list2"            "m"               
 [9] "my_list"          "rownames_vector"  "star_wars_matrix" "w"               
[13] "x"                "xlist"            "xx"               "y"               
[17] "z"            
```

```{r}
ls(e)  ## list content of e
```

```
## [1] "a"
```

```{r}
a <- 10  ## a different variable a
e$a
```

```
## [1] 1
```

```{r}
e[["a"]]
```

```
## [1] 1
```


Values from specific environments can also be retrieved with `get` or
`mget` for multiple values or assigned with `assign`.

Environments can also be locked with `lockEnvrionment`, to avoid
assignment of new variables and update of existing variables can be
locked with `lockBindings`. 


```{r}
lockEnvironment(e)
e$b <- 10
```

```
## Error: cannot add bindings to a locked environment
```

```{r}
e$a <- 10
lockBinding("a", e)
e$a <- 100
```

```
## Error: cannot change value of locked binding for 'a'
```


You can't ever learn all of R, but you can learn how to build a program and how to find help
to do the things that you want to do. Let's get hands-on.
	
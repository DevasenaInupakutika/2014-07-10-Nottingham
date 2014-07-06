## Introduction

Packages allow for easy, transparent and cross-platform extension of the R base system. R packages are a convenient way to maintain collections of R functions and data sets.
As an article distributes scientific ideas to others, a package distributes statistical methodology to others. Most users first see the packages of functions distributed with R or from CRAN. The package system allows many more people to contribute to R while still enforcing some standards. But packages are also a convenient way to maintain private functions and share them with your colleagues.

This provides a transparent way of sharing code with co-workers, and the final transition from ‚Äúplayground‚Äù to production code is much easier.

Packages can be dynamically loaded and unloaded on runtime and hence only occupy memory when actually used. Installations and updates are fully automated and can be executed from inside or outside R.

And last but not least the packaging system has tools for software validation which check that documentation exists and is technically in sync with the code, spot common errors, and check that examples actually run.

**Package:** An extension of the R base system with code, data and documentation in standardized format.

**Library:** A directory containing installed packages.

In this session, we implement a function for linear regression models. We first define classes and methods for the statistical model, including a formula interface for model specification. We then structure the pieces into the form of an R package, show how to document the code properly and finally discuss the tools for package validation and distribution.


** R code for linear regression **

As running example in this tutorial we will develop R code for the standard linear regression model

y = x‚Ä≤Œ≤ + Œµ, Œµ ‚àº N(0, œÉ2)

Our goal is not to implement all the bells and whistles of the standard R function lm() for the problem, but to write a simple function which computes the OLS estimate and has a ‚Äúprofessional look and feel‚Äù in the sense that the interface is similar to the interface of lm().

If we are given a design matrix X and response vector y then the OLS estimate is of course 

Œ≤ÀÜ = (X‚Ä≤X)‚àí1X‚Ä≤y

with covariance matrix

var(Œ≤ÀÜ) = œÉ2(X‚Ä≤X)‚àí1

For numerical reasons it is not advisable to compute Œ≤ÀÜ using the above formula, it is better to use, e.g., a QR decomposition or any other numerically good way to solve a linear system of equations (e.g., Gentle 1998). Hence, a minimal R function for linear regression is:

```{r}
linmodEst<-function(x,y){qx<-qr(x); 
coef<-solve.qr(qx,y);
df<-nrow(x)-ncol(x);
sigma2<-sum((y-x%*%coef)^2)/df; 
vcov<-sigma2*chol2inv(qx$qr); 
colnames(vcov)<-rownames(vcov)<-colnames(x); 
list(coefficients=coef,vcov=vcov,sigma=sqrt(sigma2),df=df)}

```
If we use this function to predict heart weight from body weight in the classic Fisher cats data from package `MASS`, we get:

```{r}
data(cats, package="MASS")
linmodEst(cbind(1, cats$Bwt), cats$Hwt)
```

```
coefficients
[1] -0.3566624  4.0340627

$vcov
           [,1]        [,2]
[1,]  0.4792475 -0.17058197
[2,] -0.1705820  0.06263081

$sigma
[1] 1.452373

$df
[1] 142
```

The standard **R** function for linear models:

```{r}
lm1 <- lm(Hwt~Bwt, data=cats)
lm1
```
```
Call:
lm(formula = Hwt ~ Bwt, data = cats)

Coefficients:
(Intercept)          Bwt  
    -0.3567       4.0341  
```

```{r}
vcov(lm1)
```
```
           (Intercept)         Bwt
(Intercept)   0.4792475 -0.17058197
Bwt          -0.1705820  0.06263081
```

The numerical estimates are exactly the same, but our code lacks convenient user interface:

- Prettier formatting of results
- Add utilities for fitted model like a summary() function to test for significance of parameters.
- Handle categorical predictors.
- Use formulas for model specification.

Object oriented programming helps us with issues 1 and 2, formulas with 3 and 4.

### Object Oriented Programming in R

S3 system of classes and methods already work in **R**. There is checking done as part of package quality control in R, we will discuss this in **R CMD check** later in this session.

### Classes and methods for linear regression

We will now define classes and methods for our linear regression example. Because we want to write a formula interface we make our main function `linmod()` generic, and write a default method where the first argument is a design matrix (or something which can be converted to a matrix). Later-on we will add a second method where the first argument is a formula.

A generic function is a standard R function with a special body, usually containing only a call to *UseMethod*:

```
linmod <- function(x, ...) UseMethod("linmod")

```
To add a default method, we define a function called `linmod.default()`:

```
linmod.default <- function(x, y, ...)
{
    x <- as.matrix(x)
    y <- as.numeric(y)
    est <- linmodEst(x, y)
    est$fitted.values <- as.vector(x %*% est$coefficients)
    est$residuals <- y - est$fitted.values
    est$call <- match.call()
    class(est) <- "linmod"
    est 
}

```

This method tries to convert its first argument `x` to a matrix, `as.matrix()` will throw an error of the conversion is not successful, similarly for the conversion of `y` to a
numeric vector.

We then call our function for parameter estimation, and add fitted values, residuals and the function call to the results. Finally we set the class of the return object to `linmod`.

Defining the `print()` method for our class as:

```
print.linmod <- function(x, ...)
{
    cat("Call:\n")
    print(x$call)
    cat("\nCoefficients:\n")
    print(x$coefficients)
}

```
makes it almost look like the real thing:

```{r}
x = cbind(Const=1, Bwt=cats$Bwt)
y = cats$Hw
mod1 <- linmod(x, y)
mod1
```
```
linmod.default(x = x, y = y)
Coefficients:
     Const        Bwt
-0.3566624  4.0340627
```

Note that we have used the standard names "coefficients", "fitted.values" and "residuals" for the elements of our class "linmod". As a bonus on the side we get methods for several standard generic functions for free, because their default methods work for our class:

```{r}
coef(mod1)
fitted(mod1)
resid(mod1)
```

```
   Const        Bwt
-0.3566624  4.0340627

[1] 7.711463 7.711463 7.711463 8.114869 8.114869 8.114869 ...

[1] -0.7114630 -0.3114630  1.7885370 -0.9148692 -0.8148692 ...
```
The notion of functions returning an object of a certain class is used extensively by the mod- elling functions of S. In many statistical packages you have to specify a lot of options controlling what type of output you want/need. In S you first fit the model and then have a set of methods to investigate the results (summary tables, plots, ...). The parameter estimates of a statistical model are typically summarized using a matrix with 4 columns: estimate, standard deviation, z (or t or . . . ) score and p-value. The summary method computes this matrix:

```{r}
summary.linmod <- function(object, ...){    se <- sqrt(diag(object$vcov))    tval <- coef(object) / se    TAB <- cbind(Estimate = coef(object),                 StdErr = se,                 t.value = tval,                 p.value = 2*pt(-abs(tval), df=object$df))    res <- list(call=object$call,                coefficients=TAB)    class(res) <- "summary.linmod"    res 
}
```
The utility function `printCoefmat()` can be used to print the matrix with appropriate rounding and some decoration:

```{r}
print.summary.linmod <- function(x, ...){    cat("Call:\n")    print(x$call)    cat("\n")    printCoefmat(x$coefficients, P.value=TRUE, has.Pvalue=TRUE)}
```
The result is:
```{r}
summary(mod1)
```
```
Call:linmod.default(x = x, y = y)      Estimate   StdErr t.value p.valueConst -0.35666  0.69228 -0.5152  0.6072
Bwt    4.03406  0.25026 16.1194  <2e-16 ***---Signif. codes:  0 *** 0.001 ** 0.01 * 0.05 . 0.1   1

```
Separating computation and screen output has the advantage, that we can use all values if needed for later computations. E.g., to obtain the p-values we can use

```{r}
coef(summary(mod1))[,4]
```
```
       Const          Bwt6.072131e-01 6.969045e-34
```

### S Formulas

The unifying interface for selecting variables from a data frame for a plot, test or model are S formulas. The most common formula is of type:

`y ~ x1+x2+x3`

The central object that is usually created first from a formula is the:

**model.frame**, a data frame containing only the variables appearing in the formula, together with an interpretation of the formula in the **terms** attribute. It tells us whether there is a response variable (always the first column of the model.frame), an intercept, . . .
The model.frame is then used to build the design matrix for the model and get the response. Our code shows the simplest handling of formulas, which however is already sufficient for many applications (and much better than no formula interface at all):

```{r}
linmod.formula <- function(formula, data=list(), ...){    mf <- model.frame(formula=formula, data=data)    x <- model.matrix(attr(mf, "terms"), data=mf)    y <- model.response(mf)    est <- linmod.default(x, y, ...)    est$call <- match.call()    est$formula <- formula    est}
```
The above function is an example for the most common exception to the rule that all methods should have the same arguments as the generic and in the same order. By convention formula methods have arguments formula and data (rather than x and y), hence there is at least a difference in names of the first argument: x in the generic, formula in the formula method. This exception is hard-coded in the quality control tools of `R CMD check` described below.The few lines of R code above give our model access to the wide variety of design matrices S formulas allow us to specify. E.g., to fit a model with main effects and an interaction term for body weight and sex we can use:

```{r}
summary(linmod(Hwt~Bwt*Sex, data=cats))
```
```
Call:linmod.formula(formula = Hwt ~ Bwt * Sex, data = cats)            Estimate   StdErr t.value   p.value(Intercept)  2.98131  1.84284  1.6178 0.1079605

Bwt		 2.63641   0.77590  3.3979 0.0008846 ***SexM        -4.16540  2.06176 -2.0203 0.0452578 *Bwt:SexM  1.67626  0.83733  2.0019 0.0472246 *---Signif. codes:  0 *** 0.001 ** 0.01 * 0.05 . 0.1   1       
The last missing methods most statistical models in S have are a `plot()` and `predict()` method. For the latter a simple solution could be:

```{r}
predict.linmod <- function(object, newdata=NULL, ...){    if(is.null(newdata))      y <- fitted(object)    else{        if(!is.null(object$formula)){            ## model has been fitted using formula interface            x <- model.matrix(object$formula, newdata)        }        else{            x <- newdata}        y <- as.vector(x %*% coef(object))    }y 
}

```
which works for models fitted with either the default method (in which case newdata is assumed to be a matrix with the same columns as the original x matrix), or for models fitted using the formula method (in which case newdata will be a data frame). Note that model.matrix() can also be used directly on a formula and a data frame rather than first creating a model.frame.The formula handling in our small example is rather minimalistic, production code usually handles much more cases. We did not bother to think about treatment of missing values, weights, offsets, subsetting etc. To get an idea of more elaborate code for handling formulas, one can look at the beginning of function lm() in R.

## R Packages

Now that we have code that does useful things and has a nice user interface, we may want to share our code with other people, or simply make it easier to use ourselves. There are two popular ways of starting a new package:

- Load all functions and data sets you want in the package into a clean R session, and run `package.skeleton()`. The objects are sorted into data and functions, skeleton help files are created for them using prompt() and a *DESCRIPTION* file is created. The function then prints out a list of things for you to do next.

- Create it manually, which is usually faster for experienced developers.

### Structure of a package

The extracted sources of an R package are simply a directory somewhere on your hard drive. The directory has the same name as the package and the following contents (all of which are described in more detail below):

- A file named DESCRIPTION with descriptions of the package, author, and license conditions in a structured text format that is readable by computers and by people.

- A man/ subdirectory of documentation files.

- An R/ subdirectory of R code.

- A data/ subdirectory of datasets.

Less commonly it contains:

- A src/ subdirectory of C, Fortran or C++ source.

- tests/ for validation tests.

- exec/ for other executables (eg Perl or Java).

- inst/ for miscellaneous other stuff. The contents of this directory are completely copied to the installed version of a package.

- A configure script to check for other required software or handle differences between systems.

All but the DESCRIPTION file are optional, though any useful package will have man/ and at least one of R/ and data/. Note that capitalisation of the names of files and directories is important, R is case-sensitive as are most operating systems (except Windows).

### Starting a package for linear regression

To start a package for our R code all we have to do is run function `package.skeleton()` and pass it the name of the package we want to create plus a list of all source code files. If no source files are given, the function will use all objects available in the user workspace. Assuming that all functions defined above are collected in a file called `linmod.R`, the corresponding call is:

```{r}

package.skeleton(name="linmod", code_files="linmod.R")
```
```
Creating directories ...Creating DESCRIPTION ...Creating Read-and-delete-me ...Copying code files ...Making help files ...Done.Further steps are described in ’./linmod/Read-and-delete-me’.
```

which already tells us what to do next. It created a directory called "linmod" in the current working directory. R also created subdirectories man and R, copied the R code into subdirectory R and created stumps for help file for all functions in the code.

File `Read-and-delete-me` contains further instructions:

- Edit the help file skeletons in ’man’, possibly combining help files for multiple functions.- Put any C/C++/Fortran code in ’src’.- If you have compiled code, add a `First.lib()` function in `R` to load the shared library.- Run `R CMD build` to build the package tarball.- Run `R CMD check` to check the package tarball.

Read `Writing R Extensions` for more information.

We do not have any C or Fortran code, so we can forget about items 2 and 3. The code is already in place, so all we need to do is edit the `DESCRIPTION` file and write some help pages.

### The package `DESCRIPTION` file

An appropriate `DESCRIPTION` for our package is:

```
Package: linmodTitle: Linear RegressionVersion: 1.0Date: 2014-07-06Author: Devasena InupakutikaMaintainer: Devasena <di1c13@ecs.soton.ac.uk>Description: This is a demo package for the tutorial "Creating R  Packages" to Ecologists at University of Nottingham.Suggests: MASSLicense: GPL-2
```

The file is in so called Debian-control-file format, which was invented by the Debian Linux distribution (http://www.debian.org) to describe their package. Entries are of form`Keyword: Value`

with the keyword always starting in the first column, continuation lines start with one ore more space characters. The Package, Version, License, Description, Title, Author, and Maintainer fields are mandatory, the remaining fields (Date, Suggests, ...) are optional.The Package and Version fields give the name and the version of the package, respectively. The name should consist of letters, numbers, and the dot character and start with a letter. The version is a sequence of at least two (and usually three) non-negative integers separated by single dots or dashes.The Title should be no more than 65 characters, because it will be used in various package listings with one line per package. The Author field can contain any number of authors in free text format, the Maintainer field should contain only one name plus a valid email address (similar to the “corresponding author” of a paper). The Description field can be of arbitrary length. The Suggests field in our example means that some code in our package uses functionality from package MASS, in our case we will use the cats data in the example section of help pages. A stronger form of dependency can be specified in the optional Depends field listing packages which are necessary to run our code.The License can be free text, if you submit the package to CRAN or Bioconductor and use a standard license, we strongly prefer that you use a standardised abbreviation like GPL-2 which stands for “GNU General Public License Version 2”. A list of license abbreviations R understands is given in the manual “Writing R Extensions” (R Development Core Team 2008b). The manual also contains the full documentation for all possible fields in package DESCRIPTION files. The above is only a minimal example, much more meta-information about a package as well as technical details for package installation can be stated.

<script type="text/javascript" 
        src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
    </script>
    <script type="text/javascript">MathJax.Hub.Config({tex2jax: {processEscapes: true, 
        processEnvironments: false, inlineMath: [ ['$','$'] ], 
        displayMath: [ ['$$','$$'] ] }, 
        asciimath2jax: {delimiters: [ ['$','$'] ] }, 
        "HTML-CSS": {minScaleAdjust: 125 } });
    </script>



```{r}
library("parallel")

n <- 10000
f1 <- function(n) {
    l <- list()
    for (i in seq_len(n)) l[[i]] <- seq(i)
    return(l)
}

f2 <- function(n) {
    l <- vector("list", length = n)
    for (i in seq_len(n)) l[[i]] <- seq(i)
    return(l)
}

f3 <- function(n) lapply(seq_len(n), seq)


f4 <- function(n, nc = 2L) mclapply(seq_len(n), seq, mc.cores = nc)

library("rbenchmark")
benchmark(f1(n), f2(n), f3(n), f4(n), columns = c("test", "replications", "elapsed", 
    "relative"), replications = 10)

```

```
test replications elapsed relative
1 f1(n)           10   4.521    2.967
2 f2(n)           10   1.524    1.000
3 f3(n)           10   3.757    2.465
4 f4(n)           10  25.641   16.825
```

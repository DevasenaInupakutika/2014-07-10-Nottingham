```
> slidingwindowplot <- function(windowsize, inputseq)
{
   starts <- seq(1, length(inputseq)-windowsize, by = windowsize)
   n <- length(starts)    # Find the length of the vector "starts"
   chunkGCs <- numeric(n) # Make a vector of the same length as vector "starts", but just containing zeroes
   for (i in 1:n) {
        chunk <- inputseq[starts[i]:(starts[i]+windowsize-1)]
        chunkGC <- GC(chunk)
        print(chunkGC)
        chunkGCs[i] <- chunkGC
   }
   plot(starts,chunkGCs,type="b",xlab="Nucleotide start position",ylab="GC content")
}

```
This function will make a sliding window plot of GC content for a particular input sequence inputseq specified by the user, using a particular windowsize windowsize specified by the user. Once you have typed in this function once, you can use it again and again to make sliding window plots of GC contents for different input DNA sequences, with different windowsizes. For example, you could create two different sliding window plots of the DEN-1 Dengue virus genome sequence, using windowsizes of 3000 and 300 nucleotides, respectively:

```
slidingwindowplot(3000, dengueseq)

```

```
[1] 0.4646667
[1] 0.4606667
[1] 0.4653333
```

![plot for chunk Challenges.md-2] (figures/Rplot26.png)


And

```
slidingwindowplot(300, dengueseq)
```

```
[1] 0.4366667
[1] 0.4766667
[1] 0.5
[1] 0.5066667
[1] 0.4466667
[1] 0.4333333
[1] 0.4466667
[1] 0.4866667
[1] 0.4633333
[1] 0.45
[1] 0.44
[1] 0.4633333
[1] 0.4433333
[1] 0.4
[1] 0.4766667
[1] 0.49
[1] 0.4733333
[1] 0.4666667
[1] 0.4666667
[1] 0.4866667
[1] 0.4966667
[1] 0.48
[1] 0.49
[1] 0.49
[1] 0.4633333
[1] 0.46
[1] 0.4633333
[1] 0.42
[1] 0.4466667
[1] 0.4433333
[1] 0.4466667
[1] 0.4733333
[1] 0.4733333
[1] 0.4966667
[1] 0.4833333

```
![plot of chunk Challenges.md-3] (figures/Rplot27.png)

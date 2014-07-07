```
> starts <- seq(1, length(dengueseq)-2000, by = 2000)
> n <- length(starts)    # Find the length of the vector "starts"
> chunkGCs <- numeric(n) # Make a vector of the same length as vector "starts", but just containing zeroes
> for (i in 1:n) {
        chunk <- dengueseq[starts[i]:(starts[i]+1999)]
        chunkGC <- GC(chunk)
        print(chunkGC)
        chunkGCs[i] <- chunkGC
     }
> plot(starts,chunkGCs,type="b",xlab="Nucleotide start position",ylab="GC content")
```

![plot for chunk Challenges.md-1] (figures/Rplot25.png)

In the code above, the line “chunkGCs <- numeric(n)” makes a new vector chunkGCs which has the same number of elements as the vector starts (5 elements here). This vector chunkGCs is then used within the for loop for storing the GC content of each chunk of DNA.

After the loop, the vector starts can be plotted against the vector chunkGCs using the plot() function, to get a plot of GC content against nucleotide position in the genome sequence. This is a sliding window plot of GC content.


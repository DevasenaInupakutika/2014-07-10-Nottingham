## Looping and Plotting Exercise

#### Ex1:

Look up the help for the function **sum**. Add up all the numbers from 1 to 100 in two different ways: using **for** and using **sum**.

[Solution] (sum_sol.md)

#### Ex2:

Download Biological Sequences Retrieval and Analysis package called `seqinr` using `install.packages("seqinr")`.

Here we'll be retrieving, reading, analyzing and visualizing genome sequence data using `seqinr`.

Instead of going to the NCBI website to retrieve sequence data from the NCBI database, we can retrieve sequence data from NCBI directly from R, by using the SeqinR R package.

For example, let's retrieve the **DEN-1 Dengue virus type-1 genome sequence**, which has NCBI accession NC_001477, from the NCBI website. To retrieve a sequence with a particular NCBI accession, we can use R function `getncbiseq()` as below:


To retrieve a sequence from the NCBI Nucleotide database, such as the sequence for the DEN-1 Dengue virus (accession NC_001477):

```{r}
dengueseq <- getncbiseq("NC_001477")
```

The variable dengueseq is a vector containing the nucleotide sequence. Each element of the vector contains one nucleotide of the sequence. Therefore, to print out a certain subsequence of the sequence, we just need to type the name of the vector dengueseq followed by the square brackets containing the indices for those nucleotides. For example, the following command prints out the first 50 nucleotides of the DEN-1 Dengue virus genome sequence:

```{r}
dengueseq[1:50]

```

```
[1] "a" "g" "t" "t" "g" "t" "t" "a" "g" "t" "c" "t" "a" "c" "g" "t" "g" "g" "a"
[20] "c" "c" "g" "a" "c" "a" "a" "g" "a" "a" "c" "a" "g" "t" "t" "t" "c" "g" "a"
[39] "a" "t" "c" "g" "g" "a" "a" "g" "c" "t" "t" "g"
```
These elements contain the first 50 nucleotides of the DEN-1 Dengue virus sequence. (Vector)

** Now let's write the sequence data out as a FASTA file.

```{r}
write.fasta(names="DEN-1", sequences=dengueseq, file.out="den1.fasta")
```
Once we have downloaded the sequence data for a particular NCBI accession, and stored it on a file on your computer, we can then read it into R by using read.fasta function from the SeqinR R package. 

For example, we have stored the DEN-1 Dengue virus sequence in a file “den1.fasta”, we then type:

```{r}
library("seqinr")                           # Load the SeqinR package.
dengue <- read.fasta(file = "den1.fasta")   # Read in the file "den1.fasta".
dengueseq <- dengue[[1]]                    # Put the sequence in a vector called "dengueseq".
```

Once you have retrieved a sequence from the NCBI Sequence Database and stored it in a vector variable such as dengueseq in the example above, it is possible to extract subsequence of the sequence by type the name of the vector (eg. dengueseq) followed by the square brackets containing the indices for those nucleotides. For example, to obtain nucleotides 452-535 of the DEN-1 Dengue virus genome, we can type:

```{r}
dengueseq[452:535]
```

```
[1] "c" "g" "a" "g" "g" "g" "g" "g" "a" "g" "a" "g" "c" "c" "g" "c" "a" "c" "a"
[20] "t" "g" "a" "t" "a" "g" "t" "t" "a" "g" "c" "a" "a" "g" "c" "a" "g" "g" "a"
[39] "a" "a" "g" "a" "g" "g" "a" "a" "a" "a" "t" "c" "a" "c" "t" "t" "t" "t" "g"
[58] "t" "t" "t" "a" "a" "g" "a" "c" "c" "t" "c" "t" "g" "c" "a" "g" "g" "t" "g"
[77] "t" "c" "a" "a" "c" "a" "t" "g"
```

** Let's find local variation of GC content:

To find out GC content of a genome sequence (percentage of nucleotides in a genome sequence that are Gs or Cs), you can use the GC() function in the SeqinR package. For example, to find the GC content of the DEN-1 Dengue virus sequence that we have stored in the vector dengueseq, we can type:

```{r}
GC(dengueseq)
```

```
[1] 0.4666977
```

** A sliding window analysis of of GC content

In order to study local variation in GC content within a genome sequence, we could calculate the GC content for small chunks of the genome sequence. The DEN-1 Dengue virus genome sequence is 10735 nucleotides long. To study variation in GC content within the genome sequence, we could calculate the GC content of chunks of the DEN-1 Dengue virus genome, for example, for each 2000-nucleotide chunk of the genome sequence:

```
> GC(dengueseq[1:2000])      # Calculate the GC content of nucleotides 1-2000 of the Dengue genome
[1] 0.465
> GC(dengueseq[2001:4000])   # Calculate the GC content of nucleotides 2001-4000 of the Dengue genome
[1] 0.4525
> GC(dengueseq[4001:6000])   # Calculate the GC content of nucleotides 4001-6000 of the Dengue genome
[1] 0.4705
> GC(dengueseq[6001:8000])   # Calculate the GC content of nucleotides 6001-8000 of the Dengue genome
[1] 0.479
> GC(dengueseq[8001:10000])  # Calculate the GC content of nucleotides 8001-10000 of the Dengue genome
[1] 0.4545
> GC(dengueseq[10001:10735]) # Calculate the GC content of nucleotides 10001-10735 of the Dengue genome
[1] 0.4993197
```

From the output of the above calculations, we see that the region of the DEN-1 Dengue virus genome from nucleotides 1-2000 has a GC content of 46.5%, while the region of the Dengue genome from nucleotides 2001-4000 has a GC content of about 45.3%. Thus, there seems to be some local variation in GC content within the Dengue genome sequence.

Instead of typing in the commands above to tell R to calculate the GC content for each 2000-nucleotide chunk of the DEN-1 Dengue genome, we can use a for loop to carry out the same calculations, but by typing far fewer commands. That is, we can use a for loop to take each 2000-nucleotide chunk of the DEN-1 Dengue virus genome, and to calculate the GC content of each 2000-nucleotide chunk. 

##### Hence, write a *for* loop for above process in order to make it simple.

[Solution] (DNA1-virus-loop-sol.md)


#### Ex3:

It is common to use the data generated from a sliding window analysis to create a sliding window plot of GC content. To create a sliding window plot of GC content, you plot the local GC content in each window of the genome, versus the nucleotide position of the start of each window.

Create a Sliding window plot of above calculated GC content.

[Solution] (SlidingWindow_Plot.md)


## Functions exercise

#### Ex4:

You may want to use above written code to create sliding window plots of GC content of different species’ genomes, using different windowsizes. Therefore, it makes sense to write a function to do the sliding window plot, that can take the windowsize that the user wants to use and the sequence that the user wants to study as arguments (inputs).

Write a function to do the sliding window plot.

[Solution] (Func_sliding_window_plot.md)

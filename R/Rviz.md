## Base graphics

### Painters model

Graphical elements are added to the canvas one layer at a time, and
the picture builds up in levels. Lower levels are obscured by higher
levels, allowing for blending, masking and overlaying of objects.


```{r}
plot(Titanic)
plot(1:10, 1:10)
rect(2, 2, 8, 8, col = "black")
rect(3, 3, 7, 7, col = "white")
abline(0, 1, col = "red")
```

![plot of chunk Rviz.md-1](figures/Rplot07.png)

### High level plotting functions

High level plotting functions produce an appropriate chart based on
the input.

- `plot`: generic plotting function. By default produces scatter plots
  but other `type`s can be set.

```{r}
par(mfrow = c(2, 2))
plot(1:10, type = "p", main = "points (default)")
plot(1:10, type = "l", main = "lines")
plot(1:10, 10:1, type = "b", main = "both (points and lines)")
plot(1:10, type = "h", main = "histogram")
```
![plot of chunk Rviz.md-2] (figures/Rplot08.png)


- `barbplot`


```{r}
par(mfrow = c(1, 2))
barplot(c(1, 2, 3, 4))
s <- sample(letters, 1000, replace = TRUE)
barplot(table(s))
```
![plot of chunk Rviz.md-3] (figures/Rplot09.png)

- `boxplot`


```{r}
par(mfrow = c(1, 2))
l <- lapply(1:10, rnorm)
boxplot(l)
m <- matrix(rnorm(1000), ncol = 10)
boxplot(m, names = LETTERS[1:10])
```
![plot of chunk Rviz.md-4] (figures/Rplot10.png)

- histograms: `hist`


```{r}
par(mfrow = c(1, 2))
x <- rnorm(10000)
hist(x)
hist(x, breaks = 50, freq = FALSE)
lines(density(x), col = "red")
```
![plot of chunk Rviz.md-5] (figures/Rplot11.png)

- `pie` (not recommended)


```{r}
pie(c(1, 2, 3, 4))
```
![plot of chunk Rviz.md-6] (figures/Rplot12.png)

- `curve`


```{r}
curve(x^2, 0, 10)
```
![plot of chunk Rviz.md-7] (figures/Rplot13.png)

- `matplot`

```{r}
m <- matrix(rnorm(30), ncol = 3)
dimnames(m) <- list(genes = paste("Gene", 1:10), sample = LETTERS[1:3])
matplot(t(m), type = "b")
```
![plot of chunk Rviz.md-8] (figures/Rplot14.png)

- `image` and `heatmap`

```{r}
heatmap(m, col = cm.colors(256))
```
![plot of chunk Rviz.md-9] (figures/Rplot15.png)

### Low level interaction

Low level interaction with the drawing device to build up a figure
piece by piece.

- `points`, `lines`, `rect`, `arrows`, `axis`, `abline`, ...


```{r}
plot(1:10)
points(1:3, 3:1, pch = 19, col = "red")
lines(c(10, 1), c(1, 10))
lines(c(9, 1), c(1, 9), lty = "dotted", lwd = 3)
rect(8, 8, 10, 10, col = "black")
arrows(5, 1, 5, 10)
abline(v = 2, col = "blue")
abline(h = 2, col = "steelblue")
grid()
```
![plot of chunk Rviz.md-10] (figures/Rplot16.png)

### Numerous parameters to be tuned

- See `par`:
  - margins (`mar`, ...), grid of figures (`mfrow` and `mfcol`), ...
  - `las`: axes label style
- Arbitrary graph `layout`


```{r}
(m <- matrix(c(1, 1, 2, 3, 4, 4, 4, 4), nrow = 2))
```

```
 [,1] [,2] [,3] [,4]
[1,]    1    2    4    4
[2,]    1    3    4    4
```

```{r}
layout(m)
plot(1:10, main = 1)
curve(sin(x), from = -2, to = 2, main = 2)
curve(cos(x), from = -2, to = 2, main = 3)
image(t(m), main = 4)
```
![plot of chunk Rviz.md-11](figures/Rplot17.png)

- Point symbols (plotting character): `pch`
- Symbol sizes (character expansion): `cex`
- ...

### Adding text on graphs
- `title`: for main and sub-titles
- `mtext`: margin text
- `text`: text at `x` and `y` positions
- `legend`

### Devices


By default, the figures are produced on the screen device
(`dev.new()`). Other devices can be opened prior to plotting: `pdf`,
`postscript`, `png`, `jpeg`, `svg`, ... each with their respective
options including a file name. After plotting, the device must be
closed with `dev.off()`.


```{r}
pdf("fig.pdf")
plot(1:10)
dev.off()
```
It is possible to open multiple devices and navigate them with
`dev.prev()`, `dev.next()` and set the active device (the one in which
the graphics operation occur) with `dev.set(n)`. If a screen device is
open, its content can be copied into another file device with
`dev.copy()`, `dev.copy2pdf()`, ...

### Colours

- Colours can be set by their names (see `colors()`) or by the RGB
  (red, green, blue) specification (as hexadecimals). The `scales`
  package `col2hcl` allows to translate any colour to its RGB
  hexadecimal values. In addition, a fourth (0 <= `alpha`<= 1 in
  `col2hcl`) channel defines transparency (`FF` is opaque, `00` is
  completely transparent).


```{r}
library("scales")
```

```
### Loading required package: methods
```

```{r}
cl <- col2hcl("steelblue", alpha = 0.1)
x <- rnorm(3000)
y <- rnorm(3000)
plot(x, y, pch = 19, col = cl, cex = 2)
```
![plot of chunk Rviz.md-13](figures/Rplot18.png)


The `smoothScatter` function can be used to use colour density to
  represent point density


```{r}
smoothScatter(x, y)
```

```
## KernSmooth 2.23 loaded
## Copyright M. P. Wand 1997-2009
```
![plot of chunk Rviz.md-14] (figures/Rplot19.png)

- Colour palettes: `rainbow(n)`, `heat.colors(n)`,
`terrain.colours(n)`, `topo.colors(n)`, `cm.colors(n)` or using
`colorRampPalette`:


```{r}
brblramp <- colorRampPalette(c("brown", "steelblue"))
par(mfrow = c(2, 2))
plot(1:10, pch = 19, col = rainbow(10), cex = 3)
plot(1:10, pch = 19, col = cm.colors(10), cex = 3)
plot(1:10, pch = 19, col = heat.colors(10), cex = 3)
plot(1:10, pch = 19, col = brblramp(10), cex = 3)
```

![plot of chunk Rviz.md-15](figures/Rplot20.png)


- The `RColorBrewer` package provides a series of well defined colour
  palettes for maximal discrimination, paired data, ...


```{r}
library("RColorBrewer")
display.brewer.all()
```

![plot of chunk Rviz.md-16](figures/Rplot21.png)

### Other
- `locator` to obtain the `x` and `y` from a mouse click.
- `identify` to identify index of label of the closest point to a mouse click.

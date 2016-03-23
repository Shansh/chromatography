library(ggplot2)
library(Hmisc)

directory <- "./data/ftir/" # Define directory where ftir data files are stored
files <- list.files(directory) # Get list of the all files from the directory
lng <- length(files) # Get number of the files

# Set up needed variables to NULL
df <- NULL
tbl <- NULL
names <- NULL

# Create wavenumber vector (x-axis) from the first column of the first file
wave <- read.table(file.path(directory, files[1]), header = FALSE)[, 1]

# Loop for second column in each data file and store in 'tbl' data frame
for(i in 1:lng){     
        df <- read.table(file.path(directory, files[i]), header = FALSE)[,2]
        names <- c(names, sub("^([^.]*).*", "\\1", files[i]))
        tbl <- cbind(tbl, df)
}

sq <- seq(from = -35, to = 50*lng, length.out = lng) # Create vector of separator values
tbl <- sapply(1:ncol(tbl),function(x) tbl[,x] + sq[x]) # Separate each ftir for about 50 units along y-axis
tbl <- cbind(wave, tbl) # Bind first column of wavenumbers (x-axis)
colnames(tbl)[-c(1)] <- names # Give column names as original files (may be useful)
tbl <- as.data.frame(tbl) # Define 'tbl' as data frame

# Define image type, dimensions and quality
tiff(filename = "./data/ftir.tiff",
     width = 3000, height = 4000,
     units = "px", pointsize = 12,
     compression = c("lzw"),
     bg = "white", res = 300,
     type = c("cairo"))
par(mfrow=c(1,1), mar=c(3, 3, 1, 2), las=0)

# Create blank plot
plot(tbl[,1], tbl[, lng], type = "n",
     xlab = "", ylab = "", xaxs="i",yaxs="i",
     ylim = c(0, sq[lng]), xlim = c(4000, 0),
     bty="n", xaxt="n", yaxt = "n")

# Draw ftir line graphs
for(i in 2:(lng-1)){
        lines(tbl[,1], tbl[,i], lty = 1)
}

# Axis definition
minor.tick(nx = 10, ny=0, tick.ratio=0.2)
axis(1, cex.axis = 0.8, cex.lab = 0.8, tck = -0.01, mgp = c(3, 0.1, 0))
axis(4, cex.axis = 0.8, cex.lab = 0.8, tck = FALSE, pos = 400, labels = FALSE)
mtext(side=1, text=expression("Wavenumber [cm"^-1*"]"), line=1.5, cex=0.8)
mtext(side=4, text="Intensity [a.u.]", line=-3, cex=0.8)

# Put letters above each ftir chromatogram
lett <- rev(letters[seq( from = 1, to = lng - 1)])
for(i in 2:lng){
        text(x = 3851.5, y = tbl[tbl$wave == 3851.5, i] + 10,labels=paste("(",lett[i],")", sep = ""), cex = 1.2)
}

dev.off()
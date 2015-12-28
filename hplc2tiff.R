library(ggplot2) # This library is included only because 'Hmisc' library needs it
library(Hmisc)


df <- read.csv("./data/helichrysum.csv", header = FALSE)
names(df) <- c("time", "signal")


tiff(filename = "./data/helichrysum.tiff",     
     width = 3000, height = 1300,    
     units = "px", pointsize = 12,   
     compression = c("lzw"),    
     bg = "white", res = 300,   
     type = c("cairo"))

par(mfrow=c(1,1), mar=c(2, 3, 1, 1), las=1)
plot(df$time, df$signal, type = "l",   
     xlab = "", ylab = "", xaxs="i",yaxs="i", 
     ylim = c(-40, 760), xlim = c(0, 40),
     bty="n", xaxt="n", yaxt = "n")
axis(1, at = seq(0, 40, 5),
     labels = c("", "5", "10", "15", "20", "25", "30", "35", "min"),
     cex.axis = 0.8, cex.lab = 0.8, tck = -0.01, 
     mgp = c(3, 0.1, 0))
axis(2, at = c(-40, 0, 100, 200, 300, 400, 500, 600, 700, 760),
     labels = c("", "0", "100", "200", "300", "400", "500", "600","700", "mAU"),
     cex.axis = 0.8, cex.lab = 0.8, tck = -0.01, 
     mgp = c(3, 0.4, 0))
minor.tick(nx=10, ny=10, tick.ratio=0.2)

dev.off()
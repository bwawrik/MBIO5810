args <- commandArgs(trailingOnly = TRUE)

n=as.numeric(args[1])
file_name = args[2]
heat_colors <-colorRampPalette(c("red","green"))(8)

png(filename=file_name,width=1.75,height=4,units="in",res=100)
par(pin=c(1,3.5))
par(oma=c(0,0,0,0))
colq = 10-(round (log (n))+4)
if (colq<0) {colq=0}
barplot (n, col=heat_colors[colq], log="y",ylim=c(0.1, 100))
dev.off()


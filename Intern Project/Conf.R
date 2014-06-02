SS score : Single Performance Variable
================

```{r setoptions, echo=FALSE}
  opts_chunk$set(echo=FALSE, fig.width=5, fig.height=3,warning=FALSE,comment=NA,message=FALSE)
```

```{r libs, results="hide"}
library(ggplot2)
library(grid)
library(gridExtra)
library(xtable)
require(methods)
library(scatterplot3d)
library(akima)
library(plyr)
library(scales)
library(reshape)
library(RColorBrewer)
library(TSP)
library(seriation)
library(corrgram)
library(glmnet)
library(scales)
```

```{r TTBinRule}
TTBinRule <- function (dat){
  maxBins = 100
  n <- hist(dat,breaks=maxBins,plot=F)
  d1 <- na.omit(dat)
  selectWindow <- quantile(d1, c(0,.05, .95,1)) 

  # 0-10percentile, # bins
  nLo <- n$counts[n$breaks<selectWindow[2]]
  pLo <- n$breaks[n$breaks<selectWindow[2]]

  nHi <- n$counts[n$breaks>selectWindow[3]]
  pHi <- n$breaks[n$breaks>selectWindow[3]]
  pMid <-n$breaks[n$breaks>=selectWindow[2] & n$breaks<=selectWindow[3]]

  if (length(nLo[nLo==0]) > round(0.15*maxBins,0)){
    x=as.numeric(nLo>0)
    zPos=cumsum(rle(x==0)$lengths) # TBD with dhanya
    q1 <- zPos[which.max(diff(cumsum(rle(x==0)$lengths)))+1]
    b1=c(pLo[q1:length(pLo)], pMid) # TBD discuss the signficance of q1
  } else{
    b1=c(pLo ,pMid)
  }
      
  if (length(nHi[nHi==0]) > round(0.15*maxBins,0)){
    x=as.numeric(nHi>0)
    zPos=cumsum(rle(x==0)$lengths)
    q1 <- zPos[which.max(diff(cumsum(rle(x==0)$lengths)))]
    b1=c(b1,pHi[1:q1])
  } else{
    b1=c(b1,pHi)
  }
  
  newDat <- d1[(d1>=b1[1] & d1<=b1[length(b1)])]
  numOutliers=length(d1)-length(newDat)

  n <- NULL
  n <- hist(newDat, breaks="FD", plot=F)
  n$numOutliers=numOutliers
  n$newDat = newDat
  return(n) 
}
```

```{r cutdataFunction}
cutData3 <- function (dat) {
  d.cut <- rep(NA,length(dat))
  dat1 <- as.numeric(unlist(dat))
  cutoffs=quantile(dat1,c(0.25,0.75),na.rm=T)
  d.cut[dat1<=cutoffs[[1]]]="Lo"
  d.cut[dat1>cutoffs[[1]] & dat1<=cutoffs[[2]]]="Med"
  d.cut[dat1>cutoffs[[2]]]="Hi"
  d.cut = factor(d.cut)
  d.cut = factor(d.cut,levels(d.cut)[c(2,3,1)])
  return(as.factor(d.cut))
}
```

```{r dataUpload}
file <- "MaduraBranchData_v4.csv"
data <- read.csv(file,header=TRUE)
pstart=7
data <- data[,pstart:ncol(data)]
data$ScorexBorrowers <- data$ActiveBorwrs * data$SSscore_YTD
colnames(data)[22] <- "ProductivityScore"

varNames <- names(data)
pstart=1 
p1=12
contextData=data[,pstart:p1]
perfName<<-c("ProductivityScore")
perfNameS<<-c("Productivity Score")
perfData=data[,perfName]
d.cut=cutData3(perfData)
```

```{r derivedParameters}
print(min(data$Migration_Dec,na.rm=T))
resc_Migr=1-min(data$Migration_Dec,na.rm=T)+data$Migration_Dec
dervData=data.frame("expD"=exp(data$D), "logA"=log(data$A),"logMigr"=log(data$Migration_Dec), "DxA"=(data$D*data$A),"DxLit"=(data$D*data$LitRatio), "expIWR"=exp(data$IWR), "logRescMigr"=log(resc_Migr))
fullContextData=data.frame(contextData,dervData)
data = data.frame(data,dervData)
```

```{r PerfHistogram}
  n <- NULL
  n <- TTBinRule(perfData)
  nQ <- quantile(n$newDat,c(0.1,0.25,0.75,0.9))  

  plotd <- NULL
  plotd <- data.frame("x"=n$mids,"y"=n$counts/sum(n$counts))
  q1 <- NULL
  q1 <- ggplot(plotd, aes(x=x, y=y))  + ylab("Madura Centres") +xlab(perfNameS) 
  q11 <- q1 + geom_bar(stat = "identity", fill="#599ad3") 
  q11 <- q11 +  scale_y_continuous(labels = percent_format())
  q11 <- q11 + geom_segment(aes_string(x=nQ[[1]],y=0,xend=nQ[[1]],yend=.25),color="black",linetype="dotted")
  q11 <- q11 + geom_segment(aes_string(x=nQ[[2]],y=0,xend=nQ[[2]],yend=.25),color="black",linetype="dotted")
  q11 <- q11 + geom_segment(aes_string(x=nQ[[3]],y=0,xend=nQ[[3]],yend=.25),color="black",linetype="dotted")
  q11 <- q11 + geom_segment(aes_string(x=nQ[[4]],y=0,xend=nQ[[4]],yend=.25),color="black",linetype="dotted")
  print(q11)

  r9010 = nQ[[4]]/nQ[[1]]
  r7525 = nQ[[3]]/nQ[[2]]
```

**Ratio of (90 percentile : 10 percentile) = `r r9010`**

**Ratio of (90 percentile : 10 percentile) = `r r7525`**

Logistic Model: Migration_Dec + D + exp(IWR) + exp(D) + DxA + LitRatio  ~ Performance
------------------------------------------------
```{r LogisticModelFn, fig.width=6}
LogitModelSummary <- function (lrfit){
  print(summary(lrfit))
  print(fitted(lrfit))
  print(names(fitted(lrfit)))
  b <- as.numeric(names(fitted(lrfit)))  #TBD What does the fitted function do 
  print(b)
  y <- NULL
  y$perf1=lrfit$data[,perfName]#[b]
  print(y$perf1)
  y$Predict=as.numeric(fitted(lrfit))
  y$perfGrp=lrfit$y

  y <- data.frame(y)
  p <- ggplot(y,aes(x=perf1,y=Predict,color=perfGrp)) 
  p <- p + geom_point() + ylab("Predicted Value logistic Model") + xlab(perfName) 
  p <- p + guides(color=guide_legend(perfName))        
  print(p)
  
  cutoffs=seq(from=min(y$Predict),to=max(y$Predict),length.out=7)
  tpRate <- NULL
  prec <- NULL
  for (i in 2:(length(cutoffs)-1)) {
    yPred = NULL
    yPred = as.numeric(y$Predict>=cutoffs[i])
    a <- table(y$perfGrp,yPred)
    tpRate[i-1] = a[2,2]/(sum(a[,2]))
    prec[i-1] = a[2,2]/(sum(a[2,]))
  }
  lrPerf <- data.frame("Cutoff"=round(cutoffs[2:(length(cutoffs)-1)],2),"TP Rate"=round(tpRate,3),"Precision"=round(prec,3))
  return(lrPerf)
}
```

```{r LogisticModelOutput, dpi=100}
CompareModelOutput <- function (lrfit, cutoff=0.5) {
  b <- as.numeric(names(fitted(lrfit)))
  Class <- NULL 
  
  OverallPerformance=lrfit$data[,perfName]
  FitOut=as.numeric(fitted(lrfit))
  Predict=OverallPerformance[b[FitOut>=cutoff]]
  
  Class=c(rep("Madura Data",length(OverallPerformance)),rep(paste("Model Cutoff=",cutoff),length(Predict)))
  y <- data.frame("Perf"=c(OverallPerformance,Predict),"Class"=as.factor(Class))
  
  Stats <- data.frame("Mean"=c(mean(OverallPerformance,na.rm=T),mean(Predict)), "SD"=c(sd(OverallPerformance,na.rm=T),sd(Predict)), "Median"=c(median(OverallPerformance,na.rm=T),median(Predict)))
  Stats[3,]=Stats[2,]/Stats[1,]
  rownames(Stats)=c("Madura","Model","Model:Madura")
  
  q1 <- NULL
  q1 <- ggplot(y, aes(x=Perf, group = Class, color = Class, fill = Class))
  q1 <- q1 + geom_density(aes(y=..density..*100, alpha=0.2),na.rm=TRUE) + xlab(perfNameS) + ylab('Density (x 1/100)')
  q1 <- q1 + ggtitle("Overall Performance vs Model") + theme(legend.title=element_blank())
  print(q1)
  return(Stats)
}
```
```{r OutputParameter, fig.width=6}
data$perf.cut <- combine_factor(d.cut, c(1,1,3)) #TBD discussed with dhanya why where med converted to lo What is combine-factor
levels(data$perf.cut) <- c(0,1)
data$perf.cut <- factor(data$perf.cut, levels = c(0,1))
```

```{r Model3}
lrfit2 <- glm( perf.cut ~ Migration_Dec + expIWR + expD + D + DxA + LitRatio, data=data, family = binomial,na.action=na.omit)
lrPerf2 <- LogitModelSummary(lrfit2)
```

```{r echo=FALSE, results='asis'}
#xt2=xtable(lrPerf2)
#print(xt2,type="html")
```

**Case1**

```{r}
S1 <- CompareModelOutput(lrfit2, cutoff=0.3)
```

```{r echo=FALSE, results='asis'}
#xt2=xtable(S1)
#print(xt2,type="html")
```

**Case2**

```{r}
S2 <- CompareModelOutput(lrfit2, cutoff=0.4)
```

```{r echo=FALSE, results='asis'}
#xt2=xtable(S2)
#print(xt2,type="html")
```


stepwise optimization of the above model
-----------------------------------------
```{r Model3_contd}
lrfit3 <- glm( perf.cut ~ Migration_Dec + expIWR + expD + D, data=data, family = binomial,na.action=na.omit)
lrPerf2step <- LogitModelSummary(lrfit3)
```

```{r echo=FALSE, results='asis'}
#xt3=xtable(lrPerf2step)
#print(xt3,type="html")
```

```{r}
S3 <- CompareModelOutput(lrfit3, cutoff=0.25)
```

```{r echo=FALSE, results='asis'}
xt2=xtable(S3)
#print(xt2,type="html")
```

```{r}
S4 <- CompareModelOutput(lrfit3, cutoff=0.35)
```

```{r echo=FALSE, results='asis'}
xt2=xtable(S4)
#print(xt2,type="html")
```


Influencer Context Variables
-----------------------------

```{r CompareModelOutputContext, dpi=100}
CompareModelOutputContext <- function (lrfit, cutoff=0.5, context, cname, contextCutoff, yend=2) {
  b <- as.numeric(names(fitted(lrfit)))
  Class <- NULL 
  
  OverallContext=context
  FitOut=as.numeric(fitted(lrfit))
  Predict=context[b[FitOut>=cutoff]]
  
  Class=c(rep("All Branches",length(OverallContext)),rep(paste("Model Cutoff=",cutoff),length(Predict)))
  y <- data.frame("Context"=c(OverallContext,Predict),"Class"=as.factor(Class))
  
  q1 <- NULL
  q1 <- ggplot(y, aes(x=Context, group = Class, color = Class, fill = Class))
  q1 <- q1 + geom_density(aes(alpha=0.2),na.rm=TRUE) + xlab(cname) + ylab('Density')
  q1 <- q1 + ggtitle("Overall Performance vs Model") + theme(legend.title=element_blank())
  q1 <- q1 + geom_segment(aes_string(x = contextCutoff, y = 0, xend = contextCutoff, yend = yend), linetype=2, color="black")
  
  OverallPerformance=lrfit$data[,perfName]
  PredictPerf=OverallPerformance[OverallContext>=contextCutoff]
  ClassP=c(rep("All Branches",length(OverallPerformance)),rep("Filter Selected",length(PredictPerf)))
  yP <- data.frame("Perf"=c(OverallPerformance,PredictPerf),"Class"=as.factor(ClassP))
  
  q2 <- NULL
  q2 <- ggplot(yP, aes(x=Perf, group = Class, color = Class, fill = Class))
  q2 <- q2 + geom_density(aes(y=..density..*100,alpha=0.2),na.rm=TRUE) + xlab(perfNameS) + ylab('Density (x 1/100)')
  q2 <- q2 + ggtitle(paste("Filter:Criterion >",contextCutoff)) + theme(legend.title=element_blank())
  
  #print(q1)
  #print(q2)
}
```

**1. Migration Decadal**

```{r}
model=lrfit2
#CompareModelOutputContext(model, cutoff=0.3, data$Migration_Dec, cname="Decadal Migration",contextCutoff=0.15)
```

**2. exp(IWR)**

```{r}
#CompareModelOutputContext(model, cutoff=0.3, data$expIWR, cname="exp(IWR)",contextCutoff=1.9)
```

**3. Diversity Measure, D**

```{r}
#CompareModelOutputContext(model, cutoff=0.3, data$D, cname="D",contextCutoff=75, yend=0.05)
```
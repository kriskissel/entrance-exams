## This is the preprocessing that is done on the data from IE to prepare it
## for analysis.  This includes: anonymizing the data by replacing student ID
## numbers with randomly generated fake IDs, and adding three columns to the
## data indicating course success at the 1.0, 2.0 and 2,5 grade point levels,
## in order to simplify later analysis.

df1 = read.csv("rawdata/startingData.csv")
df1 = subset(df1, Grade.earned != "*")
SID = unique(df1$SID.)
FID = 1:length(SID)
set.seed(2014)
FID = sample(FID)
SIDtoFID=cbind(SID,FID)
write.csv(SIDtoFID,"cleandata/SIDtranslationtable.csv")
translator = read.csv("cleandata/SIDtranslationtable.csv")
df1$FID = numeric(length(df1$SID.))
for (k in 1:length(df1$SID.)){
  tableentry = match(df1$SID.[k],translator[,2])
  df1$FID[k] = translator[tableentry,3]
}
df1$SID. = NULL
df1$Last.Name = NULL
df1$First.Name = NULL
df1$Date.of.Birth = NULL
df1$Sex = NULL
df1$Ethnicity = NULL
write.csv(df1, "cleandata/anonymousdata.csv")



df1$success1.0 = logical(length(df1$FID))
df1$success1.0[df1$numericalgrade >= 1.0] = TRUE
df1$success1.0[df1$Grade.earned == "P"] = TRUE

df1$success2.0 = logical(length(df1$FID))
df1$success2.0[df1$numericalgrade >= 2.0] = TRUE

df1$success2.5 = logical(length(df1$FID))
df1$success2.5[df1$numericalgrade >= 2.5] = TRUE

df1$forcednumericalgrade = df1$numericalgrade
df1$forcednumericalgrade[df1$Grade.earned == "W"] = -0.1
df1$forcednumericalgrade[df1$Grade.earned == "N"] = -0.1
df1$forcednumericalgrade[df1$Grade.earned == "P"] = 1
df1$forcednumericalgrade[df1$Grade.earned == "NC"] = -0.1
df1$forcednumericalgrade[df1$Grade.earned == "I"] = -0.1


write.csv(df1, "cleandata/preprocessedData.csv")


#1. Importing the file into R
FAA<-read.table("/Users/MACOS/Downloads/FAA1.csv",header = TRUE, sep = ",")

#Understanding the data
str(FAA)

#2. Data Cleaning
FAA<-subset(FAA, speed_ground>=30 & speed_ground<=140)
FAA<-subset(FAA, duration > 40)
FAA<-subset(FAA, height >= 6)
FAA<-subset(FAA, distance < 6000)
FAA<-subset(FAA, speed_air>=30 & speed_air <= 140 | is.na(speed_air))

#3. Data visualization 
# Histogram of some of variables
hist(FAA$duration)
hist(FAA$no_pasg)
hist(FAA$distance)
hist(FAA$speed_ground)
hist(FAA$pitch)
hist(FAA$speed_air)
hist(FAA$height)

#XY plot showing relationships between variables
plot(FAA$speed_ground, FAA$distance)
plot(FAA$duration, FAA$distance)
plot(FAA$no_pasg, FAA$distance)
plot(FAA$speed_air, FAA$distance)
plot(FAA$height, FAA$distance)
plot(FAA$pitch, FAA$distance)

#4. Model fitting
#Correlation Matrix
cor(FAA$speed_ground,FAA$distance)
CorrFAA<-subset( FAA, select = -c(2,3,6,7))
CorrFAA<-subset( CorrFAA, speed_air>=30 & speed_air <= 140)
cor(CorrFAA$distance,CorrFAA$speed_air)
#Regression Model
mode<-lm(FAA$distance~FAA$speed_ground+FAA$speed_air)
summary(mode)

#4. Consider individual Aircraft makers
FAA_Boeing<-subset(FAA, aircraft == "boeing")
FAA_Airbus<-subset(FAA, aircraft == "airbus")

#Correlation Matrix
cor(FAA_Boeing$speed_ground,FAA_Boeing$distance)
cor(FAA_Boeing$height,FAA_Boeing$distance)
cor(FAA_Boeing$duration,FAA_Boeing$distance)
cor(FAA_Boeing$no_pasg,FAA_Boeing$distance)
cor(FAA_Boeing$pitch,FAA_Boeing$distance)

CorrFAA_Boeing<-subset(FAA_Boeing, speed_air>=30 & speed_air <= 140)
cor(CorrFAA_Boeing$distance,CorrFAA_Boeing$speed_air)

cor(FAA_Airbus$speed_ground,FAA_Airbus$distance)
cor(FAA_Airbus$height,FAA_Airbus$distance)
cor(FAA_Airbus$duration,FAA_Airbus$distance)
cor(FAA_Airbus$no_pasg,FAA_Airbus$distance)
cor(FAA_Airbus$pitch,FAA_Airbus$distance)

CorrFAA_Airbus<-subset(FAA_Airbus, speed_air>=30 & speed_air <= 140)
cor(CorrFAA_Airbus$distance,CorrFAA_Airbus$speed_air)

#Regression Model
modelBoeing<-lm(FAA_Boeing$distance~FAA_Boeing$speed_ground+FAA_Boeing$speed_air)
summary(modelBoeing)

modelAirbus<-lm(FAA_Airbus$distance~FAA_Airbus$speed_ground+FAA_Airbus$speed_air)
summary(modelAirbus)

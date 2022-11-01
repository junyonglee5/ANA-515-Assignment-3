df <- `StormEvents_details.ftp_v1.0_d1996_c20220425.(2).csv`

library(tidyverse)

myvars <- c("BEGIN_DATE_TIME", "END_DATE_TIME", "BEGIN_YEARMONTH","EPISODE_ID","EVENT_ID","STATE","STATE_FIPS",
            "CZ_NAME","CZ_TYPE","CZ_FIPS","EVENT_TYPE","SOURCE","BEGIN_LAT","BEGIN_LON","END_LAT","END_LON")
newdata <- df[myvars]
head(newdata)

nd1 <- arrange(newdata,BEGIN_YEARMONTH)

str_to_upper(nd1$STATE)
str_to_upper(nd1$CZ_NAME)

nd2 <- filter(nd1,CZ_TYPE=="C")
nd3 <- select(nd2,-CZ_TYPE)

nd3$STATE_FIPS <- str_pad(nd3$STATE_FIPS, width=3, side = "left", pad="0")
nd4 <- unite(nd3, "FIPS", STATE_FIPS, CZ_FIPS, sep="")

rename_all(nd4,tolower)

data("state")
us_state_info <- data.frame(state=state.name,region=state.region,area=state.area)

DiffData <- data.frame(table(newdata$STATE))
DiffData1 <- rename(DiffData, c("state"="Var1"))
DiffData2 <- mutate_all(DiffData1,toupper)
US_STATE_INFO <- mutate_all(us_state_info,toupper)
merged <- merge(x=DiffData2, y=US_STATE_INFO, by.x="state", by.y="state")

library(ggplot2)
storm_plot <- ggplot(merged, aes(x=area, y=Freq)) +
  geom_point(aes(color=region))+
  labs(x = "Land area (square miles)",
       y = "# of storm events in 1996")
storm_plot
library(plyr)
library(dplyr)
library(magrittr)
library(ggplot2)

allhost.o1 <- read.csv("Data/allhost_20times_64bytes1.csv")
allhost.o2 <- read.csv("Data/allhost_20times_64bytes2.csv")
allhost.o3 <- read.csv("Data/allhost_20times_64bytes3.csv")

allhost.o1summary <-  allhost.o1 %>%
  select(host_name, avg, loss_percent) %>%
  group_by(host_name) %>%
  summarise(avg_summary = mean(avg), loss_percent2 = mean(loss_percent))

allhost.o2summary <-  allhost.o2 %>%
  select(host_name, avg, loss_percent) %>%
  group_by(host_name) %>%
  summarise(avg_summary = mean(avg), loss_percent2 = mean(loss_percent))

allhost.o3summary <-  allhost.o3 %>%
  select(host_name, avg, loss_percent) %>%
  group_by(host_name) %>%
  summarise(avg_summary = mean(avg), loss_percent2 = mean(loss_percent))

allhost.o1summary$time <- 1
allhost.o2summary$time <- 2
allhost.o3summary$time <- 3

allhost.summary <- rbind(
  allhost.o1summary, allhost.o2summary, allhost.o3summary
)

plot_allhost <- ggplot(
    allhost.summary %>% select(-loss_percent2),
    aes(x = time, y = avg_summary, group = host_name, color = host_name)
  ) +
  geom_point() +
  geom_line() +
  facet_grid(host_name ~ ., scales = "free") +
  theme_bw() +
  scale_x_discrete(
    limits = unique(allhost.summary$time),
    labels = c("11AM", "4PM", "12AM")
    ) +
  labs(x = "Time", y = "Average RTTs", title = "Variation of RTT vs Time") +
  theme(plot.title = element_text(size = rel(1.5)), legend.position = "none")

library(plyr)
library(dplyr)
library(magrittr)
library(ggplot2)
library(knitr)

nicru.o1 <- read.csv("Data/nicru20times_allsizes1.csv") %>%
  select(time, packet_size, avg) %>%
  group_by(packet_size) %>%
  summarise(avg_summary = mean(avg))
nicru.o2 <- read.csv("Data/nicru20times_allsizes2.csv") %>%
  select(time, packet_size, avg) %>%
  group_by(packet_size) %>%
  summarise(avg_summary = mean(avg))
nicru.o3 <- read.csv("Data/nicru20times_allsizes3.csv") %>%
  select(time, packet_size, avg) %>%
  group_by(packet_size) %>%
  summarise(avg_summary = mean(avg))

nicru.o1$time <- 1
nicru.o2$time <- 2
nicru.o3$time <- 3

nicru.summary <- rbind(nicru.o1, nicru.o2, nicru.o3)
nicru.summary$time <- as.factor(nicru.summary$time)
nicru.summary$packet_size <- as.factor(nicru.summary$packet_size)

que1_part2plot <- ggplot(
    nicru.summary,
    aes(x = packet_size, y = avg_summary, group = time, color = time)
    ) +
  geom_point() +
  geom_line() +
  labs(
    title = "Variation of Packet Size with RTT\n of www.nic.ru",
    x = "Packet Size(bytes)",
    y = "Avg RTT (ms)"
  ) +
  theme_bw() +
  theme(
    plot.title = element_text(size = rel(1.25)),
    legend.position = "bottom",
    legend.background = element_rect(
      color = "black",
      fill = "grey90",
      size = 1,
      linetype = "solid"
      ),
    legend.direction = "horizontal"
  ) +
  scale_color_manual(
    "Time",
    labels=c("11AM", "4PM", "12AM"),
    values=as.factor(c("1", "2", "3"))
  )

library(contextual)
library(here)
library(data.table)
library(ggplot2)
setwd(here("demo","replication_kruijswijk_2019"))

#source("./bandit_continuum_function_hardcoded.R")
source("./bandit_continuum_function.R")
source("./bandit_continuum_offon.R")
source("./policy_tbl.R")
source("./policy_unifcont.R")
source("./policy_efirst_regression.R")

set.seed(1)

horizon            <- 10000
simulations        <- 50

continuous_arms_standard    <- function(x, c1 = 0.25, c2 = 0.75) {
  -(x - c1) ^ 2 + c2  + rnorm(length(x), 0, 0.01)
}

continuous_arms    <- function(x) {
  c1 <- runif(1, 0.25, 0.75)
  #c2 <- runif(1, 0.25, 0.75)
  c2 <- 1
  -(x - c1) ^ 2 + c2  + rnorm(length(x), 0, 0.01)
}

int_time           <- 50
amplitude          <- 0.025
amplitude_list     <- seq(0.02, 0.2, length.out = 10)
#amplitude_list     <- c(0.15, 0.1, 0.075, 0.05, 0.025, 0.01)
learn_rate         <- 1
omega              <- 1
x0_start           <- runif(1)

deltas <- c(0.01, 0.1, 0.5)

all_data <- data.frame(amp=double(),
                 reward=double(),
                 delta=double())

for (d in deltas){
  bandit             <- OnlineOfflineContinuumBandit$new(delta = d, horizon = horizon)

  agents <- list()

  for (i in 1:length(amplitude_list)){
    agents <- append(agents, Agent$new(LifPolicy$new(int_time, amplitude_list[i], learn_rate, omega, x0_start), bandit))
  }

  history            <- Simulator$new(agents      = agents,
                                      horizon     = horizon,
                                      simulations = simulations,
                                      policy_time_loop = FALSE)$run()

  iters <- length(amplitude_list)
  reward_rate <- c()
  confs <- c()

  for(i in 1:iters){
    reward_rate[[i]] <- history$cumulative[[i]]$cum_reward_rate
    dt <- history$get_data_table()
    df_split <- split(dt, dt$agent)
    for(dd in df_split){
      dd <- as.data.table(dd)
      maxes <- dd[, .I[which.max(t)], by=sim]$V1
      select <- dd[maxes]$cum_reward_rate
      confs[[i]] <- sd(select) / sqrt(simulations) * qnorm(0.975)
    }
    # for(j in 1:length(agents)){
    # confs[[i]] <- history$cumulative[[i]]$cum_reward_rate_ci
    # dt <- history$get_data_table()
    # selectiun <- dt[dt[,'agent'] == 'Lif.2',]
    # selectiun[selectiun[, .I[which.max(t)], by=sim]$V1]
    # }
  }
  df <- data.frame(amp = amplitude_list, reward = reward_rate, delta = rep(d), ci = confs)
  all_data <- rbind(all_data, df)
}
#plot(amplitude_list, reward_rate, xaxt = "n")
#axis(1, at = amplitude_list)
#smoothingSpline = smooth.spline(amplitude_list, reward_rate, spar=0.05)
#plot(amplitude_list, reward_rate)
#lines(smoothingSpline)

ggplot(data = all_data, aes(x=amp, y=reward, label = delta)) +
        geom_line(aes(colour = as.factor(delta))) +
        geom_errorbar(aes(ymin=reward-ci, ymax=reward+ci, color=factor(delta)), width=.01) +
        geom_vline(xintercept = 0.045, linetype = "dotted", color = "black", size = 1.5)


# plot(history, type = "cumulative", regret = FALSE, rate = TRUE, disp = "ci",
#      legend_position = 'bottomright',
#      legend_labels = c("A = 0.15",
#                        "A = 0.1",
#                        "A = 0.075",
#                        "A = 0.05",
#                        "A = 0.025",
#                        "A = 0.01"),
#      legend_title = expression(paste(delta, " = ", 0.1)))

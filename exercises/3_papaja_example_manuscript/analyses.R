## ----setup---------------------------------------------------------------
# load packages
library("papaja")
library("afex")
library("emmeans")


## ----global-par----------------------------------------------------------
# Define a function that sets desired global plot defaults
par(font.main = 1, las = 1)


## ----prepare-data--------------------------------------------------------
acquisition <- readRDS("data/acquisition-task.rds")
generation <- readRDS("data/generation-task.rds")

# set some variable labels for pretty plotting
variable_labels(acquisition) <- c(
  age = "Age"
  , sex = "Sex"
  , material = "Material"
  , generation = "Generation task"
  , order = "Block order"
  , block = "Block number"
  , trial = "Trial number"
  , S = "Stimulus location"
  , R = "Response location"
  , SRI = "Response time [ms]"
  , error = "Error"
  , frequency = "Location frequency"
)

variable_labels(generation) <- c(
  age = "Age"
  , sex = "Sex"
  , material = "Material"
  , generation = "Generation task"
  , order = "Block order"
  , block = "Block number"
  , trial = "Trial number"
  , PD_instruction = "PD instruction"
  , correct_SOC = "Correctly generated second-order conditional"
)


## ----participants--------------------------------------------------------
# stats for participants section
excluded_participants <- unique(c(55, 74, 75, 126, 5, 7, 9, 12, 15))

N <- length(unique(generation$id))

n.excluded_participants <- length(excluded_participants)

tmp <- aggregate(formula = correct_SOC ~ id + sex + age, data = generation, FUN=mean)
Sex <- table(tmp$sex)

# Age: mean and range
mean(tmp$age)
range(tmp$age)


## ----acquisition-rt------------------------------------------------------
# Reaction times during SRTT phase (i.e., training or acquisition)
tmp <- acquisition[
  acquisition$error == 0 &
  acquisition$material != "No-learning" & # these Ss didn't work on SRTT
  acquisition$trial > 1 &
  acquisition$included_participant,
]

par(mfrow = c(1, 2)) # place two different plots side-by-side

# left panel: RTs in permuted and random material groups
apa_lineplot(
  data = tmp
  , id = "id"
  , dv = "SRI"
  , factors = c("block", "material")
  , dispersion = wsci
  , ylab = "Mean RT [ms]"
  , args_lines = list(lty = c("solid", "dotted"))
  , args_points = list(pch = c(21, 23), bg = c("grey70", "white"))
  , args_legend = list(legend = c("Permuted", "Random"))
  , ylim = c(475, 650)
  , jit = .05
)

# within the permuted-material group, high vs. low frequency locations can be distinguished
tmp.perm <- acquisition[
  acquisition$error == 0 &
  acquisition$trial > 1 &
  acquisition$included_participant &
  acquisition$material == "Permuted" &
  !is.na(acquisition$frequency),
]


aov_ez(data = tmp.perm, dv = "SRI", within = c("block", "frequency"), id = "id")

apa_lineplot(
  data = tmp.perm
  , id = "id"
  , dv = "SRI"
  , factors = c("block", "frequency")
  , dispersion = wsci
  , ylab = ""
  , args_lines = list(lty = c("solid", "solid"))
  , args_points = list(pch = c(21, 21))
  , args_legend = list(legend = c("High", "Low"), title = "Location frequency")
  , ylim = c(475, 650)
  , jit = .05
)


aov_ez(data = tmp, dv = "SRI", id = "id", between = "material", within = "block")



## ----generation-soc------------------------------------------------------
# proportion of correctly generated triplets in the generation task
# excluding repetitions and trials after repetitions

tmp <- generation[
  generation$included_participant &
  generation$trial > 2 &
  generation$repetition == 0 &
  generation$post_repetition == 0,
]

# visualize
apa_barplot(
  data = tmp
  , id = "id"
  , dv = "correct_SOC"
  , ylab = "Proportion correct generation"
  , factors = c("material","PD_instruction", "generation")
  , ylim = c(0, 1)
  , main = c("Free generation", "Cued generation")
  , intercept = .2
)


# ANOVA for complete design
aov_ez(data = tmp, id = "id", dv = "correct_SOC", between = c("material", "generation", "order"), within = "PD_instruction")

# separate analysis for free-generation task
tmp.a <- tmp[tmp$generation == "Free", ]
fit <- aov_ez(data = tmp.a, id = "id", dv = "correct_SOC", between = c("material", "order"), within = "PD_instruction")
fit

# Post-hoc paired comparisons for free-generation group
pairs(emmeans(fit, specs = "material"), adjust = "tukey")


#----proportion-correct-table-appendix------------------------------
tmp <- generation[
  generation$included_participant &
  generation$repetition == 0 &
  generation$post_repetition == 0,
]

# calculate proportion of regular transitions per participant
agg <- aggregate(formula = correct_SOC ~ material + generation + order + PD_instruction + id, data = tmp, FUN = mean, na.rm = TRUE)

# calculate condition means and standard errors
means <- aggregate(formula = cbind(M = correct_SOC) ~ material + generation + order + PD_instruction, data = agg, FUN = mean)
SEs <- aggregate(formula = cbind(`SE` = correct_SOC) ~ material + generation + order + PD_instruction, data = agg, FUN = se)

# merge means and CI width
tab <- merge(means, SEs)

# bind Inclusion and Exclusion side-by-side
tab <- cbind(tab[tab$PD_instruction == "Inclusion", ], tab[tab$PD_instruction == "Exclusion", c("M", "SE")])
tab$PD_instruction <- NULL

tab$material <- gsub(tab$material, pattern = "-", replacement = " ", fixed = TRUE)
tab$generation <- as.character(tab$generation)
tab$generation[duplicated(paste0(tab$material, tab$generation))] <- ""
tab$material[duplicated(tab$material)] <- ""
tab

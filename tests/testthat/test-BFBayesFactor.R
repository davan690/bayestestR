if (require("testthat") && require("BayesFactor") && require("bayestestR")) {
  set.seed(333)
  x <- BayesFactor::correlationBF(y = iris$Sepal.Length, x = iris$Sepal.Width)
  test_that("p_direction", {
    expect_equal(as.numeric(p_direction(x)), 0.9225, tol = 1)
  })


  # BF t.test one sample ---------------------------
  data(sleep)
  diffScores <- sleep$extra[1:10] - sleep$extra[11:20]
  x <- BayesFactor::ttestBF(x = diffScores)
  test_that("p_direction", {
    testthat::skip_on_travis() # Until insight v3 is released
    expect_equal(as.numeric(p_direction(x)), 0.99675, tol = 1)
  })


  # BF t.test two samples ---------------------------
  data(chickwts)
  chickwts <- chickwts[chickwts$feed %in% c("horsebean", "linseed"), ]
  chickwts$feed <- factor(chickwts$feed)
  x <- BayesFactor::ttestBF(formula = weight ~ feed, data = chickwts)
  test_that("p_direction", {
    expect_equal(as.numeric(p_direction(x)), 1, tol = 1)
  })

  # BF t.test meta-analytic ---------------------------
  t <- c(-.15, 2.39, 2.42, 2.43)
  N <- c(100, 150, 97, 99)
  x <- BayesFactor::meta.ttestBF(t = t, n1 = N, rscale = 1)
  test_that("p_direction", {
    expect_equal(as.numeric(p_direction(x)), 0.99975, tol = 1)
  })

  # # ---------------------------
  # context("BF ANOVA")
  # data(ToothGrowth)
  # ToothGrowth$dose <- factor(ToothGrowth$dose)
  # levels(ToothGrowth$dose) <- c("Low", "Medium", "High")
  # x <- BayesFactor::anovaBF(len ~ supp*dose, data=ToothGrowth)
  # test_that("p_direction", {
  #   expect_equal(as.numeric(p_direction(x)), 91.9, tol=0.1)
  # })
  #
  # # ---------------------------
  # context("BF ANOVA Random")
  # data(puzzles)
  # x <- BayesFactor::anovaBF(RT ~ shape*color + ID, data = puzzles, whichRandom="ID")
  # test_that("p_direction", {
  #   expect_equal(as.numeric(p_direction(x)), 91.9, tol=0.1)
  # })
  #
  #
  # # ---------------------------
  # context("BF lm")
  # x <- BayesFactor::lmBF(len ~ supp + dose, data = ToothGrowth)
  # test_that("p_direction", {
  #   expect_equal(as.numeric(p_direction(x)), 91.9, tol=0.1)
  # })
  #
  #
  # x2 <- BayesFactor::lmBF(len ~ supp + dose + supp:dose, data = ToothGrowth)
  # x <- x / x2
  # test_that("p_direction", {
  #   expect_equal(as.numeric(p_direction(x)), 91.9, tol=0.1)
  # })


  test_that("rope_range", {
    x <- BayesFactor::lmBF(len ~ supp + dose, data = ToothGrowth)
    testthat::expect_equal(rope_range(x)[2], sd(ToothGrowth$len)/10)

    x <- BayesFactor::ttestBF(ToothGrowth$len[ToothGrowth$supp=="OJ"],
                              ToothGrowth$len[ToothGrowth$supp=="VC"])
    testthat::expect_equal(rope_range(x)[2], sd(ToothGrowth$len)/10)

    x <- BayesFactor::ttestBF(formula = len ~ supp, data = ToothGrowth)
    testthat::expect_equal(rope_range(x)[2], sd(ToothGrowth$len)/10)

    # else
    x <- BayesFactor::correlationBF(ToothGrowth$len, ToothGrowth$dose)
    testthat::expect_equal(rope_range(x), c(-0.1, 0.1))
  })

}
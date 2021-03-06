% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/collapse.R
\name{cs_collapse}
\alias{cs_collapse}
\title{Collapse Months in Year List Object into Single Tibble}
\usage{
cs_collapse(.data)
}
\arguments{
\item{.data}{A list containing monthly crime data}
}
\value{
A tibble containing all crime data in a given year-list object.
}
\description{
This function takes a year-list containing individual tibbles - one per
   month - that have been validated and collapses them into a single tibble.
}
\details{
\code{cs_collapse} applies common sense variable classes to a number
   of variables. This is motivated by issues that originate with SLMPD \code{.csv}
   files. When they are imported, the \pkg{readr} package sometimes applies
   the incorrect variable classes because of formatting issues in the tables.
   Since the tables have inconsistent variable names and numbers of variables,
   all variables are imported as \code{chr} data. During \code{cs_collapse}'s
   execution, the following changes are made:

\describe{
  \item{Count}{Converted to \code{int}}
  \item{Crime}{Converted to \code{int}}
  \item{District}{Converted to \code{int}}
  \item{ILEADSAddress}{Converted to \code{int}}
  \item{Neighborhood}{Converted to \code{int}}
  \item{CADAddress}{Converted to \code{int}}
  \item{XCoord}{Converted to \code{dbl}}
  \item{YCoord}{Converted to \code{dbl}}
}
}
\examples{
# load example year-list object
load(system.file("testdata", "yearList17.rda", package = "compstatr", mustWork = TRUE))

# validate
cs_validate(yearList17, year = 2017)

# standaridze May, which has 26 variables
yearList17 <- cs_standardize(yearList17, month = "May", config = 26)

# validate again to confirm fix
cs_validate(yearList17, year = 2017)

# collapse now that the data are valid
crimeReports17 <- cs_collapse(yearList17)

}

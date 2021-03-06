% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/last_update.R
\name{cs_last_update}
\alias{cs_last_update}
\title{Date of Last Crime Data Update from SLMPD}
\usage{
cs_last_update(output = "string")
}
\arguments{
\item{output}{A character scalar; if \code{"string"} the date will be
returned in the style of \code{"January 2019"}. If \code{"date"}
the date will be returned as a YYYY-MM-DD date object.}
}
\value{
The date of the last posted data set in the format specified
    in the \code{output} parameter.
}
\description{
Data are updated by SLMPD on their crime statistics
    site on a monthly basis. This function returns the date of the
    last update.
}
\examples{
# obtain data of last update
cs_last_update()


}

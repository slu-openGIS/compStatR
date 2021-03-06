#' Standardized Variables
#'
#' @description Different time points of SLMPD have different numbers of variables and
#'    different names for those variables that are included in both sets of releases.
#'    This function reformats non-standard configurations to a 20 variable standard.
#'
#' @details For all months prior to 2013 and approximately half of the months during
#'    2013, SLMPD data are released with 18 variables. For one month, May 2017,
#'    the data are released with 26 variables. This function can be used to either
#'    edit an entire year list object or to edit only a specified month within it.
#'    In general, years 2008 through 2012 should be edited en masse while the month
#'    specification can be used to edit the months in 2013 and 2017 that are
#'    non-standard.
#'
#' @usage cs_standardize(.data, month, config = 18)
#'
#' @param .data A tbl
#' @param month An option string name or abbreviation of a month, or its numeric value.
#'    Acceptable inputs include, for example, "January", "january", "Jan",
#'    "jan", and 1. If all months in a year-list need to be standardized (this is
#'    applicable, as of March 2019, to all years from 2008 through 2012), the
#'    month should be given as \code{"all"} to standardize them en masse.
#' @param config The non-standard configuration, either 18 or 26
#'
#' @examples
#' # load example year-list object
#' load(system.file("testdata", "yearList17.rda", package = "compstatr", mustWork = TRUE))
#'
#' # validate
#' cs_validate(yearList17, year = 2017)
#'
#' # standaridze May, which has 26 variables
#' yearList17 <- cs_standardize(yearList17, month = "May", config = 26)
#'
#' # validate again to confirm fix
#' cs_validate(yearList17, year = 2017)
#'
#' @importFrom dplyr %>%
#' @importFrom dplyr mutate
#' @importFrom dplyr rename
#' @importFrom dplyr select
#'
#' @export
cs_standardize <- function(.data, month, config = 18){

  # check for missing parameters
  if (missing(.data)) {
    stop('A existing year-list object must be specified for .data.')
  }

  if (missing(month)) {
    stop('The month to be standardized must be specified.')
  }

  if (missing(config)) {
    stop('The non-standard configuration, either 18 or 26 must be specified.')
  }

  #quote input variables

  month <- rlang::quo_name(rlang::enquo(month))


  # undefined global variables
  AdministrativeAdjustmentIndicator = Beat = `CAD-Address` = `CAD-Street` =
  CADAddress = CADStreet = `Coded Month` = CodedMonth = Complaint = Count =
  Crime = `Date Crime Coded` = `Date Occur` = DateOccur = DateOccured =
  Description = District = `Flag Cleanup` = `Flag-Administrative` =
  `Flag-Crime` = `Flag-Unfounded` = FlagAdministrative = FlagCleanup =
  FlagCrime = FlagUnfounded = `ILEADS-Address` = `ILEADS-Street` =
  ILEADSAddress = ILEADSStreet = `ILeads Add` = `ILeads Approve` =
  `ILeads Asg` = `ILeads Type` = `Location Comment` = `Location Name` =
  LocationComment = LocationName = MonthReportedtoMSHP = Neighborhood =
  NewCrimeIndicator = UnfoundedCrimeIndicator = `X-Coord` = XCoord =
  `Y-Coord` = YCoord = NULL


  if (month == "all") {
    # we only need to clean full years of 18 variables

    if (config == 18){

      df <- .data

      df[[1]] <- cs_std18(df[[1]])
      df[[2]] <- cs_std18(df[[2]])
      df[[3]] <- cs_std18(df[[3]])
      df[[4]] <- cs_std18(df[[4]])
      df[[5]] <- cs_std18(df[[5]])
      df[[6]] <- cs_std18(df[[6]])
      df[[7]] <- cs_std18(df[[7]])
      df[[8]] <- cs_std18(df[[8]])
      df[[9]] <- cs_std18(df[[9]])
      df[[10]] <- cs_std18(df[[10]])
      df[[11]] <- cs_std18(df[[11]])
      df[[12]] <- cs_std18(df[[12]])

      return(df)

    }

  } else if (month != "all") {
    # for cleaning inidivudal months, we need to pull a single month out for cleaning

    val <- cs_selectMonth(month)

    monthData <- .data[[val]]

    if (config == 18){

      cleanData <- cs_std18(monthData)

    } else if (config == 26){

      cleanData <- cs_std26(monthData)

    }else {

      stop("The given argument for 'config' does not match an acceptible input of '18' or '26'.")

    }

    .data[[val]] <- cleanData

    # return output
    return(.data)

  }

}

# standardize month with 18 variables
cs_std18 <- function(.data){

  # undefined global variables
  administrative_adjustment_indicator = cad_address = cad_street =
    coded_month = complaint = count = crime = date_occur = date_occured =
    description = district = flag_administrative = flag_cleanup = flag_crime =
    flag_unfounded = ileads_address = ileads_street = location_comment =
    location_name = month_reportedto_mshp = neighborhood =
    new_crime_indicator = unfounded_crime_indicator = x_coord = y_coord = NULL

  # clean variable names
  .data <- dplyr::rename(.data,
                         coded_month = month_reportedto_mshp,
                         flag_crime = new_crime_indicator,
                         flag_unfounded = unfounded_crime_indicator,
                         flag_administrative = administrative_adjustment_indicator,
                         date_occur = date_occured)

  # add missing variables
  .data <- dplyr::mutate(.data,
                         complaint = as.character(NA),
                         flag_cleanup = as.character(NA))

  # re-order variables
  .data <- dplyr::select(.data, complaint, coded_month, date_occur, flag_crime, flag_unfounded,
                         flag_administrative, count, flag_cleanup, crime, district, description,
                         ileads_address, ileads_street, neighborhood, location_name, location_comment,
                         cad_address, cad_street, x_coord, y_coord)

  # return output
  return(.data)

}

# standardize month with 26 variables
cs_std26 <- function(.data){

  # undefined global variables
  i_leads_add = i_leads_approve = beat = i_leads_asg = i_leads_type = date_crime_coded = NULL

  # clean month
  .data <- dplyr::select(.data, -i_leads_add, -i_leads_approve, -beat,
                         -i_leads_asg, -i_leads_type, -date_crime_coded)

  # return output
  return(.data)

}

# select month for standardization
cs_selectMonth <- function(month){

  # convert to lower case
  month <- tolower(month)

  # identify input month
  if (month == "january" | month == "jan" | month == 1){
    val <- "January"
  } else if (month == "february" | month == "feb" | month == 2){
    val <- "February"
  } else if (month == "march" | month == "mar" | month == 3){
    val <- "March"
  } else if (month == "april" | month == "apr" | month == 4){
    val <- "April"
  } else if (month == "may" | month == 5){
    val <- "May"
  } else if (month == "june" | month == "jun" | month == 6){
    val <- "June"
  } else if (month == "july" | month == "jul" | month == 7){
    val <- "July"
  } else if (month == "august" | month == "aug" | month == 8){
    val <- "August"
  } else if (month == "september" | month == "sept" | month == "sep" | month == 9){
    val <- "September"
  } else if (month == "october" | month == "oct" | month == 10){
    val <- "October"
  } else if (month == "november" | month == "nov" | month == 11){
    val <- "November"
  } else if (month == "december" | month == "dec" | month == 12){
    val <- "December"
  } else {

    stop("The given argument for month does not match an acceptible input.")

  }

  # return output
  return(val)

}

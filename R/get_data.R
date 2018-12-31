#' @title Download a single FAO bulk download file
#' @description Downloads an individual FAO bulk download file based on \code{DatasetCode}
#' @export
#' @author Markus Kainu <muuankarski@kapsi.fi>
#' @return a data_frame.
#' @examples
#'  \dontrun{
#'  get_data(DatasetCode = "QP")
#'  }
#'

get_data <- function(DatasetCode = "QP"){

  datas <- get_datalist()
  urli <- datas[datas$DatasetCode == DatasetCode,]$FileLocation
  fly <- tempfile(fileext = ".zip")
  download.file(url = urli, destfile = fly)
  dat <- read_csv(fly)
  names(dat) <- tolower(sub(" ", "_", names(dat)))
  return(dat)
}

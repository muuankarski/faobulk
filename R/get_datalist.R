#' @title Download Database description
#' @description Downloads a description file containing information on available bulk download files
#' @export
#' @details The description file XML URL is \url{http://fenixservices.fao.org/faostat/static/bulkdownloads/datasets_E.xml}.
#' @author Markus Kainu <muuankarski@kapsi.fi>
#' @return a data_frame.
#' @examples
#'  \dontrun{
#'  get_datalist()
#'  }
#'

get_datalist <- function(){

  dat <- read_xml("http://fenixservices.fao.org/faostat/static/bulkdownloads/datasets_E.xml")

  datlst <- as_list(dat)$Datasets

  dat_lst <- list()
  for(lng in 1:length(datlst)){

    tmp_data_list <- datlst[lng]$Dataset
    tmp_data_list2 <- tmp_data_list[lapply(tmp_data_list,length)>0]
    nms <- names(tmp_data_list2)

    dat_lst_nms <- list()
    for (nm in 1:length(nms)){
      dat_lst_nms[[nms[nm]]] <- tmp_data_list2[[nms[nm]]][[1]]
    }
    dat_lst[[lng]] <- do.call(bind_cols, dat_lst_nms)
  }
  outdata <- do.call(bind_rows, dat_lst)
  return(outdata)

}




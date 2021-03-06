#' Calculate proportions from observation counts
#'
#' For a given table in a \code{\link[taxa]{taxmap}} object, convert one or more
#' columns containing counts to proportions. This is meant to be used with
#' counts associated with observations (e.g. OTUs), as opposed to counts that
#' have already been summed per taxon.
#'
#' @param obj A \code{\link[taxa]{taxmap}} object
#' @param dataset The name of a table in \code{obj} that contains counts.
#' @param cols The names/indexes of columns in \code{dataset} to use. By
#'   default, all numeric columns are used. Takes one of the following inputs:
#'   \describe{
#'     \item{TRUE/FALSE:}{All/No columns will used.}
#'     \item{Character vector:}{The names of columns to use}
#'     \item{Numeric vector:}{The indexes of columns to use}
#'     \item{Vector of TRUE/FALSE of length equal to the number of columns:}{Use the columns
#'   corresponding to \code{TRUE} values.}
#'   }
#' @param other_cols Preserve in the output non-target columns present in the
#'   input data. New columns with proportions will always be on the end. The
#'   "taxon_id" column will always be preserved in the front. Takes one of the
#'   following inputs:
#'   \describe{
#'     \item{TRUE/FALSE:}{All non-target columns will be preserved or not.}
#'     \item{Character vector:}{The names of columns to preserve}
#'     \item{Numeric vector:}{The indexes of columns to preserve}
#'     \item{Vector of TRUE/FALSE of length equal to the number of columns:}{Preserve the columns
#'   corresponding to \code{TRUE} values.}
#'   }
#' @param out_names If supplied, rename the output proportion columns. Must be
#'   the same length as \code{cold}.
#'
#' @return A tibble
#'
#' @family calculations
#' 
#' @export
#' 
#' @examples
#' \dontrun{
#' # Parse dataset for examples
#' x = parse_tax_data(hmp_otus, class_cols = "lineage", class_sep = ";",
#'                    class_key = c(tax_rank = "info", tax_name = "taxon_name"),
#'                    class_regex = "^(.+)__(.+)$")
#'                    
#' # Calculate proportions for all numeric columns
#' calc_obs_props(x, "tax_data")
#' 
#' # Calculate proportions for a subset of columns
#' calc_obs_props(x, "tax_data", cols = c("700035949", "700097855", "700100489"))
#' calc_obs_props(x, "tax_data", cols = 4:6)
#' calc_obs_props(x, "tax_data", cols = startsWith(colnames(x$data$tax_data), "70001"))
#' 
#' # Including all other columns in ouput
#' calc_obs_props(x, "tax_data", other_cols = TRUE)
#' 
#' # Inlcuding specific columns in output
#' calc_obs_props(x, "tax_data", cols = c("700035949", "700097855", "700100489"),
#'                other_cols = 2:3)
#'                
#' # Rename output columns
#' calc_obs_props(x, "tax_data", cols = c("700035949", "700097855", "700100489"),
#'                out_names = c("a", "b", "c"))
#' 
#' }
calc_obs_props <- function(obj, dataset, cols = NULL, other_cols = FALSE,
                           out_names = NULL) {
  do_calc_on_num_cols(obj, dataset, cols = cols, other_cols = other_cols,
                      out_names = out_names,
                      func =  function(count_table) {
                        do.call(cbind, lapply(count_table, function(x) x / sum(x)))
                      }
  )
}


#' Replace low counts with zero
#'
#' For a given table in a \code{\link[taxa]{taxmap}} object, convert all counts
#' below a minimum number to zero. This is useful for effectively removing
#' "singletons", "doubletons", or other low abundance counts.
#'
#' @param obj A \code{\link[taxa]{taxmap}} object
#' @param dataset The name of a table in \code{obj} that contains counts.
#' @param min_count The minimum number of counts needed for a count to remain
#'   unchanged. Any could less than this will be converted to a zero. For
#'   example, \code{min_count = 2} would remove singletons.
#' @param use_total If \code{TRUE}, the \code{min_count} applies to the total
#'   count for each row (e.g. OTU counts for all samples), rather than each cell
#'   in the table. For example \code{use_total = TRUE, min_count = 10} would
#'   convert all counts of any row to zero if the total for all counts in that
#'   row was less than 10.
#' @param cols The names/indexes of columns in \code{dataset} to use. By
#'   default, all numeric columns are used. Takes one of the following inputs:
#'   \describe{
#'     \item{TRUE/FALSE:}{All/No columns will used.}
#'     \item{Character vector:}{The names of columns to use}
#'     \item{Numeric vector:}{The indexes of columns to use}
#'     \item{Vector of TRUE/FALSE of length equal to the number of columns:}{Use the columns
#'   corresponding to \code{TRUE} values.}
#'   }
#' @param other_cols Preserve in the output non-target columns present in the
#'   input data. New columns with proportions will always be on the end. The
#'   "taxon_id" column will always be preserved in the front. Takes one of the
#'   following inputs:
#'   \describe{
#'     \item{TRUE/FALSE:}{All non-target columns will be preserved or not.}
#'     \item{Character vector:}{The names of columns to preserve}
#'     \item{Numeric vector:}{The indexes of columns to preserve}
#'     \item{Vector of TRUE/FALSE of length equal to the number of columns:}{Preserve the columns
#'   corresponding to \code{TRUE} values.}
#'   }
#' @param out_names If supplied, rename the output proportion columns. Must be
#'   the same length as \code{cold}.
#'
#' @return A tibble
#'
#' @family calculations
#' 
#' @export
#' 
#' @examples
#' \dontrun{
#' # Parse dataset for examples
#' x = parse_tax_data(hmp_otus, class_cols = "lineage", class_sep = ";",
#'                    class_key = c(tax_rank = "info", tax_name = "taxon_name"),
#'                    class_regex = "^(.+)__(.+)$")
#'                    
#' # Calculate proportions for all numeric columns
#' calc_obs_props(x, "tax_data")
#' 
#' # Calculate proportions for a subset of columns
#' calc_obs_props(x, "tax_data", cols = c("700035949", "700097855", "700100489"))
#' calc_obs_props(x, "tax_data", cols = 4:6)
#' calc_obs_props(x, "tax_data", cols = startsWith(colnames(x$data$tax_data), "70001"))
#' 
#' # Including all other columns in ouput
#' calc_obs_props(x, "tax_data", other_cols = TRUE)
#' 
#' # Inlcuding specific columns in output
#' calc_obs_props(x, "tax_data", cols = c("700035949", "700097855", "700100489"),
#'                other_cols = 2:3)
#'                
#' # Rename output columns
#' calc_obs_props(x, "tax_data", cols = c("700035949", "700097855", "700100489"),
#'                out_names = c("a", "b", "c"))
#' 
#' }
zero_low_counts <- function(obj, dataset, min_count = 2, use_total = FALSE,
                            cols = NULL, other_cols = FALSE, out_names = NULL) {
  
  # Let user know paramters used
  if (use_total) {
    my_print('Converting to zero all counts in rows with totals less than ', min_count, '.')
  } else {
    my_print('Converting to zero all counts less than ', min_count, '.')
  }

  do_it <- function(count_table) {
    # Convert low counts to zero
    if (use_total) {
      row_sums <- rowSums(count_table)
      to_zero <- row_sums < min_count & row_sums > 0
      if (sum(to_zero) > 0) {
        my_print("Zeroing ", sum(to_zero), ' of ', length(to_zero),
                 ' rows with total counts less than', min_count, ': ',
                 limited_print(colnames(count_table)[to_zero], type = "silent"))
      } else {
        my_print('No rows found with total counts less than ', min_count, '.')
      }
      count_table[to_zero, ] <- 0
    } else {
      to_zero <- count_table < min_count & count_table > 0
      if (sum(to_zero) > 0) {
        my_print("Zeroing ", sum(to_zero), ' of ', length(to_zero),
                 ' counts less than ', min_count, '.')
      } else {
        my_print('No counts found less than', min_count, '.')
      }
      count_table[to_zero] <- 0
    }
    return(count_table)
  }
  
  do_calc_on_num_cols(obj, dataset, cols = cols, other_cols = other_cols,
                                out_names = out_names, func = do_it)
}


#' Calculate rarefied observation counts
#'
#' For a given table in a \code{\link[taxa]{taxmap}} object, rarefy counts to a constant total. This
#' is a wrapper around \code{\link[vegan]{rrarefy}} that automatically detects
#' which columns are numeric and handles the reformatting needed to use tibbles.
#'
#' @param obj A \code{\link[taxa]{taxmap}} object
#' @param dataset The name of a table in \code{obj} that contains counts.
#' @param sample_size The sample size counts will be rarefied to. This can be 
#'   either a single integer or a vector of integers of equal length to the 
#'   number of columns.
#' @param cols The names/indexes of columns in \code{dataset} to use. By
#'   default, all numeric columns are used. Takes one of the following inputs:
#'   \describe{
#'     \item{TRUE/FALSE:}{All/No columns will used.}
#'     \item{Character vector:}{The names of columns to use}
#'     \item{Numeric vector:}{The indexes of columns to use}
#'     \item{Vector of TRUE/FALSE of length equal to the number of columns:}{Use the columns
#'   corresponding to \code{TRUE} values.}
#'   }
#' @param other_cols Preserve in the output non-target columns present in the
#'   input data. New columns with proportions will always be on the end. The
#'   "taxon_id" column will always be preserved in the front. Takes one of the
#'   following inputs:
#'   \describe{
#'     \item{TRUE/FALSE:}{All non-target columns will be preserved or not.}
#'     \item{Character vector:}{The names of columns to preserve}
#'     \item{Numeric vector:}{The indexes of columns to preserve}
#'     \item{Vector of TRUE/FALSE of length equal to the number of columns:}{Preserve the columns
#'   corresponding to \code{TRUE} values.}
#'   }
#' @param out_names If supplied, rename the output proportion columns. Must be
#'   the same length as \code{cold}.
#'
#' @return A tibble
#'
#' @family calculations
#' 
#' @export
#' 
#' @examples
#' \dontrun{
#' # Parse dataset for examples
#' x = parse_tax_data(hmp_otus, class_cols = "lineage", class_sep = ";",
#'                    class_key = c(tax_rank = "info", tax_name = "taxon_name"),
#'                    class_regex = "^(.+)__(.+)$")
#'                    
#' # Rarefy all numeric columns
#' rarefy_obs(x, "tax_data")
#' 
#' # Rarefy a subset of columns
#' rarefy_obs(x, "tax_data", cols = c("700035949", "700097855", "700100489"))
#' rarefy_obs(x, "tax_data", cols = 4:6)
#' rarefy_obs(x, "tax_data", cols = startsWith(colnames(x$data$tax_data), "70001"))
#' 
#' # Including all other columns in ouput
#' rarefy_obs(x, "tax_data", other_cols = TRUE)
#' 
#' # Inlcuding specific columns in output
#' rarefy_obs(x, "tax_data", cols = c("700035949", "700097855", "700100489"),
#'                other_cols = 2:3)
#'                
#' # Rename output columns
#' rarefy_obs(x, "tax_data", cols = c("700035949", "700097855", "700100489"),
#'                out_names = c("a", "b", "c"))
#' 
#' }
rarefy_obs <- function(obj, dataset, sample_size = NULL, cols = NULL,
                       other_cols = FALSE, out_names = NULL) {
  do_calc_on_num_cols(obj, dataset, cols = cols, other_cols = other_cols,
                      out_names = out_names,
                      func =  function(count_table) {
                        if (is.null(sample_size)) {
                          sample_size <- min(colSums(count_table)) # Calculate minimum count if no sample size is given
                          my_print("Rarefying to ", sample_size, " since that is the lowest sample total.")
                        }
                        as.data.frame(t(vegan::rrarefy(t(count_table), sample = sample_size)))
                      }
  )
}



#' Compare groups of samples
#' 
#' Apply a function to compare data, usually abundance, from pairs of 
#' treatments/groups. By default, every pairwise combination of treatments are 
#' compared. A custom function can be supplied to perform the comparison. The
#' plotting function \code{\link{heat_tree_matrix}} is useful for visualizing
#' these results.
#' 
#' @param obj A \code{\link[taxa]{taxmap}} object
#' @param dataset The name of a table in \code{obj} that contains data for each 
#'   sample in columns.
#' @param cols The names/indexes of columns in \code{dataset} to use. By
#'   default, all numeric columns are used. Takes one of the following inputs:
#'   \describe{
#'     \item{TRUE/FALSE:}{All/No columns will used.}
#'     \item{Character vector:}{The names of columns to use}
#'     \item{Numeric vector:}{The indexes of columns to use}
#'     \item{Vector of TRUE/FALSE of length equal to the number of columns:}{Use the columns
#'   corresponding to \code{TRUE} values.}
#'   }
#' @param groups A vector defining how samples are grouped into "treatments". Must be the same
#'   order and length as \code{cols}.
#' @param func The function to apply for each comparison. For each row in 
#'   \code{dataset}, for each combination of groups, this function will 
#'   receive the data for each treatment, passed as two character vectors.
#'   Therefore the function must take at least 2 arguments corresponding to the
#'   two groups compared. The function should return a vector or list of
#'   results of a fixed length. If named, the names will be used in the output.
#'   The names should be consistent as well. A simple example is
#'   \code{function(x, y) mean(x) - mean(y)}. By default, the following function
#'   is used:
#'   \preformatted{
#'   function(abund_1, abund_2) {
#'     log_ratio <- log2(median(abund_1) / median(abund_2))
#'     if (is.nan(log_ratio)) {
#'       log_ratio <- 0
#'     }
#'     list(log2_median_ratio = log_ratio,
#'          median_diff = median(abund_1) - median(abund_2),
#'          mean_diff = mean(abund_1) - mean(abund_2),
#'          wilcox_p_value = wilcox.test(abund_1, abund_2)$p.value)
#'   }
#'   }
#' @param combinations Which combinations of groups to use. Must be a list 
#'   of vectors, each containing the names of 2 groups to compare. By 
#'   default, all pairwise combinations of groups are compared.
#' @param other_cols If \code{TRUE}, preserve all columns not in 
#'   \code{cols} in the output. If \code{FALSE}, dont keep other columns. 
#'   If a column names or indexes are supplied, only preserve those columns.
#'   
#' @return A tibble
#'   
#' @family calculations
#' 
#' @examples
#' \dontrun{
#' # Parse dataset for plotting
#' x = parse_tax_data(hmp_otus, class_cols = "lineage", class_sep = ";",
#'                    class_key = c(tax_rank = "info", tax_name = "taxon_name"),
#'                    class_regex = "^(.+)__(.+)$")
#' 
#' # Convert counts to proportions
#' x$data$otu_table <- calc_obs_props(x, dataset = "tax_data", cols = hmp_samples$sample_id)
#' 
#' # Get per-taxon counts
#' x$data$tax_table <- calc_taxon_abund(x, dataset = "otu_table", cols = hmp_samples$sample_id)
#' 
#' # Calculate difference between groups
#' x$data$diff_table <- compare_groups(x, dataset = "tax_table",
#'                                     cols = hmp_samples$sample_id,
#'                                     groups = hmp_samples$body_site)
#'
#' # Plot results (might take a few minutes)
#' heat_tree_matrix(x,
#'                  dataset = "diff_table",
#'                  node_size = n_obs,
#'                  node_label = taxon_names,
#'                  node_color = log2_median_ratio,
#'                  node_color_range = diverging_palette(),
#'                  node_color_trans = "linear",
#'                  node_color_interval = c(-3, 3),
#'                  edge_color_interval = c(-3, 3),
#'                  node_size_axis_label = "Number of OTUs",
#'                  node_color_axis_label = "Log2 ratio median proportions")
#' 
#' }
#' 
#' @export
compare_groups <- function(obj, dataset, cols, groups,
                           func = NULL, combinations = NULL,
                           other_cols = FALSE) {
  # Get abundance by sample data
  abund_data <- get_taxmap_table(obj, dataset)
  
  # Parse columns to use
  cols <- get_numeric_cols(obj, dataset, cols)
  
  # Check groups option
  groups <- check_option_groups(groups, cols)
  
  # Define defualt function
  if (is.null(func)) {
    func <- function(abund_1, abund_2) {
      log_ratio <- log2(stats::median(abund_1) / stats::median(abund_2))
      if (is.nan(log_ratio)) {
        log_ratio <- 0
      }
      list(log2_median_ratio = log_ratio,
           median_diff = stats::median(abund_1) - stats::median(abund_2),
           mean_diff = mean(abund_1) - mean(abund_2),
           wilcox_p_value = stats::wilcox.test(abund_1, abund_2)$p.value)
    }
  }
  
  # Find other columns
  #   These might be added back to the output later
  other_cols <- get_taxmap_other_cols(obj, dataset, cols, other_cols)
  
  # Get every combination of groups to compare
  if (is.null(combinations)) {
    combinations <- t(utils::combn(unique(groups), 2))
    combinations <- lapply(seq_len(nrow(combinations)), function(i) combinations[i, ])
  }
  
  # Make function to compare one pair of groups
  one_comparison <- function(treat_1, treat_2) {
    output <- lapply(seq_len(nrow(abund_data)), function(i) {
      # get samples ids for each treatment
      samples_1 <- cols[groups == treat_1]
      samples_2 <- cols[groups == treat_2]
      
      # get abundance data for each treatment
      abund_1 <- unlist(abund_data[i, samples_1])
      abund_2 <- unlist(abund_data[i, samples_2])
      
      # Run user-supplied function on abundance info
      result <- as.list(func(abund_1, abund_2))
      
      # Complain if nothing is returned
      if (length(result) == 0) {
        stop(paste0("The function supplied returned nothing when given the following data:\n",
                    '  Groups compared: "', treat_1, '" vs "', treat_2, '"\n',
                    '  Row index: ', i, '\n',
                    limited_print(abund_1, prefix = paste0('  "', treat_1, '" data: '), type = "silent"),
                    limited_print(abund_2, prefix = paste0('  "', treat_2, '" data: '), type = "silent")))
      }
      
      # If the output does not have names, add defaults
      if (is.null(names(result))) {
        if (length(result) == 1) {
          names(result) <- "value"
        } else {
          names(result) <- paste("value_", seq_along(result)) 
        }
      }
      
      do.call(data.frame, result)
    })
    
    # Combine the results for each row into a data frame
    output <- as.data.frame(do.call(rbind, output))
    
    # Add treatments compared
    output <- cbind(data.frame(stringsAsFactors = FALSE,
                               treatment_1 = treat_1,
                               treatment_2 = treat_2),
                    output)
    
    # Add in other columns if specified
    output <- cbind(abund_data[, other_cols], output)
    
    return(output)
  }
  
  # Compare all pairs of treatments and combine
  output <- lapply(seq_len(length(combinations)), function(i) {
    one_comparison(combinations[[i]][1], combinations[[i]][2])
  })
  output <- do.call(rbind, output)
  
  # Convert to tibble and return
  dplyr::as.tbl(output)
}


#' Sum observation values for each taxon
#' 
#' For a given table in a \code{\link[taxa]{taxmap}} object, sum the values in
#' each column for each taxon. This is useful to convert per-observation counts
#' (e.g. OTU counts) to per-taxon counts.
#' 
#' @param obj A \code{\link[taxa]{taxmap}} object
#' @param dataset The name of a table in \code{obj} that contains counts.
#' @param cols The names/indexes of columns in \code{dataset} to use. By
#'   default, all numeric columns are used. Takes one of the following inputs:
#'   \describe{
#'     \item{TRUE/FALSE:}{All/No columns will used.}
#'     \item{Character vector:}{The names of columns to use}
#'     \item{Numeric vector:}{The indexes of columns to use}
#'     \item{Vector of TRUE/FALSE of length equal to the number of columns:}{Use the columns
#'   corresponding to \code{TRUE} values.}
#'   }
#' @param groups Group counts of multiple columns per treatment/group. This
#'   should be a vector of group IDs (e.g. character, integer) the same
#'   length as \code{cols} that defines which samples go in which group. When
#'   used, there will be one column in the output for each unique value in
#'   \code{groups}.
#' @param out_names The names of count columns in the output. Must be the same
#'   length as \code{cols} (or \code{unique(groups)}, if used).
#'   
#' @return A tibble
#'   
#' @family calculations
#'   
#' @export
#' 
#' @examples \dontrun{
#' # Parse dataset for example
#' x = parse_tax_data(hmp_otus, class_cols = "lineage", class_sep = ";",
#'                    class_key = c(tax_rank = "info", tax_name = "taxon_name"),
#'                    class_regex = "^(.+)__(.+)$")
#'                    
#' # Calculate the taxon abundance for each numeric column (i.e. sample)
#' calc_taxon_abund(x, "tax_data")
#' 
#' # Calculate the taxon abundance for a subset of columns
#' calc_taxon_abund(x, "tax_data", cols = 4:5)
#' calc_taxon_abund(x, "tax_data", cols = c("700035949", "700097855"))
#' calc_taxon_abund(x, "tax_data", cols = startsWith(colnames(x$data$tax_data), "70001"))
#' 
#' # Calculate the taxon abundance for groups of columns (e.g. treatments)
#' #  Note that we do not need to use the "cols" option for this since all
#' #  numeric columns are samples in this dataset. If there were numeric columns
#' #  that were not samples present in hmp_samples, the "cols" would be needed.
#' calc_taxon_abund(x, "tax_data", groups = hmp_samples$sex)
#' calc_taxon_abund(x, "tax_data", groups = hmp_samples$body_site)
#' 
#' # The above example using the "cols" option, even though not needed in this case
#' calc_taxon_abund(x, "tax_data", cols = hmp_samples$sample_id,
#'                  groups = hmp_samples$sex)
#'                  
#' # Rename the output columns
#' calc_taxon_abund(x, "tax_data", cols = hmp_samples$sample_id[1:10],
#'                  out_names = letters[1:10])
#' calc_taxon_abund(x, "tax_data", groups = hmp_samples$sex,
#'                  out_names = c("Women", "Men"))
#' 
#' # Geting a total for all columns 
#' calc_taxon_abund(x, "tax_data", cols = hmp_samples$sample_id,
#'                  groups = rep("total", nrow(hmp_samples)))
#' }
#' 
calc_taxon_abund <- function(obj, dataset, cols = NULL, groups = NULL,
                             out_names = NULL) {
  
  # Get count table
  count_table <- get_taxmap_table(obj, dataset)
  
  # Parse columns to use
  cols <- get_numeric_cols(obj, dataset, cols)
  
  # Check that groups and output names make sense
  groups <- check_option_groups(groups, cols)
  if (is.null(groups)) {
    if (is.null(out_names)) { # groups and out_names are NULL
      out_names <- colnames(count_table[cols])
    } else { # groups is NULL, but out_names set
      if (length(out_names) != length(cols)) {
        stop("The length of `cols` (", length(cols),
             ") and `out_names` (", length(out_names),
             ") are not equal.")
      }
    }
    groups <- seq_along(cols)
  } else {
    if (length(groups) != length(cols)) {
      stop("`groups` (", length(groups),
           ") must be the same length as `cols` (", length(cols), ").")
    }
    if (is.null(out_names)) { # groups is set, but out_names is NULL
      if (is.numeric(groups)) {
        warning("Numeric groups used without supplying out_name. This will result in numeric column names.")
      }
      out_names <- unique(groups)
    } else { # groups and out_names are both set
      if (length(out_names) != length(unique(groups))) {
        stop("The length of 'unique(groups)' and 'out_names' are not equal")       
      }
    }
  }
  
  # Check that out_names is a character
  if (! is.null(out_names) && is.numeric(out_names)){
    warning("`out_names` is numeric. This will result in numeric column names.")
  }
  
  # Sum counts per taxon for each sample
  my_print("Summing per-taxon counts from ", length(cols), " columns ",
           ifelse(length(unique(groups)) == length(unique(cols)), "", paste0("in ", length(unique(groups)), " groups ")),
           "for ", length(obj$taxon_ids()), ' taxa')
  obs_indexes <- obj$obs(dataset)
  output <- lapply(split(cols, groups), function(col_index) {
    vapply(obs_indexes, function(i) sum(unlist(count_table[i, col_index])), numeric(1))
  })
  output <- as.data.frame(output, stringsAsFactors = FALSE)
  
  # Add taxon_id column
  output <- cbind(data.frame(taxon_id = obj$taxon_ids(), stringsAsFactors = FALSE),
                  output)
  
  # Rename cols
  colnames(output)[-1] <- out_names
  
  # Convert to tibble and return
  dplyr::as.tbl(output)
}


#' Count the number of samples
#'
#' For a given table in a \code{\link[taxa]{taxmap}} object, count the number of
#' samples with greater than zero occurrences.
#' 
#' @param obj A \code{\link[taxa]{taxmap}} object
#' @param dataset The name of a table in \code{obj} that contains counts.
#' @param cols The names/indexes of columns in \code{data} that have counts. By
#'   Default, all numeric columns in \code{data} are used.
#' @param groups Group counts of multiple columns per treatment/group. This
#'   should be a vector of group IDs (e.g. character, integer) the same length
#'   as \code{cols} that defines which samples go in which group. When used,
#'   there will be one column in the output for each unique value in
#'   \code{groups}.
#' @param out_names The names of count columns in the output. Must be the length
#'   1 or same length as \code{unique(groups)}, if used.
#' @param drop If \code{groups} is not used, return a vector of the results instead
#'   of a table with one column.
#' @param append If \code{TRUE}, append results to input table and return.
#'
#' @return A tibble
#'
#' @family calculations
#'
#' @examples
#' \dontrun{
#' # Parse dataset for example
#' x = parse_tax_data(hmp_otus, class_cols = "lineage", class_sep = ";",
#'                    class_key = c(tax_rank = "info", tax_name = "taxon_name"),
#'                    class_regex = "^(.+)__(.+)$")
#'                    
#' # Count samples with reads
#' calc_n_samples(x, dataset = "tax_data")
#' 
#' # Return a vector instead of a table
#' calc_n_samples(x, dataset = "tax_data", drop = TRUE)
#' 
#' # Only use some columns
#' calc_n_samples(x, dataset = "tax_data", cols = hmp_samples$sample_id[1:5])
#' 
#' # Return a count for each treatment
#' calc_n_samples(x, dataset = "tax_data", groups = hmp_samples$body_site)
#' 
#' # Rename output columns 
#' calc_n_samples(x, dataset = "tax_data", groups = hmp_samples$body_site,
#'                out_names = c("A", "B", "C", "D", "E"))
#' 
#' # Add results to input table
#' calc_n_samples(x, dataset = "tax_data", append = TRUE)
#' }
#' 
#' @export
calc_n_samples <- function(obj, dataset, cols = NULL, groups = NULL,
                           out_names = NULL, drop = FALSE, append = FALSE) {
  # Get count table
  count_table <- get_taxmap_table(obj, dataset)
  
  # Parse columns to use
  cols <- get_numeric_cols(obj, dataset, cols)
  
  # Check that groups and output names make sense
  groups <- check_option_groups(groups, cols)
  if (is.null(groups)) {
    if (is.null(out_names)) { # groups and out_names are NULL
      out_names <- "n_samples"
    } else { # groups is NULL, but out_names set
      if (length(out_names) != length(cols)) {
        stop("The length of 'cols' and 'out_names' are not equal")
      }
    }
    groups <- rep("placeholder", length(cols))
  } else {
    if (length(groups) != length(cols)) {
      stop("`groups` (", length(groups),
           ") must be the same length as `cols` (", length(cols), ").")
    }
    if (length(unique(groups)) != 1 && drop) {
      stop("Cannot drop second dimension since there are multiple groups specified.")
    }
    if (is.null(out_names)) { # groups is set, but out_names is NULL
      if (is.numeric(groups)) {
        warning("Numeric groups used without supplying out_name. This will result in numeric column names.")
      }
      out_names <- unique(groups)
    } else { # groups and out_names are both set
      if (length(out_names) != length(unique(groups))) {
        stop("The length of 'unique(groups)' and 'out_names' are not equal")       
      }
    }
  }
  
  # Check that out_names is a character
  if (! is.null(out_names) && is.numeric(out_names)){
    warning("`out_names` is numeric. This will result in numeric column names.")
  }
  
  # Count number of samples
  output <- lapply(split(cols, groups), function(col_index) {
    vapply(seq_len(nrow(count_table)), function(i) sum(count_table[i, col_index] > 0), integer(1))
  })
  output <- as.data.frame(output, stringsAsFactors = FALSE)
  
  # Drop second dimension
  if (drop) {
    output <- output[[1]]
    names(output) <- count_table$taxon_id
    return(output)
  } else {
    # Rename cols
    colnames(output) <- out_names
    
    # Add taxon_id column
    if (append) {
      output <- cbind(get_taxmap_table(obj, dataset),
                      output)
    } else {
      output <- cbind(data.frame(taxon_id = count_table$taxon_id, stringsAsFactors = FALSE),
                      output)
    }
    
    # Convert to tibble and return
    return(dplyr::as.tbl(output))
  }
  
}

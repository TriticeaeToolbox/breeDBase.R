#' Create Plot
#' 
#' Create a phenotyping trial Plot containing all of the provided 
#' properties.  Plot Name, Accession Name, Plot Number and Block Number 
#' are required.  All optional properties can be added as a named value 
#' in the properties list.
#' 
#' See Class \linkS4class{Plot} for all optional plot properties
#' 
#' @param plot_name The unique name for the plot (must be unique across entire database. this is often a concatenation of the trial name, the accession name, and the plot number.)
#' @param accession_name The name of the accession being tested in the plot (must exist in the database)
#' @param plot_number The sequential number for the plot in the field (e.g. 1001, 1002, 2001, 2002). these numbers should be unique for the trial.
#' @param block_number A design parameter indicating which block the plot is in
#' @param properties (optional) Additional plot properties (as a named list)
#' 
#' @examples
#' # Create plots with just the required parameters
#' plot1 <- Plot("FARM-2019-UNH_PLOT1", "SL18-UCONN-S131", 1, 1)
#' plot2 <- Plot("FARM-2019-UNH_PLOT2", "SL18-UCONN-S31", 2, 1)
#' 
#' # Create plots with optional parameters
#' plot3 <- Plot("FARM-2019-UNH_PLOT3", "SL18-UCONN-S105", 3, 1, list(row_number = 1, col_number = 3))
#' plot4 <- Plot("FARM-2019-UNH_PLOT4", "SL18-UCONN-S146", 4, 1, list(row_number = 1, col_number = 4))
#' 
#' # Create a plot with an applied treatment
#' plot5 <- Plot(
#'      "FARM-2019-UNH_PLOT5", 
#'      "SL18-UCONN-S110", 
#'      5, 
#'      1, 
#'      list(
#'          row_number = 1, 
#'          col_number = 5, 
#'          treatments = list(
#'              inoculated = TRUE
#'          )
#'      )
#' )
#' 
#' @return Plot
#' 
#' @family Trial
#' @export
Plot <- function(
    plot_name = NULL,
    accession_name = NULL,
    plot_number = NULL,
    block_number = NULL,
    properties = list()
) {

    # Check for required properties
    if ( is.null(plot_name) ) {
        stop("Cannot create Plot: plot name required")
    }
    if ( is.null(accession_name) ) {
        stop("Cannot create Plot: accession name required")
    }
    if ( is.null(plot_number) ) {
        stop("Cannot create Plot: plot number required")
    }
    if ( is.null(block_number) ) {
        stop("Cannot create Plot: block number required")
    }

    # Create Plot with required properties
    plot <- new(
        "Plot",
        plot_name = plot_name,
        accession_name = accession_name,
        plot_number = plot_number,
        block_number = block_number,
        is_a_control = if(is.null(properties$is_a_control)) FALSE else properties$is_a_control,
        rep_number = if(is.null(properties$rep_number)) NA_integer_ else properties$rep_number,
        range_number = if(is.null(properties$range_number)) NA_integer_ else properties$range_number,
        row_number = if(is.null(properties$row_number)) NA_integer_ else properties$row_number,
        col_number = if(is.null(properties$col_number)) NA_integer_ else properties$col_number,
        seedlot_name = if(is.null(properties$seedlot_name)) NA_character_ else properties$seedlot_name,
        num_seed_per_plot = if(is.null(properties$num_seed_per_plot)) NA_real_ else properties$num_seed_per_plot,
        weight_gram_seed_per_plot = if(is.null(properties$weight_gram_seed_per_plot)) NA_real_ else properties$weight_gram_seed_per_plot,
        treatments = if(is.null(properties$treatments)) list() else properties$treatments
    )

    # Return the Plot
    return(plot)

}


#' Create Plots
#' 
#' Create a set of plots from a list of Accessions (ordered by plot) and basic layout properties.
#' The plots will start in the top left corner and move across rows and down columns.  Blocks
#' will increment in the same order as plots.  If `zig_zag` is set to TRUE then rows will 
#' alternate the direction of plot numbers.
#' 
#' @param trial_name The trial name or Trial to be used for plot names (TRIAL_PLOT#)
#' @param accessions List of Accessions or Accession names in plot order (moving across rows)
#' @param max_cols (optional, default = no max) The maximum number of columns (plots) in a row
#' @param max_cols_per_block (optional, default = no max) The maximum number of columns in a block
#' @param max_rows_per_block (optional, default = no max) The maximum number of rows in a block
#' @param rep_equals_block (optional, default = TRUE) When set, the rep number will be set as the block number
#' @param max_plots_per_rep (optional, default = no max) When set, `rep_equals_block` is FALSE and the rep number will increment after each set of max plots
#' @param zig_zag (optional, default = FALSE) When TRUE, rows will alternate direction (left to right, right to left, etc)
#' @param controls (optional, default = none) A vector of plot numbers or accession names that will be used as controls
#' 
#' @examples
#' # When given a list of 18 accessions (ACC_A -> ACC_R), a max_cols of `6` 
#' # and a max_cols_per_block of `3`, the following plots will be generated:
#' #     
#' #         COL 1   COL 2   COL 3   COL 4   COL 5   COL 6
#' # ROW 1   #1      #2      #3      #4      #5      #6
#' #         ACC_A   ACC_B   ACC_C   ACC_D   ACC_E   ACC_F
#' #         BLK 1   BLK 1   BLK 1   BLK 2   BLK 2   BLK 2
#' # 
#' # ROW 2   #7      #8      #9      #10     #11     #12
#' #         ACC_G   ACC_H   ACC_I   ACC_J   ACC_K   ACC_L
#' #         BLK 1   BLK 1   BLK 1   BLK 2   BLK 2   BLK 2
#' # 
#' # ROW 3   #13     #14     #15     #16     #17     #18
#' #         ACC_M   ACC_N   ACC_O   ACC_P   ACC_Q   ACC_R
#' #         BLK 1   BLK 1   BLK 1   BLK 2   BLK 2   BLK 2
#' accessions <- lapply(LETTERS[c(1:18)], function(x) {Accession(paste0("ACC_", x), "Saccharina latissima")})
#' plots <- createPlots("TEST_TRIAL", accessions, max_cols = 6, max_cols_per_block = 3)
#' 
#' @return vector of Plots
#' 
#' @family Trial
#' @export
createPlots <- function(
    trial_name = NULL,
    accessions = NULL,
    max_cols = NULL,
    max_cols_per_block = NULL,
    max_rows_per_block = NULL,
    rep_equals_block = TRUE,
    max_plots_per_rep = NULL,
    zig_zag = FALSE,
    controls = c()
) {

    # Check required arguments
    if ( is.null(trial_name) ) {
        stop("Cannot create Plots: trial name required")
    }
    if ( is.null(accessions) ) {
        stop("Cannot create Plots: accessions required")
    }
    if ( is.null(max_cols) ) {
        max_cols <- length(accessions)
    }
    if ( is.null(max_cols_per_block) ) {
        max_cols_per_block <- max_cols
    }

    # Set trial name from Trial
    if ( is(trial_name, "Trial") ) {
        trial_name <- trial_name@trial_name
    }

    # Calculate number of rows
    count <- length(accessions)
    max_rows <- ceiling(count/max_cols)

    # Calculate the number of blocks per row
    blocks_per_row <- ceiling(max_cols/max_cols_per_block)

    # Vector of plots to return
    plots <- c()
    plot <- 1
    row_block_start <- 1
    row_block_factor <- 1
    col_block_factor <- 0
    rep_count <- 1

    # Parse each row
    for ( row in c(1:max_rows) ) {

        # Check if row should run in opposite direction
        zag <- zig_zag && row %% 2 == 0

        # Parse each column
        for ( col in c(1:max_cols) ) {

            # Adjust column for opposite direction
            col_index <- col
            if ( zag ) {
                col_index <- max_cols - col + 1
            }

            # Setup plot
            if ( plot <= count ) {                

                # Set plot and accession names
                plot_name <- paste0(trial_name, "_", "PLOT", plot)
                accession_name <- accessions[[plot]]
                if ( is(accession_name, "Accession") ) {
                    accession_name <- accession_name@accession_name
                }
                is_a_control <- accession_name %in% controls || plot %in% controls

                # Set block
                if ( zag ) {
                    col_block_factor_zag <- (blocks_per_row - 1) - col_block_factor
                    block <- row_block_start + col_block_factor_zag
                }
                else {
                    block <- row_block_start + col_block_factor    
                }

                # Increment block row index
                if ( !is.null(max_cols_per_block) ) {
                    if ( col %% max_cols_per_block == 0 ) {
                        col_block_factor <- col_block_factor + 1
                    }
                }

                # Set rep
                rep <- NA_integer_
                if ( !is.null(max_plots_per_rep) ) {
                    rep <- rep_count
                    if ( plot %% max_plots_per_rep == 0 ) {
                        rep_count <- rep_count + 1
                    }
                }
                else if ( rep_equals_block ) {
                    rep <- block
                }

                # Create the plot
                plots <- c(plots, Plot(
                    plot_name = plot_name,
                    accession_name = accession_name,
                    plot_number = plot,
                    block_number = block,
                    properties = list(
                        row_number = row,
                        col_number = col_index,
                        rep_number = rep,
                        is_a_control = is_a_control
                    )
                ))
            }

            # Increment plot number
            plot <- plot + 1

        }

        # Reset the col block factor
        col_block_factor <- 0

        # Increment row block factor after the max row per block
        if ( !is.null(max_rows_per_block) ) {
            if ( row %% max_rows_per_block == 0 ) {
                row_block_factor <- row_block_factor + 1
                row_block_start <- row_block_start + blocks_per_row
            }
        }

    }

    # Return the plots
    return(plots)

}


#' Print Plot Layout
#' 
#' Create a tibble mirroring the plot layout of the provided plots 
#' that can be printed to the console or saved to a file in order 
#' to inspect the basic plot layout.
#' 
#' @param plots The Plots to print
#' 
#' @examples
#' # Create 18 Accessions to use in the layout
#' accessions <- lapply(LETTERS[c(1:18)], function(x) {Accession(paste0("ACC_", x), "Saccharina latissima")})
#' 
#' # Create the plots with a layout of 6 columns and a block size of 3 cols by 2 rows
#' plots <- createPlots("TEST_TRIAL", accessions, 
#'      max_cols = 6, 
#'      max_cols_per_block = 3, 
#'      max_rows_per_block = 2, 
#'      zig_zag = TRUE,
#'      controls = c("ACC_D", "ACC_P")
#' )
#' 
#' # Display the layout
#' display <- printPlots(plots)
#' # ===== Row1 =====      ===== Plot 1 =====  ===== Plot 2 =====  ===== Plot 3 =====  ===== Plot 4 =====  ===== Plot 5 =====  ===== Plot 6 =====
#' # Row1: Plot Name         TEST_TRIAL_PLOT1    TEST_TRIAL_PLOT2    TEST_TRIAL_PLOT3    TEST_TRIAL_PLOT4    TEST_TRIAL_PLOT5    TEST_TRIAL_PLOT6
#' # Row1: Accession Name               ACC_A               ACC_B               ACC_C               ACC_D               ACC_E               ACC_F
#' # Row1: Block                            1                   1                   1                   2                   2                   2
#' # Row1: Control                      FALSE               FALSE               FALSE                TRUE               FALSE               FALSE
#' # ===== Row2 =====     ===== Plot 12 ===== ===== Plot 11 ===== ===== Plot 10 =====  ===== Plot 9 =====  ===== Plot 8 =====  ===== Plot 7 =====
#' # Row2: Plot Name        TEST_TRIAL_PLOT12   TEST_TRIAL_PLOT11   TEST_TRIAL_PLOT10    TEST_TRIAL_PLOT9    TEST_TRIAL_PLOT8    TEST_TRIAL_PLOT7
#' # Row2: Accession Name               ACC_L               ACC_K               ACC_J               ACC_I               ACC_H               ACC_G
#' # Row2: Block                            1                   1                   1                   2                   2                   2
#' # Row2: Control                      FALSE               FALSE               FALSE               FALSE               FALSE               FALSE
#' # ===== Row3 =====     ===== Plot 13 ===== ===== Plot 14 ===== ===== Plot 15 ===== ===== Plot 16 ===== ===== Plot 17 ===== ===== Plot 18 =====
#' # Row3: Plot Name        TEST_TRIAL_PLOT13   TEST_TRIAL_PLOT14   TEST_TRIAL_PLOT15   TEST_TRIAL_PLOT16   TEST_TRIAL_PLOT17   TEST_TRIAL_PLOT18
#' # Row3: Accession Name               ACC_M               ACC_N               ACC_O               ACC_P               ACC_Q               ACC_R
#' # Row3: Block                            3                   3                   3                   4                   4                   4
#' # Row3: Control                      FALSE               FALSE               FALSE                TRUE               FALSE               FALSE
#' 
#' 
#' @family Trial
#' @import tibble
#' @export
printPlots <- function(plots) {

    # Get the layout dimensions
    max_cols <- 1
    max_rows <- 1
    for ( plot in plots ) {
        if ( plot@col_number > max_cols ) {
            max_cols <- plot@col_number
        }
        if ( plot@row_number > max_rows ) {
            max_rows <- plot@row_number
        }
    }

    # Tibble of plot layout to display
    rtn <- tibble()

    # Add Columns
    for ( i in c(1:max_cols) ) {
        rtn <- add_column(rtn, !!(paste0("Col", i)) := NA)
    }

    # Add Rows
    row_names <- c()
    headers <- c("Plot #", "Plot Name", "Accession Name", "Block", "Rep", "Control")
    for ( i in c(1:max_rows) ) {
        rtn <- add_row(rtn)
        row_names <- c(row_names, paste0("===== Row", i, " ====="))
        for ( j in c(2:length(headers)) ) {
            header <- headers[j]
            rtn <- add_row(rtn)
            row_names <- c(row_names, paste0("Row", i, ": ", header))
        }
    }
    
    # Set Row Names
    rtn$row_names <- row_names
    rtn <- remove_rownames(rtn)
    rtn <- column_to_rownames(rtn, var = "row_names")

    # Plot Index
    index <- 1

    # Parse each plot
    for ( plot in plots ) {

        # Calculate starting table row
        table_row_start <- (plot@row_number * length(headers)) - (length(headers) - 1)

        # Add Values to Table
        rtn[table_row_start, plot@col_number] <- paste0("===== Plot ", plot@plot_number, " =====")
        rtn[table_row_start+1, plot@col_number] <- plot@plot_name
        rtn[table_row_start+2, plot@col_number] <- plot@accession_name
        rtn[table_row_start+3, plot@col_number] <- plot@block_number
        rtn[table_row_start+4, plot@col_number] <- plot@rep_number
        rtn[table_row_start+5, plot@col_number] <- plot@is_a_control

    }

    # Return the tibble
    return(rtn)

}


#' Build Plot Template
#' 
#' Create a \code{tibble} representing the breeDBase upload 
#' template for the provided plots
#' 
#' @param plots Vector of Plots to add to the template
#' 
#' @return A \code{tibble} representation of the upload template
#' 
#' @family Trial
#' @import dplyr tibble
#' @export
buildPlotTemplate <- function(
    plots = NULL
) {

    # Set template headers
    template <- tibble::tibble(
        "plot_name" = character(),
        "accession_name" = character(),
        "plot_number" = numeric(),
        "block_number" = numeric(),
        "is_a_control" = logical(),
        "rep_number" = numeric(),
        "range_number" = numeric(),
        "row_number" = numeric(),
        "col_number" = numeric(),
        "seedlot_name" = character(),
        "num_seed_per_plot" = numeric(),
        "weight_gram_seed_per_plot" = numeric()
    )

    # Return blank template if no plots provided
    if ( is.null(plots) ) {
        return(template)
    }

    # Ensure a vector
    plots <- c(plots)

    # Parse each plot
    for ( plot in plots ) {
        row <- tibble::tibble(
            "plot_name" = plot@plot_name,
            "accession_name" = plot@accession_name,
            "plot_number" = plot@plot_number,
            "block_number" = plot@block_number,
            "is_a_control" = ifelse(plot@is_a_control, 1, NA),
            "rep_number" = plot@rep_number,
            "range_number" = plot@range_number,
            "row_number" = plot@row_number,
            "col_number" = plot@col_number,
            "seedlot_name" = plot@seedlot_name,
            "num_seed_per_plot" = plot@num_seed_per_plot,
            "weight_gram_seed_per_plot" = plot@weight_gram_seed_per_plot
        )

        # Add treatments, if provided
        for ( treatment in names(plot@treatments) ) {
            if ( plot@treatments[[treatment]] ) {
                row[[treatment]] <- 1
            }
        }

        template <- dplyr::bind_rows(template, row)
    }

    # Clean template
    for ( name in names(template) ) {
        template[name][which(template[name] == ""),] <- NA
    }

    # Return the template
    return(template)

}


#' Write Plot Template
#' 
#' Write a breeDBase upload template (.xls file) for plots
#' 
#' @param input Either a vector of Plots to include in the template OR 
#' a \code{tibble} representation of the upload template
#' @param output The file path to the output .xls file
#' 
#' @family Trial
#' @import WriteXLS
#' @export
writePlotTemplate <- function(
    input = NULL,
    output = NULL
) {

    # Check for required arguments
    if ( is.null(input) ) {
        stop("Cannot write Plot Template file: input of a template as a tibble or vector of plots is required")
    }
    if ( is.null(output) ) {
        stop("Cannot write Plot Template file: output of the file path to the .xls file is required")
    }

    # Create template if not provided one
    if ( !("tbl_df" %in% is(input)) ) {
        input <- buildPlotTemplate(input)
    }

    # Set output extension
    if ( !grepl("\\.xls$", output) ) {
        output <- paste(output, ".xls", sep="")
    }

    # Write the entire file
    else {
        print(sprintf("Writing Plot Template: %s", output))
        WriteXLS::WriteXLS(input, output)
    }

}




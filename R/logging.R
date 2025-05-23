#------------------------------------------------------------------------------#
#
#                 _         _    _      _                _
#                (_)       | |  | |    | |              | |
#   _ __    ___   _  _ __  | |_ | |__  | |  __ _  _ __  | | __
#  | '_ \  / _ \ | || '_ \ | __|| '_ \ | | / _` || '_ \ | |/ /
#  | |_) || (_) || || | | || |_ | |_) || || (_| || | | ||   <
#  | .__/  \___/ |_||_| |_| \__||_.__/ |_| \__,_||_| |_||_|\_\
#  | |
#  |_|
#
#  This file is part of the 'rstudio/pointblank' project.
#
#  Copyright (c) 2017-2025 pointblank authors
#
#  For full copyright and license information, please look at
#  https://rstudio.github.io/pointblank/LICENSE.html
#
#------------------------------------------------------------------------------#


# nocov start

#' Enable logging of failure conditions at the validation step level
#'
#' @description
#'
#' The `log4r_step()` function can be used as an action in the [action_levels()]
#' function (as a list component for the `fns` list). Place a call to this
#' function in every failure condition that should produce a log (i.e., `warn`,
#' `stop`, `notify`). Only the failure condition with the highest severity for a
#' given validation step will produce a log entry (skipping failure conditions
#' with lower severity) so long as the call to `log4r_step()` is present.
#'
#' @param x A reference to the x-list object prepared by the `agent`. This
#'   version of the x-list is the same as that generated via
#'   `get_agent_x_list(<agent>, i = <step>)` except this version is internally
#'   generated and hence only available in an internal evaluation context.
#'
#' @param message The message to use for the log entry. When not provided, a
#'   default glue string is used for the messaging. This is dynamic since the
#'   internal `glue::glue()` call occurs in the same environment as `x`, the
#'   x-list that's constrained to the validation step. The default message, used
#'   when `message = NULL` is the glue string `"Step {x$i} exceeded the {level}
#'   failure threshold (f_failed = {x$f_failed}) ['{x$type}']"`. As can be seen,
#'   a custom message can be crafted that uses other elements of the x-list with
#'   the `{x$<component>}` construction.
#'
#' @param append_to The file to which log entries at the warn level are
#'   appended. This can alternatively be one or more **log4r** appenders.
#'
#' @return Nothing is returned however log files may be written in very specific
#'   conditions.
#'
#' @section YAML:
#'
#' A **pointblank** agent can be written to YAML with [yaml_write()] and the
#' resulting YAML can be used to regenerate an agent (with [yaml_read_agent()])
#' or interrogate the target table (via [yaml_agent_interrogate()]). Here is an
#' example of how `log4r_step()` can be expressed in R code (within
#' [action_levels()], itself inside [create_agent()]) and in the corresponding
#' YAML representation.
#'
#' R statement:
#'
#' ```r
#' create_agent(
#'   tbl = ~ small_table,
#'   tbl_name = "small_table",
#'   label = "An example.",
#'   actions = action_levels(
#'     warn_at = 1,
#'     fns = list(
#'       warn = ~ log4r_step(
#'         x, append_to = "example_log"
#'       )
#'     )
#'   )
#' )
#' ```
#'
#' YAML representation:
#'
#' ```yaml
#' type: agent
#' tbl: ~small_table
#' tbl_name: small_table
#' label: An example.
#' lang: en
#' locale: en
#' actions:
#'   warn_count: 1.0
#'   fns:
#'     warn: ~log4r_step(x, append_to = "example_log")
#' steps: []
#' ```
#'
#' Should you need to preview the transformation of an *agent* to YAML (without
#' any committing anything to disk), use the [yaml_agent_string()] function. If
#' you already have a `.yml` file that holds an *agent*, you can get a glimpse
#' of the R expressions that are used to regenerate that agent with
#' [yaml_agent_show_exprs()].
#'
#' @section Examples:
#'
#' For the example provided here, we'll use the included `small_table` dataset.
#' We are also going to create an `action_levels()` list object since this is
#' useful for demonstrating a logging scenario. It will have a threshold for
#' the `warn` state, and, an associated function that should be invoked
#' whenever the `warn` state is entered. Here, the function call with
#' `log4r_step()` will be invoked whenever there is one failing test unit.
#'
#' ```{r}
#' al <-
#'   action_levels(
#'     warn_at = 1,
#'     fns = list(
#'       warn = ~ log4r_step(
#'         x, append_to = "example_log"
#'       )
#'     )
#'   )
#' ```
#'
#' Within the [action_levels()]-produced object, it's important to match things
#' up: notice that `warn_at` is given a threshold and the list of functions
#' given to `fns` has a `warn` component.
#'
#' Printing `al` will show us the settings for the `action_levels` object:
#'
#' ```{r}
#' al
#' ```
#'
#' Let's create an agent with `small_table` as the target table. We'll apply the
#' `action_levels` object created above as `al`, add two validation steps, and
#' then [interrogate()] the data.
#'
#' ```r
#' agent <-
#'   create_agent(
#'     tbl = ~ small_table,
#'     tbl_name = "small_table",
#'     label = "An example.",
#'     actions = al
#'   ) %>%
#'   col_vals_gt(columns = d, 300) %>%
#'   col_vals_in_set(columns = f, c("low", "high")) %>%
#'   interrogate()
#'
#' agent
#' ```
#'
#' \if{html}{
#' \out{
#' `r pb_get_image_tag(file = "man_log4r_step_1.png")`
#' }
#' }
#'
#' From the agent report, we can see that both steps have yielded warnings upon
#' interrogation (i.e., filled yellow circles in the `W` column).
#'
#' What's not immediately apparent is that when entering the `warn` state
#' in each validation step during interrogation, the `log4r_step()` function
#' call was twice invoked! This generated an `"example_log"` file in the working
#' directory (since it was not present before the interrogation) and log entries
#' were appended to the file. Here are the contents of the file:
#'
#' ```
#' WARN  [2022-06-28 10:06:01] Step 1 exceeded the WARN failure threshold
#'   (f_failed = 0.15385) ['col_vals_gt']
#' WARN  [2022-06-28 10:06:01] Step 2 exceeded the WARN failure threshold
#'   (f_failed = 0.15385) ['col_vals_in_set']
#' ```
#'
#' @family Logging
#' @section Function ID:
#' 5-1
#'
#' @export
log4r_step <- function(
    x,
    message = NULL,
    append_to = "pb_log_file"
) {

  rlang::check_installed("log4r", "to use the `log4r_step()` function.")

  type <- x$this_type
  warn_val <- x$warn
  stop_val <- x$stop
  notify_val <- x$notify

  log4r_fn_present <-
    vapply(
      c("warn", "stop", "notify"),
      FUN.VALUE = logical(1),
      USE.NAMES = FALSE,
      FUN = function(y) {
        grepl(
          "log4r_step(x",
          paste(
            as.character(x$actions[[paste0("fns.", y)]]),
            collapse = ""
          ),
          fixed = TRUE
        )
      }
    )
  level <- toupper(type)

  level_val <-
    switch(
      level,
      "WARN" = 3,
      "STOP" = 4,
      "NOTIFY" = 5,
      3
    )

  # Skip logging at this level if a higher severity
  # condition is present for this validation step *and*
  # there is a `log4r_step()` function ready for
  # evaluation at those higher severities
  if (warn_val   && log4r_fn_present[1]) highest_level <- 3
  if (stop_val   && log4r_fn_present[2]) highest_level <- 4
  if (notify_val && log4r_fn_present[3]) highest_level <- 5

  if (highest_level > level_val) {
    return(invisible(NULL))
  }

  if (is.character(append_to)) {
    appenders <- log4r::file_appender(file = append_to[1])
  }

  logger <- log4r::logger(appenders = appenders)

  log4r::levellog(
    logger = logger,
    level = level_val,
    message = glue::glue(
      "Step {x$i} exceeded the {level} failure threshold \\
      (f_failed = {x$f_failed}) ['{x$type}']"
    )
  )
}

# nocov end

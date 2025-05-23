% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/col_vals_expr.R
\name{col_vals_expr}
\alias{col_vals_expr}
\alias{expect_col_vals_expr}
\alias{test_col_vals_expr}
\title{Do column data agree with a predicate expression?}
\usage{
col_vals_expr(
  x,
  expr,
  na_pass = FALSE,
  preconditions = NULL,
  segments = NULL,
  actions = NULL,
  step_id = NULL,
  label = NULL,
  brief = NULL,
  active = TRUE
)

expect_col_vals_expr(
  object,
  expr,
  na_pass = FALSE,
  preconditions = NULL,
  threshold = 1
)

test_col_vals_expr(
  object,
  expr,
  na_pass = FALSE,
  preconditions = NULL,
  threshold = 1
)
}
\arguments{
\item{x}{\emph{A pointblank agent or a data table}

\verb{obj:<ptblank_agent>|obj:<tbl_*>} // \strong{required}

A data frame, tibble (\code{tbl_df} or \code{tbl_dbi}), Spark DataFrame
(\code{tbl_spark}), or, an \emph{agent} object of class \code{ptblank_agent} that is
commonly created with \code{\link[=create_agent]{create_agent()}}.}

\item{expr}{\emph{Predicate expression}

\verb{<predicate expression>} // \strong{required}

A predicate expression to use for this validation. This can either be in
the form of a call made with the \code{expr()} function or as a one-sided \strong{R}
formula (using a leading \code{~}).}

\item{na_pass}{\emph{Allow missing values to pass validation}

\verb{scalar<logical>} // \emph{default:} \code{FALSE}

Should any encountered \code{NA} values be considered as passing test units? By
default, this is \code{FALSE}. Set to \code{TRUE} to give \code{NA}s a pass.}

\item{preconditions}{\emph{Input table modification prior to validation}

\verb{<table mutation expression>} // \emph{default:} \code{NULL} (\code{optional})

An optional expression for mutating the input table before proceeding with
the validation. This can either be provided as a one-sided R formula using
a leading \code{~} (e.g., \code{~ . \%>\% dplyr::mutate(col = col + 10)} or as a
function (e.g., \code{function(x) dplyr::mutate(x, col = col + 10)}. See the
\emph{Preconditions} section for more information.}

\item{segments}{\emph{Expressions for segmenting the target table}

\verb{<segmentation expressions>} // \emph{default:} \code{NULL} (\code{optional})

An optional expression or set of expressions (held in a list) that serve to
segment the target table by column values. Each expression can be given in
one of two ways: (1) as column names, or (2) as a two-sided formula where
the LHS holds a column name and the RHS contains the column values to
segment on. See the \emph{Segments} section for more details on this.}

\item{actions}{\emph{Thresholds and actions for different states}

\verb{obj:<action_levels>} // \emph{default:} \code{NULL} (\code{optional})

A list containing threshold levels so that the validation step can react
accordingly when exceeding the set levels for different states. This is to
be created with the \code{\link[=action_levels]{action_levels()}} helper function.}

\item{step_id}{\emph{Manual setting of the step ID value}

\verb{scalar<character>} // \emph{default:} \code{NULL} (\code{optional})

One or more optional identifiers for the single or multiple validation
steps generated from calling a validation function. The use of step IDs
serves to distinguish validation steps from each other and provide an
opportunity for supplying a more meaningful label compared to the step
index. By default this is \code{NULL}, and \strong{pointblank} will automatically
generate the step ID value (based on the step index) in this case. One or
more values can be provided, and the exact number of ID values should (1)
match the number of validation steps that the validation function call will
produce (influenced by the number of \code{columns} provided), (2) be an ID
string not used in any previous validation step, and (3) be a vector with
unique values.}

\item{label}{\emph{Optional label for the validation step}

\verb{vector<character>} // \emph{default:} \code{NULL} (\code{optional})

Optional label for the validation step. This label appears in the \emph{agent}
report and, for the best appearance, it should be kept quite short. See
the \emph{Labels} section for more information.}

\item{brief}{\emph{Brief description for the validation step}

\verb{scalar<character>} // \emph{default:} \code{NULL} (\code{optional})

A \emph{brief} is a short, text-based description for the validation step. If
nothing is provided here then an \emph{autobrief} is generated by the \emph{agent},
using the language provided in \code{\link[=create_agent]{create_agent()}}'s \code{lang} argument (which
defaults to \code{"en"} or English). The \emph{autobrief} incorporates details of the
validation step so it's often the preferred option in most cases (where a
\code{label} might be better suited to succinctly describe the validation).}

\item{active}{\emph{Is the validation step active?}

\verb{scalar<logical>} // \emph{default:} \code{TRUE}

A logical value indicating whether the validation step should be active. If
the validation function is working with an \emph{agent}, \code{FALSE} will make the
validation step inactive (still reporting its presence and keeping indexes
for the steps unchanged). If the validation function will be operating
directly on data (no \emph{agent} involvement), then any step with \code{active = FALSE} will simply pass the data through with no validation whatsoever.
Aside from a logical vector, a one-sided R formula using a leading \code{~} can
be used with \code{.} (serving as the input data table) to evaluate to a single
logical value. With this approach, the \strong{pointblank} function
\code{\link[=has_columns]{has_columns()}} can be used to determine whether to make a validation step
active on the basis of one or more columns existing in the table
(e.g., \code{~ . \%>\% has_columns(c(d, e))}).}

\item{object}{\emph{A data table for expectations or tests}

\verb{obj:<tbl_*>} // \strong{required}

A data frame, tibble (\code{tbl_df} or \code{tbl_dbi}), or Spark DataFrame
(\code{tbl_spark}) that serves as the target table for the expectation function
or the test function.}

\item{threshold}{\emph{The failure threshold}

\code{scalar<integer|numeric>(val>=0)} // \emph{default:} \code{1}

A simple failure threshold value for use with the expectation (\code{expect_})
and the test (\code{test_}) function variants. By default, this is set to \code{1}
meaning that any single unit of failure in data validation results in an
overall test failure. Whole numbers beyond \code{1} indicate that any failing
units up to that absolute threshold value will result in a succeeding
\strong{testthat} test or evaluate to \code{TRUE}. Likewise, fractional values
(between \code{0} and \code{1}) act as a proportional failure threshold, where \code{0.15}
means that 15 percent of failing test units results in an overall test
failure.}
}
\value{
For the validation function, the return value is either a
\code{ptblank_agent} object or a table object (depending on whether an agent
object or a table was passed to \code{x}). The expectation function invisibly
returns its input but, in the context of testing data, the function is
called primarily for its potential side-effects (e.g., signaling failure).
The test function returns a logical value.
}
\description{
The \code{col_vals_expr()} validation function, the \code{expect_col_vals_expr()}
expectation function, and the \code{test_col_vals_expr()} test function all check
whether column values in a table agree with a user-defined predicate
expression. The validation function can be used directly on a data table or
with an \emph{agent} object (technically, a \code{ptblank_agent} object) whereas the
expectation and test functions can only be used with a data table. Each
validation step or expectation will operate over the number of test units
that is equal to the number of rows in the table (after any \code{preconditions}
have been applied).
}
\section{Supported Input Tables}{


The types of data tables that are officially supported are:
\itemize{
\item data frames (\code{data.frame}) and tibbles (\code{tbl_df})
\item Spark DataFrames (\code{tbl_spark})
\item the following database tables (\code{tbl_dbi}):
\itemize{
\item \emph{PostgreSQL} tables (using the \code{RPostgres::Postgres()} as driver)
\item \emph{MySQL} tables (with \code{RMySQL::MySQL()})
\item \emph{Microsoft SQL Server} tables (via \strong{odbc})
\item \emph{BigQuery} tables (using \code{bigrquery::bigquery()})
\item \emph{DuckDB} tables (through \code{duckdb::duckdb()})
\item \emph{SQLite} (with \code{RSQLite::SQLite()})
}
}

Other database tables may work to varying degrees but they haven't been
formally tested (so be mindful of this when using unsupported backends with
\strong{pointblank}).
}

\section{Missing Values}{


This validation function supports special handling of \code{NA} values. The
\code{na_pass} argument will determine whether an \code{NA} value appearing in a test
unit should be counted as a \emph{pass} or a \emph{fail}. The default of \code{na_pass = FALSE} means that any \code{NA}s encountered will accumulate failing test units.
}

\section{Preconditions}{


Providing expressions as \code{preconditions} means \strong{pointblank} will preprocess
the target table during interrogation as a preparatory step. It might happen
that a particular validation requires a calculated column, some filtering of
rows, or the addition of columns via a join, etc. Especially for an
\emph{agent}-based report this can be advantageous since we can develop a large
validation plan with a single target table and make minor adjustments to it,
as needed, along the way.

The table mutation is totally isolated in scope to the validation step(s)
where \code{preconditions} is used. Using \strong{dplyr} code is suggested here since
the statements can be translated to SQL if necessary (i.e., if the target
table resides in a database). The code is most easily supplied as a one-sided
\strong{R} formula (using a leading \code{~}). In the formula representation, the \code{.}
serves as the input data table to be transformed (e.g., \code{~ . \%>\% dplyr::mutate(col_b = col_a + 10)}). Alternatively, a function could instead
be supplied (e.g., \code{function(x) dplyr::mutate(x, col_b = col_a + 10)}).
}

\section{Segments}{


By using the \code{segments} argument, it's possible to define a particular
validation with segments (or row slices) of the target table. An optional
expression or set of expressions that serve to segment the target table by
column values. Each expression can be given in one of two ways: (1) as column
names, or (2) as a two-sided formula where the LHS holds a column name and
the RHS contains the column values to segment on.

As an example of the first type of expression that can be used,
\code{vars(a_column)} will segment the target table in however many unique values
are present in the column called \code{a_column}. This is great if every unique
value in a particular column (like different locations, or different dates)
requires it's own repeating validation.

With a formula, we can be more selective with which column values should be
used for segmentation. Using \code{a_column ~ c("group_1", "group_2")} will
attempt to obtain two segments where one is a slice of data where the value
\code{"group_1"} exists in the column named \code{"a_column"}, and, the other is a
slice where \code{"group_2"} exists in the same column. Each group of rows
resolved from the formula will result in a separate validation step.

If there are multiple \code{columns} specified then the potential number of
validation steps will be \code{m} columns multiplied by \code{n} segments resolved.

Segmentation will always occur after \code{preconditions} (i.e., statements that
mutate the target table), if any, are applied. With this type of one-two
combo, it's possible to generate labels for segmentation using an expression
for \code{preconditions} and refer to those labels in \code{segments} without having to
generate a separate version of the target table.
}

\section{Actions}{


Often, we will want to specify \code{actions} for the validation. This argument,
present in every validation function, takes a specially-crafted list
object that is best produced by the \code{\link[=action_levels]{action_levels()}} function. Read that
function's documentation for the lowdown on how to create reactions to
above-threshold failure levels in validation. The basic gist is that you'll
want at least a single threshold level (specified as either the fraction of
test units failed, or, an absolute value), often using the \code{warn_at}
argument. This is especially true when \code{x} is a table object because,
otherwise, nothing happens. For the \verb{col_vals_*()}-type functions, using
\code{action_levels(warn_at = 0.25)} or \code{action_levels(stop_at = 0.25)} are good
choices depending on the situation (the first produces a warning when a
quarter of the total test units fails, the other \code{stop()}s at the same
threshold level).
}

\section{Labels}{


\code{label} may be a single string or a character vector that matches the number
of expanded steps. \code{label} also supports \code{{glue}} syntax and exposes the
following dynamic variables contextualized to the current step:
\itemize{
\item \code{"{.step}"}: The validation step name
\item \code{"{.col}"}: The current column name
\item \code{"{.seg_col}"}: The current segment's column name
\item \code{"{.seg_val}"}: The current segment's value/group
}

The glue context also supports ordinary expressions for further flexibility
(e.g., \code{"{toupper(.step)}"}) as long as they return a length-1 string.
}

\section{Briefs}{


Want to describe this validation step in some detail? Keep in mind that this
is only useful if \code{x} is an \emph{agent}. If that's the case, \code{brief} the agent
with some text that fits. Don't worry if you don't want to do it. The
\emph{autobrief} protocol is kicked in when \code{brief = NULL} and a simple brief will
then be automatically generated.
}

\section{YAML}{


A \strong{pointblank} agent can be written to YAML with \code{\link[=yaml_write]{yaml_write()}} and the
resulting YAML can be used to regenerate an agent (with \code{\link[=yaml_read_agent]{yaml_read_agent()}})
or interrogate the target table (via \code{\link[=yaml_agent_interrogate]{yaml_agent_interrogate()}}). When
\code{col_vals_expr()} is represented in YAML (under the top-level \code{steps} key as
a list member), the syntax closely follows the signature of the validation
function. Here is an example of how a complex call of \code{col_vals_expr()} as a
validation step is expressed in R code and in the corresponding YAML
representation.

R statement:

\if{html}{\out{<div class="sourceCode r">}}\preformatted{agent \%>\%
  col_vals_expr(
    expr = ~ a \%\% 1 == 0,
    preconditions = ~ . \%>\% dplyr::filter(a < 10),
    segments = b ~ c("group_1", "group_2"),
    actions = action_levels(warn_at = 0.1, stop_at = 0.2),
    label = "The `col_vals_expr()` step.",
    active = FALSE
  )
}\if{html}{\out{</div>}}

YAML representation:

\if{html}{\out{<div class="sourceCode yaml">}}\preformatted{steps:
- col_vals_expr:
    expr: ~a\%\%1 == 0
    preconditions: ~. \%>\% dplyr::filter(a < 10)
    segments: b ~ c("group_1", "group_2")
    actions:
      warn_fraction: 0.1
      stop_fraction: 0.2
    label: The `col_vals_expr()` step.
    active: false
}\if{html}{\out{</div>}}

In practice, both of these will often be shorter as only the \code{expr} argument
requires a value. Arguments with default values won't be written to YAML when
using \code{\link[=yaml_write]{yaml_write()}} (though it is acceptable to include them with their
default when generating the YAML by other means). It is also possible to
preview the transformation of an agent to YAML without any writing to disk by
using the \code{\link[=yaml_agent_string]{yaml_agent_string()}} function.
}

\section{Examples}{


For all of the examples here, we'll use a simple table with three numeric
columns (\code{a}, \code{b}, and \code{c}) and three character columns (\code{d}, \code{e}, and \code{f}).

\if{html}{\out{<div class="sourceCode r">}}\preformatted{tbl <-
  dplyr::tibble(
    a = c(1, 2, 1, 7, 8, 6),
    b = c(0, 0, 0, 1, 1, 1),
    c = c(0.5, 0.3, 0.8, 1.4, 1.9, 1.2),
  )

tbl
#> # A tibble: 6 x 3
#>       a     b     c
#>   <dbl> <dbl> <dbl>
#> 1     1     0   0.5
#> 2     2     0   0.3
#> 3     1     0   0.8
#> 4     7     1   1.4
#> 5     8     1   1.9
#> 6     6     1   1.2
}\if{html}{\out{</div>}}
\subsection{A: Using an \code{agent} with validation functions and then \code{interrogate()}}{

Validate that values in column \code{a} are integer-like by using the R modulo
operator and expecting \code{0}. We'll determine if this validation has any
failing test units (there are 6 test units, one for each row).

\if{html}{\out{<div class="sourceCode r">}}\preformatted{agent <-
  create_agent(tbl = tbl) \%>\%
  col_vals_expr(expr = expr(a \%\% 1 == 0)) \%>\%
  interrogate()
}\if{html}{\out{</div>}}

Printing the \code{agent} in the console shows the validation report in the
Viewer. Here is an excerpt of validation report, showing the single entry
that corresponds to the validation step demonstrated here.

\if{html}{
\out{
<img src="https://raw.githubusercontent.com/rstudio/pointblank/main/images/man_col_vals_expr_1.png" alt="This image was generated from the first code example in the `col_vals_expr()` help file." style="width:100\%;">
}
}
}

\subsection{B: Using the validation function directly on the data (no \code{agent})}{

This way of using validation functions acts as a data filter. Data is passed
through but should \code{stop()} if there is a single test unit failing. The
behavior of side effects can be customized with the \code{actions} option.

\if{html}{\out{<div class="sourceCode r">}}\preformatted{tbl \%>\%
  col_vals_expr(expr = expr(a \%\% 1 == 0)) \%>\%
  dplyr::pull(a)
#> [1] 1 2 1 7 8 6
}\if{html}{\out{</div>}}
}

\subsection{C: Using the expectation function}{

With the \verb{expect_*()} form, we would typically perform one validation at a
time. This is primarily used in \strong{testthat} tests.

\if{html}{\out{<div class="sourceCode r">}}\preformatted{expect_col_vals_expr(tbl, expr = ~ a \%\% 1 == 0)
}\if{html}{\out{</div>}}
}

\subsection{D: Using the test function}{

With the \verb{test_*()} form, we should get a single logical value returned to
us.

\if{html}{\out{<div class="sourceCode r">}}\preformatted{test_col_vals_expr(tbl, expr = ~ a \%\% 1 == 0)
#> [1] TRUE
}\if{html}{\out{</div>}}
}

\subsection{Variations}{

We can do more complex things by taking advantage of the \code{case_when()} and
\code{between()} functions (available for use in the \strong{pointblank} package).

\if{html}{\out{<div class="sourceCode r">}}\preformatted{tbl \%>\%
  test_col_vals_expr(expr = ~ case_when(
    b == 0 ~ a \%>\% between(0, 5) & c < 1,
    b == 1 ~ a > 5 & c >= 1
  ))
#> [1] TRUE
}\if{html}{\out{</div>}}

If you only want to test a subset of rows, then the \code{case_when()} statement
doesn't need to be exhaustive. Any rows that don't fall into the cases will
be pruned (giving us less test units overall).

\if{html}{\out{<div class="sourceCode r">}}\preformatted{tbl \%>\%
  test_col_vals_expr(expr = ~ case_when(
    b == 1 ~ a > 5 & c >= 1
  ))
#> [1] TRUE
}\if{html}{\out{</div>}}
}
}

\section{Function ID}{

2-19
}

\seealso{
These reexported functions (from \strong{rlang} and \strong{dplyr}) work
nicely within \code{col_vals_expr()} and its variants: \code{\link[rlang:expr]{rlang::expr()}},
\code{\link[dplyr:between]{dplyr::between()}}, and \code{\link[dplyr:case_when]{dplyr::case_when()}}.

Other validation functions: 
\code{\link{col_count_match}()},
\code{\link{col_exists}()},
\code{\link{col_is_character}()},
\code{\link{col_is_date}()},
\code{\link{col_is_factor}()},
\code{\link{col_is_integer}()},
\code{\link{col_is_logical}()},
\code{\link{col_is_numeric}()},
\code{\link{col_is_posix}()},
\code{\link{col_schema_match}()},
\code{\link{col_vals_between}()},
\code{\link{col_vals_decreasing}()},
\code{\link{col_vals_equal}()},
\code{\link{col_vals_gt}()},
\code{\link{col_vals_gte}()},
\code{\link{col_vals_in_set}()},
\code{\link{col_vals_increasing}()},
\code{\link{col_vals_lt}()},
\code{\link{col_vals_lte}()},
\code{\link{col_vals_make_set}()},
\code{\link{col_vals_make_subset}()},
\code{\link{col_vals_not_between}()},
\code{\link{col_vals_not_equal}()},
\code{\link{col_vals_not_in_set}()},
\code{\link{col_vals_not_null}()},
\code{\link{col_vals_null}()},
\code{\link{col_vals_regex}()},
\code{\link{col_vals_within_spec}()},
\code{\link{conjointly}()},
\code{\link{row_count_match}()},
\code{\link{rows_complete}()},
\code{\link{rows_distinct}()},
\code{\link{serially}()},
\code{\link{specially}()},
\code{\link{tbl_match}()}
}
\concept{validation functions}

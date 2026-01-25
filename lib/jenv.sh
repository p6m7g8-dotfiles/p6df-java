# shellcheck shell=bash
######################################################################
#<
#
# Function: p6df::modules::java::jenv::latest::installed()
#
#>
######################################################################
p6df::modules::java::jenv::latest::installed() {

  jenv versions | p6_filter_row_exclude "temurin" | p6_filter_extract_before " (" | p6_filter_strip_chars "*" | p6_filter_row_last "1" | p6_filter_strip_spaces

  p6_return_void
}

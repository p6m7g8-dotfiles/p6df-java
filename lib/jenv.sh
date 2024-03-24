# shellcheck shell=bash
######################################################################
#<
#
# Function: p6df::modules::java::jenv::latest::installed()
#
#>
######################################################################
p6df::modules::java::jenv::latest::installed() {

  jenv versions | p6_filter_exclude "temurin" | sed -e 's, (.*,,' -e 's,\*,,' | p6_filter_last "1" | p6_filter_spaces_strip

  p6_return_void
}

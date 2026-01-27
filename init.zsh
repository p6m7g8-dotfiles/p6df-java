# shellcheck shell=bash
######################################################################
#<
#
# Function: p6df::modules::java::deps()
#
#>
######################################################################
p6df::modules::java::deps() {
  ModuleDeps=(
    p6m7g8-dotfiles/p6common
    gcuisinier/jenv
  )
}

######################################################################
#<
#
# Function: p6df::modules::java::vscodes()
#
#>
######################################################################
p6df::modules::java::vscodes() {

  p6df::modules::vscode::extension::install SonarSource.sonarlint-vscode
  p6df::modules::vscode::extension::install redhat.java
  p6df::modules::vscode::extension::install vscjava.vscode-java-debug
  p6df::modules::vscode::extension::install vscjava.vscode-java-dependency
  p6df::modules::vscode::extension::install vscjava.vscode-java-test
  p6df::modules::vscode::extension::install vscjava.vscode-maven

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::java::external::brew()
#
#>
######################################################################
p6df::modules::java::external::brew() {

  local v
  for v in 8 11 17 21; do
    p6df::core::homebrew::cli::brew::install temurin@${v} --cask
    jenv add /Library/Java/JavaVirtualMachines/temurin-${v}.jdk/Contents/Home
  done
  p6df::core::homebrew::cli::brew::install temurin --cask
  jenv add /Library/Java/JavaVirtualMachines/temurin-24.jdk/Contents/Home

  p6df::core::homebrew::cli::brew::install maven
  # p6df::core::homebrew::cli::brew::install maven-completion
  # p6df::core::homebrew::cli::brew::install maven-shell

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::java::home::symlink()
#
#  Environment:	 P6_DFZ_SRC_P6M7G8_DOTFILES_DIR
#>
######################################################################
p6df::modules::java::home::symlink() {

  p6_file_symlink "$P6_DFZ_SRC_P6M7G8_DOTFILES_DIR/p6df-java/share/.sonarlint" ".sonarlint"

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::java::langs()
#
#  Environment:	 P6_DFZ_SRC_DIR
#>
######################################################################
p6df::modules::java::langs() {

  local latest_installed=$(p6df::modules::java::jenv::latest::installed)
  jenv global "$latest_installed"
  jenv rehash

  local plugins
  local plugin
  plugins=$(p6_dir_list "$P6_DFZ_SRC_DIR/gcuisinier/jenv/available-plugins")
  for plugin in $(p6_echo "$plugins"); do
    jenv enable-plugin "$plugin"
  done

  jenv rehash

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::java::init(_module, dir)
#
#  Args:
#	_module -
#	dir -
#
#  Environment:	 P6_DFZ_SRC_DIR
#>
######################################################################
p6df::modules::java::init() {
  local _module="$1"
  local dir="$2"

  p6_bootstrap "$dir"

  p6df::core::lang::mgr::init "$P6_DFZ_SRC_DIR/gcuisinier/jenv" "j"

  p6_return_void
}

######################################################################
#<
#
# Function: str str = p6df::modules::java::prompt::env()
#
#  Returns:
#	str - str
#
#  Environment:	 JAVA_HOME
#>
######################################################################
p6df::modules::java::prompt::env() {

#  local str="jenv_root:\t  $JENV_ROOT
  local str="java_home:\t  $JAVA_HOME"

  p6_return_str "$str"
}

######################################################################
#<
#
# Function: str str = p6df::modules::java::prompt::lang()
#
#  Returns:
#	str - str
#
#>
######################################################################
p6df::modules::java::prompt::lang() {

  local str
  str=$(p6df::core::lang::prompt::lang \
    "j" \
    "jenv version-name 2>/dev/null" \
    "java -version 2>&1 | p6_filter_row_select 'Environment' | p6_filter_extract_between '(build ' ')'")

  p6_return_str "$str"
}

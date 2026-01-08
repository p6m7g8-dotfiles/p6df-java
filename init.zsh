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

  code --install-extension SonarSource.sonarlint-vscode
  code --install-extension redhat.java
  code --install-extension vscjava.vscode-java-debug
  code --install-extension vscjava.vscode-java-dependency
  code --install-extension vscjava.vscode-java-test
  code --install-extension vscjava.vscode-maven

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
    p6df::modules::homebrew::cli::brew::install temurin@${v} --cask
    jenv add /Library/Java/JavaVirtualMachines/temurin-${v}.jdk/Contents/Home
  done
  p6df::modules::homebrew::cli::brew::install temurin --cask
  jenv add /Library/Java/JavaVirtualMachines/temurin-24.jdk/Contents/Home

  p6df::modules::homebrew::cli::brew::install maven
  # p6df::modules::homebrew::cli::brew::install maven-completion
  # p6df::modules::homebrew::cli::brew::install maven-shell

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
  jenv global $latest_installed
  jenv rehash

  local plugins
  local plugin
  plugins=$(p6_dir_list "$P6_DFZ_SRC_DIR/gcuisinier/jenv/available-plugins")
  for plugin in $(p6_echo $plugins); do
    jenv enable-plugin $plugin
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
# Function: str str = p6df::modules::j::env::prompt::info()
#
#  Returns:
#	str - str
#
#  Environment:	 JAVA_HOME JENV_ROOT
#>
######################################################################
p6df::modules::j::env::prompt::info() {

  local str="jenv_root:\t  $JENV_ROOT
java_home:\t  $JAVA_HOME"

  p6_return_str "$str"
}

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
  code --install-extension vscjava.vscode-java-pack
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

  brew tap adoptopenjdk/openjdk
  local ver
  for ver in 8 9 10 11 12 13 14 15 16; do
    brew install --cask adoptopenjdk/openjdk/adoptopenjdk${ver}
  done

  brew install temurin --cask

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

  p6_run_dir "/Library/Java/JavaVirtualMachines/" p6df::modules::java::langs::doit

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
# Function: p6df::modules::java::jenv::latest::installed()
#
#>
######################################################################
p6df::modules::java::jenv::latest::installed() {

  jenv versions | p6_filter_exclude "openjdk" | sed -e 's, (.*,,' -e 's,\*,,' | p6_filter_last "1" | p6_filter_spaces_strip
}

######################################################################
#<
#
# Function: p6df::modules::java::langs::doit()
#
#  Environment:	 XXX
#>
######################################################################
p6df::modules::java::langs::doit() {

  local d
  for d in *; do
    p6_run_dir "$d" p6df::modules::java::langs::jenv::add
  done

  # XXX: These use the base brew java
  #  maven wrapper
  #  brew install maven
  #  brew install maven-completion
  #  brew install maven-shell

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::java::langs::jenv::add()
#
#>
######################################################################
p6df::modules::java::langs::jenv::add() {

  jenv add ./Contents/Home

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::java::init()
#
#  Environment:	 P6_DFZ_SRC_DIR
#>
######################################################################
p6df::modules::java::init() {

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

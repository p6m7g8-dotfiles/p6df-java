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

  # sonarlint
  code --install-extension SonarSource.sonarlint-vscode
  code --install-extensionredhat.java
  code --install-extensionvscjava.vscode-java-debug
  code --install-extensionvscjava.vscode-java-dependency
  code --install-extensionvscjava.vscode-java-pack
  code --install-extensionvscjava.vscode-java-test
  code --install-extensionvscjava.vscode-maven

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

  jenv global 16.0.1
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

  p6df::modules::java::jenv::init "$P6_DFZ_SRC_DIR"

  p6df::modules::java::prompt::init

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::java::jenv::init(dir)
#
#  Args:
#	dir -
#
#  Environment:	 HAS_JENV JENV_ROOT P6_DFZ_LANGS_DISABLE
#>
######################################################################
p6df::modules::java::jenv::init() {
  local dir="$1"

  local JENV_ROOT=$dir/gcuisinier/jenv
  if p6_string_blank "$P6_DFZ_LANGS_DISABLE" && p6_file_executable "$JENV_ROOT/bin/jenv"; then
    p6_env_export JENV_ROOT "$JENV_ROOT"
    p6_env_export HAS_JENV 1
    p6_path_if $JENV_ROOT/bin
    eval "$(jenv init - zsh)"
  fi

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::java::prompt::init()
#
#>
######################################################################
p6df::modules::java::prompt::init() {

  p6df::core::prompt::line::add "p6_lang_prompt_info"
  p6df::core::prompt::line::add "p6_lang_envs_prompt_info"
  p6df::core::prompt::lang::line::add j
}

######################################################################
#<
#
# Function: str str = p6_j_env_prompt_info()
#
#  Returns:
#	str - str
#
#  Environment:	 JAVA_HOME JENV_ROOT
#>
######################################################################
p6_j_env_prompt_info() {

  local str="jenv_root:\t  $JENV_ROOT
java_home:\t  $JAVA_HOME"

  p6_return_str "$str"
}

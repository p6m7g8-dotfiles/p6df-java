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
}

######################################################################
#<
#
# Function: p6df::modules::java::brew()
#
#  Depends:	 p6_file
#>
######################################################################
p6df::modules::java::brew() {

  brew tap adoptopenjdk/openjdk
  local ver
  for ver in 8 9 10 11 12 13 14 15 16; do
    brew install --cask adoptopenjdk/openjdk/adoptopenjdk${ver}
  done
}

######################################################################
#<
#
# Function: p6df::modules::java::home::symlink()
#
#  Depends:	 p6_file
#  Environment:	 P6_DFZ_SRC_P6M7G8_DOTFILES_DIR
#>
######################################################################
p6df::modules::java::home::symlink() {

  p6_file_symlink "$P6_DFZ_SRC_P6M7G8_DOTFILES_DIR/p6df-java/share/.sonarlint" ".sonarlint"
}

######################################################################
#<
#
# Function: p6df::modules::java::langs()
#
#  Environment:	 P6_DFZ_SRC_DIR XXX
#>
######################################################################
p6df::modules::java::langs() {

  (
    cd /Library/Java/JavaVirtualMachines/
    for d in *; do
      (
        cd $d
        jenv add ./Contents/Home
	local plugins
	local plugin
	plugins=$(p6_dir_list "$P6_DFZ_SRC_DIR/gcuisinier/jenv/available-plugins")
	for plugin in $(p6_echo $plugins); do
	  jenv enable-plugin $plugin
	done
      )
    done
  )
  jenv global 16.0
  jenv rehash

  # XXX: These use the base brew java
  #  maven wrapper
  #  brew install maven
  #  brew install maven-completion
  #  brew install maven-shell
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
# Function: p6df::modules::java::jenv::init(dir)
#
#  Args:
#	dir -
#
#  Environment:	 DISABLE_ENVS HAS_JAENV JENV_ROOT
#>
######################################################################
p6df::modules::java::jenv::init() {
  local dir="$1"

  [ -n "$DISABLE_ENVS" ] && return

  JENV_ROOT=$dir/gcuisinier/jenv

  if [ -x $JENV_ROOT/bin/jenv ]; then
    export JENV_ROOT
    export HAS_JAENV=1
    p6_path_if $JENV_ROOT/bin

    eval "$(p6_run_code jenv init - zsh)"
  fi
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

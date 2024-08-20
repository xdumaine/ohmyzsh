# virtualenv adds its own prompt prefix, so we need to disable it
export VIRTUAL_ENV_DISABLE_PROMPT=1
PROMPT=""

# will only show the version if there is a local directive using pyenv
function pyenv_version_prompt() {
  pyenv local > /dev/null 2> /dev/null
  if [ $? -ne 0 ]; then
    return
  fi
  echo "🐍 $(pyenv local 2> /dev/null) "
}

# will only show the version if there is a local directive using rbenv
function rubyenv_version_prompt() {
  rbenv local > /dev/null 2> /dev/null
  if [ $? -ne 0 ]; then
    return
  fi
  eval `eval "$(rbenv init - zsh)"`
  echo "💎 $(rbenv local 2> /dev/null) "
}

function node_version_prompt() {
  # will only show node version if there is a local directive.
  # remove this to always show node version
  # maybe consider opening a PR to add a `local` command to fnm
  if [ ! -f ./.node-version ] && [ ! -f ./.nvm ] && [ ! -f ./.nvmrc ]; then
    return
  fi
  # assumes you're using fnm or some alternative to automatically switch node versions
  # if you aren't, this will show the version of the node binary in your path
  # not necessarily the version of node being used in the current directory
  # a possible improvement here would be to compare the version from the local directive
  # to the version returned from node -v and change the color to red if they don't match
  echo "⬢ "%{$fg[magenta]%}"$(node -v) "
}

function cloud_prompt_info() {
  aws_prompt=$(aws_prompt_info)
  # I hate this. aws-prompt-info returns 0 and some non-empty, non-whitespace string when there is no
  # info, so just take a swag at it and say there's only info if the string is longer than 3 characters
  if [ ${#aws_prompt} -gt 3 ]; then
    echo "🌥️  $aws_prompt "
    return
  fi
  # add more cloud providers here
}

PROMPT+="%{$fg[magenta]%}"'$(pyenv_version_prompt)'""
PROMPT+="%{$fg[magenta]%}"'$(rubyenv_version_prompt)'""
PROMPT+="%{$fg[green]%}"'$(node_version_prompt)'""

PROMPT+="%{$fg[yellow]%}"'$(cloud_prompt_info)'" "
PROMPT+='%{$fg[cyan]%}📂 %~%{$reset_color%} $(git_prompt_info)'

# remove right prompt
RPROMPT=''

# git branch symbol, supported by some fonts (e.g., firacode)
ZSH_THEME_GIT_PROMPT_PREFIX="\uE0A0 %{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} > "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%} %{$fg_bold[red]%}*"
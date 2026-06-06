{pkgs, ...}:

{
  programs.direnv = {
    enable = true;
    package = pkgs.direnv;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  
    config.global.hide_env_diff = true;
    config.global.load_dotenv = true;
  
    stdlib = ''
  layout_uv() {
  if [[ -d ".venv" ]]; then
      VIRTUAL_ENV="$(pwd)/.venv"
  fi
  
  if [[ -z $VIRTUAL_ENV || ! -d $VIRTUAL_ENV ]]; then
      log_status "No virtual environment exists. Executing \`uv venv\` to create one."
      uv venv
      VIRTUAL_ENV="$(pwd)/.venv"
  fi
  
  PATH_add "$VIRTUAL_ENV/bin"
  export UV_ACTIVE=1  # or VENV_ACTIVE=1
  export VIRTUAL_ENV
  }
  
  layout_poetry() {
  if [[ ! -f pyproject.toml ]]; then
  log_error 'No pyproject.toml found. Use `poetry new` or `poetry init` to create one first.'
  exit 2
  fi
  
  LOCK="$PWD/poetry.lock"
  watch_file "$LOCK"
  
  local VENV=$(poetry env info --path)
  if [[ -z $VENV || ! -d $VENV/bin ]]; then
  log_status 'No poetry virtual environment found. Running `poetry install` to create one.'
  poetry install
  VENV=$(poetry env info --path)
  else
  HASH="$PWD/.poetry.lock.sha512"
  if ! sha512sum -c $HASH --quiet >&/dev/null ; then
      log_status 'poetry.lock has been updated. Running `poetry install`'
      poetry install
      sha512sum "$LOCK" > "$HASH"
  fi
  fi
  
  export VIRTUAL_ENV=$VENV
  export POETRY_ACTIVE=1
  PATH_add "$VENV/bin"
  }
    '';
  };
}

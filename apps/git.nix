{pkgs, ...}:

{
  programs.git = {
    enable = true;
    package = pkgs.git;
    lfs.enable = true;
    settings = {
      alias = {
        a = "add";
        b = "branch --list --all";
        ca = "commit --amend";
        cf = "commit --fixup";
        ci = "commit --interactive";
        cm = "commit --message";
        d = "difftool";
        ds = "diff --summary";
        i = "init";
        lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'";
        lr = "log --no-merges --format='* %s  %h'";
        ls = "log --nomerges --oneline";
        st = "status";
        sw = "switch";
        pf = "push --force";
      };
      user = {
        email = "marc.yefimchuk@radiofrance.com";
        name = "Marc Yefimchuk";
      };
      init.defaultBranch = "main";
      fetch.prune = true;
      push = {
        autoSetupRemote = true;
        default = "current";
      };
      branch.autoSetupMerge = "simple";
      pull = {
        twohead = "ort";
        rebase = true;
      };
      credentials.helper = "cache --timeout=3600";
      color = {
        diff = "auto";
        status = "auto";
        branch = "auto";
        interactive = "auto";
        ui = true;
        pager = true;
      };
      diff.tool = "nvimdiff";
      difftool.prompt = false;
      "difftool \"nvimdiff\"".cmd = ''nvim -d "$LOCAL" "$REMOTE"'';
      "difftool \"nbdime\"".cmd = ''git-nbdifftool diff "$LOCAL" "$REMOTE" "$BASE"'';
      mergetool.prompt = false;
      "mergetool \"nbdime\"".cmd = ''git-nbmergetool merge "$BASE" "$LOCAL" "$REMOTE" "$MERGED"'';
    };
  };
}

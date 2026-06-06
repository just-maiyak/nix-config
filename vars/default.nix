{
  brewHook = ''eval "$(/opt/homebrew/bin/brew shellenv)"'';
  shellAliases = {
    # Handy
    aepy = "./.venv/bin/activate";
    cat = "bat";
    du = "dust";
    j = "cd";
    jk = ''cd "$STRUKTUR_PATH"'';
    ls = "exa --color";
    ll = "exa -al --color";
    la = "exa -al --color";

    # Docker
    d = "docker";
    dc = "docker container";
    di = "docker image";
    dn = "docker network";
    dv = "docker volume";

    # k8s
    k = "kubectl";
    kuc = "kubectl config use-context";
    kns = ''kubectl config set-context "$(kubectl config current-context)" --namespace'';
    kex = "kubectl exec -it";
    kl = "kubectl logs";
    kg = "kubectl get";
    kgp = "kubectl get pods";
    kd = "kubectl describe";
    kgall = "kubectl get ingress,service,deployment,pod,statefulset";
    kwatch = "kubectl get pods -w --all-namespaces";
    kru = "kubectl rollout restart deployment";

    # gcloud
    gcs = "gcloud storage";
  };
}

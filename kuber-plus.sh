alias pods="kubectl get pods"
alias pod="pods"
alias cm="kubectl get cm"
alias desc="kubectl describe"
alias get="kubectl get"
alias deploy="kubectl get deployments"
alias ctx="kubectl config get-contexts"

function login() {
  cmd=(kubectl $CLUSTER_OPTIONS $NAMESPACE_OPTIONS exec -it)
  if [ $# -eq 2 ]; then
    "${cmd[@]}" "$1" -c "$2" -- sh
  elif [ $# -eq 1 ]; then
    "${cmd[@]}" "$1" -- sh
  fi
}

generate_function(){
  local cluster=$1
  local namespace=$2
  local func_name="kuber${namespace}/${cluster}"
  local func=$(cat <<EOF
${func_name}() {
  PS1="[$namespace@$cluster]$ "
  CLUSTER_OPTIONS="--cluster=$cluster"
  NAMESPACE_OPTIONS="--namespace=$namespace"
  alias kubectl="kubectl --cluster=$cluster --namespace=$namespace"
}
EOF
)
  eval "$func"
  echo "generated: $func_name"
}

kubectl config view -o jsonpath='{range .contexts[*]}{.context.cluster}{"@"}{.context.namespace}{"\n"}{end}' \
  | while IFS='@' read -r cluster namespace; do
    generate_function $cluster $namespace
  done
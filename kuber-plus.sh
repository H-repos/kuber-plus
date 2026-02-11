# Format: "original-value/target-value"
FUNC_NAME_REPLACEMENTS=("abc-service/abc" "xyz-prod/xyz")
PREFIX="kube"

alias pods="kubectl get pods"
alias pod="pods"
alias cm="kubectl get cm"
alias desc="kubectl describe"
alias get="kubectl get"
alias deploy="kubectl get deployments"
alias ctx="kubectl config get-contexts"

function login() {
  cmd=(kubectl $CONTEXT_OPTIONS exec -it)
  if [ $# -eq 2 ]; then
    "${cmd[@]}" "$1" -c "$2" -- sh
  elif [ $# -eq 1 ]; then
    "${cmd[@]}" "$1" -- sh
  fi
}

generate_function(){
  local cluster=$1
  local namespace=$2
  local context=$3
  local func_name="${namespace}/${cluster}"

  for replacement in "${FUNC_NAME_REPLACEMENTS[@]}"; do
    func_name=$(echo "$func_name" | sed "s/$replacement/")
  done

  func_name="${PREFIX}${func_name}"
  local func=$(cat <<EOF
${func_name}() {
  PS1="[${namespace}@${cluster}]$ "
  CONTEXT_OPTIONS="--context=${context}"
  alias kubectl='kubectl --context="${context}"'
}
EOF
)
  eval "$func"
  echo "generated: $func_name"
}

JSONPATH_TEMPLATE='{range .contexts[*]}{.context.cluster}{"@"}{.context.namespace}{"@"}{.name}{"\n"}{end}'

kubectl config view -o jsonpath="$JSONPATH_TEMPLATE" \
  | while IFS='@' read -r cluster namespace context; do
    generate_function "$cluster" "$namespace" "$context"
  done
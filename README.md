[中文版本 (Chinese Version)](README-zh.md)

# Kuber Plus

A powerful shell script that simplifies multi-context Kubernetes command-line operations through **context isolation**, improving development efficiency.

## Core Value

Each terminal window can independently switch to different contexts, enabling parallel operations across multiple environments without repeatedly switching between them.

## Working Principle

1. **Automatic Function Generation**:
   - Reads `kubectl config view` to get all contexts
   - Parses cluster and namespace for each context
   - Generates independent switching functions for each combination
   - Sets environment variables and aliases internally to achieve automatic switching

2. **Function Naming Format**: `kube<namespace>/<cluster>`

3. **Context Isolation**:
   - Each terminal maintains its own kubectl context independently
   - Switching in one terminal does not affect other terminals
   - All kubectl commands automatically use `--context` parameter
   - Prompt displays the namespace and cluster from the current context: `[namespace@cluster]`

## Features

### Convenient Aliases

Pre-defined shortcuts for common kubectl commands:

| Alias | Command |
|-------|---------|
| `pods` / `pod` | `kubectl get pods` |
| `cm` | `kubectl get cm` |
| `desc` | `kubectl describe` |
| `get` | `kubectl get` |
| `deploy` | `kubectl get deployments` |
| `ctx` | `kubectl config get-contexts` |

### Quick Login Function

Quickly enter a pod with the `login` command:

```bash
login pod-name              # Enter default container
login pod-name container    # Enter specified container
```

### Function Name Customization

You can customize function names by editing `FUNC_NAME_REPLACEMENTS` in the script:

```bash
# Format: "original-value/target-value"
FUNC_NAME_REPLACEMENTS=("abc-service/abc" "xyz-prod/xyz")
```

For example, if your namespace is `abc-service`, it will be replaced with `abc` in the function name. If your cluster is `xyz-prod`, it will be replaced with `xyz`.

## Usage Examples

### Multi-terminal Parallel Operations

```bash
# Terminal 1: Operate on production environment
kubeapp-ns/prod-cluster
[app-ns@prod-cluster]$ pods  # Check production environment Pods

# Terminal 2: Operate on development environment  
kubeapp-ns/dev-cluster
[app-ns@dev-cluster]$ deploy  # Check development environment deployments

# Terminal 3: Operate on test environment
kubetest-ns/test-cluster
[test-ns@test-cluster]$ login test-app-pod  # Log in to test environment Pod
```

### View Available Switching Functions

The script outputs all generated function names when loaded:

```bash
$ source ~/kuber-plus.sh
generated: kubedefault/cluster-1
generated: kubeprod/cluster-1
generated: kubedev/cluster-2
...
```

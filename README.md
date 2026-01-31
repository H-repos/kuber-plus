# Kuber Plus

A powerful kubectl shortcut tool that simplifies multi-cluster Kubernetes command-line operations through **context isolation**, improving development efficiency.

## Core Value

Each terminal window can independently switch to different clusters and namespaces, enabling parallel operations across multiple environments without repeatedly switching between them.

## Working Principle

1. **Automatic Function Generation**:
   - Reads `kubectl config view` to get all contexts
   - Parses cluster and namespace for each context
   - Generates independent switching functions for each combination
   - Sets environment variables and aliases internally to achieve automatic switching

2. **Function Naming Format**: `kuber<namespace>/<cluster>`

## Usage Examples

### Multi-terminal Parallel Operations

```bash
# Terminal 1: Operate on production environment
kuberapp-ns/prod-cluster
[app-ns@prod-cluster]$ kubectl get pods  # Check production environment Pods

# Terminal 2: Operate on development environment  
kuberapp-ns/dev-cluster
[app-ns@dev-cluster]$ kubectl get deployments  # Check development environment deployments

# Terminal 3: Operate on test environment
kubertest-ns/test-cluster
[test-ns@test-cluster]$ kubectl exec -it test-app-pod -- sh  # Log in to test environment Pod
```

### View Available Switching Functions

The script outputs all generated function names when loaded:

```bash
$ source ~/kuber-plus.sh
generated: kuberdefault/cluster-1
generated: kuberprod/cluster-1
generated: kuberdev/cluster-2
...
```

---

[中文版本 (Chinese Version)](README-zh.md)
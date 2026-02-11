[English Version](README.md)

# Kuber Plus

一个强大的 kubectl 快捷工具，通过 **context 隔离** 简化多context Kubernetes 命令行操作，提升开发效率。

## 核心价值

每个终端窗口可以独立切换到不同的Kubernetes context，实现多环境并行操作，无需在多个环境间反复切换。

## 工作原理

1. **自动生成函数**：
   - 读取 `kubectl config view` 获取所有上下文
   - 解析每个上下文的 cluster 和 namespace
   - 为每个组合生成独立的切换函数
   - 函数内部设置环境变量和别名，实现自动切换

2. **函数命名格式**：`kube<namespace>/<cluster>`

3. **上下文隔离**：
   - 每个终端独立维护自己的 kubectl 上下文
   - 在一个终端切换不会影响其他终端
   - 所有 kubectl 命令自动使用 `--context` 参数
   - 提示符显示当前上下文对应的命名空间和集群：`[namespace@cluster]`

## 功能特性

### 便捷别名

预定义的常用 kubectl 命令快捷方式：

| 别名 | 命令 |
|------|------|
| `pods` / `pod` | `kubectl get pods` |
| `cm` | `kubectl get cm` |
| `desc` | `kubectl describe` |
| `get` | `kubectl get` |
| `deploy` | `kubectl get deployments` |
| `ctx` | `kubectl config get-contexts` |

### 快速登录功能

使用 `login` 命令快速进入 pod：

```bash
login pod-name              # 进入默认容器
login pod-name container    # 进入指定容器
```

### 函数名自定义

可以通过编辑脚本中的 `FUNC_NAME_REPLACEMENTS` 来自定义函数名：

```bash
# 格式："原始值/目标值"
FUNC_NAME_REPLACEMENTS=("abc-service/abc" "xyz-prod/xyz")
```

例如，如果您的命名空间是 `abc-service`，它将在函数名中被替换为 `abc`。如果您的集群是 `xyz-prod`，它将被替换为 `xyz`。

## 使用示例

### 多终端并行操作

```bash
# 终端 1：操作生产环境
kubeapp-ns/prod-cluster
[app-ns@prod-cluster]$ pods  # 查看生产环境的 Pod

# 终端 2：操作开发环境  
kubeapp-ns/dev-cluster
[app-ns@dev-cluster]$ deploy  # 查看开发环境的部署

# 终端 3：操作测试环境
kubetest-ns/test-cluster
[test-ns@test-cluster]$ login test-app-pod  # 登录测试环境的 Pod
```

### 查看可用的切换函数

脚本加载时会输出所有生成的函数名称：

```bash
$ source ~/kuber-plus.sh
generated: kubedefault/cluster-1
generated: kubeprod/cluster-1
generated: kubedev/cluster-2
...
```

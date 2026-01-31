# Kuber Plus

一个强大的 kubectl 快捷工具，通过 **context 隔离** 简化多集群 Kubernetes 命令行操作，提升开发效率。

## 核心价值

每个终端窗口可以独立切换到不同的集群和命名空间，实现多环境并行操作，无需在多个环境间反复切换。

## 工作原理

1. **自动生成函数**：
   - 读取 `kubectl config view` 获取所有上下文
   - 解析每个上下文的 cluster 和 namespace
   - 为每个组合生成独立的切换函数
   - 函数内部设置环境变量和别名，实现自动切换

2. **函数命名格式**：`kuber<namespace>/<cluster>`

## 使用示例

### 多终端并行操作

```bash
# 终端 1：操作生产环境
kuberapp-ns/prod-cluster
[app-ns@prod-cluster]$ kubectl get pods  # 查看生产环境的 Pod

# 终端 2：操作开发环境  
kuberapp-ns/dev-cluster
[app-ns@dev-cluster]$ kubectl get deployments  # 查看开发环境的部署

# 终端 3：操作测试环境
kubertest-ns/test-cluster
[test-ns@test-cluster]$ kubectl exec -it test-app-pod -- sh  # 登录测试环境的 Pod
```

### 查看可用的切换函数

脚本加载时会输出所有生成的函数名称：

```bash
$ source ~/kuber-plus.sh
generated: kuberdefault/cluster-1
generated: kuberprod/cluster-1
generated: kuberdev/cluster-2
...
```

---

[English Version](README.md)
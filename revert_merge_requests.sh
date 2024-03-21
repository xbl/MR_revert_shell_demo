#!/bin/bash

release_branch=$1  # 通过第一个命令行参数指定发布分支的名称
feature_branch=$2  # 通过第二个命令行参数指定特性分支的名称

# 检查是否提供了必要的命令行参数
if [ -z "$release_branch" ] || [ -z "$feature_branch" ]; then
  echo "请提供发布分支和特性分支的名称作为命令行参数！"
  exit 1
fi

# 1. 使用git log过滤出特性分支上的合并请求的提交历史记录，并包含合并请求的提交消息
commit_hashes=$(git log origin/"$release_branch" --grep="$feature_branch" --merges --format="%H" | tac)

# 2. 使用找到的合并请求的提交哈希进行git revert操作
for commit_hash in $commit_hashes; do
    echo "Reverting commit: $commit_hash"
    git revert $commit_hash --no-edit
    
    # 如果需要自动提交撤销的更改，可以将以下两行解除注释
    # git add .
    # git commit --no-edit
    
    echo "Reverted commit: $commit_hash"
done
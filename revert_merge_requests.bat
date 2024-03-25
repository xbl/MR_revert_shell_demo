@echo off

set release_branch=%1
set feature_branch=%2

REM 检查是否提供了必要的命令行参数
if "%release_branch%"=="" (
    echo 请提供发布分支的名称作为第一个命令行参数！
    exit /b 1
)

if "%feature_branch%"=="" (
    echo 请提供特性分支的名称作为第二个命令行参数！
    exit /b 1
)

REM 1. 使用git log过滤出特性分支上的合并请求的提交历史记录，并包含合并请求的提交消息
for /f "delims=" %%G in ('git log origin/%release_branch% --grep="%feature_branch%" --merges --format^="%H" ^| type') do (
    set commit_hash=%%G
    echo Reverting commit: !commit_hash!
    git revert -m 1 !commit_hash! --no-edit
    
    REM 如果需要自动提交撤销的更改，可以将以下两行解除注释
    REM git add .
    REM git commit --no-edit
    
    echo Reverted commit: !commit_hash!
)
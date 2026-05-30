---
title: AI
date: 2026/05/28
updated: 2026/05/28
index_img: https://cdn.sxrekord.com/blog/rekord.png
banner_img: https://cdn.sxrekord.com/blog/rekord.png
categories:
- 感悟
tags:
- AI
---

# TLDR

1. AI非常擅长使用工具软件，所以你会发现网络问题、配置问题处理的尤其有效
2. 让AI做软件工程还是不够稳定，对代码库的变动在初级、中级、高级和架构师中间跳动，相反，同一个人对同一套代码库的变更效果非常稳定，而且通常会越来越好。
3. 之前的AI不沟通，只执行，现在有了grill，能解决一部分问题，但还不够，因为没grill的内容AI已经视为理解，但真的和你达成一致了吗
4. AI还是不会复制粘贴，只会删除和重写
5. AI不够“懒惰”


# 概念

## 项目指令文件

项目指令文件是 AI agent 的长期项目说明。不同工具的文件名不一样：Codex 是 `AGENTS.md`；Claude Code 是 `CLAUDE.md`。

适合写：

- 构建、测试、格式化命令。
- 代码风格、提交规范、分支规范。
- 目录职责、模块边界、不要随便改的文件。
- 脏工作区处理原则。
- 高风险操作的确认要求。

不适合写：

- 一次性任务，这类更适合 prompt。
- 大段背景材料，太长反而稀释重点。
- 和权限冲突的要求，比如要求改工作区外文件，但没有配置对应权限。


## Prompt

AI agent 的 prompts 目录下的文件，本质上是一些特定要求的快捷输入方式。

比如用户总是要求 AI 按规范提交代码、先检查变更、再给出摘要，那么与其每次重复说明，不如把这些要求沉淀成一份 prompt。它对用户的意义就在于复用：把高频、稳定、明确的要求提前写好，后续只需按场景调用即可。


## Skill

Skill 是把一类任务沉淀成可复用工作流，是一套带触发条件、步骤、脚本和参考资料的任务包。

基本结构：

```plain
skill-name/
├── SKILL.md
├── scripts/
├── references/
└── assets/
```

最重要的是 `SKILL.md`：

- `name`：skill 名称。
- `description`：触发条件，写得越清楚越容易在正确场景被调用。
- 正文：具体步骤、注意事项、何时读取 references、何时运行 scripts。

适合做成 Skill：

- 固定流程：比如 OpenSpec 提案、归档、按规范发布版本。
- 专业领域：比如某套业务协议、内部平台、特定文件格式。
- 高频复杂任务：每次都要查资料、跑脚本、按步骤处理的事情。

不适合做成 Skill：

- 一句话能说清的要求，用 prompt 即可。
- 只属于某个仓库的规则，放项目指令文件更合适。
- 只是接一个外部系统，优先考虑 MCP。

“我这次想这么做”变成“这类任务以后都要这么做”，就可以考虑沉淀成 Skill。

## prompt与skill的区别

OpenSpec 同时提供 prompt 和 Skill，就是一个典型例子：

- `/opsx:apply` 这类斜杠命令，入口通常是 prompt。
- 用户直接说“继续实现这个 OpenSpec change”，更容易触发 Skill。
- prompt 负责给用户一个明确命令入口，Skill 负责沉淀可复用的工作流。
- 两者可以内容相似，但面向的触发方式不同。

prompt 偏“怎么触发”，Skill 偏“触发后怎么稳定完成”。

## MCP

MCP 可以理解为给 Codex 接外部工具和数据源的协议。prompt 告诉 Codex 怎么做，MCP 则给 Codex 提供“能用什么”。

常见价值：

- 接文档：让 Codex 查内部文档、官方文档、知识库。
- 接系统：让 Codex 读 issue、PR、CI、监控、数据库等外部状态。
- 接工具：把团队已有脚本、平台能力包装成 Codex 可调用的工具。

Codex 里常用命令：

```bash
codex mcp list
codex mcp get <name>
codex mcp add <name> --url <url>
codex mcp add <name> -- <command>
codex mcp remove <name>
```

两种接入方式：

- `--url`：连接远程 MCP server，适合文档、平台、团队服务。
- `-- <command>`：本地启动 stdio server，适合本机脚本和本地工具。

需要鉴权时，不要把 token 写进命令里，使用环境变量：

```bash
codex mcp add docs --url https://example.com/mcp --bearer-token-env-var DOCS_TOKEN
codex mcp add local-tool --env API_KEY=$API_KEY -- node server.js
```

## Profile

Profile 是一组可切换的 `config.toml` 配置层，用来把不同使用场景沉淀成运行模式。

文件位置：

```plain
~/.codex/dev.config.toml
~/.codex/review.config.toml
~/.codex/auto.config.toml
```

使用方式：

```bash
codex --profile dev
codex --profile review
```

适合放：

```toml
model = "gpt-5.5"
model_reasoning_effort = "xhigh"
approval_policy = "on-request"
sandbox_mode = "workspace-write"
web_search = "live"
```

典型用法：

- `dev`：日常开发，`workspace-write + on-request`。
- `review`：只读审查，`read-only + untrusted`。
- `auto`：自动化任务，`workspace-write + never`。
- `deep-review`：强模型、高推理、保守权限。


## Hooks

Hooks 是 Codex 生命周期里的脚本插桩，用来在固定节点执行自定义检查或动作。

常见时机：

- `SessionStart`：会话开始。
- `UserPromptSubmit`：用户提交 prompt 后。
- `PreToolUse`：工具执行前。
- `PermissionRequest`：请求权限时。
- `PostToolUse`：工具执行后。
- `Stop`：一轮结束时。
- `PreCompact` / `PostCompact`：上下文压缩前后。

配置位置：

```plain
~/.codex/hooks.json
~/.codex/config.toml
<repo>/.codex/hooks.json
<repo>/.codex/config.toml
```

inline TOML 示例：

```toml
[[hooks.PostToolUse]]
matcher = "^Bash$"

[[hooks.PostToolUse.hooks]]
type = "command"
command = "python3 .codex/hooks/check_output.py"
timeout = 30
statusMessage = "Checking command output"
```

适合做：

- 提交 prompt 前检查是否泄露 token。
- 工具执行前拦截危险命令。
- 工具执行后检查输出。
- 会话结束时生成摘要。
- 自动跑项目约束检查。

注意：

- Hook 是脚本，第一次或变更后需要信任。
- 多个匹配 hook 会并发执行，不适合依赖顺序。
- Hook 不能替代 sandbox，它是流程扩展，不是权限边界。

## Plugin

Plugin 是 Codex 的能力打包和分发单位。它没有引入一种全新的能力类型，而是把 prompt、Skill、MCP、脚本、资源等已有能力用一种更适合安装、升级和分发的形式组织起来。

一个 plugin 通常有：

```plain
plugin-name/
├── .codex-plugin/plugin.json
├── skills/
├── .mcp.json
├── .app.json
├── scripts/
└── assets/
```

核心是 `.codex-plugin/plugin.json`，它描述插件名称、版本、说明、入口和 UI 信息。比如 GitHub plugin 就会声明自己的 skills、app 配置、图标、能力说明等。

常用命令：

```bash
codex plugin marketplace list
codex plugin marketplace add <name> <source>
codex plugin marketplace upgrade
codex plugin list
codex plugin add <plugin>@<marketplace>
codex plugin remove <plugin>
```

适合做成 plugin：

- 一组能力要一起分发，比如 GitHub、Figma、Slack 这类平台集成。
- 同时包含 Skill、MCP、脚本、资源文件。
- 团队希望通过 marketplace 管理安装、升级和可见性。


# Codex

## 权限管理

Codex 权限管理最关键的是三项：

1. `sandbox`：决定能改哪里

- `read-only`：只读，适合审查、解释、排查。
- `workspace-write`：可改当前项目，适合日常开发，推荐默认值。
- `danger-full-access`：完全放开，只适合容器、临时环境。

2. `ask-for-approval`：决定什么时候问用户

- `untrusted`：最保守，写文件和危险命令先问。
- `on-request`：交互开发推荐值。
- `never`：全自动，适合 CI，不适合本地重要仓库。

二者关系：

- `sandbox` 是硬边界，prompt 不能越权。
- `ask-for-approval` 是确认策略，不只是 sandbox 失败后才生效，也可能在执行前生效。
- `untrusted` 会在非可信命令执行前询问。
- `on-request` 允许 Codex 对高风险操作主动请求确认。
- `never` 不询问用户，sandbox 不允许就直接失败。

prompt 只能表达意图，sandbox 才决定能力；prompt 要求的操作超出 sandbox 时，Codex 只能请求授权或失败。

3. `search`：是否允许联网搜索

推荐组合：

```bash
codex --sandbox workspace-write --ask-for-approval on-request
```

只读模式：

```bash
codex --sandbox read-only --ask-for-approval untrusted
```

需要改多个目录：

```bash
codex --sandbox workspace-write --add-dir ../common
```

不要日常使用：

```bash
codex --dangerously-bypass-approvals-and-sandbox
```

## AGENTS.md

加载规则:
- 全局：优先读 `~/.codex/AGENTS.override.md`，否则读 `~/.codex/AGENTS.md`。
- 项目：从仓库根目录一路读到当前目录，每层优先 `AGENTS.override.md`，其次 `AGENTS.md`。
- 越靠近当前目录的规则越靠后，也就越具体。
- 空文件会被忽略，内容太大可能被 `project_doc_max_bytes` 截断。
- 如果想用别的文件名，可以配置 `project_doc_fallback_filenames`。

# Claude Code

## 权限管理

当 Claude Code 准备执行某个工具或命令时，大致判断顺序是：

```plain
deny rules
-> ask rules
-> permission mode
-> allow rules
-> 运行时询问或执行
```

所以核心不是“先看 mode 还是先看 rule”，而是分层决策：

- `deny`：硬拒绝，匹配就不能做。
- `ask`：硬询问，匹配就必须问。
- `permission mode`：决定当前会话的基线能力和默认审批姿态。
- `allow`：在基线允许的范围内，把指定工具、命令、路径预批准，减少询问。

`allow` 不是比 `mode` 更高一级的授权。它不会把 `plan` 变成可编辑模式，也不会约束 `bypassPermissions` 只执行 allow 列表里的工具。它更像是在当前 mode 下配置“哪些操作不用再问”。

配置位置：

```plain
~/.claude/settings.json
<repo>/.claude/settings.json
<repo>/.claude/settings.local.json
```

常见 mode：

- `default`：标准模式，首次使用需要确认。
- `acceptEdits`：自动接受当前工作区内的文件编辑和常见文件操作。
- `plan`：只读规划，不改源文件。
- `auto`：自动批准部分工具调用，但带后台安全检查。
- `dontAsk`：未预先允许的工具直接拒绝。
- `bypassPermissions`：跳过权限提示，只适合容器或虚拟机。

rules 分三类：

- `allow`：允许指定工具或命令，不再询问。
- `ask`：每次执行前询问。
- `deny`：直接禁止，优先级最高。

示例：

```json
{
  "permissions": {
    "allow": [
      "Bash(npm run test *)",
      "Edit(/src/**)"
    ],
    "deny": [
      "Read(./.env)",
      "Read(./secrets/**)",
      "Bash(git push *)"
    ]
  }
}
```

上面这份配置的含义是：

- `.env`、`secrets/**`、`git push` 永远拒绝。
- `npm run test *` 和 `src/**` 下的编辑预批准。
- 其他操作交给当前 mode 决定：直接做、询问，还是拒绝。

额外目录：

```bash
claude --add-dir ../common
```

或写入配置：

```json
{
  "additionalDirectories": ["../common"]
}
```

注意：`additionalDirectories` 主要扩展文件访问范围，不等于把该目录变成完整配置根目录。


## CLAUDE.md

`CLAUDE.md` 是 Claude Code 的项目指令文件，官方也把它归在 memory 体系里。它会在每次会话开始时加载进上下文，但不是强制配置。

常见位置：

```plain
~/.claude/CLAUDE.md
<repo>/CLAUDE.md
<repo>/.claude/CLAUDE.md
<repo>/CLAUDE.local.md
```

加载规则：

- Claude Code 从当前工作目录向上查找 `CLAUDE.md` 和 `CLAUDE.local.md`。
- 越靠近当前目录的内容越后加载，也就越具体。
- `CLAUDE.local.md` 适合个人本地偏好，不应提交。
- 子目录里的 `CLAUDE.md` 通常在 Claude 读取对应目录文件时再加载。

如果仓库已经有 `AGENTS.md`，可以让 `CLAUDE.md` 引用它：

```md
@AGENTS.md
```

也可以直接做软链接：

```bash
ln -s AGENTS.md CLAUDE.md
```

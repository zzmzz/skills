# Skills 合集

个人自用的 AI 编程助手 Skills 合集，支持 Claude Code、Cursor、Windsurf、Aider 等 AI 编程工具。

## 目录结构

```
├── .claude-plugin/
│   └── marketplace.json   # Claude Code Plugin 注册文件
├── skills/
│   └── research/          # 综合调研 skill
│       └── SKILL.md
└── README.md
```

## Skills 列表

### research — 综合调研

**作用**：针对用户提出的技术需求，自动通过 GitHub 和搜索引擎进行全面调研，分析现有开源项目和技术方案，最终输出结构化的中文调研报告。

**触发词**：`调研`、`research`、`有没有类似的`、`GitHub 上有没有`、`找找有没有现成的`、`技术选型`、`帮我看看有什么方案`、`对比一下`、`有什么好用的xxx`、`推荐一个xxx` 等。

**实现逻辑**：

1. **理解需求** — 从用户输入中提取核心功能、使用场景、技术栈偏好和约束条件
2. **生成搜索关键词** — 至少 3 组（GitHub 英文关键词 + 搜索引擎中英文关键词）
3. **GitHub 搜索** — 优先 `gh` CLI → 降级 GitHub API → 降级 WebFetch，按 Star 排序
4. **搜索引擎搜索** — 使用 ddgr 进行 DuckDuckGo 搜索，获取博客、教程、文档等（与 GitHub 搜索并行执行）
5. **筛选与深入分析** — 合并去重，筛选 top 5-10 项目，查看 README、Star、活跃度等
6. **实现思考** — 分析能否直接用、是否需组合、自己做的路径、风险与挑战
7. **输出调研报告** — 结构化 Markdown 报告，包含项目对比表格、实现建议和最终结论

---

## 安装方式

### OpenSkills（通用，推荐）

适用于 Claude Code、Cursor、Windsurf、Aider 等所有支持 SKILL.md 的 AI 编程工具。

安装到当前项目：

```bash
npx openskills install zzmzz/skills
npx openskills sync
```

安装到全局：

```bash
npx openskills install zzmzz/skills --global
```

### Claude Code（Plugin 方式）

```
/plugin marketplace add zzmzz/skills
/plugin install zzmzz-skills@zzmzz-skills
```

或者交互式安装：
1. 输入 `/plugin marketplace add zzmzz/skills`
2. 选择 `Browse and install plugins`
3. 选择 `zzmzz-skills`
4. 选择 `Install now`

安装完成后，直接在对话中说"调研 xxx"即可触发 research skill。

---

## 添加新 Skill

1. 在 `skills/` 下新建目录，添加 `SKILL.md`
2. 在 `.claude-plugin/marketplace.json` 的 `skills` 数组中添加路径
3. 更新本 README

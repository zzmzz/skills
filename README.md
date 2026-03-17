# Skills 合集

个人自用的 AI 编程助手 Skills 合集，支持 Claude Code 和 Cursor。

## 目录结构

```
├── skills/                # Skills 源文件
│   └── research/          # 综合调研 skill
│       └── SKILL.md
├── claude/                # Claude Code 安装相关
│   └── install.sh         # 一键安装脚本
├── cursor/                # Cursor 安装相关
│   ├── rules/             # .mdc 规则文件
│   │   └── research.mdc
│   └── install.sh         # 一键安装脚本
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

### Claude Code

**方式一：一键安装（推荐）**

```bash
git clone git@github.com:zzmzz/skills.git
cd skills
bash claude/install.sh
```

脚本会将 `skills/` 下的所有 skill 以符号链接的方式安装到 `~/.claude/skills/`。

**方式二：手动复制**

```bash
cp -r skills/research ~/.claude/skills/research
```

### Cursor

**方式一：一键安装**

在你的项目根目录下运行：

```bash
git clone git@github.com:zzmzz/skills.git /tmp/skills
bash /tmp/skills/cursor/install.sh
```

脚本会将 `.mdc` 规则文件复制到当前项目的 `.cursor/rules/` 下。

**方式二：手动安装**

```bash
mkdir -p .cursor/rules
cp cursor/rules/research.mdc .cursor/rules/
```

**方式三：通过 Cursor 设置界面**

1. 打开 Cursor 设置 → **Rules**
2. 点击 **Add Rule**
3. 将 `cursor/rules/research.mdc` 的内容粘贴进去
4. 保存即可

---

## 添加新 Skill

1. 在 `skills/` 下新建目录，添加 `SKILL.md`
2. 在 `cursor/rules/` 下新建对应的 `.mdc` 文件
3. 更新本 README

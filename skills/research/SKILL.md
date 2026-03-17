---
name: research
description: |
  综合调研 skill：针对用户需求，通过 GitHub 和搜索引擎搜索相关内容，分析现有方案，
  思考实现路径，最终输出结构化中文调研报告。

  当用户说"调研"、"research"、"有没有类似的"、"GitHub 上有没有"、"找找有没有现成的"、
  "我想做一个xxx"（后跟调研意图）、"有没有现成的轮子"、"搜一下有没有"、"技术选型"、
  "帮我看看有什么方案"、"对比一下"、"有什么好用的xxx"、"推荐一个xxx"时，
  优先使用本 skill。
---

# Research Skill — 综合调研

## 工作流程

### 第 1 步：理解需求

从用户输入中提取：
- **核心功能**：用户想要什么？
- **使用场景**：在什么环境下用？（CLI / Web / Library / API 等）
- **技术栈偏好**：是否指定了语言或框架？
- **约束条件**：性能、许可证、维护活跃度等要求

如果需求不明确，用 AskUserQuestion 向用户确认关键信息后再继续。

### 第 2 步：生成搜索关键词

根据需求生成 **至少 3 组** 搜索关键词，分为：
- **GitHub 关键词**：偏向项目名、技术术语（英文为主）
- **搜索引擎关键词**：偏向问题描述、方案对比（中英文各一组）

### 第 3 步：GitHub 搜索

使用以下策略搜索 GitHub，**按优先级依次尝试**：

**方案 A — gh CLI**（优先）：
```bash
gh search repos "关键词" --sort stars --limit 10 --json name,owner,description,stargazersCount,language,updatedAt,url,licenseInfo
```

**方案 B — curl GitHub API**（gh 不可用时降级）：
```bash
curl -s "https://api.github.com/search/repositories?q=关键词&sort=stars&per_page=10" | python3 -c "
import sys, json
data = json.load(sys.stdin)
for r in data.get('items', []):
    print(f\"⭐ {r['stargazers_count']:>6}  {r['full_name']:<40}  {r.get('language','N/A'):<12}  {r.get('license',{}).get('spdx_id','N/A'):<10}  {r['html_url']}\")
    print(f\"         {r.get('description','')[:100]}\")
    print()
"
```

**方案 C — WebFetch**（以上都失败时兜底）：
使用 WebFetch 抓取 GitHub 搜索页面。

**重要**：每组关键词都要搜索，合并结果去重。

### 第 4 步：搜索引擎搜索

使用 ddgr（DuckDuckGo 命令行搜索）进行搜索引擎搜索：

```bash
/root/miniconda3/bin/ddgr --np --json -n 5 "关键词"
```

对每组搜索引擎关键词执行搜索，结果用 python3 解析 JSON 提取标题、链接和摘要。

```bash
/root/miniconda3/bin/ddgr --np --json -n 5 "关键词" | python3 -c "
import sys, json
results = json.load(sys.stdin)
for i, r in enumerate(results, 1):
    print(f\"{i}. {r['title']}\")
    print(f\"   {r['url']}\")
    print(f\"   {r.get('abstract','')[:150]}\")
    print()
"
```

**并行执行**：GitHub 搜索和搜索引擎搜索之间没有依赖关系，应使用多个 Bash 工具调用并行执行以提高效率。

### 第 5 步：筛选与深入分析

1. 合并 GitHub 和搜索引擎结果，去重
2. 筛选 top 5-10 个最相关的项目/方案
3. 对重点项目使用以下方式深入了解：
   - `gh repo view owner/repo` 查看项目详情
   - WebFetch 读取项目 README
   - 查看 Star 数、最近提交、Issue 活跃度等指标

### 第 6 步：实现思考

基于调研结果，深入思考：
- **现有方案能否直接使用**？哪个最接近需求？
- **是否需要组合多个工具**？如何组合？
- **如果需要自己做**，技术路径是什么？可以借鉴哪些设计？
- **风险与挑战**：可能遇到什么坑？

### 第 7 步：输出调研报告

以 Markdown 格式输出完整报告，结构如下：

---

## 📋 调研报告：{主题}

### 1. 需求理解

简述对需求的理解，包括核心功能、场景、约束等。

### 2. 搜索策略

| 渠道 | 关键词 | 结果数量 |
|------|--------|---------|
| GitHub | `keyword1` | N 个 |
| GitHub | `keyword2` | N 个 |
| DuckDuckGo | `keyword3` | N 个 |
| ... | ... | ... |

### 3. 发现的相关项目/方案

对每个值得关注的项目：

#### 📦 项目名 — 一句话描述
- **链接**：URL
- **语言**：xxx | **Stars**：xxx | **最近更新**：xxx
- **License**：xxx
- **优点**：...
- **缺点/不足**：...
- **与需求匹配度**：⭐⭐⭐⭐⭐ (1-5)

### 4. 非 GitHub 资源

列出从搜索引擎发现的有价值的博客文章、教程、文档、Stack Overflow 讨论等。

| 来源 | 标题 | 链接 | 价值点 |
|------|------|------|--------|
| ... | ... | ... | ... |

### 5. 对比总结

| 项目 | Stars | 语言 | 活跃度 | License | 匹配度 | 推荐度 |
|------|-------|------|--------|---------|--------|--------|
| ... | ... | ... | ... | ... | ... | ... |

### 6. 实现建议

- **推荐方案**：直接使用 / 组合使用 / 自己实现
- **推荐理由**：...
- **实现路径**（如需自己做）：
  1. ...
  2. ...
- **可借鉴的设计/代码**：...
- **风险与注意事项**：...

### 7. 结论

一段话总结最终建议。

---

## 注意事项

- 所有输出使用中文
- 搜索时优先使用英文关键词以获得更全面的结果
- 对 Star 数、更新时间等数据要如实呈现，不要编造
- 如果某个搜索渠道失败，记录失败原因并继续使用其他渠道
- 报告中的链接必须来自实际搜索结果，不要自行构造 URL

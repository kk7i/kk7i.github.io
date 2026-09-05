# Copilot 维护规约

本仓库是个人 AI 探索作品集（GitHub Pages 静态站点，无需构建）。

## 目录结构
- 每个作品一个目录：`works/<主题>/index.html`
- 根目录 `index.html` 是作品集首页，作品按时间**倒序**展示（新的在上）

## 作品卡片格式
新增/更新作品时，严格按既有卡片风格，插入到 `<!-- WORKS-LIST -->` 注释**之前**：

```html
<a class="card" href="<目录名>/">
  <span class="date">YYYY-MM-DD</span><br>
  <span class="title">🎙️ 作品标题</span>
  <div class="desc">一句话描述（20 字内）</div>
</a>
```

## 硬规则
1. 描述一句话、20 字内，像知识卡片，不废话
2. **只改动 `<!-- WORKS-LIST -->` 之前的卡片区域**，不动样式、其它卡片、结构
3. 所有内部链接用**相对路径**（`./xxx` 或 `works/xxx/`），绝不用以 `/` 开头的绝对路径
4. 仓库根目录已有 `.nojekyll`，不要删除
5. 不确定的地方先问用户，不要猜

## 推荐分工
- 建目录、复制文件、插卡片、commit、push → 用 `add-work.sh` 脚本（确定性操作，比 AI 快）
- 给新作品**写那句一句话描述 / 提炼卖点** → 可以让我（Copilot）来，我在理解内容上有优势

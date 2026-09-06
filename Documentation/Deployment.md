# Deployment, Version Control & CI/CD Guide

This guide outlines how the **Global Electronics Retailer** Power BI portfolio is deployed, version-controlled, and published.

---

## 1. Power BI Project (PBIP) & Developer Mode

This project uses the modern **Power BI Project (.pbip)** format introduced by Microsoft Fabric and Power BI Desktop:

```
orignal made by me.pbip                <- Root project pointer
orignal made by me.Report/             <- Report layout & visual definitions
   ├── definition.pbir
   └── definition/
       └── pages/                     <- Individual page JSONs & visual JSONs
orignal made by me.SemanticModel/      <- Data model & transformations
   ├── definition.pbism
   ├── diagramLayout.json
   └── definition/
       ├── model.tmdl                 <- Model annotations & culture
       ├── relationships.tmdl         <- Star schema relationship definitions
       ├── expressions.tmdl           <- Shared Power Query M expressions
       └── tables/                    <- Individual TMDL files per table
```

### Why PBIP & TMDL?
- **Git Friendly**: Plain text JSON and Tabular Model Definition Language (TMDL) allow granular git diffs, branch merging, and code review without binary `.pbix` merge conflicts.
- **Enterprise CI/CD Ready**: Can be compiled and deployed directly to Microsoft Fabric or Power BI Service workspaces via Azure DevOps or GitHub Actions.

---

## 2. GitHub Pages Static Web Hosting

The portfolio includes an automated static portfolio website hosted via GitHub Pages:
- **Repository**: [`shivam349/Data-Analyst`](https://github.com/shivam349/Data-Analyst)
- **Deployment URL**: `https://shivam349.github.io/Data-Analyst/`
- **Workflow**: Automated deployment via GitHub Actions (`.github/workflows/deploy.yml`) on push to `main`.

---

## 3. Microsoft Power BI Service Publishing (Future Embed)

To embed the interactive Power BI report into the GitHub Pages site:
1. Open [`orignal made by me.pbip`](../orignal%20made%20by%20me.pbip) in Power BI Desktop.
2. Click **Publish** $\to$ Select your Power BI Service Workspace.
3. In Power BI Service, navigate to the published report.
4. Click **File** $\to$ **Embed report** $\to$ **Publish to web (public)** (or **Website or portal**).
5. Copy the generated `<iframe>` embed code.
6. Follow the instructions in [`Adding_PowerBI_Embed.md`](./Adding_PowerBI_Embed.md) to insert the iframe into `index.html`.

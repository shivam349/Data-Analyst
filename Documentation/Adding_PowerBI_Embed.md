# Future Power BI Embed Insertion Procedure

This guide explains how to insert your real Power BI embed HTML/iframe into the GitHub Pages portfolio website when ready.

---

## 1. Designated Embed Container

The static portfolio website has already been built with a dedicated, responsive Power BI embed container located in [`index.html`](../index.html).

Locate this exact block in `index.html`:

```html
<!-- POWER BI EMBED START -->
<div id="powerbi-live-embed" class="embed-wrapper">
    <!-- REAL POWER BI EMBED HTML WILL BE INSERTED HERE -->
    <div class="embed-placeholder">
        <div class="placeholder-icon">
            <svg viewBox="0 0 24 24" width="48" height="48" fill="none" stroke="currentColor" stroke-width="2">
                <rect x="2" y="3" width="20" height="14" rx="2" ry="2"></rect>
                <line x1="8" y1="21" x2="16" y2="21"></line>
                <line x1="12" y1="17" x2="12" y2="21"></line>
            </svg>
        </div>
        <h3>Live Interactive Power BI Report</h3>
        <p>The interactive Power BI embed iframe will be inserted here.</p>
        <div class="embed-status">
            <span class="pulse-dot"></span>
            <span>Awaiting Embed Code</span>
        </div>
    </div>
</div>
<!-- POWER BI EMBED END -->
```

---

## 2. Insertion Steps

When you generate your public or secure embed code from Power BI Service:

1. Copy the embed `<iframe>` code provided by Power BI Service.
   *(Example format: `<iframe title="..." width="100%" height="700" src="https://app.powerbi.com/view?r=..." frameborder="0" allowFullScreen="true"></iframe>`)*
2. In [`index.html`](../index.html), replace **ONLY** the contents between:
   `<!-- POWER BI EMBED START -->`  
   and  
   `<!-- POWER BI EMBED END -->`  
   with your real `<iframe>` tag.
3. **DO NOT** redesign or overwrite the rest of `index.html`.
4. **DO NOT** modify the PBIP or semantic model files merely to add the iframe.
5. Test locally by opening `index.html` in your browser to ensure the report renders cleanly and scales responsively.

---

## 3. Commit & Deploy to GitHub Pages

Once inserted, push the change:

```bash
git add index.html
git commit -m "Insert live Power BI embed iframe"
git push origin main
```

The GitHub Actions workflow will automatically run, build, and deploy the updated page to your live GitHub Pages URL:  
`https://shivam349.github.io/Data-Analyst/`

# Verified Live Power BI Embed & Architecture

This document details the live Power BI embed implemented on the **Global Electronics Retailer** portfolio website.

---

## 1. Verified Live Embed Implementation

The website uses Microsoft Power BI's **Publish to Web (Public)** feature to embed the complete interactive report.

### Key Architecture Facts:
- **One Unified Embed**: A single responsive iframe provides access to the entire multi-page report.
- **Three Embedded Pages**: Users can navigate directly between all three pages via the built-in Power BI bottom page bar:
  1. *Executive Overview*
  2. *Customer & Product Intelligence*
  3. *Store, Channel & Fulfillment*
- **Report Separation**: The Power BI report runs as an independent cloud-hosted artifact rendered by Microsoft Power BI Service. The static GitHub Pages website serves as a portfolio presentation shell around the report without interfering with its internal VertiPaq calculation engine.

---

## 2. Exact Location in `index.html`

The iframe is situated inside the `#powerbi-live-embed` container in [`index.html`](../index.html):

```html
<!-- ============================================================ -->
<!-- POWER BI EMBED START -->
<!-- ============================================================ -->
<div id="powerbi-live-embed" class="embed-wrapper">
  <!-- REAL POWER BI EMBED HTML WILL BE INSERTED HERE -->
  <iframe
      title="orignal made by me"
      width="600"
      height="373.5"
      src="https://app.powerbi.com/view?r=eyJrIjoiMjRiZTBjZDgtNTJkYS00ZDI0LWJkOTQtZGFiN2E1M2M3NDE5IiwidCI6IjQ1NDM5MDU5LWY3ZTItNGI0MC1iM2M0LWQzODdmOWI0OWJmMSJ9"
      frameborder="0"
      allowFullScreen="true">
  </iframe>
</div>
<!-- ============================================================ -->
<!-- POWER BI EMBED END -->
<!-- ============================================================ -->
```

---

## 3. Responsive Styling Architecture

While the default Power BI embed snippet specifies fixed dimensions (`width="600" height="373.5"`), our responsive design system in [`css/style.css`](../css/style.css) ensures optimal rendering across all device formats:

```css
.embed-wrapper {
  position: relative;
  width: 100%;
  aspect-ratio: 16 / 9;
  min-height: 540px;
  background: #0b0f19;
  overflow: hidden;
}

.embed-wrapper iframe {
  width: 100% !important;
  height: 100% !important;
  min-height: 540px;
  border: 0 !important;
  display: block;
}

@media (min-width: 1024px) {
  .embed-wrapper, .embed-wrapper iframe {
    min-height: 660px;
  }
}

@media (max-width: 768px) {
  .embed-wrapper, .embed-wrapper iframe {
    min-height: 420px;
    height: 460px;
  }
}
```

---

## 4. ⚠️ Power BI Data Privacy & Security Notice

> [!WARNING]
> **Microsoft Security Notice on Publish to Web:**
> Microsoft documentation explicitly states: *"When you use Publish to web, anyone on the Internet can view your published report or visual. Viewing requires no authentication. It includes viewing detail-level data that your queries return. Only publish reports to the web that anyone on the Internet should be able to view."*

### Security Compliance for this Portfolio:
- **Public Portfolio Data Only**: This project utilizes anonymized demonstration dataset files (Global Electronics Retailer) intended for public educational and recruitment showcase.
- **Zero Secrets or Credentials**: No database connection strings, passwords, personal tokens, or proprietary organizational data are included or exposed.
- **Publish-to-Web Integrity**: Deleting or changing the Publish-to-Web link in Power BI Service will deactivate the iframe on the live website. Ensure the link remains active in your Power BI tenant.

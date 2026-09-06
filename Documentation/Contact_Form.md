# Contact Me Form & Formspree Integration Specification

This document details the architecture, fields, endpoint configuration, and user experience behavior of the contact mechanism on the **Shivam Garg** Data Analyst portfolio website.

---

## 1. Overview & Architecture

The portfolio employs a static-friendly, secure contact architecture combining **Formspree** serverless form processing with client-side progressive enhancement and a direct email fallback.

```
USER BROWSER (Portfolio Visitor / Recruiter)
   ├── Enters Name, Email, Subject, Message
   ├── Client-Side Validation (Required fields, Email format)
   └── Submits via AJAX (or Native POST Fallback)
             │
             ▼
FORMSPREE ENDPOINT (https://formspree.io/f/xppzjrky)
   ├── Spam & Bot Protection (Built-in verification)
   └── Delivers Message via Secure SMTP
             │
             ▼
RECIPIENT INBOX (shivamgarg1515@gmail.com)
```

---

## 2. Form Fields Specification

| Field Name | HTML Tag | Type | Required | Purpose |
| :--- | :--- | :--- | :--- | :--- |
| `name` | `<input>` | `text` | **Yes** | Visitor / Recruiter full name. |
| `email` | `<input>` | `email` | **Yes** | Reply-to email address for communication. |
| `subject` | `<input>` | `text` | **Yes** | Subject line of the inquiry or opportunity. |
| `message` | `<textarea>` | `text` | **Yes** | Body content of the message. |

---

## 3. Formspree Endpoint Configuration

- **Action Endpoint**: `https://formspree.io/f/xppzjrky`
- **HTTP Method**: `POST`
- **Security & Privacy**:
  - The Formspree endpoint ID (`xppzjrky`) is public and intended for static website forms.
  - Zero private account credentials, API secrets, or passwords are required or exposed in the client HTML or repository.
  - All form submissions are routed directly to **`shivamgarg1515@gmail.com`**.

---

## 4. Submission & UX Handling

### Progressive Enhancement Flow:
1. **Validation**: All fields are validated before submission. Invalid emails trigger native HTML5 validation prompts.
2. **Submitting State**:
   - The submit button state switches to `"Sending Message..."` and is temporarily disabled to prevent duplicate submissions.
3. **Success State**:
   - Displays a clean green alert:  
     *"✓ Thank you! Your message has been sent successfully. Shivam will respond shortly."*
   - The form input fields are automatically cleared.
4. **Failure Handling**:
   - If a network error occurs or Formspree returns a non-200 status, the user is notified with an error alert and directed to use the direct email fallback:  
     *"✗ Submission failed. Please try again or email shivamgarg1515@gmail.com directly."*
   - The submit button is restored.
5. **No-JS Fallback**:
   - If JavaScript is disabled, the form submits natively via standard HTTP POST to Formspree's hosted confirmation page.

---

## 5. Direct Contact Fallback

In addition to the web form, the contact panel and footer permanently display Shivam Garg's direct email:
- **Email**: [shivamgarg1515@gmail.com](mailto:shivamgarg1515@gmail.com)
- **Direct Mailto Link**: `mailto:shivamgarg1515@gmail.com`

---

## 6. Exact Location in `index.html`

The contact form is located within the `<section class="contact-section" id="contact">` block:

```html
<form id="portfolio-contact-form" action="https://formspree.io/f/xppzjrky" method="POST" class="contact-form">
  <!-- Name, Email, Subject, Message, and Submit Button -->
</form>
```

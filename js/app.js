/* =====================================================================
   PORTFOLIO JAVASCRIPT
   Shivam Garg | Data Analyst Portfolio
   ===================================================================== */

document.addEventListener('DOMContentLoaded', () => {
  // 1. Report Pages Tab Switching
  const tabBtns = document.querySelectorAll('.tab-btn');
  const tabContents = document.querySelectorAll('.tab-content');

  tabBtns.forEach(btn => {
    btn.addEventListener('click', () => {
      const targetId = btn.getAttribute('data-target');
      
      tabBtns.forEach(b => b.classList.remove('active'));
      tabContents.forEach(c => c.classList.remove('active'));

      btn.classList.add('active');
      const targetEl = document.getElementById(targetId);
      if (targetEl) targetEl.classList.add('active');
    });
  });

  // 2. Screenshot Lightbox Modal
  const modal = document.getElementById('image-modal');
  const modalImg = document.getElementById('modal-img');
  const modalClose = document.getElementById('modal-close');
  const screenshotCards = document.querySelectorAll('.screenshot-card');

  screenshotCards.forEach(card => {
    card.addEventListener('click', () => {
      const img = card.querySelector('.screenshot-img');
      if (img && modal && modalImg) {
        modalImg.src = img.src;
        modal.classList.add('open');
      }
    });
  });

  if (modalClose && modal) {
    modalClose.addEventListener('click', () => {
      modal.classList.remove('open');
    });
    modal.addEventListener('click', (e) => {
      if (e.target === modal) {
        modal.classList.remove('open');
      }
    });
  }

  // 3. Copy Code Buttons
  const copyButtons = document.querySelectorAll('.copy-btn');
  copyButtons.forEach(btn => {
    btn.addEventListener('click', () => {
      const targetId = btn.getAttribute('data-code');
      const codeEl = document.getElementById(targetId);
      if (codeEl) {
        navigator.clipboard.writeText(codeEl.innerText).then(() => {
          const originalText = btn.innerText;
          btn.innerText = 'Copied!';
          setTimeout(() => {
            btn.innerText = originalText;
          }, 2000);
        });
      }
    });
  });

  // 4. DAX & SQL Tab Selectors
  setupCodeTabs('dax-tab-btn', 'dax-content');
  setupCodeTabs('sql-tab-btn', 'sql-content');

  function setupCodeTabs(btnClass, contentClass) {
    const btns = document.querySelectorAll('.' + btnClass);
    const contents = document.querySelectorAll('.' + contentClass);

    btns.forEach(btn => {
      btn.addEventListener('click', () => {
        const target = btn.getAttribute('data-code-target');
        btns.forEach(b => b.classList.remove('active'));
        contents.forEach(c => c.classList.remove('active'));

        btn.classList.add('active');
        const activeContent = document.getElementById(target);
        if (activeContent) activeContent.classList.add('active');
      });
    });
  }

  // 5. Smooth Nav Active State
  const sections = document.querySelectorAll('section[id]');
  window.addEventListener('scroll', () => {
    const scrollY = window.pageYOffset;
    sections.forEach(current => {
      const sectionHeight = current.offsetHeight;
      const sectionTop = current.offsetTop - 100;
      const sectionId = current.getAttribute('id');
      const navLink = document.querySelector(`.nav-links a[href*=${sectionId}]`);

      if (navLink) {
        if (scrollY > sectionTop && scrollY <= sectionTop + sectionHeight) {
          navLink.classList.add('active');
        } else {
          navLink.classList.remove('active');
        }
      }
    });
  });
});

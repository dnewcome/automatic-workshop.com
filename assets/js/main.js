(function () {
  'use strict';

  // Mobile navigation toggle
  var burger = document.querySelector('.gh-burger');
  var mobileNav = document.querySelector('.gh-head-mobile-nav');

  if (burger && mobileNav) {
    burger.addEventListener('click', function () {
      var isExpanded = burger.getAttribute('aria-expanded') === 'true';
      burger.setAttribute('aria-expanded', String(!isExpanded));
      mobileNav.classList.toggle('is-open');
      document.body.classList.toggle('gh-nav-open');
    });

    document.addEventListener('keydown', function (e) {
      if (e.key === 'Escape' && mobileNav.classList.contains('is-open')) {
        burger.setAttribute('aria-expanded', 'false');
        mobileNav.classList.remove('is-open');
        document.body.classList.remove('gh-nav-open');
      }
    });
  }

  // Header scroll shadow
  var header = document.querySelector('.gh-head');
  if (header) {
    window.addEventListener('scroll', function () {
      if (window.scrollY > 10) {
        header.classList.add('gh-head-scrolled');
      } else {
        header.classList.remove('gh-head-scrolled');
      }
    }, { passive: true });
  }

})();

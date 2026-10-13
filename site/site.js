// TreniDay landing page: Goro's exercise animations (lottie-web, cropped to
// the figure like the app's ExerciseThumb), the running hold on the workout
// mock-up and the reveal on scroll. Everything degrades to a static page.
(function () {
  'use strict';

  var root = document.documentElement;
  var reduceMotion = window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  root.classList.add('js');

  // ── Reveal sections as they scroll in ──────────────────────────────────
  var reveals = document.querySelectorAll('.reveal');
  if (!('IntersectionObserver' in window) || reduceMotion) {
    reveals.forEach(function (el) { el.classList.add('in'); });
  } else {
    var ro = new IntersectionObserver(function (entries) {
      entries.forEach(function (e) {
        if (e.isIntersecting) { e.target.classList.add('in'); ro.unobserve(e.target); }
      });
    }, { rootMargin: '0px 0px -8% 0px' });
    reveals.forEach(function (el) { ro.observe(el); });
  }

  // ── Exercise animations ────────────────────────────────────────────────
  // Each <div class="lottie" data-anim="name"> plays anim/<name>.json once it
  // comes near the screen; anim/crops.json holds the square around the figure
  // on the 400 × 400 canvas (written by tools/site/build_site.py from
  // lib/data/static/animation_crops.dart).
  var base = root.getAttribute('data-base') || '';
  var slots = Array.prototype.slice.call(document.querySelectorAll('.lottie[data-anim]'));
  var crops = null;
  var players = [];

  function start(el) {
    if (el.dataset.started || !window.lottie || !crops) return;
    el.dataset.started = '1';
    var name = el.dataset.anim;
    var anim = window.lottie.loadAnimation({
      container: el,
      renderer: 'svg',
      loop: true,
      autoplay: !reduceMotion,
      path: base + 'anim/' + name + '.json',
      rendererSettings: { preserveAspectRatio: 'xMidYMid meet', progressiveLoad: true }
    });
    anim.addEventListener('DOMLoaded', function () {
      var c = crops[name];
      var svg = el.querySelector('svg');
      if (c && svg) svg.setAttribute('viewBox', c.join(' '));
      if (reduceMotion) anim.goToAndStop(Math.floor(anim.totalFrames / 3), true);
    });
    players.push({ el: el, anim: anim });
  }

  function watch() {
    if (!('IntersectionObserver' in window)) { slots.forEach(start); return; }
    var lo = new IntersectionObserver(function (entries) {
      entries.forEach(function (e) {
        if (e.isIntersecting) start(e.target);
        // Pause what is off screen: a page of loops should not burn a phone.
        players.forEach(function (p) {
          if (p.el === e.target && !reduceMotion) e.isIntersecting ? p.anim.play() : p.anim.pause();
        });
      });
    }, { rootMargin: '200px 0px' });
    slots.forEach(function (el) { lo.observe(el); });
  }

  if (slots.length) {
    fetch(base + 'anim/crops.json')
      .then(function (r) { return r.json(); })
      .catch(function () { return {}; })
      .then(function (json) {
        crops = json;
        if (window.lottie) watch();
        else window.addEventListener('load', function () { if (window.lottie) watch(); });
      });
  }

  // ── The hold running on the workout mock-up ────────────────────────────
  var ring = document.querySelector('[data-hold]');
  if (ring) {
    var total = parseInt(ring.getAttribute('data-hold'), 10) || 30;
    var arc = ring.querySelector('.arc');
    var num = ring.querySelector('b');
    var len = 2 * Math.PI * 50;
    var left = total;
    arc.style.strokeDasharray = len.toFixed(1);
    var draw = function () {
      num.textContent = left;
      arc.style.strokeDashoffset = (len * (1 - left / total)).toFixed(1);
    };
    draw();
    if (!reduceMotion) {
      setInterval(function () {
        left = left > 1 ? left - 1 : total;
        draw();
      }, 1000);
    }
  }
})();

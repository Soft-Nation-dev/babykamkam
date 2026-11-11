const body = document.body;
const intro = document.querySelector("[data-intro]");
const site = document.querySelector("[data-site]");
const openButton = document.querySelector("[data-open-invitation]");
const skipButton = document.querySelector("[data-skip-intro]");
const skipLink = document.querySelector(".skip-link");
const reduceMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches;

let introFinished = false;

function finishIntro({ focus = false } = {}) {
  if (introFinished) return;
  introFinished = true;
  intro.classList.add("is-complete");
  site.classList.add("is-visible");
  site.setAttribute("aria-hidden", "false");
  body.classList.remove("intro-active");

  document.querySelectorAll(".hero .reveal").forEach((element, index) => {
    window.setTimeout(() => element.classList.add("is-revealed"), index * 130);
  });

  if (focus) {
    const heading = document.querySelector(".hero h2");
    heading.setAttribute("tabindex", "-1");
    heading.focus({ preventScroll: true });
  }
}

function openInvitation() {
  if (introFinished) return;
  intro.classList.add("is-opening");
  openButton.disabled = true;
  window.setTimeout(() => finishIntro(), reduceMotion ? 0 : 1100);
}

openButton.addEventListener("click", openInvitation);
skipButton.addEventListener("click", () => finishIntro({ focus: true }));
skipLink.addEventListener("click", () => finishIntro());

window.addEventListener("keydown", (event) => {
  if (event.key === "Escape" && !introFinished) finishIntro({ focus: true });
});

if (window.location.hash && window.location.hash !== "#top") {
  finishIntro();
}

function seededRandom(seed) {
  const value = Math.sin(seed * 999) * 10000;
  return value - Math.floor(value);
}

const stars = document.querySelector("[data-stars]");
for (let index = 0; index < 36; index += 1) {
  const star = document.createElement("span");
  star.className = "star";
  star.style.left = `${seededRandom(index + 1) * 100}%`;
  star.style.top = `${seededRandom(index + 41) * 100}%`;
  star.style.setProperty("--size", `${2 + seededRandom(index + 81) * 4}px`);
  star.style.setProperty("--duration", `${2.5 + seededRandom(index + 121) * 3.5}s`);
  star.style.setProperty("--delay", `${seededRandom(index + 161) * -5}s`);
  stars.appendChild(star);
}

const revealObserver = new IntersectionObserver(
  (entries, observer) => {
    entries.forEach((entry) => {
      if (!entry.isIntersecting) return;
      entry.target.classList.add("is-revealed");
      observer.unobserve(entry.target);
    });
  },
  { threshold: 0.14, rootMargin: "0px 0px -5%" },
);

document.querySelectorAll(".reveal").forEach((element) => revealObserver.observe(element));

const targetDate = new Date("2026-12-13T14:00:00+01:00");
const countdown = document.querySelector("[data-countdown]");
const countdownFields = {
  days: countdown.querySelector("[data-days]"),
  hours: countdown.querySelector("[data-hours]"),
  minutes: countdown.querySelector("[data-minutes]"),
  seconds: countdown.querySelector("[data-seconds]"),
};

function updateCountdown() {
  const difference = Math.max(0, targetDate.getTime() - Date.now());
  const totalSeconds = Math.floor(difference / 1000);
  const days = Math.floor(totalSeconds / 86400);
  const hours = Math.floor((totalSeconds % 86400) / 3600);
  const minutes = Math.floor((totalSeconds % 3600) / 60);
  const seconds = totalSeconds % 60;

  countdownFields.days.textContent = String(days).padStart(2, "0");
  countdownFields.hours.textContent = String(hours).padStart(2, "0");
  countdownFields.minutes.textContent = String(minutes).padStart(2, "0");
  countdownFields.seconds.textContent = String(seconds).padStart(2, "0");
}

updateCountdown();
window.setInterval(updateCountdown, 1000);

const portraitScene = document.querySelector("[data-portrait-scene]");
const portraitShell = portraitScene.querySelector(".portrait-shell");

if (!reduceMotion) {
  portraitScene.addEventListener("pointermove", (event) => {
    const bounds = portraitScene.getBoundingClientRect();
    const normalizedX = (event.clientX - bounds.left) / bounds.width - 0.5;
    const normalizedY = (event.clientY - bounds.top) / bounds.height - 0.5;
    portraitShell.style.setProperty("--rotate-y", `${normalizedX * 14}deg`);
    portraitShell.style.setProperty("--rotate-x", `${normalizedY * -10}deg`);
  });

  portraitScene.addEventListener("pointerleave", () => {
    portraitShell.style.setProperty("--rotate-y", "-5deg");
    portraitShell.style.setProperty("--rotate-x", "2deg");
  });

  document.querySelectorAll(".tilt-card").forEach((card) => {
    card.addEventListener("pointermove", (event) => {
      const bounds = card.getBoundingClientRect();
      const x = (event.clientX - bounds.left) / bounds.width - 0.5;
      const y = (event.clientY - bounds.top) / bounds.height - 0.5;
      card.style.setProperty("--card-y", `${x * 6}deg`);
      card.style.setProperty("--card-x", `${y * -6}deg`);
    });

    card.addEventListener("pointerleave", () => {
      card.style.setProperty("--card-y", "0deg");
      card.style.setProperty("--card-x", "0deg");
    });
  });
}

const splineLayer = document.querySelector("[data-spline-scene]");
const splineSceneUrl = splineLayer.dataset.splineScene.trim();

if (splineSceneUrl) {
  const iframe = document.createElement("iframe");
  iframe.src = splineSceneUrl;
  iframe.title = "Interactive 3D dedication scene";
  iframe.loading = "eager";
  iframe.allow = "autoplay; fullscreen";
  splineLayer.appendChild(iframe);
}

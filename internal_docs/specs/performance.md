# App performance — idea (owner, 2026-10-12)

> Part of the project notes — the index is [internal_docs/README.md](../README.md).

**The wish:** work on the app's performance as a separate piece of work, in a session (or branch) of its own. Nothing is measured or decided yet.

**How to start:** measure before changing anything — a profile build (`flutter run --profile`) on a real iPhone and a real Android phone with DevTools (frame chart, CPU profiler, memory), the web build with the browser's performance panel. Write the numbers here, agree a budget with the owner, then fix the worst first.

**Candidate places to look at** (guesses from the code, not findings):
- **Start-up:** `main()` opens seven Hive boxes and runs the progress migrations before the first frame; the post-frame init then runs notifications, Health (`configure`, with a 5 s timeout), the widget snapshot (which builds today's plan) and the deep-link check one after another.
- **Lottie in lists:** `ExerciseThumb` plays an animation in every visible tile (Home's branches and plan, the Courses tab, the pickers, Branch Journey); compositions are cached, but every tile ticks a controller.
- **Home:** `homeDataProvider` and `todayPlanProvider` rebuild the middle and the plan; `HomeDigest` and the generator run on every rebuild; the host's SVG at 200 px.
- **The workout screen:** a 1 s timer, the cue chooser, the Lottie player, 21 preloaded audio players.
- **The web build:** about 4.2 MB compressed on first load (measured 2026-10-07); fonts, the CanvasKit renderer, 155 Lottie files in the bundle.
- **Memory:** SVGs of five hosts in six moods, Lottie compositions, the widget art (iOS widget extensions have a ~30 MB limit; 12 PNGs of ~37 KB decode to 590 KB each).

**Done when:** the owner has the numbers, the agreed budget, and the fixes that bring the worst places under it.

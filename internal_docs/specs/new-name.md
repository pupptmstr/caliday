# A new name for the app — idea (owner, 2026-10-12)

> Part of the project notes — the index is [internal_docs/README.md](../README.md).

**The wish:** while making the landing page the owner learned that the `caliday` domains are taken and asked to think of another name. Not urgent: recorded only, nothing is decided.

**What was found (2026-10-12, before deciding anything):**
- `caliday.com` is registered and parked for sale (Afternic); `caliday.app` is registered; `caliday.io` and `caliday.fit` looked free (whois).
- A web search for "caliday app" found no other app or product with this name — only calendar apps with similar names (Cal List, Calindori). So the name itself does not look taken; the domains are. Before choosing, check the trademark registers (EUIPO, USPTO, WIPO) and the App Store / Google Play for the candidate.

**If the name changes, it touches:** the app's display name (`CFBundleDisplayName`, the Android label, the web `manifest.json` / `index.html`), every ARB string that says CaliDay (and the What's new history), the app icon's alt texts, the widgets' names, the landing page (`site/`, the og cards by `tools/site/make_og.py`), the legal pages in `docs/`, the GitHub repository and with it the Pages address (`/caliday/`; the legal URLs are referenced from the app and the store listings), the store listings. The bundle / application id (`com.pupptmstr.caliday`) can stay as it is: users never see it, and changing it makes a new app in the stores.

**When:** best before the first store release — afterwards a rename costs the listing's history and the users' recognition.

**Questions for the owner:** what the name should say (calisthenics, every day, Goro, play?); whether Goro's name can carry the brand; whether a short own domain matters (a custom domain for Pages is one `--url` of `tools/site/build_site.py` plus the DNS).

**Done when:** the owner has picked a name from a checked shortlist (domain, trademarks, stores), and it is in the app, the site and the listings.

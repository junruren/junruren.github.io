# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Junru Ren's personal site (https://junruren.com), a Jekyll site deployed on GitHub Pages. It is a detached fork of the [academicpages](https://github.com/academicpages/academicpages.github.io) template (itself derived from Minimal Mistakes). The `upstream` remote still points at academicpages, so most files under `_includes/`, `_layouts/`, `_sass/`, `assets/`, `markdown_generator/`, and `talkmap*` are unmodified template code — prefer content changes over template edits, since local edits there create merge conflicts when syncing upstream.

The day-to-day work in this repo is **writing blog posts**, not developing software.

## Build / preview

Local preview works on this machine, but the whole toolchain **must run under Rosetta**:

```bash
arch -x86_64 env ARCHFLAGS="-arch x86_64" /usr/bin/bundle install  # installs into vendor/bundle
arch -x86_64 /usr/bin/bundle exec jekyll serve -l -H localhost    # http://localhost:4000, live reload
arch -x86_64 /usr/bin/bundle exec jekyll build                    # one-off build into _site/
```

Spell out `/usr/bin/bundle`. A bare `bundle` resolves to `/opt/homebrew/bin/bundle`, which is
an arm64-only Ruby 4 script, so `arch -x86_64 bundle` dies with `Bad CPU type in executable`
before it reaches the Gemfile.

This uses the macOS system Ruby (`/usr/bin/ruby` 2.6) with Bundler 1.17, which is what `Gemfile.lock` was resolved against. `docker compose up` is the documented alternative but `docker` is not on PATH here.

Four things make this fragile; do not "fix" them by guessing:

- **Why Rosetta.** System Ruby 2.6 is a universal binary, and `Gem::Platform.local` reports `universal-darwin-25` under *both* architectures. RubyGems therefore treats the **x86_64** precompiled gems as compatible and installs `nokogiri-…-x86_64-darwin` and `ffi-…-x86_64-darwin`. An arm64 process cannot load them and dies with `LoadError: cannot load such file -- nokogiri/nokogiri`. Running under `arch -x86_64` makes the process x86_64 so the gems load. Dropping the prefix is the single most likely way to "break" the build again.
- **`arch -x86_64` alone is not enough for gems built from source.** It makes the Ruby *process*
  x86_64, which is what lets the precompiled gems load — but when a gem compiles its own C
  extension, `clang` still defaults to the native arm64 target. The result is a vendor tree that
  is architecturally mixed: `nokogiri` and `ffi` (precompiled) x86_64, while `eventmachine`,
  `http_parser.rb`, `racc`, and `commonmarker` (source-built) come out arm64. `jekyll build`
  never loads those four, so builds pass and nothing looks wrong — but `jekyll serve -l` needs
  `eventmachine` for livereload and dies with `incompatible architecture (have 'arm64', need
  'x86_64')`. Hence `ARCHFLAGS="-arch x86_64"` on the install line above. To check:
  `find vendor/bundle -name '*.bundle' | xargs -n1 lipo -archs | sort | uniq -c` should report
  x86_64 only. To repair, delete the offending gem and extension directories under
  `vendor/bundle/ruby/2.6.0/` and re-run the install command — bundler will not rebuild a gem
  it considers already present.
- **Never `sudo gem install` for this repo.** The old root-owned install at `/Library/Ruby/Gems/2.6.0` has native extensions compiled for `universal-darwin-23` and `-24`; upgrading macOS to Darwin 25 orphaned them, which is the `Could not find commonmarker` failure. The `vendor/bundle` install above sidesteps that with no sudo and no system directories. `rm -rf vendor .bundle` resets it completely. `vendor/` and `.bundle/` are gitignored.
- **Homebrew Ruby cannot run this Gemfile.** `ruby 4.0.6` is on PATH ahead of the system Ruby, but `github-pages` (231) pins jekyll 3.9.5 plus a tree of old native gems that will not build on Ruby 4. Prefix commands rather than reaching for `brew`.

None of this affects deployment — `actions/jekyll-build-pages` brings its own pinned toolchain — so `Gemfile.lock` is gitignored and local drift is harmless. Ruby 2.6 has been end-of-life since 2022, so the durable fix, when it is worth the time, is `brew install ruby@3.3` + `bundle install` against that, which drops the Rosetta requirement.

`_config.yml` is **not** reloaded by `jekyll serve` — restart the server after editing it.

There are no tests, linters, or type checks in this repo.

JavaScript is pre-bundled: `npm install && npm run build:js` concatenates jQuery + plugins + `assets/js/_main.js` into `assets/js/main.min.js`, which **is committed** (`node_modules/` is gitignored). Only run it if you touched `assets/js/_main.js` or `assets/js/plugins/`.

## Deployment

Push to `master` → `.github/workflows/jekyll.yml` builds with `actions/jekyll-build-pages` and deploys to GitHub Pages. Only the plugins in the `whitelist:` block of `_config.yml` are available (GitHub Pages safe mode) — do not add gems expecting them to run in CI. `_site/` is build output and gitignored; never edit it.

Work happens on topic branches named `blog/<topic>/N` (e.g. `blog/waymo/1`, `about/update/1`) and lands on `master` via PR.

Those branches accumulate. `./scripts/tidy-local.sh` fast-forwards `master`, prunes remote-tracking
refs, and deletes local branches whose work has landed — including rebase- and squash-merged ones, which
`git branch --merged` misses because they share no SHA with `master`. It prints a plan by default;
`--apply` performs the deletions. It detects all three merge styles — merge commit, rebase, and
squash — since only the first leaves a shared SHA. It refuses to run on a dirty tree and never
touches `upstream`.

### Pull requests must target this repo, never the template

`origin` is `junruren/junruren.github.io`. `upstream` is the academicpages template this site was forked from. With both remotes present and nothing pinned, **`gh` resolves the repo to `academicpages/academicpages.github.io`** — so a bare `gh pr create` opens a pull request against the *template project*, not this site. This was verified, not hypothetical.

The guards live in `.git/config` and therefore do **not** survive a fresh clone. After cloning, run:

```bash
./scripts/setup-git-guards.sh
```

It pins `gh repo set-default junruren/junruren.github.io`, makes `upstream` fetch-only (`git fetch upstream` still works for template syncs; `git push upstream` fails loudly), and sets `remote.pushDefault=origin`. It is idempotent and self-verifying.

Confirm with `gh repo view --json nameWithOwner` — it must print `junruren/junruren.github.io`. When creating a PR by hand, be explicit anyway:

```bash
gh pr create --repo junruren/junruren.github.io --base master
```

## Upstream sync policy

**Last synced: 2026-08-21, up to `a4386d8`** (previous sync: 2025-04-09).

Treat academicpages as a **parts catalogue, not a source of truth**. This is a site that was
seeded from a template, not a fork that tracks it. There is no server, no runtime dependency,
and no user data here, so upstream carries almost nothing security-relevant — its changes are
overwhelmingly cosmetic and performance work.

**Cadence: review, don't chase.** Roughly twice a year, *and* always before editing any template
file, skim what has landed and cherry-pick only what you want:

```bash
git fetch upstream
git log --oneline master..upstream/master
```

Never auto-merge, and never add CI that does.

**What keeps this cheap.** Across 113 upstream commits and 16 months, the conflict surface was
four files. That held only because local edits to `_sass/`, `_layouts/`, `assets/`, and existing
`_includes/` are near zero. Preserve that: add new files (like `_includes/substack-embed.html`)
or override through `_includes/head/custom.html` and `_includes/footer/custom.html` rather than
editing template code in place.

**Never take these from upstream:**

- `.github/CONTRIBUTING.md`, `.github/PULL_REQUEST_TEMPLATE.md`, and the `bad-pr`, `close-tests`,
  and `jekyll-build` workflows. They manage contributions to the *template project*; `bad-pr.yml`
  auto-closes PRs and `jekyll-build.yml` targets branch `main` and would run alongside our deploy.
  The only workflow this site needs is `.github/workflows/jekyll.yml`.
- Academicons from jsDelivr. It is deliberately self-hosted from `assets/css/academicons.min.css`
  (keep upstream's `preload` pattern, just point it at the local file). Same principle removed the
  `cdnjs.cloudflare.com` polyfill — prefer fewer third-party hosts.
- The Mastodon share button in `_includes/social-share.html`. It is the only share link that
  routes readers through a third party (`addtoany.com`); the other four go straight to the
  destination. Upstream owns this file, so a sync will try to put it back.
- Demo content: `_pages/markdown.md`, `_publications/*paper-title-number-*.md`, and the `images/`
  files only those pages reference. Upstream keeps adding new ones; delete them each time.

**Gotcha:** upstream added `connection_pool` to the `Gemfile`, so a sync means re-running
`arch -x86_64 env ARCHFLAGS="-arch x86_64" /usr/bin/bundle install` before local preview works again. Deployment is unaffected —
`actions/jekyll-build-pages` brings its own pinned toolchain, which is also why `Gemfile.lock`
is gitignored.

**After any sync, verify by hand:** homepage, `/cv/`, `/year-archive/`, a MathJax-heavy post, a
Substack mirror post, the dark-mode toggle, and the footer on a narrow viewport.

## Git gotcha

This repo has `status.showUntrackedFiles=no` set locally. Plain `git status` reports "nothing to commit" even when a brand-new post or image directory exists on disk. **Always use `git status -u`** (or `git status --untracked-files=all`) before concluding the tree is clean or that a file was committed.

## Content model

Three content types, all driven by `defaults:` in `_config.yml` — front matter does **not** need `layout:`, `author_profile:`, `read_time:`, etc.:

- `_posts/YYYY-MM-DD-Slug.md` — blog posts, listed at `/year-archive/` ("Blog Posts" in the nav).
- `_pages/*.md|html` — standalone pages, each declaring its own `permalink:` (`about.md` is the homepage at `/`).
- Collections `_publications/`, `_talks/`, `_teaching/`, `portfolio` — declared under `collections:`; `_talks` and `_teaching` are currently unused and hidden from the nav (see `_data/navigation.yml`).

### Post front matter conventions

```yaml
---
title: "Post Title"
date: 2026-07-29
permalink: /posts/2026/07/short-slug/
tags:
  - personal
  - mit
---
```

The site-wide `permalink: /:categories/:title/` is overridden per-post by an explicit `/posts/YYYY/MM/slug/` — follow that pattern so URLs stay stable and predictable.

Two behaviors that bite:

- **`future: false`** — a post dated after today's date is silently dropped from the build.
- **`excerpt_separator: "\n\n"`** — the first paragraph of a post becomes its excerpt on `/year-archive/` and in the RSS feed. A leading image or figure therefore renders inside the archive listing. Start posts with a text paragraph and place hero/cover images after it (see commit `b867cbe`, which moved photos for exactly this reason).

Cross-link posts with Liquid rather than hardcoded URLs:

```liquid
[using LaTeX in VS Code]({% post_url 2025-06-29-Tutorial-LaTeX-VSCode %})
```

### Images and files

Per-post image directories are named after the post file: `images/2026-07-29-MIT-Reflection/…`, referenced with absolute paths (`/images/2026-07-29-MIT-Reflection/Dome.jpeg`). Larger photos use a `<figure>` with an `<a>` wrapper to the full image, explicit `width`/`height`, a descriptive `alt`, and a `<figcaption>`. Downloadable assets (PDFs, `files/cv.pdf`) go in `files/` and are served at `/files/…`.

### Publications

Each entry sets `category:` to a key from `publication_category:` in `_config.yml`. Only `patents` has a heading title configured; other categories render with a blank `<h2>`, so add a title there before using a new category.

## Substack and the dual-platform model

Since August 2026, essays also live on Substack (<https://junruren.substack.com>). junruren.com remains the complete archive of everything, so updates stay accessible to a diverse audience however (and wherever) they read. Substack has no canonical-URL support, no native Markdown tables, and only limited LaTeX — which is why the split below exists.

- **Reports, tutorials, and project write-ups** are written here in `_posts/` (site-first), as always. Copying one to Substack is optional and manual.
- **Essays** are published on Substack first (that's where the email goes out). After publishing one, run `python3 scripts/substack_sync.py` from the repo root and commit/push the result — it mirrors each new Substack post into `_posts/` as a generated file: `generated: substack-sync` and `substack_url:` in the front matter, full HTML body, images downloaded to `images/substack/<slug>/` (the mirror is fully self-hosted, no third-party CDN dependency). **The sync is deliberately manual — do not re-add CI automation for it.** Substack blocks GitHub Actions egress IPs (verified Aug 2026: direct fetches and generic proxies all fail from runners), and routing post content through third-party relay APIs was considered and rejected. Don't hand-edit a generated mirror beyond front-matter touch-ups (e.g. adding tags); the Substack version is the source of truth for those posts.
- **The skip marker**: the sync ignores any feed item whose body contains "Originally published at https://junruren.com". That line marks posts that originated here (the five posts migrated in Aug 2026 all carry it on their Substack copies). **Always keep that exact attribution line when hand-copying a site post to Substack**, or the sync will mirror the copy back and create a duplicate.
- Site-origin posts that also exist on Substack carry a `{: .notice}` line ("This post also lives on my Substack…") placed **after** the first paragraph — never before it, or it becomes the archive excerpt.
- `substack_url:` in `_config.yml` powers `_includes/substack-embed.html` (the subscribe iframe on the About page); `_data/navigation.yml` has a "Newsletter" external link.
- Hand-copying a site post into the Substack editor: GitHub Pages serves `Access-Control-Allow-Origin: *`, so from a Substack editor tab you can `fetch()` the rendered junruren.com post, absolutize `src`/`href` against the post URL, and dispatch a synthetic `paste` ClipboardEvent with `text/html` into the ProseMirror editor — Substack then re-hosts images automatically. Set the title via the React-native value setter (typed input during page load gets dropped), publish **without** sending email for back-dated posts, and set the publish date and slug to match the original.

## Writing style and editorial conventions

Distilled from the ten published posts. Match these when drafting or editing prose; they are descriptive of what Junru actually does, not aspirational rules.

**Voice**

- First person, warm and plain, low on hype. Claims get hedged rather than oversold ("I got lucky, very lucky"; "this sounds like common sense"). Failures are narrated openly — a whole 6.7960 section explains how an `argmax` broke the gradient chain and wasted weeks.
- Register shifts by post type. Reflective essays (MIT reflection, Jazz and Homesickness) lean away from contractions and carry no emoji; tutorials and lighter posts use contractions freely and sprinkle 😅 😉 🌟 sparingly.
- Short one-sentence paragraphs land the beats: "Lesson learned." "So there you have it." "Yes, with conditions."
- Rhetorical questions open sections; parenthetical asides carry the jokes. Complaints are softened and never aimed at a named person ("those trivial 'complaints' aside").
- The engineer + MBA dual lens is a recurring explicit frame, as is the Chinese/international-student perspective. Foreign-language terms are italicized and glossed in a footnote.

**Structure**

- The opening paragraph states what the post is and who it is for, often with a one-line thesis ("The short version: find the right announcement surfaces, show up, and keep the curiosity dial set to 'loud.'"). Because of `excerpt_separator`, this paragraph is also the archive blurb — write it to stand alone.
- Section titles are concrete and often playful: "Party or Pset?", "Flip the Table", "The Dual Mandate", "Was It Worth It?". Long posts get an explicit scaffold — time-of-day headers for the MIT reflection, numbered steps for tutorials and playbooks.
- `---` horizontal rules separate movements within a post.
- Bold lead-ins act as mini-headings inside prose sections ("**Networking is a must.**", "**Literature review starts on day one.**").
- Posts close with a short reflective beat plus an invitation to reply (`[Drop me a note](mailto:junru@computer.org)`, "I'd love to learn from them") or a teaser for the next post.
- Optional `## Appendix:` sections hold link lists, source tables, or by-the-numbers receipts.

**Sourcing and credit**

- Nearly every proper noun is linked — professors' and TAs' personal homepages, programs, arXiv papers, news articles, Wikipedia for public figures. Prefer primary sources.
- Footnotes (`[^1]`) carry glosses, citations, and asides that would break the sentence.
- Credit is given generously and by name: an `## Acknowledgement` section on project posts, thanks to the person who suggested an idea, a long closing thank-you on the reflection.
- Consent and scope disclaimers appear where content touches other people or institutions — the CSAIL post offers to remove the mailing-list links on request; the cheatsheet post warns that exam scope may differ.
- Exact numbers with receipts: 91.23%, 502 images, 231 units, 388.25 miles. Comparisons and results go in Markdown tables.

**Mechanics that recur**

- Cover images are ChatGPT-generated and credited with the model and full prompt, in a blockquote with the prompt italicized: `> Generated by GPT-4o. Prompt: _..._`.
- Image captions use `> caption text` directly under the image in older posts; newer posts use `<figure>`/`<figcaption>` (with `class="half"` for side-by-side pairs, and an inline `max-width` style for portrait shots).
- `{: .notice}` marks disclaimers, cautions, and update notes.
- Evergreen tutorials are revised in place with a **dated** update note rather than silently edited, and they speak directly to readers of the earlier version ("Breadcrumb for my Class of 2026 classmates: the old version of this post told you to...").
- Posts cross-link each other with `{% post_url %}` and often tease the next post in a series.
- Work held back stays in the repo rather than being deleted: `published: false` in front matter (`2024-12-10-6.7960-Final-Project-Blog.md`), and cut sections are left in the file as HTML comments (the leadership section in the MIT reflection).

**Titles and tags**

- Titles are Title Case, frequently with a colon subtitle: `Tutorial: <Topic>` for tutorials, `<Course Number> Final Project: <Topic>` for class write-ups, or a question (`What is it like to do AI research inside Nike?`).
- Two to five lowercase tags per post; `mit` appears on most. Existing tags to reuse: `personal`, `mit`, `mit-sloan`, `grad-school`, `tutorial`, `latex`, `vscode`, `class`, `projects`, `research`, `ai`, `software`, `culture`, `networking`, `music`, `internship`, `nike`.

## The CV has two rendering paths

- `_pages/cv.md` — hand-written Markdown, served at `/cv/`, linked from the nav. **This is the source of truth.**
- `_data/cv.json` + `_includes/cv-template.html` + `_sass/layout/_json_cv.scss` — a JSON-Resume-style rendering at `/cv-json/`, currently not linked from the nav. Regenerated from the Markdown by `scripts/update_cv_json.sh` (wraps `scripts/cv_markdown_to_json.py`, which also pulls contact/social fields out of `_config.yml`).

After editing `_pages/cv.md`, run `./scripts/update_cv_json.sh` to keep `/cv-json/` in sync (it prompts to start a Jekyll server at the end — answer `n` to skip). Also refresh `files/cv.pdf` separately if the PDF is meant to match.

## Site-wide configuration

Nearly everything personal lives in `_config.yml`: title/description, the `author:` block (bio, employer, and the social handles that drive the sidebar icons), Google Analytics ID, publication categories, and collection defaults. `_data/navigation.yml` controls the header links — commented-out entries (Talks, Teaching, Portfolio, the JSON CV) hide sections without deleting their content.

Styling is Sass under `_sass/` (entry point `assets/css/main.scss`), with `_sass/theme/_default.scss` and `_sass/theme/_dark.scss` as the two color themes. `.sass-cache/` is stale build residue, not source.

## Inherited template machinery (rarely touched)

`markdown_generator/` holds Jupyter notebooks and Python scripts that generate `_publications/` and `_talks/` markdown from TSV files; `talkmap.ipynb` / `talkmap.py` geocode talk locations into `talkmap/`, driven by `.github/workflows/scrape_talks.yml` on pushes to `talks/**`. These are upstream template features and are not part of the current content workflow.

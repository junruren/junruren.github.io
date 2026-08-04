# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Junru Ren's personal site (https://junruren.com), a Jekyll site deployed on GitHub Pages. It is a detached fork of the [academicpages](https://github.com/academicpages/academicpages.github.io) template (itself derived from Minimal Mistakes). The `upstream` remote still points at academicpages, so most files under `_includes/`, `_layouts/`, `_sass/`, `assets/`, `markdown_generator/`, and `talkmap*` are unmodified template code — prefer content changes over template edits, since local edits there create merge conflicts when syncing upstream.

The day-to-day work in this repo is **writing blog posts**, not developing software.

## Build / preview

```bash
bundle install                                # ruby deps
bundle exec jekyll serve -l -H localhost      # http://localhost:4000, live reload
docker compose up                             # alternative: same site at :4000
```

Neither path works out of the box on this machine right now: the system Ruby is 2.6 with Bundler 1.17 and the gems are not installed (`bundle exec jekyll` fails with `Could not find commonmarker`), and `docker` is not on PATH. Install a modern Ruby (e.g. via `brew install ruby` / rbenv) and re-run `bundle install`, or install Docker Desktop, before promising a local preview.

`_config.yml` is **not** reloaded by `jekyll serve` — restart the server after editing it.

There are no tests, linters, or type checks in this repo.

JavaScript is pre-bundled: `npm install && npm run build:js` concatenates jQuery + plugins + `assets/js/_main.js` into `assets/js/main.min.js`, which **is committed** (`node_modules/` is gitignored). Only run it if you touched `assets/js/_main.js` or `assets/js/plugins/`.

## Deployment

Push to `master` → `.github/workflows/jekyll.yml` builds with `actions/jekyll-build-pages` and deploys to GitHub Pages. Only the plugins in the `whitelist:` block of `_config.yml` are available (GitHub Pages safe mode) — do not add gems expecting them to run in CI. `_site/` is build output and gitignored; never edit it.

Work happens on topic branches named `blog/<topic>/N` (e.g. `blog/waymo/1`, `about/update/1`) and lands on `master` via PR.

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

## The CV has two rendering paths

- `_pages/cv.md` — hand-written Markdown, served at `/cv/`, linked from the nav. **This is the source of truth.**
- `_data/cv.json` + `_includes/cv-template.html` + `assets/css/cv-style.css` — a JSON-Resume-style rendering at `/cv-json/`, currently not linked from the nav. Regenerated from the Markdown by `scripts/update_cv_json.sh` (wraps `scripts/cv_markdown_to_json.py`, which also pulls contact/social fields out of `_config.yml`).

After editing `_pages/cv.md`, run `./scripts/update_cv_json.sh` to keep `/cv-json/` in sync (it prompts to start a Jekyll server at the end — answer `n` to skip). Also refresh `files/cv.pdf` separately if the PDF is meant to match.

## Site-wide configuration

Nearly everything personal lives in `_config.yml`: title/description, the `author:` block (bio, employer, and the social handles that drive the sidebar icons), Google Analytics ID, publication categories, and collection defaults. `_data/navigation.yml` controls the header links — commented-out entries (Talks, Teaching, Portfolio, the JSON CV) hide sections without deleting their content.

Styling is Sass under `_sass/` (entry point `assets/css/main.scss`), with `_sass/theme/_default.scss` and `_sass/theme/_dark.scss` as the two color themes. `.sass-cache/` is stale build residue, not source.

## Inherited template machinery (rarely touched)

`markdown_generator/` holds Jupyter notebooks and Python scripts that generate `_publications/` and `_talks/` markdown from TSV files; `talkmap.ipynb` / `talkmap.py` geocode talk locations into `talkmap/`, driven by `.github/workflows/scrape_talks.yml` on pushes to `talks/**`. These are upstream template features and are not part of the current content workflow.

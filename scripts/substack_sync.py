#!/usr/bin/env python3
"""Mirror new Substack essays into _posts/ so junruren.com stays a complete
archive and updates remain accessible to a diverse audience.

Substack is the source of truth for essays written there; this script turns
each new Substack post into a generated Jekyll post (full HTML body, images
downloaded into images/substack/<slug>/ and rewritten to local paths). Posts
whose content contains "Originally published at https://junruren.com" are
skipped — those originated on this site and already live in _posts/.

Runs from the repo root (locally or in .github/workflows/substack-sync.yml):

    python3 scripts/substack_sync.py [--dry-run]

Stdlib only — no pip installs needed in CI.
"""

from __future__ import annotations

import argparse
import email.utils
import html
import json
import pathlib
import re
import sys
import time
import urllib.error
import urllib.parse
import urllib.request
import xml.etree.ElementTree as ET

FEED_URL = "https://junruren.substack.com/feed"
SITE_ORIGIN_MARKER = "Originally published at https://junruren.com"
CONTENT_NS = "{http://purl.org/rss/1.0/modules/content/}encoded"
REQUEST_HEADERS = {
    "User-Agent": (
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 "
        "(KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36"
    ),
    "Accept": "*/*",
    "Accept-Language": "en-US,en;q=0.9",
}
# Substack (and substackcdn) block requests from GitHub Actions egress IPs at
# the network level — every client gets an instant 403, verified empirically.
# When a direct fetch is refused, retry through a public relay that fetches
# server-side from unblocked IPs: allorigins for the XML feed, wsrv.nl for
# images (allorigins times out on large binaries; wsrv.nl is a dedicated
# image proxy). Direct is always tried first, so nothing changes where
# Substack is reachable.
FEED_RELAY = "https://api.allorigins.win/raw?url={}"
IMAGE_RELAY = "https://wsrv.nl/?url={}"
RETRIES = 3

REPO_ROOT = pathlib.Path(__file__).resolve().parent.parent
POSTS_DIR = REPO_ROOT / "_posts"
IMAGES_ROOT = REPO_ROOT / "images" / "substack"

IMG_EXT_RE = re.compile(r"\.(png|jpe?g|gif|webp|avif)(?=$|[?%])", re.IGNORECASE)


def fetch(url: str, relay: str | None = None) -> bytes:
    """GET url, falling back to the relay when the direct route is blocked."""
    candidates = [url]
    if relay:
        candidates.append(relay.format(urllib.parse.quote(url, safe="")))
    last_error: Exception = RuntimeError("no fetch candidates")
    for candidate in candidates:
        req = urllib.request.Request(candidate, headers=REQUEST_HEADERS)
        for attempt in range(1, RETRIES + 1):
            try:
                with urllib.request.urlopen(req, timeout=60) as resp:
                    return resp.read()
            except (urllib.error.HTTPError, urllib.error.URLError) as err:
                last_error = err
                code = getattr(err, "code", None)
                if code == 403:
                    print(f"HTTP 403 for {candidate}, trying next route")
                    break  # hard block — retrying the same route is pointless
                if attempt == RETRIES:
                    break
                delay = 5 * attempt
                print(f"{err} for {candidate}, retrying in {delay}s "
                      f"({attempt}/{RETRIES})")
                time.sleep(delay)
    raise last_error


def slug_from_link(link: str) -> str:
    return urllib.parse.urlparse(link).path.rstrip("/").split("/")[-1]


def already_mirrored(link: str, slug: str) -> bool:
    needle = f"substack_url: {link}"
    for post in POSTS_DIR.glob("*.md"):
        head = post.read_text(encoding="utf-8", errors="replace")[:2000]
        if needle in head:
            return True
        if post.stem.endswith(slug):
            return True
    return False


def guess_ext(image_url: str) -> str:
    decoded = urllib.parse.unquote(image_url)
    match = IMG_EXT_RE.search(decoded)
    return "." + match.group(1).lower().replace("jpg", "jpeg") if match else ".jpeg"


def localize_images(content: str, slug: str, dry_run: bool) -> str:
    """Download every substackcdn image and point the HTML at local copies."""
    urls = re.findall(r'src="(https://substackcdn\.com/[^"]+)"', content)
    seen = {}
    for index, url in enumerate(dict.fromkeys(urls), start=1):
        local_rel = f"/images/substack/{slug}/image-{index}{guess_ext(url)}"
        seen[url] = local_rel
        if dry_run:
            continue
        target = REPO_ROOT / local_rel.lstrip("/")
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_bytes(fetch(url, IMAGE_RELAY))
    for url, local_rel in seen.items():
        content = content.replace(f'src="{url}"', f'src="{local_rel}"')
        content = content.replace(f'href="{url}"', f'href="{local_rel}"')
    return content


def first_paragraph_text(content: str) -> str:
    match = re.search(r"<p[^>]*>(.*?)</p>", content, re.DOTALL)
    if not match:
        return ""
    text = re.sub(r"<[^>]+>", "", match.group(1))
    return html.unescape(text).strip()


def build_post(item: dict, dry_run: bool) -> pathlib.Path:
    slug = item["slug"]
    date = item["date"]
    content = localize_images(item["content"], slug, dry_run)
    excerpt = first_paragraph_text(content)
    front_matter = "\n".join(
        [
            "---",
            f"title: {json.dumps(item['title'])}",
            f"date: {date:%Y-%m-%d}",
            f"permalink: /posts/{date:%Y}/{date:%m}/{slug}/",
            f"substack_url: {item['link']}",
            f"excerpt: {json.dumps(excerpt)}",
            "generated: substack-sync",
            "---",
        ]
    )
    notice = (
        f"This post was originally published on [my Substack]({item['link']}). "
        "Comments and email subscription live there.\n{: .notice}"
    )
    body = f"{front_matter}\n\n{notice}\n\n{content}\n"
    path = POSTS_DIR / f"{date:%Y-%m-%d}-{slug}.md"
    if not dry_run:
        path.write_text(body, encoding="utf-8")
    return path


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--dry-run", action="store_true", help="report only; write nothing")
    args = parser.parse_args()

    root = ET.fromstring(fetch(FEED_URL, FEED_RELAY))
    items = root.findall("./channel/item")
    print(f"feed: {len(items)} item(s)")

    created = 0
    for element in items:
        title = (element.findtext("title") or "").strip()
        link = (element.findtext("link") or "").strip()
        content = element.findtext(CONTENT_NS) or ""
        pub_date = email.utils.parsedate_to_datetime(element.findtext("pubDate"))
        slug = slug_from_link(link)

        if SITE_ORIGIN_MARKER in content:
            print(f"skip (site-origin): {slug}")
            continue
        if already_mirrored(link, slug):
            print(f"skip (already mirrored): {slug}")
            continue

        item = {
            "title": title,
            "link": link,
            "content": content,
            "date": pub_date,
            "slug": slug,
        }
        path = build_post(item, args.dry_run)
        created += 1
        prefix = "would create" if args.dry_run else "created"
        print(f"{prefix}: {path.relative_to(REPO_ROOT)}")

    print(f"done: {created} new post(s)")
    return 0


if __name__ == "__main__":
    sys.exit(main())

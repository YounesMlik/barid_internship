from playwright.sync_api import Page, BrowserContext
from scraper.core import login
from pathlib import Path
import os
from collections import defaultdict
from functools import lru_cache

DEFAULT_DOWNLOAD_PATH = "data/cab"


def navigate(page: Page) -> None:
    page.click("#Header1_Menu1-menuItem002")
    page.click("#Header1_Menu1-menuItem002-subMenu-menuItem000")
    page.click("#Header1_Menu1-menuItem001")
    page.click("#Header1_Menu1-menuItem001-subMenu-menuItem003")


def init_page(context: BrowserContext) -> Page:
    page = context.new_page()
    # login(page)
    # navigate(page)
    return page


def task(page: Page, cab: str, download_path: str = DEFAULT_DOWNLOAD_PATH):
    existing = all_downloads_exist(cab, download_path=download_path)
    if existing:
        print(f"Skipping {cab} (already downloaded)")
        return
    print(f"Downloading {cab}")

    page.fill("#txtCodeBor", cab)
    page.keyboard.press("Enter")  # replace if needed
    page.locator("#GridBordereau_Lbid_bordereau_0", has_text=cab).wait_for()

    ids: list[str] = []
    for row in page.locator("#GridBordereau tbody tr").all():
        cells = row.locator("td").all()
        if cells:
            ids.append(cells[0].inner_text().strip())

    print(ids)
    # ids = ids[:1]  # deal with POD later

    for i, id in enumerate(ids):
        file_path = Path(download_path) / f"{cab}__{id}__{len(ids)}__{i + 1}.html"
        if file_path.exists():
            print(f"Skipping {id} (already downloaded)")
            continue

        print(id)
        page.click(f"#GridBordereau_LinkDetail_{i}")
        page.locator(f"#IdBordereau[value='{id}']").wait_for()

        with file_path.open("w", encoding="utf-8") as file:
            file.write(page.content())

        page.click("#btnretour")  # back

    page.click("#Button1")  # reset=

@lru_cache(maxsize=1)
def build_download_index(download_path: str):
    """
    Returns:
        dict[cab] -> {
            "max_total": int,
            "indices": set[int],
        }
    """
    index = defaultdict(lambda: {"max_total": 0, "indices": set()})

    for file in Path(download_path).iterdir():
        if file.suffix != ".html":
            continue
        if file.name.count("__") != 3:
            continue
        
        cab, *_rest, total_str, idx_str = file.stem.split("__")

        total = int(total_str)
        idx = int(idx_str)

        entry = index[cab]
        entry["max_total"] = max(entry["max_total"], total)
        entry["indices"].add(idx)

    return index


def all_downloads_exist(cab: str, download_path: str = DEFAULT_DOWNLOAD_PATH) -> bool:
    index = build_download_index(download_path)
    entry = index.get(cab)
    if not entry or entry["max_total"] == 0:
        return False

    expected = set(range(1, entry["max_total"] + 1))
    return entry["indices"] == expected

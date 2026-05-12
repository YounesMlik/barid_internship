from playwright.sync_api import Page, BrowserContext
from scraper.core import login
from pathlib import Path

FEILDS = [
    {"name": "Cab", "id": "CodeBordereau"},
    {"name": "Date depot", "id": "date_op"},
    {"name": "Type cab", "id": "Type_bordereau"},
    {"name": "Dernier statut", "id": "Dernier_staut"},
    {"name": "Régime", "id": "regime"},
    {"name": "Contrat", "id": "contrat"},
    {"name": "Id", "id": "IdBordereau"},
    {"name": "Etat", "id": "heure_op"},
    {"name": "Poids global(en KG)", "id": "Poids_global"},
    {"name": "Centre/Agence depot", "id": "entite_dep"},
    {"name": "Destination", "id": "destination"},
    {"name": "Client", "id": "client"},
    {"name": "Produit/Niveau Service", "id": "txtlibproduit"},
    {"name": "Mode paiement", "id": "txtmodepaiement"},
    {"name": "Taxe DTQ ?(Dhs)", "id": "txttxdtq"},
    {"name": "Canal  de livraison 1", "id": "txtmodlivrai"},
    {"name": "Canal  de livraison 2", "id": "txtlibsitealivr"},
    {"name": "Longueur", "id": "txtLongueur"},
    {"name": "Hauteur", "id": "txtHauteur"},
    {"name": "Largeur", "id": "txtLargeur"},
    {"name": "Poids Volumétrique", "id": "txtPoidsVolume"},
]

DEFAULT_DOWNLOAD_PATH = "data/cab"


def navigate(page: Page) -> None:
    page.click("#Header1_Menu1-menuItem002")
    page.click("#Header1_Menu1-menuItem002-subMenu-menuItem000")
    page.click("#Header1_Menu1-menuItem001")
    page.click("#Header1_Menu1-menuItem001-subMenu-menuItem003")


def init_page(context: BrowserContext) -> Page:
    page = context.new_page()
    login(page)
    navigate(page)
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

        # data: dict[str, str] = {}
        # for field in FEILDS:
        #     datum: str = page.locator(f"#{field['id']}").input_value()      # just do it on local html
        #     data[field["name"]] = datum
        # print(data)

        page.click("#btnretour")  # back

    page.click("#Button1")  # reset


def all_downloads_exist(
    cab: str,
    # id_col: int,
    # total_col: int,
    # index_col: int,
    # seperator: str = "__",
    download_path: str = DEFAULT_DOWNLOAD_PATH,
) -> bool:
    files = list(Path(download_path).glob(f"{cab}__*__*__*.html"))

    if not files:
        return False

    parsed_names = [file.stem.split("__") for file in files]

    total_expected = max(int(parts[2]) for parts in parsed_names)

    downloaded_indices = {int(parts[3]) for parts in parsed_names}

    expected_indices = set(range(1, total_expected + 1))

    return downloaded_indices == expected_indices

from playwright.sync_api import Page, BrowserContext
from datetime import date
from scraper.core import login

QUERY = "68|/EditionsSmi/smi_situa_journa_distrib4"
DOWNLOAD_FOLDER = "data/smi_situa_journa_distrib4"
AGENCE = "74400.0"  # CENTRE COURRIER COLIS LAAYOUNE


def setup_form(page: Page, query: str = QUERY, agence: str = AGENCE) -> None:
    page.select_option("#ddletats", query)
    page.select_option("#ParametersDataGrid_Agence_0", agence)


def submit_date(page: Page, dt: date) -> None:
    page.fill("#ParametersDataGrid_x_date_1", dt.strftime("%Y-%m-%d"))
    page.keyboard.press("Enter")  # replace if needed
    page.wait_for_load_state("domcontentloaded")


def download_csv(
    page: Page, filename: str | None = None, download_folder: str = DOWNLOAD_FOLDER
) -> None:
    page.select_option("#mReportsViewer_ctl01_ctl05_ctl00", "CSV")

    with page.expect_download() as download_info:
        page.click("#mReportsViewer_ctl01_ctl05_ctl01")

    download = download_info.value
    if filename is None:
        filename = download.suggested_filename
    # download.save_as("data/test.csv")
    download.save_as(f"{download_folder}/{filename}")


def navigate(page: Page) -> None:
    page.click("#Header1_Menu1-menuItem002")
    page.click("#Header1_Menu1-menuItem002-subMenu-menuItem000")
    page.click("#Header1_Menu1-menuItem002")
    page.click("#Header1_Menu1-menuItem002-subMenu-menuItem006")


def init_page(context: BrowserContext) -> Page:
    page = context.new_page()
    login(page)
    navigate(page)
    setup_form(page)
    return page


def task(page: Page, dt: date):
    submit_date(page, dt)
    page.wait_for_function("""
        () => {
        const el = document.querySelector("#mReportsViewer_ctl01_ctl05_ctl00");
        return el && !el.disabled && el.options.length > 1;
        }
        """)
    download_csv(page, f"{dt.strftime('%Y-%m-%d')}.csv")

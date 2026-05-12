from datetime import date
from scraper.core import run_workflow, date_range
from scraper import etats, historique


import main
import lib
import importlib

importlib.reload(lib)
importlib.reload(main)


def run_etats():
    run_workflow(
        etats.init_page,
        etats.task,
        date_range(date(2024, 1, 1), date(2023, 12, 20)),
        headless=False,
    )


def run_historique():
    cab_list = (
        lib.read_smi_suiviexpedition_many()
        .sort("DATE_DERNIER_STATUT", descending=True)["CAB"]
        .to_list()
    )
    run_workflow(
        historique.init_page,
        historique.task,
        cab_list,
        headless=True,
    )


if __name__ == "__main__":
    run_historique()

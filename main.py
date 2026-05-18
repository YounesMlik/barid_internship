import os
import polars as pl
from datetime import date
from pathlib import Path

COLUMN_MAPPING = {
    "code_bordereau": "CAB",
    "nomrais": "CLIENT",
    "serviceoptionnel": "SERVICES_OPTIONNELS",
    "desburpoexpediteur": "SITE_EXPEDITEUR",
    "reception": "RECEPTION",
    "dernier_statut": "DERNIER_STATUT",
    "date_dernierstatut": "DATE_DERNIER_STATUT",
    "desburpodernierstatut": "SITE_DERNIER_STATUT",
    "destination": "DESTINATION",
}

our_locations = [
    "AGENCE MESSAGERIE DAKHLA",
    "AGENCE MESSAGERIE LAAYOUNE",
    "CENTRE COURRIER COLIS LAAYOUNE",
    "DAKHLA CLD",
    "ES-SEMARA CLD",
    "LAAYOUNE PORT",
    "TARFAYA",
    "HUB LAAYOUNE CHRONODIALI",
    # "BOUJDOUR",
    # "BIRGANDOUZ",
    # "LAAYOUNE HAY TAAOUN",
]
DEFAULT_DELAY = 7  # days

DEFAULT_INPUT_PATH = "smi_suiviexpedition.csv"
DEFAULT_OUTPUT_PATH = "rapport_retard.xlsx"


def get_input_file(path: str = DEFAULT_INPUT_PATH):
    while not os.path.exists(path):
        path = input("Fichier introuvable. Entrez le chemin du fichier CSV : ").strip()
    return path


def get_delay_threshold():
    delay_input = input(
        f"Seuil de retard en jours ? (Entrée = {DEFAULT_DELAY}) : "
    ).strip()
    days = int(delay_input) if delay_input else DEFAULT_DELAY
    return pl.duration(days=days)


def load_data(path: str | Path):
    return (
        pl.read_csv(path, skip_lines=3, try_parse_dates=True).head(-1)  # drop last row
    ).with_columns(pl.col("date_dernierstatut").dt.cast_time_unit("ms"))


def filter_data(df: pl.DataFrame, delay_threshold):
    now = date.today()
    return (
        df.rename(COLUMN_MAPPING)
        .filter(
            (pl.col("SITE_DERNIER_STATUT").is_in(our_locations))
            & (~pl.col("DERNIER_STATUT").is_in(["liv", "liv_ret"]))
            & (pl.col("DATE_DERNIER_STATUT") < now - delay_threshold)
        )
        .sort("SITE_DERNIER_STATUT")
    )


def main():
    input_file = get_input_file()
    delay_threshold = get_delay_threshold()

    data = load_data(input_file)
    result = filter_data(data, delay_threshold)

    result.write_excel(DEFAULT_OUTPUT_PATH)


if __name__ == "__main__":
    main()

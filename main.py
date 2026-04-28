import os
import polars as pl
from datetime import date


COLUMN_MAPPING = {
    "code_bordereau": "CAB",
    "nomrais": "CLIENT",
    "serviceoptionnel": "SERVICES OPTIONNELS",
    "desburpoexpediteur": "SITE EXPEDITEUR",
    "reception": "RECEPTION(OK ou NOK)",
    "dernier_statut": "DERNIER STATUT",
    "date_dernierstatut": "DATE DERNIER STATUT",
    "desburpodernierstatut": "SITE DERNIER STATUT",
    "destination": "DESTINATION",
}

our_locations = [
    "AGENCE MESSAGERIE DAKHLA",
    "AGENCE MESSAGERIE LAAYOUNE",
    "BIRGANDOUZ",
    "BOUJDOUR",
    "CENTRE COURRIER COLIS LAAYOUNE",
    "DAKHLA CLD",
    "ES-SEMARA CLD",
    "LAAYOUNE PORT",
    "TARFAYA",
    # "HUB LAAYOUNE CHRONODIALI",  # ask supervisor if these should be included
    # "LAAYOUNE HAY TAAOUN",
]
DEFAULT_DELAY = 7  # days

input_file = "smi_suiviexpedition.csv"
output_file = "rapport_retard.csv"


def get_input_file():
    path = input("Entrez le chemin du fichier CSV : ").strip()
    while not os.path.exists(path):
        path = input("Fichier introuvable. Entrez le chemin du fichier CSV : ").strip()
    return path


def get_delay_threshold():
    delay_input = input(
        f"Seuil de retard en jours ? (Entrée = {DEFAULT_DELAY}) : "
    ).strip()
    days = int(delay_input) if delay_input else DEFAULT_DELAY
    return pl.duration(days=days)


def load_data(path):
    return (
        pl.read_csv(path, skip_lines=3, try_parse_dates=True).head(-1)  # drop last row
    )


def filter_data(df, delay_threshold):
    now = date.today()
    return df.rename(COLUMN_MAPPING).filter(
        (pl.col("SITE DERNIER STATUT").is_in(our_locations))
        & (~pl.col("DERNIER STATUT").is_in(["liv", "liv_ret"]))
        & (pl.col("DATE DERNIER STATUT") < now - delay_threshold)
    )


def main():
    input_file = get_input_file()
    delay_threshold = get_delay_threshold()

    data = load_data(input_file)
    result = filter_data(data, delay_threshold)

    result.write_csv(output_file)


if __name__ == "__main__":
    main()

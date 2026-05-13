import polars as pl
from pathlib import Path
from bs4 import BeautifulSoup, Tag
from typing import Callable, Iterable
from dataclasses import dataclass
from types import SimpleNamespace


@dataclass(frozen=True, slots=True)
class TableConfig:
    table_id: str
    schema: pl.Schema
    transforms: Iterable[pl.Expr] = ()


@dataclass(frozen=True, slots=True)
class FieldConfig:
    id: str
    name: str
    method: str = "value"


type Extractor = Callable[[Tag], str | None]

OPERATIONS_TABLE = TableConfig(
    table_id="GridViewOperations",
    schema=pl.Schema(
        [
            ("Date operation", pl.String),
            ("Heure Syst.Oper.", pl.String),
            ("Statut", pl.String),
            ("Agence", pl.String),
            ("Agent oper.", pl.String),
            ("Etat", pl.String),
            ("Date Etat", pl.String),
            ("Agent maj", pl.String),
            ("ORIGINE", pl.String),
        ]
    ),
    transforms=[
        pl.col("Date operation").str.to_date("%d-%m-%Y"),
        pl.col("Heure Syst.Oper.").str.to_datetime("%d-%m-%Y %H:%M"),
        pl.col("Agent oper.").cast(pl.Int64),
        pl.col("Etat").str.extract(r"\[\s*(.*?)\s*\]", 1).alias("status_code"),
        pl.col("Etat").str.extract(r"\((.*?)\)", 1).alias("is_valid"),
    ],
)

SERVICES_TABLE = TableConfig(
    table_id="GDVService",
    schema=pl.Schema(
        [
            ("Libellé service", pl.String),
            ("Num compte", pl.String),
            ("Mnt à percevoir", pl.String),
            ("Adr/compte service", pl.String),
            ("Gsm", pl.String),
            ("Taxe TTC", pl.String),
            ("ORIGINE", pl.String),
        ]
    ),
    transforms=[
        pl.col("Mnt à percevoir").cast(pl.Float64),
        pl.col("Taxe TTC").cast(pl.Float64),
    ],
)

DELIVERY_TABLE = TableConfig(
    table_id="GDVinfoliv",
    schema=pl.Schema(
        [
            ("agence_liv", pl.String),
            ("date_liv", pl.String),
            ("date.transf.ccp", pl.String),
            ("montant", pl.String),
            ("beneficiaire", pl.String),
            ("n°pid", pl.String),
            ("statut", pl.String),
            ("origine", pl.String),
            ("etat", pl.String),
            ("N°compte/Infos", pl.String),
            ("N°chéque/N°reçu.TPE", pl.String),
        ]
    ),
    transforms=[
        pl.col("date_liv").str.to_date("%d/%m/%Y"),
        pl.col("date.transf.ccp").str.to_date("%d/%m/%Y"),
        pl.col("montant").cast(pl.Float64),
    ],
)

TABLES = SimpleNamespace(
    operations=OPERATIONS_TABLE,
    services=SERVICES_TABLE,
    delivery=DELIVERY_TABLE,
)

FIELDS = [
    FieldConfig("CodeBordereau", "Cab"),
    FieldConfig("date_op", "Date depot"),
    FieldConfig("Type_bordereau", "Type cab"),
    FieldConfig("Dernier_staut", "Dernier statut"),
    FieldConfig("regime", "Régime"),
    FieldConfig("contrat", "Contrat"),
    FieldConfig("IdBordereau", "Id"),
    FieldConfig("heure_op", "Etat"),
    FieldConfig("Poids_global", "Poids global(en KG)"),
    FieldConfig("entite_dep", "Centre/Agence depot"),
    FieldConfig("destination", "Destination"),
    FieldConfig("client", "Client"),
    FieldConfig("txtlibproduit", "Produit/Niveau Service"),
    FieldConfig("txtmodepaiement", "Mode paiement", method="text"),
    FieldConfig("txttxdtq", "Taxe DTQ ?(Dhs)"),
    FieldConfig("txtmodlivrai", "Canal de livraison 1"),
    FieldConfig("txtlibsitealivr", "Canal de livraison 2"),
    FieldConfig("txtLongueur", "Longueur"),
    FieldConfig("txtHauteur", "Hauteur"),
    FieldConfig("txtLargeur", "Largeur"),
    FieldConfig("txtPoidsVolume", "Poids Volumétrique"),
]

EXTRACTORS = {
    "text": lambda e: e.get_text(strip=True),
    "value": lambda e: e.get("value"),
}


def extract_table(
    soup: BeautifulSoup,
    config: TableConfig,
    additional_cols={},
) -> pl.DataFrame:

    table = soup.find("table", id=config.table_id)

    if table is None:
        return pl.DataFrame(schema=config.schema)

    rows = [
        [cell.get_text(strip=True) for cell in row.find_all(["th", "td"])]
        for row in table.find_all("tr")
    ]

    if not rows:
        return pl.DataFrame(schema=config.schema)

    headers, *data = rows

    return (
        pl.DataFrame(data, schema=headers, orient="row")
        .cast(config.schema)
        .with_columns(
            *config.transforms,
            **{k: pl.lit(v) for k, v in additional_cols.items()},
        )
    )


def extract_fields(
    soup: BeautifulSoup,
    fields: list[FieldConfig] = FIELDS,
    extractors: dict[str, Extractor] = EXTRACTORS,
):
    data: dict[str, str] = {}

    for field in fields:
        elem = soup.select_one(f"#{field.id}")
        method = field.method
        extractor = extractors[method]

        if elem is None:
            datum = ""
        else:
            datum = extractor(elem)
            if datum is None:
                datum = ""
            else:
                datum = datum.strip()

        data[field.name] = datum

    df = pl.from_dict(data).with_columns(
        pl.col("Date depot").str.to_date("%d/%m/%Y", strict=False),
        pl.col("Type cab").cast(pl.Int64, strict=False),
        pl.col("Contrat").cast(pl.Int64, strict=False),
        pl.col("Id").cast(pl.Int64, strict=False),
        pl.col("Longueur").cast(pl.Float64, strict=False),
        pl.col("Largeur").cast(pl.Float64, strict=False),
        pl.col("Hauteur").cast(pl.Float64, strict=False),
        pl.col("Poids Volumétrique").cast(pl.Float64, strict=False),
        pl.col("Poids global(en KG)").cast(pl.Float64, strict=False),
        pl.col("Taxe DTQ ?(Dhs)").cast(pl.Float64, strict=False),
    )
    return df


def extract_page(file_path: str):
    file = Path(file_path)
    html = file.read_text()
    soup = BeautifulSoup(html)
    tables = [
        extract_table(soup, config)
        for config in [TABLES.operations, TABLES.services, TABLES.delivery]
    ]
    fields = extract_fields(soup)
    return tables, fields

import polars as pl
from pathlib import Path
from typing import Callable, Iterable, Any
from dataclasses import dataclass, field as dc_field
from types import SimpleNamespace
from lxml import html


@dataclass(frozen=True, slots=True)
class TableConfig:
    table_id: str
    schema: pl.Schema
    renames: dict[str, str] = dc_field(default_factory=dict)
    transforms: Iterable[pl.Expr] = ()


@dataclass(frozen=True, slots=True)
class FieldConfig:
    id: str
    name: str
    method: str = "value"


type Extractor = Callable[[html.HtmlElement], str | None]

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
    renames={
        "Date operation": "Date_operation",
        "Heure Syst.Oper.": "Heure_Syst_Oper",
        "Agent oper.": "Agent_oper",
        "Date Etat": "Date_Etat",
        "Agent maj": "Agent_maj",
    },
    transforms=[
        pl.col("Date_operation").str.to_date("%d-%m-%Y"),
        pl.col("Heure_Syst_Oper").str.to_datetime("%d-%m-%Y %H:%M"),
        pl.col("Agent_oper").cast(pl.Int64),
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
    renames={
        "Libellé service": "Libelle_service",
        "Num compte": "Num_compte",
        "Mnt à percevoir": "Mnt_a_percevoir",
        "Taxe TTC": "Taxe_TTC",
    },
    transforms=[
        pl.col("Mnt_a_percevoir").cast(pl.Float64),
        pl.col("Taxe_TTC").cast(pl.Float64),
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
    renames={
        "date.transf.ccp": "date_transf_ccp",
        "n°pid": "n_pid",
        "N°compte/Infos": "N_compte_Infos",
        "N°chéque/N°reçu.TPE": "N_cheque_N_reçu_TPE",
    },
    transforms=[
        pl.col("date_liv").str.to_date("%d/%m/%Y"),
        pl.col("date_transf_ccp").str.to_date("%d/%m/%Y"),
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
    FieldConfig("IdBordereau", "Id"),
    FieldConfig("date_op", "Date depot"),
    FieldConfig("Type_bordereau", "Type cab"),
    FieldConfig("Dernier_staut", "Dernier statut"),
    FieldConfig("regime", "Régime"),
    FieldConfig("contrat", "Contrat"),
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
    "text": lambda e: e.text_content().strip(),
    "value": lambda e: e.get("value"),
}


def parse_table_rows(table: html.HtmlElement):
    tbody = table[0]
    return [[cell.text_content().strip() for cell in row] for row in tbody]


def extract_table(
    tree: html.HtmlElement,
    config: TableConfig,
    additional_cols: dict[str, Any] = {},
) -> pl.DataFrame:
    additional_cols_list = [pl.lit(v).alias(k) for k, v in additional_cols.items()]

    table = tree.get_element_by_id(config.table_id, None)

    if table is None:
        rows = []
    else:
        rows = parse_table_rows(table)

    data = rows[1:]

    df = (
        pl.DataFrame(data, schema=config.schema, orient="row")
        .rename(config.renames)
        .with_columns(
            *config.transforms,
        )
        .select(
            *additional_cols_list,
            pl.all(),
        )
    )

    return df


def extract_fields(
    tree: html.HtmlElement,
    fields: list[FieldConfig] = FIELDS,
    extractors: dict[str, Extractor] = EXTRACTORS,
):
    elements_by_id = {
        elem.attrib["id"]: elem for elem in tree.iter() if "id" in elem.attrib
    }

    data: dict[str, str] = {}

    for field in fields:
        # elem = tree.get_element_by_id(field.id, None)
        elem = elements_by_id.get(field.id)

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


def extract_page(html_text: str):
    tree = html.fromstring(html_text)
    fields = extract_fields(tree)
    cab = fields["Cab"][0]
    id = fields["Id"][0]
    tables = {
        k: extract_table(tree, config, additional_cols={"cab": cab, "id": id})
        for k, config in vars(TABLES).items()
    }
    return {"fields": fields, **tables}


def extract_pages(html_texts: Iterable[str]):
    tables_list: dict[str, list[pl.DataFrame]] = {
        "fields": [],
        "operations": [],
        "services": [],
        "delivery": [],
    }
    for html_text in html_texts:
        page_data = extract_page(html_text)
        for key in tables_list:
            tables_list[key].append(page_data[key])

    return {key: pl.concat(dfs) if dfs else None for key, dfs in tables_list.items()}


def extract_pages_from_folder(folder_path: str | Path):
    files = Path(folder_path).iterdir()
    return extract_pages((file.read_text() for file in files))

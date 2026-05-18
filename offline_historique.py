import polars as pl
from pathlib import Path
from typing import Callable, Iterable, Any
from itertools import chain
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
        pl.col("Date_operation").str.to_date("%d-%m-%Y", strict=False),
        pl.col("Heure_Syst_Oper").str.to_datetime("%d-%m-%Y %H:%M", strict=False),
        pl.col("Agent_oper").cast(pl.Int64, strict=False),
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
        pl.col("Mnt_a_percevoir").cast(pl.Float64, strict=False),
        pl.col("Taxe_TTC").cast(pl.Float64, strict=False),
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
        pl.col("date_liv").str.to_date("%d/%m/%Y", strict=False),
        pl.col("date_transf_ccp").str.to_date("%d/%m/%Y", strict=False),
        pl.col("montant").cast(pl.Float64, strict=False),
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
    FieldConfig("date_op", "Date_depot"),
    FieldConfig("Type_bordereau", "Type_cab"),
    FieldConfig("Dernier_staut", "Dernier_statut"),
    FieldConfig("regime", "Regime"),
    FieldConfig("contrat", "Contrat"),
    FieldConfig("heure_op", "Etat"),
    FieldConfig("Poids_global", "Poids_global_en_KG"),
    FieldConfig("entite_dep", "Centre_Agence_depot"),
    FieldConfig("destination", "Destination"),
    FieldConfig("client", "Client"),
    FieldConfig("txtlibproduit", "Produit_Niveau_Service"),
    FieldConfig("txtmodepaiement", "Mode_paiement", method="text"),
    FieldConfig("txttxdtq", "Taxe_DTQ_Dhs"),
    FieldConfig("txtmodlivrai", "Canal_de_livraison_1"),
    FieldConfig("txtlibsitealivr", "Canal_de_livraison_2"),
    FieldConfig("txtLongueur", "Longueur"),
    FieldConfig("txtHauteur", "Hauteur"),
    FieldConfig("txtLargeur", "Largeur"),
    FieldConfig("txtPoidsVolume", "Poids_Volumetrique"),
]
FIELDS_TRANSFORMS = [
    pl.col("Date_depot").str.to_date("%d/%m/%Y", strict=False),
    pl.col("Type_cab").cast(pl.Int64, strict=False),
    pl.col("Contrat").cast(pl.Int64, strict=False),
    pl.col("Id").cast(pl.Int64, strict=False),
    pl.col("Longueur").cast(pl.Float64, strict=False),
    pl.col("Largeur").cast(pl.Float64, strict=False),
    pl.col("Hauteur").cast(pl.Float64, strict=False),
    pl.col("Poids_Volumetrique").cast(pl.Float64, strict=False),
    pl.col("Poids_global_en_KG").cast(pl.Float64, strict=False),
    pl.col("Taxe_DTQ_Dhs").cast(pl.Float64, strict=False),
]

EXTRACTORS = {
    "text": lambda e: e.text_content().strip(),
    "value": lambda e: e.get("value"),
}


def fix_length(arr: list, length: int, fill=""):
    if len(arr) > length:
        del arr[length:]
    elif len(arr) < length:
        arr.extend([fill] * (length - len(arr)))

    return arr


def parse_table_rows(table: html.HtmlElement) -> list[list[str]]:
    tbody = table[0]
    return [[cell.text_content().strip() for cell in row] for row in tbody]


def extract_table(
    tree: html.HtmlElement,
    config: TableConfig,
    cab,
    id,
) -> list[list[str]]:

    table = tree.get_element_by_id(config.table_id, None)

    if table is None:
        rows = []
    else:
        rows = parse_table_rows(table)

    data_rows = rows[1:]

    data_rows = [fix_length(row, config.schema.len(), "") for row in data_rows]
    data_rows = [[cab, id, *row] for row in data_rows]

    return data_rows


def extract_fields(
    tree: html.HtmlElement,
    fields: list[FieldConfig] = FIELDS,
    extractors: dict[str, Extractor] = EXTRACTORS,
) -> dict[str, str]:
    elements_by_id = {
        elem.attrib["id"]: elem for elem in tree.iter() if "id" in elem.attrib
    }

    data_dict: dict[str, str] = {}

    for field in fields:
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

        data_dict[field.name] = datum

    return data_dict


def extract_page(html_text: str):
    tree = html.fromstring(html_text)
    fields = extract_fields(tree)
    cab = fields["Cab"]
    id = fields["Id"]
    tables = {
        k: extract_table(tree, config, cab, id) for k, config in vars(TABLES).items()
    }
    return {"fields": fields, **tables}


def extract_pages(html_texts: Iterable[str]):  # make sure html_texts isn't empty
    fields_list: list[dict[str, str]] = []

    tables_list: dict[str, list[list[str]]] = {
        "operations": [],
        "services": [],
        "delivery": [],
    }
    for html_text in html_texts:
        page_data = extract_page(html_text)

        fields_list.append(page_data["fields"])

        for key in tables_list:
            tables_list[key].append(page_data[key])

    return {
        "fields": pl.DataFrame(fields_list).with_columns(FIELDS_TRANSFORMS),
        **{
            key: (
                pl.DataFrame(
                    chain(*table),
                    orient="row",
                    schema=["cab", "id", *getattr(TABLES, key).schema],
                )
                .rename(getattr(TABLES, key).renames)
                .with_columns(getattr(TABLES, key).transforms)
            )
            for key, table in tables_list.items()
        },
    }


def extract_pages_from_folder(folder_path: str | Path):
    files = Path(folder_path).iterdir()
    return extract_pages((file.read_text() for file in files))


def parse_historique_from_folder(
    input_folder_path: str,
    output_folder_path: str,
    save_output: bool = True,
):
    input_folder = Path(input_folder_path)
    output_folder = Path(output_folder_path)

    existing_dfs: dict[str, pl.DataFrame] = {
        file.stem: pl.read_parquet(file) for file in output_folder.iterdir()
    }
    if "fields" not in existing_dfs:
        cabs = set()
    else:
        cabs = set(existing_dfs["fields"]["Cab"])

    input_files = sorted(list(input_folder.iterdir()))

    input_files = [
        file for file in input_files if file.stem.partition("__")[0] not in cabs
    ]

    if not input_files:
        return existing_dfs

    extracted_dfs: dict[str, pl.DataFrame] = extract_pages(
        (file.read_text() for file in input_files)
    )

    dfs = {
        key: pl.concat([existing_dfs[key], extracted_dfs[key]])
        for key in existing_dfs.keys()
    }

    if save_output:
        for key, df in dfs.items():
            df.write_parquet(output_folder / (key + ".parquet"))

    return dfs

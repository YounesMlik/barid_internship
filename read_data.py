import polars as pl
from pathlib import Path
from datetime import date
from io import StringIO
import main

smi_suiviexpedition_PATH = "data/smi_suiviexpedition"

smi_situa_journa_distrib4_PATH = "data/smi_situa_journa_distrib4"

smi_envoisbyproduitintern_PATH = "data/smi_envoisbyproduitintern"


def read_smi_envoisbyproduitintern(path: str | Path) -> pl.DataFrame:
    data = pl.read_csv(path, try_parse_dates=True).filter(
        pl.all_horizontal(pl.all().is_null()).not_()
    )
    return data


def read_smi_envoisbyproduitintern_many(
    path: str | Path = smi_envoisbyproduitintern_PATH,
) -> pl.DataFrame:
    folder = Path(path)
    raw_dfs: list[pl.DataFrame] = []
    for file in folder.iterdir():
        raw_df = read_smi_envoisbyproduitintern(file)
        raw_dfs.append(raw_df)
    data: pl.DataFrame = pl.concat(raw_dfs)
    data = data.unique("codeenvoi_")
    data = data.with_columns(
        pl.col("pouds_reel_").str.replace(",", ".").cast(pl.Float64),
        pl.col("poids_volume_").str.replace(",", ".").cast(pl.Float64),
    )
    data = data.sort("datedepot")
    return data


def read_smi_suiviexpedition(path: str | Path) -> pl.DataFrame:
    data = (
        pl.read_csv(path, skip_lines=3, try_parse_dates=True)
        .head(-1)
        .with_columns(pl.col("date_dernierstatut"))
        .rename(main.COLUMN_MAPPING)
        .filter((pl.col("SITE_DERNIER_STATUT").is_in(main.our_locations)))
        .unique("CAB")
        .sort("DATE_DERNIER_STATUT")
        .with_columns(pl.col("CAB").str.strip_chars())
    )
    return data


def read_smi_suiviexpedition_many(
    path: str | Path = smi_suiviexpedition_PATH,
) -> pl.DataFrame:
    folder = Path(path)
    raw_dfs: list[pl.DataFrame] = []
    for file in folder.iterdir():
        raw_df = read_smi_suiviexpedition(file)
        raw_dfs.append(raw_df)
    data: pl.DataFrame = pl.concat(raw_dfs)
    data = data.unique("CAB")
    data = data.sort("DATE_DERNIER_STATUT")
    return data


def read_smi_situa_journa_distrib4(
    path: str | Path,
) -> tuple[pl.DataFrame, pl.DataFrame]:
    with open(path) as f:
        parts = f.read().strip().split("\n\n")

    current_df = pl.read_csv(StringIO(parts[0]))
    d_one_df = pl.read_csv(StringIO(parts[1]))
    current_df = current_df.rename({current_df.columns[0]: "unique_id"})
    d_one_df = d_one_df.rename({d_one_df.columns[0]: "unique_id"})

    return current_df, d_one_df


def read_smi_situa_journa_distrib4_many(
    path: str | Path = smi_situa_journa_distrib4_PATH,
) -> tuple[pl.DataFrame, pl.DataFrame]:
    folder = Path(path)
    current_dfs: list[pl.DataFrame] = []
    d_one_dfs: list[pl.DataFrame] = []
    for file in folder.iterdir():
        ds = date.fromisoformat(file.stem)
        current_df, d_one_df = read_smi_situa_journa_distrib4(file)
        current_df = current_df.select(pl.lit(ds).alias("ds"), pl.all())
        d_one_df = d_one_df.select(pl.lit(ds).alias("ds"), pl.all())
        current_dfs.append(current_df)
        d_one_dfs.append(d_one_df)

    current_df = pl.concat(current_dfs)
    d_one_df = pl.concat(d_one_dfs)

    return current_df, d_one_df

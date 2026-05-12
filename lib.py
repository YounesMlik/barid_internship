import polars as pl
from pathlib import Path
from datetime import date
from io import StringIO
import main
from typing import Callable

smi_suiviexpedition_PATH = "data/smi_suiviexpedition"

smi_situa_journa_distrib4_PATH = "data/smi_situa_journa_distrib4"


def read_smi_suiviexpedition(
    path: str,
) -> pl.DataFrame:
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
    path: str = smi_suiviexpedition_PATH,
) -> pl.DataFrame:
    folder = Path(path)
    raw_dfs = []
    for file in folder.iterdir():
        raw_df = read_smi_suiviexpedition(file)
        raw_dfs.append(raw_df)
    data: pl.DataFrame = pl.concat(raw_dfs)
    data = data.unique("CAB")
    data = data.sort("DATE_DERNIER_STATUT")
    return data


def read_smi_situa_journa_distrib4(path: str) -> tuple[pl.DataFrame, pl.DataFrame]:
    with open(path) as f:
        parts = f.read().strip().split("\n\n")

    current_df = pl.read_csv(StringIO(parts[0]))
    d_one_df = pl.read_csv(StringIO(parts[1]))
    current_df = current_df.rename({current_df.columns[0]: "unique_id"})
    d_one_df = d_one_df.rename({d_one_df.columns[0]: "unique_id"})

    return [current_df, d_one_df]


def read_smi_situa_journa_distrib4_many(
    path: str = smi_situa_journa_distrib4_PATH,
) -> tuple[pl.DataFrame, pl.DataFrame]:
    folder = Path(path)
    current_dfs = []
    d_one_dfs = []
    for file in folder.iterdir():
        ds = date.fromisoformat(file.stem)
        current_df, d_one_df = read_smi_situa_journa_distrib4(file)
        current_df = current_df.select(pl.lit(ds).alias("ds"), pl.all())
        d_one_df = d_one_df.select(pl.lit(ds).alias("ds"), pl.all())
        current_dfs.append(current_df)
        d_one_dfs.append(d_one_df)
    current_dfs = pl.concat(current_dfs)
    d_one_dfs = pl.concat(d_one_dfs)

    # print()
    return current_dfs, d_one_dfs


def complete_grid(
    df: pl.DataFrame,
    *,
    dimensions: dict[str, pl.Series | Callable[[pl.DataFrame], pl.Series]],
    on: list[str] | None = None,
    fill_value=None,
) -> pl.DataFrame:

    grids: list[pl.DataFrame] = []
    for name, values in dimensions.items():
        if callable(values):
            values = values(df)
        grids.append(values.to_frame(name))

    full = grids[0]

    for g in grids[1:]:
        full = full.join(g, how="cross")

    result = full.join(
        df,
        on=on or list(dimensions),
        how="left",
    ).sort(on or list(dimensions))

    if fill_value is not None:
        result = result.fill_null(fill_value)

    return result


def complete_time_grid(
    df: pl.DataFrame,
    id_col: str,
    time_col: str,
    freq: str,
    time_unit: str = "us",
    fill_value=None,
) -> pl.DataFrame:

    return complete_grid(
        df,
        dimensions={
            id_col: df[id_col].unique(),
            time_col: pl.datetime_range(
                start=df[time_col].min(),
                end=df[time_col].max(),
                interval=freq,
                eager=True,
                time_unit=time_unit,
            ),
        },
        fill_value=fill_value,
    )

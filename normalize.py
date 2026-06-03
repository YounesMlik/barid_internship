import polars as pl
from typing import Iterable
import re


def normalize_col(
    df: pl.DataFrame,
    patterns: pl.DataFrame,
    input_col: str,
    extracted_col: str | None,
    pattern_name_col: str | None,
) -> pl.DataFrame:
    pattern_rows = list(patterns.iter_rows(named=True))

    exprs = {
        extracted_col: [
            pl.col(input_col).str.extract(pattern["regex"]) for pattern in pattern_rows
        ],
        pattern_name_col: [
            pl.when(pl.col(input_col).str.contains(pattern["regex"])).then(
                pl.lit(pattern["name"])
            )
            for pattern in pattern_rows
        ],
    }

    normalized = (
        df.select(input_col)
        .unique()
        .with_columns(
            [pl.coalesce(v).alias(k) for k, v in exprs.items() if k is not None]
        )
    )

    return df.join(normalized, on=input_col, how="left")


def build_regex(prefix, suffix):
    start = rf"^{re.escape(prefix)}\s+" if prefix else "^"
    end = rf"\s+{re.escape(suffix)}$" if suffix else "$"
    return rf"{start}(.*?){end}"


def build_patterns(pattern_list: Iterable[tuple[str | None, str | None]]):
    return pl.DataFrame(
        pattern_list,
        schema=["prefix", "suffix"],
        orient="row",
    ).with_columns(
        pl.concat_str(
            [pl.col("prefix"), pl.col("suffix")],
            separator=" ",
            ignore_nulls=True,
        ).alias("name"),
        pl.struct(["prefix", "suffix"])
        .map_elements(lambda x: build_regex(x["prefix"], x["suffix"]))
        .alias("regex"),
    )


AGENCE_PATTERNS = build_patterns(
    [
        ("BC", None),
        ("HUB", "CHRONODIALI"),
        ("AGENCE MESSAGERIE", None),
        ("AGENCE MOBILE", None),
        ("CENTRE MESSAGERIE", None),
        ("CENTRE COURRIER COLIS", None),
        (None, "PPAL"),
        (None, "CLD"),
        (None, "CTD"),
        (None, "CD"),
    ]
)


def normalize_agence(df: pl.DataFrame) -> pl.DataFrame:
    return normalize_col(df, AGENCE_PATTERNS, "Agence", "Agence_city", "Agence_type")

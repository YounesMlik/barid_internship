import polars as pl
import numpy as np
from datetime import date
from typing import Callable, Literal, Any, Mapping, Optional
from hijridate import Gregorian
from coreforecast.scalers import boxcox, boxcox_lambda


def complete_grid(
    df: pl.DataFrame,
    *,
    dimensions: Mapping[
        str, pl.Series | pl.Expr | Callable[[pl.DataFrame], pl.Series | pl.Expr]
    ],
    on: list[str] | None = None,
    fill_value: Any = None,
) -> pl.DataFrame:

    grids: list[pl.DataFrame] = []

    for name, values in dimensions.items():
        if callable(values):
            values = values(df)
            print("hiiii")

        if isinstance(values, pl.Expr):
            grid = df.select(values.alias(name))
        else:
            grid = values.to_frame(name)

        grids.append(grid)

    full = grids[0]

    for g in grids[1:]:
        full = full.join(g, how="cross")

    keys = on or list(dimensions)
    result = full.join(df, on=keys, how="left").sort(keys)

    if fill_value is not None:
        result = result.fill_null(fill_value)

    return result


def complete_time_grid(
    df: pl.DataFrame,
    id_col: str | None,
    time_col: str,
    freq: str,
    time_unit: Literal["ns", "us", "ms"] | None = None,
    fill_value: Any = None,
) -> pl.DataFrame:
    dimensions: dict[str, pl.Expr] = {}

    dimensions[time_col] = pl.datetime_range(
        start=pl.col(time_col).min(),
        end=pl.col(time_col).max(),
        interval=freq,
        time_unit=time_unit,
    )

    if id_col is not None:
        dimensions[id_col] = pl.col(id_col).unique()

    return complete_grid(
        df,
        dimensions=dimensions,
        fill_value=fill_value,
    )


def complete_date_grid(
    df: pl.DataFrame,
    id_col: str | None,
    time_col: str,
    freq: str,
    fill_value: Any = None,
) -> pl.DataFrame:
    dimensions: dict[str, pl.Expr] = {}

    dimensions[time_col] = pl.date_range(
        start=pl.col(time_col).min(),
        end=pl.col(time_col).max(),
        interval=freq,
    )

    if id_col is not None:
        dimensions[id_col] = pl.col(id_col).unique()

    return complete_grid(
        df,
        dimensions=dimensions,
        fill_value=fill_value,
    )


def aggregate_by_date(
    df: pl.DataFrame,
    freq: str,
    value_col: str,
    date_col: str,
    *,
    total_col: str = "total",
    count_col: str = "count",
    mean_col: str = "mean",
    std_col: str = "std",
    fill_value: Any = 0,
):
    return (
        df.group_by_dynamic(
            index_column=date_col,
            every=freq,
        )
        .agg(
            pl.col(value_col).sum().alias(total_col),
            pl.len().alias(count_col),
            pl.col(value_col).mean().alias(mean_col),
            pl.col(value_col).std().alias(std_col),
        )
        .pipe(complete_date_grid, None, date_col, freq, fill_value)
    )


def span_by_id(
    df: pl.DataFrame,
    key: str,
    date_col: str,
    span_col: str = "lead_days",
) -> pl.DataFrame:
    """
    calculate lead time in days
    """
    return (
        df.group_by(key, maintain_order=True)
        .agg(
            start=pl.col(date_col).first(),
            end=pl.col(date_col).last(),
        )
        .with_columns((pl.col("end") - pl.col("start")).dt.total_days().alias(span_col))
    )


def survival_table(
    df: pl.DataFrame,
    value_col: str,
    bucket_size: int = 1,
    bucket_col: str = "bucket",
) -> pl.DataFrame:
    return (
        df.with_columns(
            pl.col(value_col).floordiv(bucket_size).mul(bucket_size).alias(bucket_col)
        )
        .group_by(bucket_col, maintain_order=True)
        .agg(events=pl.len())
        .sort(bucket_col)
        .pipe(
            complete_grid,
            dimensions={
                bucket_col: pl.arange(
                    pl.col(bucket_col).min(),
                    pl.col(bucket_col).max() + bucket_size,
                    step=bucket_size,
                ),
            },
            fill_value=0,
        )
        .with_columns(
            pdf=pl.col("events") / (pl.col("events").sum() * bucket_size),
            survival=pl.col("events").cum_sum(reverse=True) / pl.col("events").sum(),
            hazard=pl.col("events") / pl.col("events").cum_sum(reverse=True),
        )
        .with_columns(
            expected_remaining_time=(
                (pl.col("survival") * bucket_size).cum_sum(reverse=True)
                / pl.col("survival")
            ),
            cum_hazard=pl.col("hazard").cum_sum(),
        )
        .with_columns(
            expected_total_time=pl.col(bucket_col) + pl.col("expected_remaining_time")
        )
        .filter(pl.col("survival") >= 0.001)
    )


def to_hijri(dt: date) -> bool:
    """Return True if the Gregorian date falls in Ramadan."""
    return Gregorian.fromdate(dt).to_hijri().month == 9


def is_ramadan(dt: date) -> bool:
    """Return True if the Gregorian date falls in Ramadan."""
    return Gregorian.fromdate(dt).to_hijri().month == 9


def auto_boxcox(
    x: np.ndarray,
    method: str,
    season_length: Optional[int] = None,
    lower: float = -0.9,
    upper: float = 2.0,
):
    lmbda = boxcox_lambda(x, method, season_length, lower, upper)
    return boxcox(x, lmbda)

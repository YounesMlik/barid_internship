import polars as pl
from datetime import date
from typing import Callable, Literal, Any
from hijridate import Gregorian

def complete_grid(
    df: pl.DataFrame,
    *,
    dimensions: dict[str, pl.Series | Callable[[pl.DataFrame], pl.Series]],
    on: list[str] | None = None,
    fill_value: Any = None,
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
    id_col: str | None,
    time_col: str,
    freq: str,
    time_unit: Literal["ns", "us", "ms"] | None = None,
    fill_value: Any = None,
) -> pl.DataFrame:
    time_range = pl.datetime_range(
        start=df[time_col].min(),  # pyright: ignore[reportArgumentType]
        end=df[time_col].max(),  # pyright: ignore[reportArgumentType]
        interval=freq,
        eager=True,
        time_unit=time_unit,
    )  # type: ignore

    dimensions = {time_col: time_range}

    if id_col is not None:
        dimensions[id_col] = df[id_col].unique()

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
    time_range = pl.date_range(
        start=df[time_col].min(),  # pyright: ignore[reportArgumentType]
        end=df[time_col].max(),  # pyright: ignore[reportArgumentType]
        interval=freq,
        eager=True,
    )  # type: ignore

    dimensions = {time_col: time_range}

    if id_col is not None:
        dimensions[id_col] = df[id_col].unique()

    return complete_grid(
        df,
        dimensions=dimensions,
        fill_value=fill_value,
    )




def aggregate_timeseries(
    df: pl.DataFrame,
    freq: str,
    value_col: str,
    date_col: str,
    fill_value: Any = 0,
):
    return (
        df.group_by_dynamic(
            index_column=date_col,
            every=freq,
        )
        .agg(
            pl.col(value_col).sum(),
            len=pl.len(),
            mean=pl.col(value_col).sum() / pl.len(),
        )
        .pipe(
            complete_grid,
            dimensions={
                date_col: lambda d: pl.date_range(
                    start=d[date_col].min(),  # pyright: ignore[reportArgumentType]
                    end=d[date_col].max(),  # pyright: ignore[reportArgumentType]
                    interval=freq,
                    eager=True,
                ),  # type: ignore
            },
            fill_value=fill_value,
        )
    )


def to_hijri(dt: date) -> bool:
    """Return True if the Gregorian date falls in Ramadan."""
    return Gregorian.fromdate(dt).to_hijri().month == 9


def is_ramadan(dt: date) -> bool:
    """Return True if the Gregorian date falls in Ramadan."""
    return Gregorian.fromdate(dt).to_hijri().month == 9

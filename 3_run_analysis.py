import sqlite3
from pathlib import Path

import matplotlib
import pandas as pd

matplotlib.use("Agg")
import matplotlib.pyplot as plt

FOLDER = Path(__file__).parent
DATABASE = FOLDER / "churn.db"
VIEWS = FOLDER / "views"
QUERIES = FOLDER / "queries"
RESULTS = FOLDER / "results"
CHARTS = FOLDER / "charts"
MAX_ROWS_ON_SCREEN = 15

CHARTS_TO_DRAW = {
    "02_churn_by_contract": ("contract", "churn_rate_pct", "Churn rate by contract type", "{:.1f}%"),
    "03_churn_by_tenure": ("tenure_group", "churn_rate_pct", "Churn rate by how long they've been a customer", "{:.1f}%"),
    "04_churn_by_payment_method": ("payment_method", "churn_rate_pct", "Churn rate by payment method", "{:.1f}%"),
    "05_churn_by_internet_service": ("internet_service", "churn_rate_pct", "Churn rate by internet service", "{:.1f}%"),
    "11_risk_score_check": ("risk_level", "churn_rate_pct", "Churn rate by risk score level", "{:.1f}%"),
    "14_what_if_contract_upgrade": ("month_to_month_moved_to_yearly", "yearly_revenue_saved",
                                    "Yearly revenue saved if month-to-month customers move to yearly contracts", "${:,.0f}"),
}


def draw_chart(name, result):
    label_column, value_column, title, label_format = CHARTS_TO_DRAW[name]
    fig, ax = plt.subplots(figsize=(8, 4.5))
    bars = ax.bar(result[label_column].astype(str), result[value_column], color="#4C72B0")
    ax.bar_label(bars, labels=[label_format.format(v) for v in result[value_column]], padding=3)
    ax.set_title(title, fontsize=12, pad=12)
    ax.set_ylabel(value_column.replace("_", " ").replace("pct", "(%)"))
    ax.set_ylim(0, result[value_column].max() * 1.2)
    ax.spines[["top", "right"]].set_visible(False)
    plt.xticks(rotation=15 if len(result) > 3 else 0)
    plt.tight_layout()
    fig.savefig(CHARTS / f"{name}.png", dpi=150)
    plt.close(fig)


def main():
    RESULTS.mkdir(exist_ok=True)
    CHARTS.mkdir(exist_ok=True)
    pd.set_option("display.width", 200)
    with sqlite3.connect(DATABASE) as con:
        for view_file in sorted(VIEWS.glob("*.sql")):
            con.execute(f"DROP VIEW IF EXISTS {view_file.stem}")
            con.executescript(view_file.read_text())
        for sql_file in sorted(QUERIES.glob("*.sql")):
            result = pd.read_sql_query(sql_file.read_text(), con)
            print(f"\n=== {sql_file.stem}")
            print(result.head(MAX_ROWS_ON_SCREEN).to_string(index=False))
            if len(result) > MAX_ROWS_ON_SCREEN:
                print(f"... {len(result):,} rows in total, all saved to results/{sql_file.stem}.csv")
            result.to_csv(RESULTS / f"{sql_file.stem}.csv", index=False)
            if sql_file.stem in CHARTS_TO_DRAW:
                draw_chart(sql_file.stem, result)
    print(f"\nSaved results to results/ and {len(CHARTS_TO_DRAW)} charts to charts/")


if __name__ == "__main__":
    main()

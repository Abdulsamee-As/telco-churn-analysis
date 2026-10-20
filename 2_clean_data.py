import sqlite3
from pathlib import Path

import pandas as pd

FOLDER = Path(__file__).parent
RAW_FILE = FOLDER / "data" / "raw_customers.csv"
CLEAN_FOLDER = FOLDER / "data" / "clean"
DATABASE = FOLDER / "churn.db"

COLUMN_NAMES = {
    "customerID": "customer_id",
    "gender": "gender",
    "SeniorCitizen": "senior_citizen",
    "Partner": "has_partner",
    "Dependents": "has_dependents",
    "tenure": "tenure_months",
    "PhoneService": "phone_service",
    "MultipleLines": "multiple_lines",
    "InternetService": "internet_service",
    "OnlineSecurity": "online_security",
    "OnlineBackup": "online_backup",
    "DeviceProtection": "device_protection",
    "TechSupport": "tech_support",
    "StreamingTV": "streaming_tv",
    "StreamingMovies": "streaming_movies",
    "Contract": "contract",
    "PaperlessBilling": "paperless_billing",
    "PaymentMethod": "payment_method",
    "MonthlyCharges": "monthly_charges",
    "TotalCharges": "total_charges",
    "Churn": "churn",
}

TABLES = {
    "customers": ["customer_id", "gender", "senior_citizen", "has_partner", "has_dependents"],
    "services": ["customer_id", "phone_service", "multiple_lines", "internet_service", "online_security",
                 "online_backup", "device_protection", "tech_support", "streaming_tv", "streaming_movies"],
    "accounts": ["customer_id", "tenure_months", "tenure_group", "contract", "paperless_billing",
                 "payment_method", "monthly_charges", "total_charges", "churned"],
}


def clean(df):
    df = df.rename(columns=COLUMN_NAMES)

    blank_charges = pd.to_numeric(df["total_charges"], errors="coerce").isna().sum()
    df["total_charges"] = pd.to_numeric(df["total_charges"], errors="coerce").fillna(0)
    print(f"  Fixed {blank_charges} blank total_charges (brand-new customers, set to 0)")

    df["senior_citizen"] = df["senior_citizen"].map({1: "Yes", 0: "No"})
    print("  Changed senior_citizen from 1/0 to Yes/No")

    df = df.replace({"No phone service": "No", "No internet service": "No"})
    print("  Replaced 'No phone service' / 'No internet service' with 'No'")

    df["churned"] = (df["churn"] == "Yes").astype(int)
    df = df.drop(columns="churn")
    print("  Turned churn Yes/No into churned 1/0")

    df["tenure_group"] = pd.cut(
        df["tenure_months"],
        bins=[-1, 12, 24, 48, 72],
        labels=["0-12 months", "13-24 months", "25-48 months", "49-72 months"],
    ).astype(str)
    print("  Added tenure_group (0-12, 13-24, 25-48, 49-72 months)")

    duplicates = df["customer_id"].duplicated().sum()
    if duplicates:
        raise ValueError(f"{duplicates} duplicate customer ids found")
    return df


def save(df):
    CLEAN_FOLDER.mkdir(parents=True, exist_ok=True)
    with sqlite3.connect(DATABASE) as con:
        for table, columns in TABLES.items():
            df[columns].to_csv(CLEAN_FOLDER / f"{table}.csv", index=False)
            df[columns].to_sql(table, con, if_exists="replace", index=False)
            print(f"  {table:<10} {len(df):,} rows -> churn.db and data/clean/{table}.csv")


def main():
    raw = pd.read_csv(RAW_FILE)
    print(f"Read {len(raw):,} customers with {raw.shape[1]} columns")
    print("Cleaning:")
    df = clean(raw)
    print("Saving 3 tables:")
    save(df)


if __name__ == "__main__":
    main()

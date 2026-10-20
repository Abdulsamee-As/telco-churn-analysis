import urllib.request
from pathlib import Path

URL = "https://raw.githubusercontent.com/IBM/telco-customer-churn-on-icp4d/master/data/Telco-Customer-Churn.csv"
RAW_FILE = Path(__file__).parent / "data" / "raw_customers.csv"


def main():
    RAW_FILE.parent.mkdir(exist_ok=True)
    urllib.request.urlretrieve(URL, RAW_FILE)
    customers = RAW_FILE.read_text().count("\n") - 1
    print(f"Downloaded {customers:,} customers to data/{RAW_FILE.name}")


if __name__ == "__main__":
    main()

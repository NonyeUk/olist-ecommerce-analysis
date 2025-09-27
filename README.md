
# 📦 Olist E-Commerce Data Analysis

## ✨ Introduction

Brazil’s **Olist** is an online marketplace that helps small businesses sell their products across multiple e-commerce platforms. Over time, Olist collected a massive amount of order, customer, and review data—an untapped goldmine for understanding sales performance, customer behavior, and delivery efficiency.

In this project, I put on my **data analyst hat** to explore this dataset, uncover trends, and visualize actionable insights using **SQL** and **Power BI**. From cleaning messy text fields to crafting sleek dashboards, this analysis highlights how data can shape smarter decisions in e-commerce.

---

## 🎯 Problem Statement

The goal was to use Olist’s raw data to answer key business questions:

* How are **sales and revenue** trending over time?
* Which **products** and **categories** drive the most growth?
* What patterns exist in **customer reviews**, delivery times, and payment methods?
* Where can the business improve customer retention and satisfaction?

---

## 🧰 Skills Demonstrated

* **Data Wrangling (SQL):** Cleaning categorical text, handling nulls/duplicates, computing KPIs (monthly sales, new vs returning customers, AOV, YoY revenue).
* **Data Analysis:** Revenue growth, product performance, customer segmentation, delivery KPIs, and review impact.
* **Dashboarding (Power BI):** Interactive reports with parameters, dynamic product tables, and geospatial visuals.
* **Documentation & Storytelling:** Translating technical work into clear, decision-ready insights.

---

## 🛠️ Tech Stack

* **SQL (SQLite)** – data cleaning, exploration, and advanced analysis
* **Power BI** – data modeling and interactive dashboards
* **GitHub** – version control and project documentation

---

## 🕵️ Data Wrangling

The raw dataset contained multiple tables—orders, customers, reviews, payments, products, and leads.
Key cleaning steps included:

* Standardizing categorical text and date formats
* Handling null values and duplicates
* Creating derived metrics such as **new vs returning customers**, **monthly revenue growth**, and **average delivery times**

---

## 🔍 Exploratory Data Analysis (EDA)

Before dashboarding, I explored the data to uncover:

* Seasonal sales patterns and year-over-year trends
* Delivery performance vs. review scores
* Payment method distribution and its relationship to order size
* Category-level revenue contributions

---

## 📊 Data Analysis (SQL)

To move beyond exploration, I designed a set of **business-driven SQL queries** to generate deeper insights:

* **Sales & Customer Analysis** – Monthly revenue growth, average order value (AOV), new vs returning customers by state, and revenue growth rates.
* **Customer Segmentation** – Grouped customers into **VIP**, **Regular**, **Normal**, or **One-Time** based on spend and purchase frequency.
* **Product Performance** – Ranked product categories by revenue, calculated revenue percentage contributions, and merged with review scores to find high-growth/high-satisfaction categories.
* **Payment Analysis** – Measured order share, revenue, and approval times by payment method.
* **Review & Delivery Analysis** – Connected delivery delays with review scores to identify service issues.
* **Lead Source & Business Type** – Tracked orders and revenue by marketing source and business type to highlight acquisition performance.

These queries combined CTEs, window functions, and aggregations to produce actionable metrics ready for visualization.

---

## 📈 Dashboards

I designed **two key dashboards** in Power BI to tell the story at a glance:

### 1️⃣ **Sales & Performance**

* KPIs: Total Sales, Orders, and Customers with YoY comparison
* Product performance table with Revenue, YoY growth, and Avg Review (dynamic parameter to display top products)
* Revenue by location (map)

### 2️⃣ **Customer Insights**

* Average Review KPI and monthly review trend
* Review score distribution
* Avg delivery days vs review score
* Payment method mix
* Customer segmentation and lead source × business type metrics

*(Screenshots available in the `dashboards/images` folder)*

---

## 💡 Key Insights

* **Revenue Growth:** Total revenue showed a steady upward trend, signaling strong market expansion.
* **Customer Retention Gap:** New customers dominated, but **returning customers were scarce**, highlighting an opportunity for loyalty programs.
* **Delivery & Reviews:** Delayed deliveries were the primary driver of poor reviews, underscoring the need for logistics improvements.
* **Payment Mix:** Credit card payments remained the top method, with digital wallets emerging as a growth area.
* **Overall Sentiment:** Despite delivery challenges, the average review score held at **4.0**, indicating a generally positive customer experience.

---

## 🔗 Dataset

The dataset is publicly available on [Kaggle – Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce).
Due to file size, raw data is not included in this repo.

---

## 📂 Repository Structure

```
olist-sql-powerbi-analysis/
│
├── sql/                 # Cleaning, exploration, and analysis scripts
│   ├── cleaning.sql
│   ├── exploration.sql
│   └── analysis.sql
│
├── dashboards/
│   ├── images/          # Dashboard screenshots
│   └── pbix/
│       └── olist_dashboard.pbix
│
├── data/                # Placeholder for dataset (not included)
│   └── .gitkeep
│
└── README.md
```

---

## 🚀 Next Steps & Recommendations

* **Customer Retention:** Launch loyalty programs or targeted campaigns to encourage repeat purchases.
* **Delivery Optimization:** Focus on faster fulfillment in regions with high delays to protect review scores.
* **Payment Strategy:** Promote emerging payment methods to capture a wider audience.

---

## 📜 License

MIT — see [LICENSE](LICENSE).

---

### 🌱 Takeaway

This project reinforced how **data cleaning + smart SQL analysis + interactive visuals = business clarity**.
With Olist’s dataset, I transformed raw transactions into actionable insights—proof that every dataset has a story waiting to be told.



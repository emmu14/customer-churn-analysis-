# customer-churn-analysis-
# 🔍 Customer Churn Analysis
**Tools Used:** MySQL | Power BI | Excel | GitHub

![Dashboard](screenshots/dashboard_overview.png)

---

## 📌 Project Overview
This project analyses customer transaction data to identify which customers have churned (stopped buying), find the reasons behind churn, and flag at-risk customers before they leave — using SQL queries in MySQL and an interactive Power BI dashboard.

**Churn Definition used in this project:**
A customer is considered churned if their last order was placed before June 30, 2024 — meaning they have been inactive for more than 6 months.

---

## 🎯 Business Questions Answered
- What is the overall customer churn rate?
- Which customer segment churns the most — Premium, Standard or Basic?
- Which cities have the highest churn rate?
- Which active customers are at risk of churning soon?
- How much revenue was lost because of churned customers?

---

## 📈 Key Insights Found
1. **40% overall churn rate** — 80 out of 200 customers stopped buying
2. **Basic segment** has the highest churn at 50% — needs loyalty incentives
3. **Premium customers** are the most loyal with only 30% churn rate
4. **20+ at-risk customers** identified — business can contact them with discount offers today
5. **Active customers spend 2x more** and place 3x more orders than churned customers
6. **Revenue impact** — significant revenue loss identified from churned customer segment

---

## 🛠️ Tools and Skills Used
| Tool | Purpose |
|------|---------|
| MySQL | Database creation, SQL queries, churn analysis |
| Power BI | Interactive dashboard with 4 visuals |
| Excel | Raw data — 200 customers, 1079 orders |
| GitHub | Version control and portfolio sharing |

**SQL Concepts Used:**
CREATE TABLE, JOIN, GROUP BY, CASE WHEN, Window Functions (OVER),
CREATE VIEW, DATE functions (DATEDIFF), Subqueries, TRUNCATE

---

## 📁 Project Structure
```
customer-churn-analysis/
│
├── data/
│   └── customer_data.xlsx          ← 200 customers + 1079 orders
│
├── sql/
│   ├── 01_create_tables.sql        ← creates database and tables
│   ├── 02_load_data.sql            ← data loading instructions
│   ├── 03_churn_analysis.sql       ← 8 churn analysis queries
│   └── 04_powerbi_exports.sql      ← export queries for Power BI
│
├── powerbi/
│   └── Customer_Churn_Dashboard.pbix
│
├── screenshots/
│   ├── dashboard_overview.png
│   ├── kpi_cards.png
│   └── at_risk_table.png
│
└── README.md
```

---

## 📊 Dashboard Visuals Built
| Visual | Description |
|--------|-------------|
| KPI Cards | Total Customers, Churned, Active, Churn Rate %, At-Risk Count |
| Donut Chart | Active vs Churned customers split |
| Bar Chart | Churn rate by customer segment |
| At-Risk Table | List of customers about to churn with risk level |

---

## 🔄 How to Run This Project

### Step 1 — Set up the database
1. Install MySQL and MySQL Workbench (free at dev.mysql.com)
2. Open MySQL Workbench
3. Run `01_create_tables.sql` to create the database and tables

### Step 2 — Import the data
1. Right-click the `customers` table → Table Data Import Wizard
2. Import the `customers` sheet from `customer_data.xlsx`
3. Right-click the `orders` table → Table Data Import Wizard
4. Import the `orders` sheet from `customer_data.xlsx`

### Step 3 — Run the analysis
1. Open `03_churn_analysis.sql` in MySQL Workbench
2. Run Query 1 first — this creates the VIEW all other queries need
3. Run each query one by one to see the insights

### Step 4 — Build the Power BI dashboard
1. Run `04_powerbi_exports.sql` and export each result as CSV
2. Open Power BI Desktop → Get Data → load all 5 CSV files
3. Build 4 visuals: KPI cards, Donut chart, Bar chart, At-Risk table

---

## 💡 Business Recommendations
Based on the SQL analysis findings:

- **Win back churned Premium customers** — they spent the most before leaving. Send personalised win-back emails with a special offer.
- **Target at-risk customers immediately** — 20+ active customers are 90-179 days inactive. A 10% discount offer could save them before they churn.
- **Improve Basic segment retention** — 50% churn rate is too high. Consider a loyalty programme or rewards scheme.
- **Investigate the churn spike period** — find what caused the high volume of last orders and address the root cause.

---

## 📸 Screenshots

### Full Dashboard
![Dashboard Overview](screenshots/dashboard_overview.png)

### KPI Cards
![KPI Cards](screenshots/kpi_cards.png)

### At-Risk Customers Table
![At Risk Table](screenshots/at_risk_table.png)

---

## 👤 About Me
This is **Project 2** in my data analytics portfolio. I am learning data analytics and building real projects to develop my skills.

📧 your.email@gmail.com
🔗 [LinkedIn Profile](https://www.linkedin.com/in/emmanuvel-christin-63b585264)
📊 [Project 1 — Sales Dashboard](https://github.com/emmu14/sales-dashboard)

---

## 🚀 Skills Demonstrated
- Relational database design and management
- Writing complex SQL queries for business analysis
- Data cleaning and preparation
- Business intelligence dashboard building
- Identifying actionable insights from data
- Version control with GitHub

---

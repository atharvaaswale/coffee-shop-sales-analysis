# ☕ Coffee Shop Sales & Menu Optimization Analysis

### **Project Overview**
This project provides a data-driven strategy for a multi-location coffee retail business. By transitioning from **SQL-based data extraction** to **Python-based advanced analytics**, I identified critical revenue leaks, operational bottlenecks during peak hours, and untapped upselling opportunities across three major locations: **Astoria, Hell's Kitchen, and Lower Manhattan**.

---

## 📈 **Key Business Insights**

### **1. Growth & Seasonality**
* **The February Factor:** Analysis revealed a consistent revenue dip in February across all stores. 
* **Analyst Insight:** This decline is primarily an **operational calendar effect** due to the 28-day month rather than a drop in organic demand, as March saw a recovery exceeding 30%.

### **2. Menu Intelligence (The "Kill List")**
* **Identifying Dead Assets:** "Dark Chocolate" was identified as the lowest revenue generator ($755 total) with high inventory stagnancy.
* **Category Over-Saturation:** The **Loose Tea** category is over-represented in the bottom 10% of revenue, suggesting a need for menu simplification.

### **3. Operational Efficiency**
* **The "Morning Gold Mine":** Revenue peaks sharply between **8:00 AM and 10:00 AM**.
* **Strategic Fix:** Maximize staffing levels during this 2-hour window to capture high transaction density, especially in **Hell's Kitchen**, our most efficient location.

### **4. Unit Economics & Upselling**
* **The Single-Item Trap:** Over 70% of transactions consist of only a **single item**.
* **Revenue Multiplier:** Data proves that moving a customer from 1 item to 2 items increases the **Average Ticket Size** by nearly 60% (from ~$3.70 to ~$6.00).

---

## 🛠️ **Tech Stack & Methodology**
* **SQL:** Performed complex joins, CTEs, and window functions to aggregate transactional data into 5 core business queries.
* **Python (Pandas):** Cleaned data, handled missing MoM values, and performed normalization.
* **Seaborn & Matplotlib:** Created a unified "Viridis" themed dashboard for executive reporting.

---

## 🚀 **Final Recommendations**
* **Bundle Strategy:** Launch a "Coffee + Pastry" combo to break the 1-item transaction ceiling.
* **Menu Purge:** Remove the bottom 5 performing Loose Tea variants to reduce inventory complexity.
* **Afternoon Pivot:** Increase marketing for Bakery and Drinking Chocolate after 12:00 PM to match shifting afternoon demand.

---

## 📂 **Project Structure**
* `sales-optimisation-analysis.ipynb`: Full Python source code and visualizations.
* `Data/`: Cleaned CSV outputs from SQL queries.
* `Visuals/`: High-resolution dashboard exports.

# 🏦 Bank Matsliah – Relational Database Design & SQL

---

# 📖 Project Overview

**Bank Matsliah** is a relational database project developed using **Microsoft SQL Server**.

The project simulates a real banking environment by designing and implementing a normalized relational database that stores information about customers, employees, bank accounts, deposits, loans, and banking operations.

The main goal of this project was to design a scalable, well-structured database that ensures data integrity while supporting future business analysis using SQL, Python, and Power BI.

This project demonstrates the complete database design process, from business requirements to logical data modeling, table creation, relationships, constraints, and data preparation for analytical reporting.

---

# 🎯 Project Goals

The project was designed to achieve the following objectives:

- Design a relational database from scratch.
- Apply database normalization principles.
- Build a scalable banking database.
- Define Primary Keys and Foreign Keys.
- Maintain data integrity using Constraints.
- Create relationships between business entities.
- Prepare a database optimized for business intelligence and data analysis.
- Build a strong foundation for future SQL, Python, and Power BI projects.

---

# 🏦 Business Scenario

Banks manage large amounts of customer and financial data every day.

To support efficient banking operations, a well-designed relational database is required to organize information, ensure consistency, and enable fast reporting and business analysis.

The **Bank Matsliah** database models a real banking system by storing data about:

- 👨‍💼 Bank employees
- 👥 Customers
- 💳 Bank accounts
- 💰 Deposits
- 🏦 Loans & Mortgages

The database reflects the relationships between customers, employees, accounts, deposits, and loans, allowing future analytical projects to generate valuable business insights.

---

# 🔗 Entity Relationships

The database contains several One-to-Many relationships.

### Bankers

- Banker_ID → Primary Key
- ReportsTo → Self-referencing Foreign Key
- Connected to Accounts

### Clients

- Client_ID → Primary Key
- Connected to Accounts

### Accounts

- Account_Number → Primary Key
- Client_ID → Foreign Key
- Banker_ID → Foreign Key
- Connected to Deposits
- Connected to Loans

### Deposits

- Deposit_ID → Primary Key
- Account_Number → Foreign Key

### Loans

- Loan_ID → Primary Key
- Account_Number → Foreign Key

The relational model guarantees referential integrity across all business entities.

---

# 🏗 Database Design Process

The project followed the complete database development lifecycle:

1. Business requirements analysis
2. Database planning
3. Entity identification
4. ERD design
5. Table creation
6. Primary Key definition
7. Foreign Key relationships
8. Constraints implementation
9. Data validation
10. Data population

---

# 📊 Database Features

✔ Relational Database

✔ Normalized Structure

✔ Primary Keys

✔ Foreign Keys

✔ Constraints

✔ One-to-Many Relationships

✔ Self-Referencing Relationship

✔ Data Integrity

✔ Scalable Design

---

# 🛠 Technologies

- Microsoft SQL Server
- SQL
- Relational Database Design
- ERD (Entity Relationship Diagram)
- Primary Keys
- Foreign Keys
- Constraints

---

# 🚀 Future Development

This relational database serves as the foundation for future analytical projects, including:

- SQL Data Analysis
- Advanced SQL Queries
- Python Data Analysis
- Power BI Dashboards
- Banking KPI Reporting
- Business Intelligence Solutions

---

# 💼 Skills Demonstrated

This project demonstrates practical experience in:

- Relational Database Design
- SQL Development
- Database Modeling
- ERD Design
- Data Normalization
- Primary & Foreign Keys
- Constraints
- Business Analysis
- Logical Data Modeling
- Database Documentation

---

# 👩‍💻 Author

**Anat Shmueli**

**Data Analyst | Database Analyst**

📧 anatshmoueli@gmail.com

---

⭐ Thank you for visiting this project.

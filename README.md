# Olist E-Commerce SQL Analysis

This repository contains my SQL analysis project using the Olist e-commerce dataset.

The main goal of this project is to practice SQL by analyzing order data, delivery times, and customer reviews.  
All analyses were written using Microsoft SQL Server.

## Dataset
The dataset is taken from the Olist Brazilian E-Commerce dataset on Kaggle.
https://www.kaggle.com/datasets/terencicp/e-commerce-dataset-by-olist-as-an-sqlite-database?resource=download

Tables used in this project:
- orders
- order_items
- order_reviews

## What I Analyzed

- Monthly number of orders
- Monthly revenue based on delivered orders
- Average delivery time in days
- Percentage of late deliveries
- Relationship between delivery time and customer review scores

## Key Finding

Orders that were delivered faster received higher review scores.

Average delivery time decreases as review score increases:
- Low-rated orders were delivered much later
- High-rated orders were delivered faster

This shows that delivery speed has a strong effect on customer satisfaction.

## Notes
- TRY_CONVERT was used to handle invalid or missing date values
- Only delivered orders were included in delivery-related calculations
- This project focuses on learning SQL fundamentals such as JOIN, GROUP BY, and date functions

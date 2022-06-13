# Hotel Booking Database

## Project Overview
In this project I build a simple relational database to help me get the fundamentals of SQL syntax. Some of the concepts covered include; table creation, data manipulation as well as more advanced concepts like triggers and stored routines.

The `booking_db` is a database to help manage the booking process of various rooms in a hotel. After booking, the hotel allows users to cancel their bookings latest by the day prior to the booked date. Cancellation is free. However, if this is the third (or more) consecutive cancellations, the hotel imposes a $10 fine.

## Steps
1. Create a database i.e. `booking_db`
2. Create tables
    * The database will have four tables i.e. `guests`, `pending_terminations`, `rooms` and `bookings`.
3. Create a view
    * A view is a virtual table based on the results of an SQL statement. Views help simplify code and restrict access to certain data in a table. The view in this project is called `guest_bookings`
4. Create stored procedures
    * In simple terms, a stored procedure is SQL code that you can save so that it can be reused over and over again. This project will have nine stored procedures.
5. Create a trigger
    * A trigger is a series of actions that are activated when a defined event occurs for a specific table. This event can either be an **INSERT**, **UPDATE** or **DELETE**. Triggers can be invoked before or after the said event. The trigger in this project is called `payment_check`
6. Create a stored function
    * Stored functions are very similar to stored procedures except for some differences. Stored functions must return a value but it is optional for stored procedures. The stored function in this project is called `check_cancellation`
7. Test and see whether everything created by `booking.sql` is working properly by running commands in `test.sql`

## Requirements
MySQL database server 5.0 or later

## Disclaimer
To the best of my knowledge, this data is fabricated and it does not correspond to real people. Any similarity to existing people is purely coincidental.
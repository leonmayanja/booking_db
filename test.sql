-- This SQL file is to be used to test whether or not statements in 'booking.sql' excecuted successfully

-- Run the following SELECT statements to see the contenets of the tables
-- The 'pending_terminations' table should be empty at this point since no termination has been made
SELECT * FROM guests;
SELECT * FROM pending_terminations;
SELECT * FROM bookings;
SELECT * FROM rooms;

-- Testing 'insert_new_guest' procedure
CALL insert_new_guest ( 11, 'Daffy', 'Rocks', 'rMSrBPHk', 'drocks0@fastcompany.com');
SELECT * FROM guests ORDER BY guest_since DESC;

-- Testing 'delete_guest' procedure
CALL delete_guest (8);
CALL delete_guest (4);
SELECT * FROM guests;

-- Since guest with id number 4 has an outstanding payment, a new record is added to the 'pending_terminations' table
-- This is due to the 'payment_check' trigger in 'booking.sql'
SELECT * FROM pending_terminations;

-- Testing 'update_guest_password' & 'update_guest_email' procedures
CALL update_guest_password (8, 'GrCrpYPZPuY9');
CALL update_guest_email (8, 'rtrollope7@gmail.com');
SELECT * FROM guests;

-- Testing the 'update_payment' procedure
-- Running the two SELECT statements below, we see that guest with id=6 has an outstanding payment
-- We’ll update the payment status from 'Unpaid' to 'Paid' using the 'update_payment' procedure
SELECT * FROM guests WHERE id = 6;
SELECT * FROM bookings WHERE guest_id = 6;
CALL update_payment (155);
-- Running the two SELECT statements again shows guest with id=6 no longer has an outstanding payment
SELECT * FROM guests WHERE id = 6;
SELECT * FROM bookings WHERE guest_id = 6;

-- Testing the 'search_room' procedure
-- CALLing the the first 'search_room' procedure returns no results
-- This is because the single room is already booked on 2017-12-26 at 1pm
CALL search_room('Single', '2017-12-26', '13:00:00');
-- CALLing the second 'search_room' procedure returns some results
-- This is because the double room is available on 2018-04-15 at 2pm
CALL search_room('Double', '2018-04-15', '14:00:00');
-- CALLing the third 'search_room' procedure returns a row of results
-- This is because the triple room has already been booked for the specified date and time
CALL search_room('Triple', '2018-06-12', '15:00:00');

-- Testing the 'make_booking' procedure
-- Executing the first CALL statement should return an error message
-- This is due to the unique key constraint (uc1) that was added to the 'bookings' table
CALL make_booking ('S', '2017-12-26', '13:00:00', 5);
-- The remaining CALL statements should excecute successfully and add new entries to the 'bookings' table two weeks from the current date
CALL make_booking ('ES', CURDATE() + INTERVAL 2 WEEK, '11:00:00', 9);
CALL make_booking ('S', CURDATE() + INTERVAL 2 WEEK, '11:00:00', 5);
SELECT * FROM bookings;
SELECT * FROM guests;

-- Testing the 'cancel_booking' procedure
-- Executing the first CALL statement should return a message saying 'cancellation cannot be done'
-- This is because the booked date for booking has already past i.e. 2017-12-26
CALL cancel_booking(100, @message);
SELECT @message;

-- Replace *** with the booking id of the new booking made by guest with id=5 and execute the two statements
-- It should return the message 'Booking Cancelled' indicating that the cancellation was successful
CALL cancel_booking(***, @message);
SELECT @message;

-- Replace ... with the booking id of the new booking made by guest with id=8 and execute the two statements
-- It should return the message 'Booking Cancelled' indicating that the cancellation was successful
CALL cancel_booking(..., @message);
SELECT @message;

-- Excecute the SELECT statement below
-- You should notice that the payment_due value of guest_id=5 is 0 while that of guest_id=8 is $10
-- This is because the most recent cancellation by guest_id=3 is the 3rd consecutive cancellation. Hence, a $10 fine is imposed
SELECT * FROM guests;
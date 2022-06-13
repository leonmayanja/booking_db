CREATE DATABASE booking_db;
USE booking_db;


-- ********************************
-- CREATE TABLES
-- ********************************
-- Records here will contain guest information
CREATE TABLE guests (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    guest_since TIMESTAMP DEFAULT NOW() NOT NULL,
    payment_due DECIMAL(6, 2) NOT NULL DEFAULT 0
);

-- Records from the guests table will be transferred here under certain circumstances
CREATE TABLE pending_terminations (
    id VARCHAR(255) PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    request_date TIMESTAMP DEFAULT NOW() NOT NULL,
    payment_due DECIMAL(6, 2) NOT NULL DEFAULT 0
);

-- Records here will contain room information
CREATE TABLE rooms (
    id VARCHAR(255) PRIMARY KEY,
    room_type VARCHAR(255) NOT NULL,
    price DECIMAL(6, 2) NOT NULL
);

-- Records here will contain the booking information 
CREATE TABLE bookings (
    room_num INT PRIMARY KEY,
    room_id VARCHAR(255) NOT NULL,
    booked_date DATE NOT NULL,
    booked_time TIME NOT NULL,
    guest_id INT NOT NULL,
    datetime_of_booking TIMESTAMP DEFAULT NOW() NOT NULL,
    payment_status VARCHAR(255) NOT NULL DEFAULT 'Unpaid',
    CONSTRAINT uc1 UNIQUE (room_id, booked_date, booked_time)
);

ALTER TABLE bookings
    ADD CONSTRAINT fk1 FOREIGN KEY (guest_id) REFERENCES guests (id) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT fk2 FOREIGN KEY (room_id) REFERENCES rooms (id) ON DELETE CASCADE ON UPDATE CASCADE;


-- ********************************
-- INSERT DATA
-- ********************************
INSERT INTO guests (id, first_name, last_name, password, email, guest_since, payment_due) VALUES
(1, 'Suellen', 'Ugoni', '2HBMKPnF1', 'sugoni0@usda.gov', '2017-04-15 12:10:13', 0),
(2, 'Urbain', 'Knightsbridge', '8ANygzkMo95', 'uknightsbridge1@google.nl', '2018-02-06 16:48:43', 0),
(3, 'Roxane', 'Ellerbeck', 'hWQp0quC', 'rellerbeck2@youku.com', '2017-12-28 05:36:50', 0),
(4, 'Kali', 'Traves', '5CXheXFFH', 'ktraves3@statcounter.com', '2017-06-01 21:12:11', 150),
(5, 'Angelle', 'Sellan', 'TK1Zl116', 'asellan4@naver.com', '2017-05-30 17:30:22', 0),
(6, 'Amandy', 'Durante', '8BgJe2Ziu5', 'adurante5@about.me', '2017-09-09 02:30:49', 100),
(7, 'Edee', 'Agge', 'QHTLJtbG1acL', 'eagge6@t-online.de', '2018-01-09 17:36:49', 0),
(8, 'Robbie', 'Trollope', 'GrCrpYPZPuY9', 'rtrollope7@china.com.cn', '2017-12-16 22:59:46', 0),
(9, 'Marlane', 'Draye', '94REfoMQt7Yb', 'mdraye8@google.com.hk', '2017-10-12 05:39:20', 0),
(10, 'Giffy', 'Ariss', 'gANMQWJj9', 'gariss9@cbslocal.com', '2017-07-18 16:28:35', 0);

INSERT INTO rooms (id, room_type, price) VALUES
('S', 'Single', 120),
('D', 'Double', 240),
('T', 'Triple', 360),
('Q', 'Quad', 480),
('MS', 'Mini Suite', 600),
('ES', 'Executive Suite', 850),
('PS', 'Presidential Suite', 1300);

INSERT INTO bookings (room_num, room_id, booked_date, booked_time, guest_id, datetime_of_booking, payment_status) VALUES
(100 , 'S', '2017-12-26', '13:00:00', 9, '2017-12-20 20:31:27', 'Paid'),
(105 , 'Q', '2017-12-30', '17:00:00', 8, '2017-12-22 05:22:10', 'Paid'),
(200 , 'PS', '2017-12-31', '16:00:00', 5, '2017-12-28 18:14:23', 'Paid'),
(150 , 'ES', '2018-03-05', '08:00:00', 4, '2018-02-22 20:19:17', 'Unpaid'),
(120 , 'MS', '2018-03-02', '11:00:00', 6, '2018-03-01 16:13:45', 'Paid'),
(110 , 'D', '2018-03-28', '16:00:00', 6, '2018-03-23 22:46:36', 'Paid'),
(111 , 'D', '2018-04-15', '14:00:00', 5, '2018-04-12 22:23:20', 'Cancelled'),
(205 , 'PS', '2018-04-23', '13:00:00', 5, '2018-04-19 10:49:00', 'Cancelled'),
(155 , 'ES', '2018-05-25', '10:00:00', 6, '2018-05-21 11:20:46', 'Unpaid'),
(108 , 'T', '2018-06-12', '15:00:00', 3, '2018-05-30 14:40:23', 'Paid');


-- ********************************
-- CREATE VIEW
-- ********************************
-- This view will show all the booking details of a booking by joining the booking and rooms tables
CREATE VIEW guest_bookings AS
SELECT room_id, room_type, booked_date, booked_time, guest_id, datetime_of_booking, price, payment_status
FROM bookings 
JOIN rooms
ON bookings.room_id = rooms.id
ORDER BY bookings.room_num;


-- ********************************
-- CREATE PROCEDURES
-- ********************************
DELIMITER $$

-- Stored procedure to add new guests into guests table
CREATE PROCEDURE insert_new_guest (IN p_id INT, IN p_first_name VARCHAR(255), IN p_last_name VARCHAR(255), IN p_password VARCHAR(255), IN p_email VARCHAR(255))
BEGIN
    INSERT INTO guests (id, first_name, last_name, password, email) VALUES (p_id, p_first_name, p_last_name, p_password, p_email);
END $$

-- Stored procedure to delete a guest from the guests table
CREATE PROCEDURE delete_guest (IN p_id VARCHAR(255))
BEGIN
    DELETE FROM guests WHERE id = p_id;
END $$

-- Stored procedure to update a guest's password in guests table
CREATE PROCEDURE update_guest_password (IN p_id VARCHAR(255), IN p_password VARCHAR(255))
BEGIN
    UPDATE guests SET password = p_password WHERE id = p_id;
END $$

-- Stored procedure to update a guest's email in guests table
CREATE PROCEDURE update_guest_email (IN p_id VARCHAR(255), IN p_email VARCHAR(255))
BEGIN
    UPDATE guests SET email = p_email WHERE id = p_id;
END $$

-- Stored procedure to make a new booking in bookings table
CREATE PROCEDURE make_booking (IN p_room_id VARCHAR(255), IN p_booked_date DATE, IN p_booked_time TIME, IN p_guest_id INT)
BEGIN
    DECLARE v_price DECIMAL(6, 2);
    DECLARE v_payment_due DECIMAL(6, 2);
    SELECT price INTO v_price FROM rooms WHERE id = p_room_id;
    INSERT INTO bookings (room_id, booked_date, booked_time, guest_id) VALUES (p_room_id, p_booked_date, p_booked_time, p_guest_id);
    SELECT payment_due INTO v_payment_due FROM guests WHERE id = p_guest_id;
    UPDATE guests SET payment_due = v_payment_due + v_price
    WHERE id = p_guest_id;
END $$

-- Stored procedure to update payment status in bookings and guests tables after a guest makes a payment
CREATE PROCEDURE update_payment (IN p_id INT)
BEGIN
    DECLARE v_guest_id INT;
    DECLARE v_payment_due DECIMAL(6, 2);
    DECLARE v_price DECIMAL(6, 2);
    UPDATE bookings SET payment_status = 'Paid' WHERE id = p_id;
    SELECT guest_id, price INTO v_guest_id, v_price FROM guest_bookings WHERE id = p_id;
    SELECT payment_due INTO v_payment_due FROM guests WHERE id = v_guest_id;
    UPDATE guests SET payment_due = v_payment_due - v_price WHERE id = v_guest_id;
END $$

-- Stored procedure to view all bookings made by a particular guest
CREATE PROCEDURE view_bookings (IN p_id VARCHAR(255))
BEGIN
    SELECT * FROM guest_bookings WHERE id = p_id;
END $$

-- Stored procedure to search for available rooms
CREATE PROCEDURE search_room (IN p_room_type VARCHAR(255), IN p_booked_date DATE, IN p_booked_time TIME)
BEGIN
    SELECT * FROM rooms WHERE id NOT IN (SELECT room_id FROM bookings WHERE booked_date = p_booked_date AND booked_time = p_booked_time AND payment_status != 'Cancelled') AND room_type = p_room_type;
END $$

-- Stored procedure to cancel booking
CREATE PROCEDURE cancel_booking (IN p_booking_id INT, OUT p_message VARCHAR(255))
BEGIN
    DECLARE v_cancellation INT;
    DECLARE v_guest_id INT;
    DECLARE v_payment_status VARCHAR(255);
    DECLARE v_booked_date DATE;
    DECLARE v_price DECIMAL(6, 2);
    DECLARE v_payment_due VARCHAR(255);
    SET v_cancellation = 0;
    SELECT guest_id, booked_date, price, payment_status INTO v_guest_id, v_booked_date, v_price, v_payment_status FROM guest_bookings WHERE id = p_booking_id;
    SELECT payment_due INTO v_payment_due FROM guests WHERE id = v_guest_id;
    IF CURDATE() >= v_booked_date THEN 
		SELECT 'Cancellation cannot be done on/after the booked date' INTO p_message;
        ELSEIF v_payment_status = 'Cancelled' OR v_payment_status = 'Paid' THEN
			SELECT 'Booking has already been cancelled or paid' INTO p_message;
        ELSE
			UPDATE bookings SET payment_status = 'Cancelled' WHERE id = p_booking_id;
			SET v_payment_due = v_payment_due - v_price;
			SET v_cancellation = check_cancellation (p_booking_id);
			IF v_cancellation >= 2 THEN SET v_payment_due = v_payment_due + 10;
			END IF;
			UPDATE guests SET payment_due = v_payment_due WHERE id = v_guest_id;
			SELECT 'Booking Cancelled' INTO p_message;
    END IF;
END $$


-- ********************************
-- CREATE TRIGGER
-- ********************************
-- This trigger will check the outstanding balance of a guest
CREATE TRIGGER payment_check BEFORE DELETE ON guests FOR EACH ROW
BEGIN
    DECLARE v_payment_due DECIMAL(6, 2);
    SELECT payment_due INTO v_payment_due FROM guests WHERE id = OLD.id;
    IF v_payment_due > 0 THEN
		INSERT INTO pending_terminations (id, email, payment_due) VALUES (OLD.id, OLD.email, OLD.payment_due);
    END IF;
END $$


-- ********************************
-- CREATE FUNCTION
-- ********************************
-- This function will check the number of consecutive cancellations made by a guest who's trying to cancel a booking
CREATE FUNCTION check_cancellation (p_booking_id INT) RETURNS INT DETERMINISTIC
BEGIN
    DECLARE v_done INT;
    DECLARE v_cancellation INT;
    DECLARE v_current_payment_status VARCHAR(255);
    DECLARE cur CURSOR FOR 
		SELECT payment_status FROM bookings
        WHERE guest_id = (SELECT guest_id FROM bookings WHERE id = p_booking_id)
        ORDER BY datetime_of_booking DESC;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = 1;
    SET v_done = 0;
    SET v_cancellation = 0;
    OPEN cur;
	cancellation_loop : LOOP
		FETCH cur INTO v_current_payment_status;
		IF v_current_payment_status != 'Cancelled' OR v_done = 1 THEN LEAVE cancellation_loop;
			ELSE SET v_cancellation = v_cancellation + 1;
		END IF;
    END LOOP;
    CLOSE cur;
    RETURN v_cancellation;
END $$

DELIMITER ;
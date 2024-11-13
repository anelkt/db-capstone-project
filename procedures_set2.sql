use littlelemondb;

-- CheckBooking

 DELIMITER  $$
 create procedure CheckBooking(IN book_date DATE, IN table_no INT)
 
 begin 
	declare msg varchar(100);
	declare check_table int;
    
    set check_table = 0;
    
	select Count(*) INTO check_table 
    from bookings 
	where Booking_Date = book_date  and Table_Number = table_no;
 
	if check_table > 0  then
		set msg = concat('Table ', table_no, ' is already booked');
	else 
		set msg = concat('Table ', table_no, ' is available');
	end if;
    
    select msg as Booking_status;
end $$

 DELIMITER  ;

call CheckBooking('2022-11-12',3)


--AddValidBooking

DELIMITER $$
create procedure AddValidBooking(IN book_date DATE, IN table_no INT)

begin 
	declare check_table int;
    declare msg varchar(100);
    
	start transaction;
    
    set check_table = 0;
	select Count(*) INTO check_table 
    from bookings 
	where Booking_Date = book_date  and Table_Number = table_no;
    
    if check_table > 0 then 
		rollback;
        set msg = concat('Table ',table_no, ' is already booked - booking cancelled');
	else 
		insert into bookings(Booking_Date, Table_Number) 
        value (book_date,table_no);
		commit;
        set msg = concat('Table ',table_no, ' is available - booking has been successfully made');
    
   end if; 
   
    select msg as Booking_status;
    
end $$

DELIMITER ;

call AddValidBooking('2022-12-17',6);

--AddBooking

DELIMITER $$

create procedure AddBooking(IN bookingID INT,IN  bookingDate DATE, IN tableNumber INT, IN customerID INT)
 begin 
	declare check_table INT;
    declare msg varchar(100);
    
	start transaction;
    set check_table = 0;
    select count(*) INTO check_table
    from bookings
    where Booking_Date = bookingDate  and Table_Number = tableNumber;
    
    if check_table > 0 then
        rollback;
		set msg = concat('Table ',tableNumber, ' is already booked - booking cancelled');
	else 
		insert into bookings(Booking_ID, Booking_Date, Table_Number, Customer_ID) 
        value (bookingID, bookingDate, tableNumber, customerID);
        commit;
		set msg = 'New booking added';
    end if;
    
    select msg as Confirmation;

 
 end $$
 
 DELIMITER ;
 
call AddBooking(9,'2022-12-30',3, 4);

--UpdateBooking

DELIMITER $$
create procedure UpdateBooking(IN bookingID INT,IN  bookingDate DATE)
begin
	declare msg varchar(100);
    start transaction;
    if exists(select 1 from bookings where Booking_ID = bookingID) then
		update bookings
			set Booking_Date = bookingDate
		where Booking_ID = bookingID;
		commit;
		set msg = Concat('Booking ',bookingID,' updated');
	else
		rollback;
        set msg = Concat('Booking with ID', BookingID, ' does not exist');
	end if;
     select msg  as Confirmation;
end $$
DELIMITER ;

call UpdateBooking(22,'2022-12-18');

select * from bookings
where booking_id = 9;

--CancelBooking

DELIMITER $$
create procedure CancelBooking(IN BookingID INT)
begin
	declare msg varchar(100);
	start transaction;
    if  exists(select 1 from bookings where booking_id = BookingID) then
		delete from bookings where booking_id = BookingID;
		commit;
		set msg = Concat('Booking ', BookingID, ' cancelled');
	else
		rollback;
        set msg = Concat('Booking with ID', BookingID, ' does not exist');
	end if;
    select msg  as Confirmation;
end$$
DELIMITER ;

call CancelBooking(9);








use littlelemondb;


--procedure GetMaxQuantity

create procedure GetMaxQuantity()
select MAX(count_items) "Max Qantity in Order" 
from (
select Order_ID, SUM(Quantity) as  count_items
from OrderItems
group by Order_ID) calculate_orders ;

call GetMaxQuantity();


-- prepared statement GetOrderDetail

PREPARE GetOrderDetail FROM 
"
with total_quantity as (
select Order_ID, SUM(Quantity) as Quantity 
from OrderItems
group by Order_ID)
SELECT o.Order_ID, oi.Quantity, o.Total_Price
FROM Orders o
JOIN total_quantity oi ON o.Order_ID = oi.Order_ID
JOIN Bookings b ON o.Booking_ID = b.Booking_ID
WHERE b.Customer_ID = ?
";


SET @id = 1;
EXECUTE GetOrderDetail USING @id;


--procedure CancelOrder

DELIMITER $$

CREATE  PROCEDURE CancelOrder (IN input_Order_ID INT)
BEGIN
    DECLARE msg VARCHAR(255);
    DELETE FROM OrderDeliveryStatus WHERE Order_ID = input_Order_ID;
    DELETE FROM OrderItems WHERE Order_ID = input_Order_ID;
    DELETE FROM Orders WHERE Order_ID = input_Order_ID;
    
    SET msg = CONCAT('Order ', input_Order_ID, ' is canceled');
    SELECT msg AS Cancellation_Status;
END$$

DELIMITER ;

call CancelOrder(5);


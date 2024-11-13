use littlelemondb;


-- task 1 create the required virtual table
create view OrdersView as 
    select Order_ID, SUM(Quantity) as Quantity ,SUM(Item_Cost) as Cost
    from OrderItems
    group by Order_ID
    having  SUM(Quantity) > 2 ;


select * from OrdersView; 


--task 2 extract the required records on the customers from the tables in the Little Lemon database

select c.Customer_ID, c.Full_Name, oi.Order_ID, 
        Item_Type as Menue_Name, Item_Name as Course_Name, 
        round(avg(o.Total_Price)) as Order_Cost
from OrderItems oi
left join Orders o on o.Order_ID = oi.Order_ID
left join Bookings b on b.Booking_ID = o.Booking_ID
left join Customers  c on c.Customer_ID = b.Customer_ID
left join Menue m on m.Menue_ID = oi.Menue_ID
group by c.Customer_ID, c.Full_Name, oi.Order_ID  , Item_Type, Item_Name
having  avg(o.Total_Price) >= 150
order by avg(o.Total_Price) asc;


--task 3 identify the required records on menu items
select m.Item_Name
from Menue m
where m.Menue_ID = any (
    select oi.Menue_ID
    from OrderItems oi
    group by oi.Menue_ID
    having COUNT(oi.Order_ID) > 2
);

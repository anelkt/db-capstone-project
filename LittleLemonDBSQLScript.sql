-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema LittleLemonDB
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema LittleLemonDB
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `LittleLemonDB` DEFAULT CHARACTER SET utf8 ;
USE `LittleLemonDB` ;

-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Customers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Customers` (
  `Customer_ID` INT NOT NULL,
  `Full_Name` VARCHAR(150) NOT NULL,
  `Contact_Number` VARCHAR(15) NOT NULL,
  `Email` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`Customer_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Bookings`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Bookings` (
  `Booking_ID` INT NOT NULL,
  `Booking_Date` DATE NOT NULL,
  `Table_Number` INT NOT NULL,
  `Customer_ID` INT NOT NULL,
  PRIMARY KEY (`Booking_ID`),
  INDEX `Customer_ID_idx` (`Customer_ID` ASC) VISIBLE,
  CONSTRAINT `Customer_ID`
    FOREIGN KEY (`Customer_ID`)
    REFERENCES `LittleLemonDB`.`Customers` (`Customer_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Menue`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Menue` (
  `Menue_ID` INT NOT NULL,
  `Item_Type` ENUM('Cuisine', 'Starter', 'Course', 'Drink', 'Dessert') NOT NULL,
  `Item_Name` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`Menue_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`StaffInformation`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`StaffInformation` (
  `Staff_ID` INT NOT NULL,
  `First_Name` VARCHAR(45) NOT NULL,
  `Last_Name` VARCHAR(45) NOT NULL,
  `Role` VARCHAR(45) NOT NULL,
  `Salary` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`Staff_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Orders` (
  `Order_ID` INT NOT NULL,
  `Order_Date` DATETIME NOT NULL,
  `Booking_ID` INT NULL,
  `Staff_ID` INT NULL,
  `Total_Price` DECIMAL(10,2) NOT NULL CHECK (Total_Price >= 0),
  PRIMARY KEY (`Order_ID`),
  INDEX `Booking_ID_idx` (`Booking_ID` ASC) VISIBLE,
  INDEX `Staff_ID_idx` (`Staff_ID` ASC) VISIBLE,
  CONSTRAINT `Booking_ID`
    FOREIGN KEY (`Booking_ID`)
    REFERENCES `LittleLemonDB`.`Bookings` (`Booking_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Staff_ID`
    FOREIGN KEY (`Staff_ID`)
    REFERENCES `LittleLemonDB`.`StaffInformation` (`Staff_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`OrderItems`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`OrderItems` (
  `Order_ItemID` INT NOT NULL,
  `Order_ID` INT NULL,
  `Menue_ID` INT NULL,
  `Quantity` INT NOT NULL CHECK (Quantity >= 0),
  `Item_Cost` DECIMAL(10,2) NOT NULL CHECK (Item_Cost >= 0),
  PRIMARY KEY (`Order_ItemID`),
  INDEX `Menu_ID_idx` (`Menue_ID` ASC) VISIBLE,
  INDEX `Order_ID_idx` (`Order_ID` ASC) VISIBLE,
  CONSTRAINT `Menue_ID`
    FOREIGN KEY (`Menue_ID`)
    REFERENCES `LittleLemonDB`.`Menue` (`Menue_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Order_ID`
    FOREIGN KEY (`Order_ID`)
    REFERENCES `LittleLemonDB`.`Orders` (`Order_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`OrderDeliveryStatus`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`OrderDeliveryStatus` (
  `DeliveryStatus_ID` INT NOT NULL,
  `Order_ID` INT NULL,
  `Delivery_Date` DATE NULL,
  `Status` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`DeliveryStatus_ID`),
  INDEX `Order_ID_idx` (`Order_ID` ASC) VISIBLE,
  CONSTRAINT `FK_Order_DeliveryStatus`
    FOREIGN KEY (`Order_ID`)
    REFERENCES `LittleLemonDB`.`Orders` (`Order_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

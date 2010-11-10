-- phpMyAdmin SQL Dump
-- version 3.3.7deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Nov 10, 2010 at 10:28 AM
-- Server version: 5.1.49
-- PHP Version: 5.3.3-1ubuntu9

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `gmatchbox`
--

-- --------------------------------------------------------

--
-- Table structure for table `linear_coordinate_object`
--

CREATE TABLE IF NOT EXISTS `linear_coordinate_object` (
  `linear_coordinate_object_id` int(11) NOT NULL AUTO_INCREMENT,
  `object_type_id` int(11) NOT NULL,
  `organism_id` int(11) NOT NULL,
  `string` longblob,
  `length` int(11) NOT NULL,
  `external_id` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`linear_coordinate_object_id`),
  KEY `object_type_id` (`object_type_id`),
  KEY `organism_id` (`organism_id`),
  KEY `external_id` (`external_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `object_type`
--

CREATE TABLE IF NOT EXISTS `object_type` (
  `object_type_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `description` varchar(1054) DEFAULT NULL,
  PRIMARY KEY (`object_type_id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `linear_coordinate_object`
--
ALTER TABLE `linear_coordinate_object`
  ADD CONSTRAINT `linear_coordinate_object_ibfk_1` FOREIGN KEY (`object_type_id`) REFERENCES `object_type` (`object_type_id`) ON DELETE CASCADE ON UPDATE CASCADE;

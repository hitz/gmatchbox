-- phpMyAdmin SQL Dump
-- version 3.3.7deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Nov 10, 2010 at 10:52 AM
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
-- Table structure for table `experiment`
--

CREATE TABLE IF NOT EXISTS `experiment` (
  `experiment_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `description` varchar(1054) DEFAULT NULL,
  PRIMARY KEY (`experiment_id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `experiment_metadata`
--

CREATE TABLE IF NOT EXISTS `experiment_metadata` (
  `experiment_metadata_id` int(11) NOT NULL AUTO_INCREMENT,
  `value` varchar(1054) NOT NULL,
  `experiment_id` int(11) NOT NULL,
  `experiment_metadata_type_id` int(11) NOT NULL,
  PRIMARY KEY (`experiment_metadata_id`),
  KEY `experiment_id` (`experiment_id`),
  KEY `experiment_metadata_type_id` (`experiment_metadata_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `experiment_metadata_type`
--

CREATE TABLE IF NOT EXISTS `experiment_metadata_type` (
  `experiment_metadata_type_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `description` varchar(1054) DEFAULT NULL,
  PRIMARY KEY (`experiment_metadata_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `loc`
--

CREATE TABLE IF NOT EXISTS `loc` (
  `loc_id` int(12) NOT NULL AUTO_INCREMENT,
  `start` int(12) NOT NULL,
  `stop` int(12) NOT NULL,
  `orientation` int(2) NOT NULL,
  `loc_set_id` int(11) NOT NULL,
  `linear_coordinate_object_id` int(12) DEFAULT NULL,
  PRIMARY KEY (`loc_id`),
  KEY `start` (`start`),
  KEY `stop` (`stop`),
  KEY `orientation` (`orientation`),
  KEY `linear_coordinate_object_id` (`linear_coordinate_object_id`),
  KEY `loc_set_id` (`loc_set_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `loc_metadata`
--

CREATE TABLE IF NOT EXISTS `loc_metadata` (
  `loc_metadata_id` int(11) NOT NULL AUTO_INCREMENT,
  `value` longblob NOT NULL,
  `loc_id` int(11) NOT NULL,
  `loc_metadata_type_id` int(11) NOT NULL,
  PRIMARY KEY (`loc_metadata_id`),
  KEY `loc_id` (`loc_id`),
  KEY `loc_metadata_type_id` (`loc_metadata_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `loc_metadata_type`
--

CREATE TABLE IF NOT EXISTS `loc_metadata_type` (
  `loc_metadata_type_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `description` varchar(1054) DEFAULT NULL,
  PRIMARY KEY (`loc_metadata_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `loc_set`
--

CREATE TABLE IF NOT EXISTS `loc_set` (
  `loc_set_id` int(11) NOT NULL AUTO_INCREMENT,
  `experiment_id` int(11) NOT NULL,
  `name` varchar(128) NOT NULL,
  `description` varchar(1054) DEFAULT NULL,
  PRIMARY KEY (`loc_set_id`),
  UNIQUE KEY `name` (`name`),
  KEY `experiment_id` (`experiment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `experiment_metadata`
--
ALTER TABLE `experiment_metadata`
  ADD CONSTRAINT `experiment_metadata_ibfk_2` FOREIGN KEY (`experiment_metadata_type_id`) REFERENCES `experiment_metadata_type` (`experiment_metadata_type_id`),
  ADD CONSTRAINT `experiment_metadata_ibfk_1` FOREIGN KEY (`experiment_id`) REFERENCES `experiment` (`experiment_id`);

--
-- Constraints for table `loc`
--
ALTER TABLE `loc`
  ADD CONSTRAINT `loc_ibfk_1` FOREIGN KEY (`loc_set_id`) REFERENCES `loc_set` (`loc_set_id`);

--
-- Constraints for table `loc_metadata`
--
ALTER TABLE `loc_metadata`
  ADD CONSTRAINT `loc_metadata_ibfk_1` FOREIGN KEY (`loc_id`) REFERENCES `loc` (`loc_id`),
  ADD CONSTRAINT `loc_metadata_ibfk_2` FOREIGN KEY (`loc_metadata_type_id`) REFERENCES `loc_metadata_type` (`loc_metadata_type_id`);

--
-- Constraints for table `loc_set`
--
ALTER TABLE `loc_set`
  ADD CONSTRAINT `loc_set_ibfk_1` FOREIGN KEY (`experiment_id`) REFERENCES `experiment` (`experiment_id`) ON DELETE CASCADE;

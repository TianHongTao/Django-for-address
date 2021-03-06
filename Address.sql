CREATE DATABASE  IF NOT EXISTS `Address` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `Address`;
-- MySQL dump 10.13  Distrib 5.7.24, for Linux (x86_64)
--
-- Host: localhost    Database: Address
-- ------------------------------------------------------
-- Server version	5.7.24-0ubuntu0.18.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Group_Relation`
--

DROP TABLE IF EXISTS `Group_Relation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Group_Relation` (
  `User_ID` int(11) NOT NULL,
  `Group_ID` int(11) NOT NULL,
  PRIMARY KEY (`User_ID`,`Group_ID`),
  KEY `Group_Relation_group_ID_fk` (`Group_ID`),
  CONSTRAINT `Group_Relation_ID_WECHATID_ID_fk` FOREIGN KEY (`User_ID`) REFERENCES `ID_WECHATID` (`ID`),
  CONSTRAINT `Group_Relation_group_ID_fk` FOREIGN KEY (`Group_ID`) REFERENCES `group` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Group_Relation`
--

LOCK TABLES `Group_Relation` WRITE;
/*!40000 ALTER TABLE `Group_Relation` DISABLE KEYS */;
INSERT INTO `Group_Relation` VALUES (33,1),(59,1),(33,2),(59,2),(60,2),(60,3),(36,17),(37,17),(33,18),(36,18),(37,18),(39,18),(59,18),(60,18),(34,19),(40,19),(48,19),(60,20),(36,21),(37,21),(59,21),(60,21),(38,22),(39,22),(59,22),(60,22);
/*!40000 ALTER TABLE `Group_Relation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `ID_INFO`
--

DROP TABLE IF EXISTS `ID_INFO`;
/*!50001 DROP VIEW IF EXISTS `ID_INFO`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `ID_INFO` AS SELECT 
 1 AS `ID`,
 1 AS `WECHATID`,
 1 AS `PHONE`,
 1 AS `PASSWORD`,
 1 AS `USERNAME`,
 1 AS `signature`,
 1 AS `email`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `ID_LOCATION`
--

DROP TABLE IF EXISTS `ID_LOCATION`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ID_LOCATION` (
  `ID` int(11) NOT NULL,
  `LOCATION_ID` int(11) NOT NULL,
  PRIMARY KEY (`ID`,`LOCATION_ID`),
  KEY `I_L_LOCATION_ID_fk` (`LOCATION_ID`),
  CONSTRAINT `I_L_ID_WECHATID_ID_fk` FOREIGN KEY (`ID`) REFERENCES `ID_WECHATID` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `I_L_LOCATION_ID_fk` FOREIGN KEY (`LOCATION_ID`) REFERENCES `LOCATION` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ID_LOCATION`
--

LOCK TABLES `ID_LOCATION` WRITE;
/*!40000 ALTER TABLE `ID_LOCATION` DISABLE KEYS */;
INSERT INTO `ID_LOCATION` VALUES (33,69),(38,81),(59,94),(60,95),(61,98),(62,100);
/*!40000 ALTER TABLE `ID_LOCATION` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ID_WECHATID`
--

DROP TABLE IF EXISTS `ID_WECHATID`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ID_WECHATID` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `WECHATID` varchar(255) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ID_WECHATID_WECHATID_uindex` (`WECHATID`)
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ID_WECHATID`
--

LOCK TABLES `ID_WECHATID` WRITE;
/*!40000 ALTER TABLE `ID_WECHATID` DISABLE KEYS */;
INSERT INTO `ID_WECHATID` VALUES (58,'Admin'),(60,'shujuku'),(61,'shujuku2222'),(62,'shujuku222222'),(33,'THT123456'),(38,'THT5'),(39,'THT6'),(40,'THT7'),(48,'zhanglang'),(59,'zhanlang2');
/*!40000 ALTER TABLE `ID_WECHATID` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER DELETE_WITH AFTER DELETE ON Address.ID_WECHATID for each row
  BEGIN
    DELETE FROM USERINFO WHERE USERINFO.ID = OLD.ID;
    DELETE FROM RELATION WHERE RELATION.MYID = OLD.ID OR RELATION.FRIENDID = OLD.ID;
    DELETE FROM ID_LOCATION WHERE ID_LOCATION.ID = OLD.ID;
  end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `LOCATION`
--

DROP TABLE IF EXISTS `LOCATION`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `LOCATION` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `PARENT_ID` int(11) NOT NULL,
  `LOCATION` char(255) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `LOCATION_pk` (`LOCATION`,`PARENT_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=gbk;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `LOCATION`
--

LOCK TABLES `LOCATION` WRITE;
/*!40000 ALTER TABLE `LOCATION` DISABLE KEYS */;
INSERT INTO `LOCATION` VALUES (98,97,'sjijsi'),(91,1,'安徽'),(69,1,'北京'),(71,70,'北下关'),(95,1,'朝阳区'),(81,80,'成都'),(83,82,'赤峰'),(92,91,'凤阳'),(72,1,'贵州'),(70,69,'海淀'),(79,78,'晋城'),(94,93,'昆明'),(85,84,'拉萨'),(82,1,'内蒙古'),(75,74,'浦东'),(77,76,'青岛'),(76,1,'山东'),(78,1,'山西'),(74,1,'上海'),(100,99,'实际上内'),(99,1,'实时'),(96,95,'世贸天街'),(97,1,'是'),(80,1,'四川'),(84,1,'西藏'),(73,72,'兴义'),(93,1,'云南');
/*!40000 ALTER TABLE `LOCATION` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `OfficialAccount`
--

DROP TABLE IF EXISTS `OfficialAccount`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `OfficialAccount` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `NAME` varchar(255) CHARACTER SET gbk DEFAULT NULL,
  `INFO` varchar(255) DEFAULT NULL,
  `MAINBODY` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `OfficialAccount_NAME_uindex` (`NAME`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `OfficialAccount`
--

LOCK TABLES `OfficialAccount` WRITE;
/*!40000 ALTER TABLE `OfficialAccount` DISABLE KEYS */;
INSERT INTO `OfficialAccount` VALUES (1,'测试公众号1','我是测试公众号1','个人'),(2,'测试公众号2','测试公众号2','个人'),(3,'测试公众号3','测试公众号3','个人'),(4,'测试公众号4','测试公众号4','个人'),(5,'测试公众号5','测试公众号5','企业'),(6,'测试公众号6','我是测试公众号6','营销'),(7,'数据库公众号','这是数据库公众号','企业'),(8,'数据库测试51515151','数据库测试51515151','个人');
/*!40000 ALTER TABLE `OfficialAccount` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `OfficialAccount_Relation`
--

DROP TABLE IF EXISTS `OfficialAccount_Relation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `OfficialAccount_Relation` (
  `User_ID` int(11) NOT NULL,
  `Off_ID` int(11) NOT NULL,
  PRIMARY KEY (`User_ID`,`Off_ID`),
  KEY `OfficialAccount_Relation_OfficialAccount_ID_fk` (`Off_ID`),
  CONSTRAINT `OfficialAccount_Relation_ID_WECHATID_ID_fk` FOREIGN KEY (`User_ID`) REFERENCES `ID_WECHATID` (`ID`),
  CONSTRAINT `OfficialAccount_Relation_OfficialAccount_ID_fk` FOREIGN KEY (`Off_ID`) REFERENCES `OfficialAccount` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `OfficialAccount_Relation`
--

LOCK TABLES `OfficialAccount_Relation` WRITE;
/*!40000 ALTER TABLE `OfficialAccount_Relation` DISABLE KEYS */;
INSERT INTO `OfficialAccount_Relation` VALUES (33,1),(59,1),(60,1),(48,2),(59,2),(33,3),(59,3),(60,4),(33,5),(59,5),(60,5),(40,6),(59,6),(60,7),(60,8);
/*!40000 ALTER TABLE `OfficialAccount_Relation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `OfficialAccount_Word`
--

DROP TABLE IF EXISTS `OfficialAccount_Word`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `OfficialAccount_Word` (
  `Off_ID` int(11) NOT NULL,
  `Word_ID` int(11) NOT NULL,
  PRIMARY KEY (`Off_ID`,`Word_ID`),
  KEY `OfficialAccount_Word_Word_ID_fk` (`Word_ID`),
  CONSTRAINT `OfficialAccount_Word_OfficialAccount_ID_fk` FOREIGN KEY (`Off_ID`) REFERENCES `OfficialAccount` (`ID`),
  CONSTRAINT `OfficialAccount_Word_Word_ID_fk` FOREIGN KEY (`Word_ID`) REFERENCES `Word` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `OfficialAccount_Word`
--

LOCK TABLES `OfficialAccount_Word` WRITE;
/*!40000 ALTER TABLE `OfficialAccount_Word` DISABLE KEYS */;
INSERT INTO `OfficialAccount_Word` VALUES (1,1),(1,2),(1,3),(1,5),(3,9),(4,11),(6,12),(6,25),(5,26),(4,27),(7,28),(8,29);
/*!40000 ALTER TABLE `OfficialAccount_Word` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `RELATION`
--

DROP TABLE IF EXISTS `RELATION`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `RELATION` (
  `MYID` int(11) NOT NULL,
  `FRIENDID` int(11) NOT NULL,
  `REMARK` varchar(255) CHARACTER SET gbk DEFAULT NULL,
  PRIMARY KEY (`MYID`,`FRIENDID`),
  KEY `RELATION_ID_WECHATID_ID_fk_2` (`FRIENDID`),
  CONSTRAINT `RELATION_ID_WECHATID_ID_fk` FOREIGN KEY (`MYID`) REFERENCES `ID_WECHATID` (`ID`),
  CONSTRAINT `RELATION_ID_WECHATID_ID_fk_2` FOREIGN KEY (`FRIENDID`) REFERENCES `ID_WECHATID` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RELATION`
--

LOCK TABLES `RELATION` WRITE;
/*!40000 ALTER TABLE `RELATION` DISABLE KEYS */;
INSERT INTO `RELATION` VALUES (33,39,'THT6'),(59,33,'田宏韬2'),(60,33,'田宏韬2'),(60,38,'THT5');
/*!40000 ALTER TABLE `RELATION` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `USERINFO`
--

DROP TABLE IF EXISTS `USERINFO`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `USERINFO` (
  `ID` int(11) NOT NULL,
  `PHONE` varchar(255) CHARACTER SET latin1 DEFAULT NULL,
  `PASSWORD` varchar(255) CHARACTER SET latin1 NOT NULL,
  `USERNAME` varchar(255) CHARACTER SET gbk NOT NULL,
  `signature` varchar(255) CHARACTER SET gbk DEFAULT NULL,
  `email` varchar(255) CHARACTER SET latin1 DEFAULT NULL,
  PRIMARY KEY (`ID`),
  CONSTRAINT `USERINFO_ID_WECHATID_ID_fk` FOREIGN KEY (`ID`) REFERENCES `ID_WECHATID` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `USERINFO`
--

LOCK TABLES `USERINFO` WRITE;
/*!40000 ALTER TABLE `USERINFO` DISABLE KEYS */;
INSERT INTO `USERINFO` VALUES (33,'18801116788','ThT123456','田宏韬2','','16281173@bjtu.edu.cn'),(38,'150','ThT123456','THT5','我是THT5','16281177@bjtu.edu.cn'),(39,'160','ThT123456','THT6','我是THT6','16281178@bjtu.edu.cn'),(48,'110','ThT123456','青蛙','我是青蛙！','16281180@bjtu.edu.cn'),(58,'110','Admin123','管理员','管理员帐号','Admin@admin.cn'),(59,'18801116795','ThT123456','战狼2','战狼2！！！','16281195@bjtu.edu.cn'),(60,'18801116789','QaZ872','数据库拉拉','','16281190@bjtu.edu.cn');
/*!40000 ALTER TABLE `USERINFO` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 trigger CHECK_MAIL
  before INSERT
  on USERINFO
  for each row
  BEGIN
    IF(NEW.email in (SELECT email FROM USERINFO))
    then
      SIGNAL SQLSTATE 'TX000' SET MESSAGE_TEXT = '邮箱重复！';
    end if;
  end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Temporary table structure for view `USER_LOCTAION`
--

DROP TABLE IF EXISTS `USER_LOCTAION`;
/*!50001 DROP VIEW IF EXISTS `USER_LOCTAION`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `USER_LOCTAION` AS SELECT 
 1 AS `USERNAME`,
 1 AS `LOCATION`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `Word`
--

DROP TABLE IF EXISTS `Word`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Word` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `INFO` varchar(255) DEFAULT NULL,
  `NAME` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Word`
--

LOCK TABLES `Word` WRITE;
/*!40000 ALTER TABLE `Word` DISABLE KEYS */;
INSERT INTO `Word` VALUES (1,'测试文章1','测试1'),(2,'测试文章2','测试2'),(3,'测试文章3','测试3'),(5,'我是测试文章4','测试文章4'),(9,'我是测试文章5','测试文章5'),(11,'测试公众号6','测试公众号6'),(12,'我是测试文章7','测试文章7'),(25,'我是测试文章8','测试文章8'),(26,'我是测试文章9','测试文章9'),(27,'这是测试公众号文章4','测试公众号文章4'),(28,'数据库公众号１','数据库公众号１'),(29,'今天是周二','周二');
/*!40000 ALTER TABLE `Word` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_group_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',2,'add_permission'),(6,'Can change permission',2,'change_permission'),(7,'Can delete permission',2,'delete_permission'),(8,'Can view permission',2,'view_permission'),(9,'Can add group',3,'add_group'),(10,'Can change group',3,'change_group'),(11,'Can delete group',3,'delete_group'),(12,'Can view group',3,'view_group'),(13,'Can add user',4,'add_user'),(14,'Can change user',4,'change_user'),(15,'Can delete user',4,'delete_user'),(16,'Can view user',4,'view_user'),(17,'Can add content type',5,'add_contenttype'),(18,'Can change content type',5,'change_contenttype'),(19,'Can delete content type',5,'delete_contenttype'),(20,'Can view content type',5,'view_contenttype'),(21,'Can add session',6,'add_session'),(22,'Can change session',6,'change_session'),(23,'Can delete session',6,'delete_session'),(24,'Can view session',6,'view_session');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user`
--

DROP TABLE IF EXISTS `auth_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(30) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user`
--

LOCK TABLES `auth_user` WRITE;
/*!40000 ALTER TABLE `auth_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_groups`
--

DROP TABLE IF EXISTS `auth_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_user_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`),
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_groups`
--

LOCK TABLES `auth_user_groups` WRITE;
/*!40000 ALTER TABLE `auth_user_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_user_permissions`
--

DROP TABLE IF EXISTS `auth_user_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_user_user_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_user_permissions`
--

LOCK TABLES `auth_user_user_permissions` WRITE;
/*!40000 ALTER TABLE `auth_user_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'admin','logentry'),(3,'auth','group'),(2,'auth','permission'),(4,'auth','user'),(5,'contenttypes','contenttype'),(6,'sessions','session');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_migrations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2018-12-05 13:36:27.444062'),(2,'auth','0001_initial','2018-12-05 13:36:28.142013'),(3,'admin','0001_initial','2018-12-05 13:36:28.302981'),(4,'admin','0002_logentry_remove_auto_add','2018-12-05 13:36:28.331569'),(5,'admin','0003_logentry_add_action_flag_choices','2018-12-05 13:36:28.345852'),(6,'contenttypes','0002_remove_content_type_name','2018-12-05 13:36:28.459899'),(7,'auth','0002_alter_permission_name_max_length','2018-12-05 13:36:28.478786'),(8,'auth','0003_alter_user_email_max_length','2018-12-05 13:36:28.497118'),(9,'auth','0004_alter_user_username_opts','2018-12-05 13:36:28.507624'),(10,'auth','0005_alter_user_last_login_null','2018-12-05 13:36:28.537576'),(11,'auth','0006_require_contenttypes_0002','2018-12-05 13:36:28.541385'),(12,'auth','0007_alter_validators_add_error_messages','2018-12-05 13:36:28.550413'),(13,'auth','0008_alter_user_username_max_length','2018-12-05 13:36:28.565698'),(14,'auth','0009_alter_user_last_name_max_length','2018-12-05 13:36:28.579712'),(15,'sessions','0001_initial','2018-12-05 13:36:28.637227');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('noffgrmuahhpmcdlbcffv9f7ojsaoeu4','NGRkNzc2ZTA2NjMyNmYyMmE2OWE5NTVmYzhlODU1MmY5YjIxNWExZDp7ImlzX2xvZ2luIjp0cnVlLCJXZWNoYXRJRCI6InNodWp1a3UiLCJQYXNzd29yZCI6IlFhWjg3MiIsImkiOjAsImZyaWVuZElEIjoiVEhUNCAiLCJvZmZJRCI6IjgifQ==','2019-01-08 07:21:23.226103'),('swavw4shtwhaekp32wc6cgehaeeh1wk0','ZDI1ZmIyZjYwYzJiMTI1OTRmMTg4NWZkNjI0YjVhMGNmODA3YjUxZDp7ImlzX2xvZ2luIjp0cnVlLCJXZWNoYXRJRCI6IlRIVDEyMzQ1NiIsIlBhc3N3b3JkIjoiVGhUMTIzNDU2IiwiZnJpZW5kSUQiOiJUSFQxMjM0NTYiLCJpIjowLCJvZmZJRCI6IiJ9','2019-01-05 04:42:47.766214'),('z3kqxfibpmlb7vy2th13p625g4zuiu7x','Y2M3YmViYTg1YzU4YzljYzZhZWYzYWUyODEzYTk5YmE3Nzg2YjJkYzp7ImlzX2xvZ2luIjp0cnVlLCJXZWNoYXRJRCI6IlNIVUpVS1VDRVNISTEiLCJQYXNzd29yZCI6IjEyMzQ1NiIsImZyaWVuZElEIjoid3V5YW5neWFuZyJ9','2018-12-31 10:27:35.560071');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `group`
--

DROP TABLE IF EXISTS `group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `group` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `NAME` varchar(255) DEFAULT NULL,
  `INFO` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `group`
--

LOCK TABLES `group` WRITE;
/*!40000 ALTER TABLE `group` DISABLE KEYS */;
INSERT INTO `group` VALUES (1,'测试1','测试群聊1'),(2,'测试2','测试群聊2'),(3,'测试3','测试群聊3'),(16,'测试4','测试群聊4'),(17,'测试５','测试群聊５'),(18,'测试6','测试群聊6'),(19,'测试7','测试群聊7'),(20,'数据库群聊','我是数据库测试'),(21,'数据库群聊1','我是数据库群聊1'),(22,'数据库啦啦啦','设置为图');
/*!40000 ALTER TABLE `group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'Address'
--

--
-- Dumping routines for database 'Address'
--
/*!50003 DROP PROCEDURE IF EXISTS `delete_location` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_location`(IN location_id INT(11))
begin
    declare Location_id int(11) default null;
    set Location_id = (select id from LOCATION where PARENT_ID = location_id);
    while Location_id IS NOT NULL do
      delete from LOCATION where ID = location_id;
      set Location_id = (select id from LOCATION where PARENT_ID = location_id);
    end while;
  end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_full_location` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_full_location`(IN LOCATION_ID int)
BEGIN
    DECLARE fullLocation varchar(255);
    DECLARE parentId INTEGER;
    set fullLocation = (select LOCATION from LOCATION where ID = LOCATION_ID);
    set parentId = (SELECT PARENT_ID FROM LOCATION WHERE ID = LOCATION_ID);
    WHILE parentId != 1 do
      set LOCATION_ID = parentId;
      set parentId = (SELECT PARENT_ID FROM LOCATION WHERE ID = LOCATION_ID);
      set fullLocation = CONCAT(fullLocation," ",(select LOCATION from LOCATION where ID = LOCATION_ID));
    end while;
    select fullLocation;
  end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `INSERTINTOOFF` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `INSERTINTOOFF`(IN ID int, IN Off int)
BEGIN
  IF ID NOT IN (SELECT User_ID FROM OfficialAccount_Relation WHERE Off_ID = Off)
    THEN
    INSERT INTO OfficialAccount_Relation(Off_ID,User_ID) VALUES (Off,ID);
    commit;
  end if;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `ID_INFO`
--

/*!50001 DROP VIEW IF EXISTS `ID_INFO`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `ID_INFO` AS select `USERINFO`.`ID` AS `ID`,`ID_WECHATID`.`WECHATID` AS `WECHATID`,`USERINFO`.`PHONE` AS `PHONE`,`USERINFO`.`PASSWORD` AS `PASSWORD`,`USERINFO`.`USERNAME` AS `USERNAME`,`USERINFO`.`signature` AS `signature`,`USERINFO`.`email` AS `email` from (`ID_WECHATID` join `USERINFO`) where (`USERINFO`.`ID` = `ID_WECHATID`.`ID`) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `USER_LOCTAION`
--

/*!50001 DROP VIEW IF EXISTS `USER_LOCTAION`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `USER_LOCTAION` AS select `ID_INFO`.`USERNAME` AS `USERNAME`,`LOCATION`.`LOCATION` AS `LOCATION` from ((`ID_LOCATION` join `LOCATION`) join `ID_INFO`) where ((`ID_LOCATION`.`LOCATION_ID` = `LOCATION`.`ID`) and (`ID_LOCATION`.`ID` = `ID_INFO`.`ID`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-12-26 22:58:03

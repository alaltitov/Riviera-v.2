-- MySQL dump 10.13  Distrib 8.0.31, for macos12 (x86_64)
--
-- Host: localhost    Database: owners_mysql
-- ------------------------------------------------------
-- Server version	8.0.33

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `feedbacks`
--

DROP TABLE IF EXISTS `feedbacks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `feedbacks` (
  `id` int NOT NULL AUTO_INCREMENT,
  `date` datetime DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `tel` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `feedbacks`
--

LOCK TABLES `feedbacks` WRITE;
/*!40000 ALTER TABLE `feedbacks` DISABLE KEYS */;
/*!40000 ALTER TABLE `feedbacks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `date` datetime DEFAULT NULL,
  `payment_id` varchar(100) DEFAULT NULL,
  `payment_summ` varchar(100) DEFAULT NULL,
  `status` tinyint DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `payments_idx` (`user_id`),
  CONSTRAINT `payments` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
INSERT INTO `payments` VALUES (1,'2023-01-27 09:51:50','2c31334a-000f-5000-9000-12558db12f5d','200000',1,4),(2,'2023-03-27 09:57:02','2c2f854e-000f-5000-9000-17c18ee6743b','268400',1,4),(3,'2023-04-27 11:58:57','2c2f85c1-000f-5000-9000-156578374a1b','600085',1,4),(4,'2023-04-27 12:02:06','2c2f867e-000f-5000-a000-1a77e328f156','290000',1,4);
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `profiles`
--

DROP TABLE IF EXISTS `profiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `profiles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `tel` varchar(45) NOT NULL,
  `email` varchar(45) NOT NULL,
  `address` varchar(45) NOT NULL,
  `balance` int DEFAULT NULL,
  `account` varchar(45) DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `profiles_idx` (`user_id`),
  CONSTRAINT `profiles` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `profiles`
--

LOCK TABLES `profiles` WRITE;
/*!40000 ALTER TABLE `profiles` DISABLE KEYS */;
INSERT INTO `profiles` VALUES (2,'Иван Иванов','+7-901-000-0000','ivanov@riviera.ru','36',-225572,'4',4);
/*!40000 ALTER TABLE `profiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `service`
--

DROP TABLE IF EXISTS `service`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service` (
  `id` int NOT NULL AUTO_INCREMENT,
  `service` varchar(50) DEFAULT NULL,
  `tariff` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service`
--

LOCK TABLES `service` WRITE;
/*!40000 ALTER TABLE `service` DISABLE KEYS */;
INSERT INTO `service` VALUES (1,'electro',420),(2,'gas',687),(3,'water',520),(4,'garbage',100000);
/*!40000 ALTER TABLE `service` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `texts`
--

DROP TABLE IF EXISTS `texts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `texts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `page` varchar(50) DEFAULT NULL,
  `label` varchar(50) DEFAULT NULL,
  `content` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `texts`
--

LOCK TABLES `texts` WRITE;
/*!40000 ALTER TABLE `texts` DISABLE KEYS */;
INSERT INTO `texts` VALUES (1,'main','header__text','Место, где соприкасаются безмятежность и умиротворение'),(2,'main','about__title','\"Тишину можно вдыхать, как запах\"'),(3,'main','about__text','Поселок коттеджного типа \"Ривьера\" создан в едином архитектурном стиле \"минимализм\". На территории поселка, относящейся к землям ИЖС, расположились 220 домовладений от 110 до 560 кв. м, построенных из монолитного бетона с утеплением в 200 мм и оборудованных проточно-вытяжной вентиляцией, что позволяет комфортно себя чувствовать жильцам в любое время года. Площадь участков составляет от 10 до 20 соток. Ведется третья заключительная очередь строительства.'),(4,'main','details__text','Поселок находится в престижном Слободском районе, в 20 км от МКАД по Рижскому шоссе у берега реки Ивушка, в окружении соснового бора. Добраться до поселка можно как на личном транспорте, так и на маршрутных такси.'),(5,'main','details__text','В поселке имеются игровые площадки для детей, две спортивные площадки, сеть дорог для автомобилей и пешеходов, зоны отдыха, велодорожки, зоны выгула собак и магазин. Территория поселка полностью благоустроена и озеленена. Поселок круглосуточно находится под охраной.'),(6,'main','details__text','Поселок обеспечен всеми коммуникациями: электроснабжение 15 кВт, магистральный газ 7 м³/ч, водоснабжение, ливневая и бытовая канализации, интернет до 1 Гбит/с. Возле каждого домовладения установлен контейнер для бытовых отходов, вывоз мусора осуществляется на регулярной основе.'),(7,'main','houses_text','Каким он будет, небольшим, уютным, комфортным или же просторным - решать только Вам. К продаже предлагаются одноэтажные и двухэтажные дома от 110 до 560 кв.м.'),(8,'main','offer_text','Дом 123 кв.м. по специальной цене. Кухня-гостиная, 3 спальни, 2 санузла, навес на 2 автомобиля. Участок 12 соток. Дом полностью меблирован. Звоните!'),(9,'main','offer_price','45.000.000 р.'),(10,'main','offer_price','36.000.000 р.'),(11,'main','feedback_text','Оставьте заявку и наш менеджер обязательно с Вами свяжется, cогласует время осмотра и другие детали.');
/*!40000 ALTER TABLE `texts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `login` varchar(45) NOT NULL,
  `password` varchar(500) NOT NULL,
  `date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `login_UNIQUE` (`login`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (4,'first','pbkdf2:sha256:600000$nZTJ8Ju64qV534Xf$c4e880730b5d07e07e81586970f7efb1883e71dc18f20cb83c5d2dac00926bed','2023-06-30 15:25:46');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `utilities`
--

DROP TABLE IF EXISTS `utilities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `utilities` (
  `id` int NOT NULL AUTO_INCREMENT,
  `date` datetime DEFAULT NULL,
  `value_electro` int DEFAULT NULL,
  `value_gas` int DEFAULT NULL,
  `value_water` int DEFAULT NULL,
  `summ` int DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `utilities_idx` (`user_id`),
  CONSTRAINT `utilities` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `utilities`
--

LOCK TABLES `utilities` WRITE;
/*!40000 ALTER TABLE `utilities` DISABLE KEYS */;
INSERT INTO `utilities` VALUES (1,'2022-11-27 11:09:45',0,0,0,0,4),(2,'2022-12-27 11:09:45',200,100,10,257900,4),(3,'2023-01-27 11:20:56',250,200,50,210500,4),(4,'2023-02-27 11:24:50',400,300,130,273300,4),(5,'2023-03-27 11:25:41',450,350,200,191750,4),(6,'2023-04-27 11:27:09',539,395,217,177135,4),(7,'2023-05-27 11:28:03',673,467,284,240584,4),(8,'2023-06-27 11:28:57',754,511,416,232888,4);
/*!40000 ALTER TABLE `utilities` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-07-28 17:53:34

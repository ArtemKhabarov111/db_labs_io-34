-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema default_schema
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema Lab4
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `Lab4` ;

-- -----------------------------------------------------
-- Schema Lab4
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Lab4` DEFAULT CHARACTER SET utf8 ;
USE `Lab4` ;

-- -----------------------------------------------------
-- Table `Lab4`.`Content`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Lab4`.`Content` ;

CREATE TABLE IF NOT EXISTS `Lab4`.`Content` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `uploader_id` INT UNSIGNED NOT NULL,
  `title` VARCHAR(200) NOT NULL,
  `category` VARCHAR(50) NULL DEFAULT NULL,
  `url` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Lab4`.`Queue`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Lab4`.`Queue` ;

CREATE TABLE IF NOT EXISTS `Lab4`.`Queue` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `reviewer_id` INT UNSIGNED NULL DEFAULT NULL,
  `status` VARCHAR(50) NULL DEFAULT NULL,
  `Content_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`, `Content_id`),
  INDEX `fk_Queue_Content_idx` (`Content_id` ASC) VISIBLE,
  CONSTRAINT `fk_Queue_Content`
    FOREIGN KEY (`Content_id`)
    REFERENCES `Lab4`.`Content` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Lab4`.`Label`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Lab4`.`Label` ;

CREATE TABLE IF NOT EXISTS `Lab4`.`Label` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `text` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Lab4`.`ContentLabel`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Lab4`.`ContentLabel` ;

CREATE TABLE IF NOT EXISTS `Lab4`.`ContentLabel` (
  `Content_id` INT UNSIGNED NOT NULL,
  `Label_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Content_id`, `Label_id`),
  INDEX `fk_ContentLabel_Content1_idx` (`Content_id` ASC) VISIBLE,
  INDEX `fk_ContentLabel_Label1_idx` (`Label_id` ASC) VISIBLE,
  CONSTRAINT `fk_ContentLabel_Content1`
    FOREIGN KEY (`Content_id`)
    REFERENCES `Lab4`.`Content` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ContentLabel_Label1`
    FOREIGN KEY (`Label_id`)
    REFERENCES `Lab4`.`Label` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Lab4`.`Subscription`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Lab4`.`Subscription` ;

CREATE TABLE IF NOT EXISTS `Lab4`.`Subscription` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `account_id` INT UNSIGNED NOT NULL,
  `expires` DATE NULL DEFAULT NULL,
  `Content_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`, `Content_id`),
  INDEX `fk_Subscription_Content1_idx` (`Content_id` ASC) VISIBLE,
  CONSTRAINT `fk_Subscription_Content1`
    FOREIGN KEY (`Content_id`)
    REFERENCES `Lab4`.`Content` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Lab4`.`Account`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Lab4`.`Account` ;

CREATE TABLE IF NOT EXISTS `Lab4`.`Account` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `settings` TEXT NULL DEFAULT NULL,
  `name` VARCHAR(50) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Lab4`.`AccountSubscription`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Lab4`.`AccountSubscription` ;

CREATE TABLE IF NOT EXISTS `Lab4`.`AccountSubscription` (
  `Subscription_id` INT UNSIGNED NOT NULL,
  `Subscription_Content_id` INT UNSIGNED NOT NULL,
  `Account_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Subscription_id`, `Subscription_Content_id`, `Account_id`),
  INDEX `fk_AccountSubscription_Subscription1_idx` (`Subscription_id` ASC, `Subscription_Content_id` ASC) VISIBLE,
  INDEX `fk_AccountSubscription_Account1_idx` (`Account_id` ASC) VISIBLE,
  CONSTRAINT `fk_AccountSubscription_Subscription1`
    FOREIGN KEY (`Subscription_id` , `Subscription_Content_id`)
    REFERENCES `Lab4`.`Subscription` (`id` , `Content_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_AccountSubscription_Account1`
    FOREIGN KEY (`Account_id`)
    REFERENCES `Lab4`.`Account` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Lab4`.`Group`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Lab4`.`Group` ;

CREATE TABLE IF NOT EXISTS `Lab4`.`Group` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `info` TEXT NULL DEFAULT NULL,
  `label` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Lab4`.`AccountGroup`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Lab4`.`AccountGroup` ;

CREATE TABLE IF NOT EXISTS `Lab4`.`AccountGroup` (
  `Group_id` INT UNSIGNED NOT NULL,
  `Account_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Group_id`, `Account_id`),
  INDEX `fk_AccountGroup_Group1_idx` (`Group_id` ASC) VISIBLE,
  INDEX `fk_AccountGroup_Account1_idx` (`Account_id` ASC) VISIBLE,
  CONSTRAINT `fk_AccountGroup_Group1`
    FOREIGN KEY (`Group_id`)
    REFERENCES `Lab4`.`Group` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_AccountGroup_Account1`
    FOREIGN KEY (`Account_id`)
    REFERENCES `Lab4`.`Account` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Lab4`.`TaskScript`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Lab4`.`TaskScript` ;

CREATE TABLE IF NOT EXISTS `Lab4`.`TaskScript` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `defenition` TEXT NULL DEFAULT NULL,
  `created` DATETIME NOT NULL,
  `title` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Lab4`.`Session`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Lab4`.`Session` ;

CREATE TABLE IF NOT EXISTS `Lab4`.`Session` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `start_time` DATETIME NOT NULL,
  `end_time` DATETIME NULL DEFAULT NULL,
  `Account_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`, `Account_id`),
  INDEX `fk_Session_Account1_idx` (`Account_id` ASC) VISIBLE,
  CONSTRAINT `fk_Session_Account1`
    FOREIGN KEY (`Account_id`)
    REFERENCES `Lab4`.`Account` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Lab4`.`SessionScriptLink`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Lab4`.`SessionScriptLink` ;

CREATE TABLE IF NOT EXISTS `Lab4`.`SessionScriptLink` (
  `script_id` INT UNSIGNED NOT NULL,
  `TaskScript_id` INT UNSIGNED NOT NULL,
  `Session_id` INT UNSIGNED NOT NULL,
  `Session_Account_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`script_id`, `TaskScript_id`, `Session_id`, `Session_Account_id`),
  INDEX `fk_SesstionScriptLink_TaskScript1_idx` (`TaskScript_id` ASC) VISIBLE,
  INDEX `fk_SesstionScriptLink_Session1_idx` (`Session_id` ASC, `Session_Account_id` ASC) VISIBLE,
  CONSTRAINT `fk_SesstionScriptLink_TaskScript1`
    FOREIGN KEY (`TaskScript_id`)
    REFERENCES `Lab4`.`TaskScript` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_SesstionScriptLink_Session1`
    FOREIGN KEY (`Session_id` , `Session_Account_id`)
    REFERENCES `Lab4`.`Session` (`id` , `Account_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Lab4`.`Result`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Lab4`.`Result` ;

CREATE TABLE IF NOT EXISTS `Lab4`.`Result` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `session` INT UNSIGNED NOT NULL,
  `notes` TEXT NULL DEFAULT NULL,
  `score` FLOAT NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Lab4`.`SessionResultLink`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Lab4`.`SessionResultLink` ;

CREATE TABLE IF NOT EXISTS `Lab4`.`SessionResultLink` (
  `Session_id` INT UNSIGNED NOT NULL,
  `Session_Account_id` INT UNSIGNED NOT NULL,
  `Result_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Session_id`, `Session_Account_id`, `Result_id`),
  INDEX `fk_SessionResultLink_Session1_idx` (`Session_id` ASC, `Session_Account_id` ASC) VISIBLE,
  INDEX `fk_SessionResultLink_Result1_idx` (`Result_id` ASC) VISIBLE,
  CONSTRAINT `fk_SessionResultLink_Session1`
    FOREIGN KEY (`Session_id` , `Session_Account_id`)
    REFERENCES `Lab4`.`Session` (`id` , `Account_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_SessionResultLink_Result1`
    FOREIGN KEY (`Result_id`)
    REFERENCES `Lab4`.`Result` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


-- -----------------------------
-- Початкові дані для таблиць
-- -----------------------------

-- 1. Account
INSERT INTO `Account` (`id`, `settings`, `name`,     `email`) VALUES
  (1, '{"theme":"light"}',  'Alice',   'alice@example.com'),
  (2, '{"theme":"dark"}',   'Bob',     'bob@example.com'),
  (3, '{"theme":"blue"}',   'Carol',   'carol@example.com'),
  (4, '{"theme":"solar"}',  'Dave',    'dave@example.com');

-- 2. Content
INSERT INTO `Content` (`id`, `uploader_id`, `title`,               `category`,  `url`) VALUES
  (1, 1, 'Intro to SQL',           'Database',  'https://…/sql1'),
  (2, 2, 'Advanced Python',        'Programming','https://…/py2'),
  (3, 1, 'Web Dev Basics',         'Web',       'https://…/web3'),
  (4, 3, 'Data Structures in C++', 'CS',        'https://…/cpp4');

-- 3. Label
INSERT INTO `Label` (`id`, `text`) VALUES
  (1, 'beginner'),
  (2, 'intermediate'),
  (3, 'advanced'),
  (4, 'reference');

-- 4. ContentLabel
INSERT INTO `ContentLabel` (`Content_id`, `Label_id`) VALUES
  (1, 1),
  (1, 4),
  (2, 2),
  (3, 1);

-- 5. Subscription
INSERT INTO `Subscription` (`id`, `account_id`, `expires`,    `Content_id`) VALUES
  (1, 1, '2025-12-31', 1),
  (2, 2, '2025-06-30', 3),
  (3, 1, '2025-09-15', 2),
  (4, 3, '2026-01-01', 4);

-- 6. AccountSubscription
INSERT INTO `AccountSubscription` (`Subscription_id`, `Subscription_Content_id`, `Account_id`) VALUES
  (1, 1, 1),
  (2, 3, 2),
  (3, 2, 1),
  (4, 4, 3);

-- 7. Queue
INSERT INTO `Queue` (`id`, `reviewer_id`, `status`,      `Content_id`) VALUES
  (1, 2, 'pending',    1),
  (2, 3, 'approved',   2),
  (3, NULL, 'in-review',3),
  (4, 4, 'rejected',   4);

-- 8. `Group`
INSERT INTO `Group` (`id`, `info`,                   `label`) VALUES
  (1, 'Engineering team',      'engineers'),
  (2, 'HR department',         'hr'),
  (3, 'Marketing crew',        'marketing'),
  (4, 'Support squad',         'support');

-- 9. AccountGroup
INSERT INTO `AccountGroup` (`Group_id`, `Account_id`) VALUES
  (1, 1),
  (1, 2),
  (4, 3),
  (2, 4);

-- 10. TaskScript
INSERT INTO `TaskScript` (`id`, `defenition`,          `created`,             `title`) VALUES
  (1, 'Solve SQL query',      '2025-05-01 10:00:00', 'SQL Basics'),
  (2, 'Implement class',      '2025-05-02 12:30:00', 'OOP Example'),
  (3, 'Build HTML form',      '2025-05-03 09:15:00', 'Web Form'),
  (4, 'Debug Python script',  '2025-05-04 14:45:00', 'Py Debugging');

-- 11. Session
INSERT INTO `Session` (`id`, `start_time`,           `end_time`,            `Account_id`) VALUES
  (1, '2025-05-10 08:00:00', '2025-05-10 09:00:00',  1),
  (2, '2025-05-10 10:00:00', '2025-05-10 11:30:00',  2),
  (3, '2025-05-11 14:00:00', NULL,                   1),
  (4, '2025-05-12 16:15:00', '2025-05-12 17:00:00',  3);

-- 12. SessionScriptLink
INSERT INTO `SessionScriptLink` (`script_id`, `TaskScript_id`, `Session_id`, `Session_Account_id`) VALUES
  (1, 1, 1, 1),
  (2, 2, 2, 2),
  (3, 3, 3, 1),
  (4, 4, 4, 3);

-- 13. Result
INSERT INTO `Result` (`id`, `session`, `notes`,                 `score`) VALUES
  (1, 1, 'Good job',             95.5),
  (2, 2, 'Needs improvement',    67.0),
  (3, 3, 'Incomplete',           40.0),
  (4, 4, 'Excellent',            100.0);

-- 14. SessionResultLink
INSERT INTO `SessionResultLink` (`Session_id`, `Session_Account_id`, `Result_id`) VALUES
  (1, 1, 1),
  (2, 2, 2),
  (3, 1, 3),
  (4, 3, 4);


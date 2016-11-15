use hilt_test;

drop table if exists `users`;

CREATE TABLE `users` (
  `user_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `mail` varchar(255) NOT NULL,
  `first_name` varchar(255) NOT NULL DEFAULT '' COMMENT 'Имя',
  `last_name` varchar(255) NOT NULL DEFAULT '' COMMENT 'Фамилия',
  `address` varchar(500) NOT NULL DEFAULT '' COMMENT 'Адрес',
  `date_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_update` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `mail_UNIQUE` (`mail`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;
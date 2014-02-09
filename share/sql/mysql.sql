CREATE DATABASE IF NOT EXISTS `<?= $arg->{db_name} ?>`;

CREATE TABLE IF NOT EXISTS `user` (
      `id`    INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT
    , `name`  VARCHAR(255) NOT NULL
    , UNIQUE(name)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `item` (
      `id`         INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT
    , `user_id`    INTEGER NOT NULL
    , `name`       VARCHAR(255) NOT NULL
    , `created_at` INTEGER UNSIGNED NOT NULL
    , `updated_at` INTEGER UNSIGNED NOT NULL
    , FOREIGN KEY(user_id) REFERENCES user(id)
) ENGINE = InnoDB;

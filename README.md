# 勤怠くん

### 環境構築

`$ brew install mysql`

`$ mysql.server start`

`$ mysql -uroot`


```
mysql> create database `kintaikun_dev`;
```

Cmd + D

`$ vi .bundle/config`

```
---
BUNDLE_BUILD__MYSQL2: "--with-ldflags=-L/usr/local/opt/openssl/lib"
```

`$ bundle i`

`$ vi config/database.yml`


```
default: &default
  adapter: mysql2
  host: <%= ENV['MYSQL_HOST'] || '127.0.0.1' %>
  username: root
  password:
  encoding: utf8

development:
  <<: *default
  database: kintaikun_dev

test:
  <<: *default
  database: kintaikun_test
```

`$ bundle exec rails db:migrate`

`$ brew install npm`

`$ npm install`

`$ bundle exec rails s`


### URL
http://kintaikun.bamboo-yujiro.com/

### 環境

Ruby 2.4.1

Ruby On Rails 5.1.4

### テスト実行コマンド
```$ bin/rspec spec/models/attendance_spec.rb```

```$ bin/rspec spec/models/user_spec.rb```

```$ bin/rspec spec/forms/login_form_spec.rb```

### デプロイ
```$ bin/cap production deploy --trace```

### データベース
![Screenshot](https://raw.github.com/bamboo-yujiro/kintaikun/master/kintaikun_database_er.png "scr")

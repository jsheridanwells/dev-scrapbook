# MySql Setup

### Basics

Starting: `$ mysql.server start`

Stopping: `$ mysql.server stop`

Restarting: `$ mysql.server restart`

Securing the server: `$ mysql_secure_installation`

Say 'no' to Validate Password Component. Enter a root user password
'yes' to removing anonymous users. 'yes' to disallowing remote logins
'yes to removing test db. 'yes' to reloading privileged tables.

### Creating an Application User

1. login: `$ mysql -uroot -p<MY_PASSWORD>`

2. `CREATE DATABASE my_database;`

3. `CREATE USER 'my_app_user'@'%' IDENTIFIED BY 'mypassword';

4. Grant all privileges: `GRANT ALL PRIVILEGES ON my_database.* TO 'my_app_user'@'%'`

5. Reload the privileges: `FLUSH PRIVILEGES`

6. Quit and login with the new user: `$ mysql -umy_app_user -pmypassword`

7. Check if the user has the right access: `USE my_database;` (if it says 'Database changed', you're good.)











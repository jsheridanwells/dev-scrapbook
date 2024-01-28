# MongoDB Quick Install And Start
_This is for Ubuntu Jammy on WSL2_

1. [Installation](https://www.mongodb.com/docs/manual/tutorial/install-mongodb-on-ubuntu/)
2. If you're running Ubuntu on WSL, do the following:
   - Create the actual mongod command: `sudo nano /etc/init.d/mongod`
   - Paste in [these contents](https://raw.githubusercontent.com/mongodb/mongo/master/debian/init.d)
   - Make it executable: `sudo chmod +x /etc/init.d/mongod`
   - Also this: `sudo chown mongodb:mongodb /var/run/mongod.pid`
   - Test: `sudo service mongod start`

CLI Reference:
 - Start: `sudo service mongod start`
 - Status: `sudo service mongod status`
 - Stop: `sudo service mongod stop`
 - Restart: `sudo service mongod restart`
 - Shell: `mongosh`



###### References:
[https://www.mongodb.com/docs/manual/tutorial/install-mongodb-on-ubuntu/#run-mongodb-community-edition](https://www.mongodb.com/docs/manual/tutorial/install-mongodb-on-ubuntu/#run-mongodb-community-edition)

[https://askubuntu.com/a/1225658](https://askubuntu.com/a/1225658)

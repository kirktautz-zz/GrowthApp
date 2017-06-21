README.MD
## 1. Build the image

docker create -t growthdb .

## 2. start up a container. Link

## You will need to enter the mongo shell with:

docker container exec -it name_of_container mongo admin

## This will take you to the mongo shell in the admin database
## you will need to create admin privileges
db.createUser({ user: "username", pwd: "password", roles: [{ role: ”userAdminAnyDatabase", db: "admin"}]})

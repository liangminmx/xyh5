#!/bin/bash

echo "Waiting for MySQL to be ready..."
while ! mysqladmin ping -h"mysql" -p"echeverra" --silent 2>/dev/null; do
    echo "Waiting for MySQL..."
    sleep 2
done

echo "MySQL is ready!"

echo "Updating database configurations..."

sed -i 's/DatabaseAddr="127.0.0.1"/DatabaseAddr="mysql"/g' /home/server/chargeserver/config.xml
sed -i 's/DBIP="127.0.0.1"/DBIP="mysql"/g' /home/server/gmserver/config.xml
sed -i 's/GMDatabase IP="127.0.0.1"/GMDatabase IP="mysql"/g' /home/server/gmserver/config.xml
sed -i 's/<Database DatabaseAddr="127.0.0.1"/<Database DatabaseAddr="mysql"/g' /home/server/worldserver/config.xml
sed -i 's/<Database Index="1" DBIP="127.0.0.1"/<Database Index="1" DBIP="mysql"/g' /home/server/operationanalysisserver/config.xml
sed -i 's/DatabaseAddr="127.0.0.1"/DatabaseAddr="mysql"/g' /home/server/gameserver/config.xml
sed -i 's/DBIP="127.0.0.1"/DBIP="mysql"/g' /home/server/gameserver/config.xml

echo "Starting game servers..."
cd /home/server
./start.sh

tail -f /dev/null

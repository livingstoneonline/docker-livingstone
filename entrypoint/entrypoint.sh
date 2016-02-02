#!/bin/sh
# Changes the credentials of the fedora user on startup and imports the database
# if not present.
set -u
set -e

rand_pass() {
    < /dev/urandom tr -dc _A-Za-z0-9 | head -c${1:-32}; echo;
}

# Enviroment Variables
readonly MYSQL_HOST="${MYSQL_HOST:-$MYSQL_PORT_3306_TCP_ADDR}"
readonly MYSQL_HOST_PORT="${MYSQL_HOST_PORT:-$MYSQL_PORT_3306_TCP_PORT}"
readonly MYSQL_ROOT_USER="${MYSQL_ROOT_USER:-root}"
readonly MYSQL_ROOT_PASSWORD="${MYSQL_ROOT_PASSWORD:-$MYSQL_ENV_MYSQL_ROOT_PASSWORD}"
readonly FEDORA_HOST="${FEDORA_HOST:-$FEDORA_PORT_8080_TCP_ADDR}"
readonly FEDORA_HOST_PORT="${FEDORA_HOST_PORT:-$FEDORA_PORT_8080_TCP_PORT}"
readonly DRUPAL_ADMIN_USER="admin"
readonly DRUPAL_ADMIN_EMAIL="nigel.g.banks@gmail.com"
readonly DRUPAL_ADMIN_PASSWORD="${DRUPAL_ADMIN_PASSWORD:-$(rand_pass)}"
readonly DRUPAL_DB_NAME="livingstone"
readonly DRUPAL_DB_USER="drupal"
readonly DRUPAL_DB_PASSWORD="${DRUPAL_DB_PASSWORD:-$(rand_pass)}"
export MYSQL_HOST
export MYSQL_HOST_PORT
export DRUPAL_DB_NAME
export DRUPAL_DB_USER
export DRUPAL_DB_PASSWORD

compressed_database_dump_files() {
    ls /entrypoint/livingstone/*.sql.*
}

uncompressed_database_dump_files() {
    ls /entrypoint/livingstone/*.sql
}

decompress_database_dumps() {
    echo "Decompressing Database Dumps"
    for compressed_dump_file in $(compressed_database_dump_files); do
        decompress_database_dump $compressed_dump_file
    done
}

decompress_database_dump() {
    local filename=$1
    gunzip $filename
}

mysql_client() {
    mysql --user=$MYSQL_ROOT_USER --password="$MYSQL_ROOT_PASSWORD" \
          --host=$MYSQL_HOST --port=$MYSQL_HOST_PORT --protocol=tcp "$@"
}

can_connect_to_mysql() {
    mysqladmin -s \
               --user=$MYSQL_ROOT_USER --password="$MYSQL_ROOT_PASSWORD" \
               --host=$MYSQL_HOST --port=$MYSQL_HOST_PORT --protocol=tcp \
               ping 2>&1 1>/dev/null
}

database_exists() {
    local database_name=$1
    mysql_client -e "use $database_name" 2>&1 1>/dev/null
}

import_database() {
    local database_name=$1
    local database_dump_file=$2
    echo "Importing database '$database_name'..."
    mysql_client $database_name < $database_dump_file || { echo "Failed to Import database '$database_name'"; exit 1; }
    echo "Imported database '$database_name'"
}

drupal_database_user_exists() {
    local query="SELECT EXISTS(SELECT 1 FROM mysql.user WHERE user = '$DRUPAL_DB_USER');"
    local user_exists=$(mysql_client -NBe "$query")
    [ $user_exists -eq 1 ]
}

drupal_database_exists() {
    database_exists "$DRUPAL_DB_NAME" 2>&1 > /dev/null
}

update_drupal_database_user_password() {
    local query="SET PASSWORD FOR '$DRUPAL_DB_USER'@'%' = PASSWORD('$DRUPAL_DB_PASSWORD');"
    echo "Updating Drupal database user password"
    mysql_client -e "$query" || { echo "Failed to update user password '$DRUPAL_DB_USER'"; exit 1; }
}

create_drupal_database_user() {
    local query="CREATE USER '$DRUPAL_DB_USER'@'%' IDENTIFIED BY '$DRUPAL_DB_PASSWORD';"
    echo "Creating Drupal database user"
    mysql_client -e "$query" || { echo "Failed to create user '$DRUPAL_DB_USER'"; exit 1; }
}

grant_access_to_drupal_database_user() {
    local query="GRANT ALL ON $DRUPAL_DB_NAME.* TO '$DRUPAL_DB_USER'@'%';";
    echo "Granting Drupal database user access to '$DRUPAL_DB_NAME'"
    mysql_client -e "$query" || { echo "Failed to grant access to '$DRUPAL_DB_NAME' for '$DRUPAL_DB_USER'"; exit 1; }
}

create_drupal_database() {
    local query="CREATE DATABASE $DRUPAL_DB_NAME;";
    echo "Creating Drupal database"
    mysql_client -e "$query" || { echo "Failed to create Drupal database '$DRUPAL_DB_NAME'"; exit 1; }
}

import_drupal_database() {
    import_database $DRUPAL_DB_NAME "/entrypoint/livingstone/$DRUPAL_DB_NAME.sql"
}

setup_drupal_database_user() {
    if drupal_database_user_exists; then
        update_drupal_database_user_password
    else
        create_drupal_database_user
    fi
    grant_access_to_drupal_database_user
}

setup_drupal_database() {
    if drupal_database_exists; then
        echo "Drupal Database '$DRUPAL_DB_NAME', already exists and was not imported"
    else
        create_drupal_database
        import_drupal_database
    fi
}

update_drupal_site_settings() {
    echo "Rewriting settings.php for sites/default"
    code="include DRUPAL_ROOT.'/includes/install.inc'; include DRUPAL_ROOT.'/includes/update.inc'; global \$db_prefix; \$db['databases']['value'] = update_parse_db_url('mysql://$DRUPAL_DB_USER:$DRUPAL_DB_PASSWORD@$MYSQL_HOST:$MYSQL_HOST_PORT/$DRUPAL_DB_NAME', \$db_prefix); drupal_rewrite_settings(\$db, \$db_prefix);"
    cd $DRUPAL_ROOT
    drush eval "$code"
}

update_drupal_admin_user_password() {
    cd $DRUPAL_ROOT
    drush sqlq "update users set name='$DRUPAL_ADMIN_USER', mail='$DRUPAL_ADMIN_EMAIL' where uid=1;"
    drush user-password 1 --password=$DRUPAL_ADMIN_PASSWORD
}

update_drupal_settings() {
    cd $DRUPAL_ROOT
    drush variable-set --yes islandora_base_url "http://$FEDORA_PORT_8080_TCP_ADDR:$FEDORA_PORT_8080_TCP_PORT/fedora"
}

update_drupal_site() {
    cd $DRUPAL_ROOT
    drush cc all
    drush -y updb
    drush cc all
    drush features-revert-all -y
    drush cc all
}

display_access_information() {
    cat <<EOF
################################################################################
# MySQL Root User: $MYSQL_ROOT_USER
# MySQL Root User Password: $MYSQL_ROOT_PASSWORD
# Drupal User: $DRUPAL_ADMIN_USER
# Drupal Password: $DRUPAL_ADMIN_PASSWORD
# Drupal Database: $DRUPAL_DB_NAME
# Drupal Database User: $DRUPAL_DB_USER
# Drupal Database Password: $DRUPAL_DB_PASSWORD
################################################################################
EOF
}

wait_for_containers() {
    dockerize -wait tcp://$MYSQL_HOST:$MYSQL_HOST_PORT -timeout 60s
    dockerize -wait tcp://$FEDORA_HOST:$FEDORA_HOST_PORT -timeout 360s
}

main() {
    wait_for_containers
    can_connect_to_mysql || { echo "Cannot connect to MySQL Server"; exit 1; }
    decompress_database_dumps
    setup_drupal_database
    setup_drupal_database_user
    update_drupal_site_settings
    update_drupal_admin_user_password
    update_drupal_settings
    update_drupal_site
    display_access_information
    exec "$@"
}
main "$@"

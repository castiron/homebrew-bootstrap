setup_database() {
	declare zip_file
	declare sql_file

	# Save DB credentials
	echo $DB_SERVER:$DB_PORT:$DB_DATABASE:$DB_USER:$DB_PASSWORD >~/.pgpass
	chmod 600 ~/.pgpass

	h2 "Setup Craft CMS (if necessary)"

	while ! pg_isready -h $DB_SERVER; do
		h2 "Waiting for PostreSQL server"
		sleep 1
	done

	cd /var/www/html &&
		./craft setup/security-key &&
		./craft install \
			--interactive=0 \
			--email="${CRAFTCMS_EMAIL:-office@castironcoding.com}" \
			--username="${CRAFTCMS_USERNAME:-admin}" \
			--password="${CRAFTCMS_PASSWORD:-password}" \
			--siteUrl="${CRAFTCMS_SITEURL:-@web}" \
			--language="${CRAFTCMS_LANGUAGE:-en-US}"

}

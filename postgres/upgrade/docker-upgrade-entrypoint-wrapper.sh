#!/bin/sh
set -u -o pipefail;

# probably we will end up with a copy of
# https://github.com/docker-library/postgres/blob/2353eaaa68b7f4febfa08571a6499367a36b560d/12/alpine/docker-entrypoint.sh

if [ "$1" = 'postgres' ]; then
	if [ -s $PGDATA/PG_VERSION ]; then
		PG_MAJOR_OLD=$(cat $PGDATA/PG_VERSION);
		if [ $PG_MAJOR_OLD -lt $PG_MAJOR ]; then
			echo "Current PGDATA version $PG_MAJOR_OLD, version wanted by this docker $PG_MAJOR";


			echo "Install Alpine Postgres version ~$PG_MAJOR_OLD";
			apk add --no-cache "postgresql=~$PG_MAJOR_OLD";


			PGDATAOLD="$PGDATA/$PG_MAJOR_OLD";
			echo "Move $PGDATA to $PGDATAOLD";

			mkdir -p "$PGDATAOLD";
			chown -R postgres "$PGDATAOLD"
			chmod 700 "$PGDATAOLD";

			find $PGDATA/* -prune ! -name $PG_MAJOR_OLD -exec mv {} "$PGDATAOLD/." +;


			PGUPGRADE="$PGDATA/upgrade_${PG_MAJOR_OLD}_to_${PG_MAJOR}";
			echo "Set $PGUPGRADE as working directory";

			mkdir -p "$PGUPGRADE";
			chown -R postgres "$PGUPGRADE"
			chmod 700 "$PGUPGRADE";

			cd "$PGUPGRADE";


			PGDATANEW="$PGDATA/$PG_MAJOR";
			echo "Init $PG_MAJOR in $PGDATANEW";

			mkdir -p "$PGDATANEW";
			chown -R postgres "$PGDATANEW"
			chmod 700 "$PGDATANEW";

#?	exec su-exec postgres "$BASH_SOURCE" "$@"
			su postgres -c "PGDATA='$PGDATANEW' eval 'initdb $POSTGRES_INITDB_ARGS'";


			echo "Upgrade $PG_MAJOR_OLD to $PG_MAJOR";
			su postgres -c "PGBINOLD=/usr/bin/ PGBINNEW=/usr/local/bin/ PGDATAOLD=$PGDATAOLD PGDATANEW=$PGDATANEW /usr/local/bin/pg_upgrade -o '-c config_file=$PGDATAOLD/postgresql.conf' -O '-c config_file=$PGDATANEW/postgresql.conf'";


			echo "Move $PGDATANEW to $PGDATA";
			find $PGDATANEW/* -prune -exec mv {} $PGDATA +;
			rmdir $PGDATANEW;


			echo "Remove Alpine Postgres version ~$PG_MAJOR_OLD";
			apk del --purge postgresql;
		fi;

		echo "Starting postgres for upgrade check";
		su postgres -c 'pg_ctl -w start';

		psql='psql -U postgres --set ON_ERROR_STOP=on';
		for f in /upgrade/*; do
			case "$f" in
				*docker-upgrade-entrypoint-wrapper.sh) ;; # ignore this script
				*.sql)    echo "$0: running $f"; su postgres -c "$psql -f \"$f\""; echo ;;
				*.sql.gz) echo "$0: running $f"; gunzip -c "$f" | su postgres -c "$psql"; echo ;;
				*)        echo "$0: ignoring $f" ;;
			esac;
		done;

		echo "Stopping postgres for upgrade check"
		su postgres -c 'pg_ctl stop'
	fi;
fi;
echo "Docker Upgrade Entrypoint Wrapper calling \"/usr/local/bin/docker-entrypoint.sh\" \"$@\"";
exec "/usr/local/bin/docker-entrypoint.sh" "$@";

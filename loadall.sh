echo Creating database tpch...
createdb tpch
echo Creating fixeddecimal extension...
psql tpch -c "create extension fixeddecimal;"
echo Building TPC-H schema...
psql tpch -f tpch-create_fixeddecimal.sql
echo Loading TPC-H data...
time python loaddata.py
echo Performing Vacuum freeze...
time vacuumdb --freeze --verbose --jobs=8 --table=lineitem --table=orders --table=customer --table=nation --table=part --table=partsupp --table=region --table=supplier --dbname=tpch
echo Creating indexes...
time python index_david_v8.py
echo Creating primary keys...
time psql tpch -f primary_keys.sql
echo Building foreign key constraints...
time python foreign_keys.py
time python foreign_keys2.py
time python foreign_keys3.py
echo Applying NDISTINCT fix...
psql tpch -f ndistinct-fix-3tb.sql
echo Performing ANALYZE of tpch database...
time python analyze.py
echo Done.


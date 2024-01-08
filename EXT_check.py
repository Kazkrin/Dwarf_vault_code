from ldap3 import Server, Connection
import psycopg2
#import psycopg2._psycopg
import psycopg2.extras
from datetime import datetime, timezone, timedelta
import tzlocal 
import sys
import os
import logging
import logging.handlers
import colorlog


#-------------
#Block to connect into AD 
#--------------

service_id = "test"
username  = "dsv\\sd.automation"
server = Server('ldap_server_address', use_ssl=True)
conn = Connection(server, user = 'ad_user_mail' , password= 'ad_user_password', auto_bind=True)
conn.bind()


#--------------
#Block to connect into PG DB
#--------------

ORAUSER='oracledb_username'
ORAPASSWORD='oracle_username_password'
ORA_SDTZ='UTC'
PGUSER='database_username'
PGPASSWORD='passwrod_to_database'
#PGHOST = ''



#--------------
# To retrive data of employes directly reports to specific manager
#--------------


managers_name = ''
def getDirectReports(samAccountName):
    conn.search(
            search_base='OU=DSV.COM,DC=DSV,DC=COM',
            search_filter=f'(samAccountName={samAccountName})',
            attributes=[
                'directReports',
            ]
        )
    return conn.entries


def check_if_user_exist(displayName):
    conn.search(
        search_base='OU=DSV.COM,DC=DSV,DC=COM',
        search_filter=f'(displayName={displayName})', 
        attributes = [
        'givenName', 
        'accountExpires',
        'cn',
        'sn',
        'mail',
        'pwdLastSet',
        ])
    #return conn.entries
    if conn.entries == []:
        return False
    else:
        return True



conn1 = psycopg2.connect(dbname="dashboard", user=PGUSER, password=PGPASSWORD, host=PGHOST)
curr = conn1.cursor()
curr.execute(f"""SELECT key, account_name from public.external_account_reviewing WHERE password_age = 'INACTIVE ACCOUNT'""")
result = curr.fetchall()

for users in result:
    user_details = check_if_user_exist(users[1])
    if not user_details:
        params = users[0]
        query = """UPDATE public.external_account_reviewing SET password_age = 'DELETED' WHERE key = %s """
        curr.execute(query, (params,))

conn1.commit()
conn1.close()

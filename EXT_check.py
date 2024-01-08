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
server = Server('ldaps.emea.dsv.com', use_ssl=True)
conn = Connection(server, user = 'kamil.karpiuk@dsv.com' , password= '#avezmech1989', auto_bind=True)
conn.bind()


#--------------
#Block to connect into PG DB
#--------------

ORAUSER='DSVINTEG'
ORAPASSWORD='ugyCg7CBf0nNgi9YV0xm'
ORA_SDTZ='UTC'
PGUSER='dashboard'
PGPASSWORD='F2njvd@fdjk8'
#PGHOST = 'i26441.dsv.com'
PGHOST = 'i26442.dsv.com'


#--------------
# To retrive data of employes directly reports to specific manager
#--------------


managers_name = 'marcin.kawka'
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
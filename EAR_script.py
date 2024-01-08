#!/usr/bin/env python
# --------------------------------------------------------------------------
# This is External Account Reviewing to monitor and control EXT accounts
#---------------------------------------------------------------------------

from ldap3 import Server, Connection
import psycopg2
import psycopg2.extras
from datetime import datetime, timezone, timedelta
import tzlocal 
import sys
import os

#-------------
#Block to connect into AD 
#--------------

service_id = "test"
username  = "your_user_name"
server = Server('address_of_ldap_server', use_ssl=True)
conn = Connection(server, user = 'ad_user_mail' , password= 'ad_password', auto_bind=True)
conn.bind()

#--------------
#Block to connect into PG DB
#--------------

ORAUSER=''
ORAPASSWORD=''
ORA_SDTZ='UTC'
PGUSER=''
PGPASSWORD=''
#PGHOST = ''
PGHOST = ''

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

#--------------
#Core of the script
#---------------

temp_table = []
#To get detailed info of Direct Reports by attributes and calcuate Password Age of their accounts
def getUserDetails(distinguishedName):
    conn.search(
        search_base='OU=DSV.COM,DC=DSV,DC=COM',
        search_filter=f'(distinguishedName={distinguishedName})', 
        attributes = [
        'givenName', 
        'accountExpires',
        'cn',
        'sn',
        'mail',
        'pwdLastSet',
        ])
    return conn.entries


user_details = getUserDetails
reports = getDirectReports(managers_name)
for users in reports:
    for user in users.directReports.values:
            if 'cn=ext.' in user.lower():
                user_details = getUserDetails(user)
                
                current_date = datetime.now(timezone.utc).date()
                start_date = user_details[0].pwdLastSet.value.date()
                password_age = current_date - start_date
                if password_age.days >= 90:
                     password_age = 'ACCOUNT INACTIVE'
        
                temp_table.append((
                     user_details[0].cn.value,
                     user_details[0].accountExpires.value.date(), 
                     user_details[0].givenName.value, 
                     user_details[0].sn.value, 
                     user_details[0].mail.value,
                     password_age)
                     )

                print(temp_table) 
                
#--------------
# Connecting to our Postgre DB and inserting data from loop
#--------------

conn = psycopg2.connect(dbname="dashboard", user=PGUSER, password=PGPASSWORD, host=PGHOST)
curr = conn.cursor()
psycopg2.extras.execute_batch(curr,"INSERT INTO public.external_account_reviewing (account_name, expiration_date, name, surname, email_address, password_age) VALUES (%s,%s,%s,%s,%s,%s) ON CONFLICT (account_name) DO UPDATE SET expiration_date=excluded.expiration_date, password_age=excluded.password_age ;",temp_table) 

conn.commit()
curr.close()
conn.close()

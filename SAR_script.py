# --------------------------------------------------------------------------
# This is Service Account Reviewing to monitor and control SVC accounts
#---------------------------------------------------------------------------

from ldap3 import Server, Connection
import psycopg2
import psycopg2.extras
from datetime import datetime, timezone, timedelta
import tzlocal

#-------------
#Block to connect into AD 
#--------------

service_id = "test"
username  = "dsv\\sd.automation"
server = Server('ldaps.emea.dsv.com', use_ssl=True)
conn = Connection(server, user = 'PL.SVC.6463.EARSCR.prd' , password= '2Mma7MOrvUw?A$38vk?dLD0D', auto_bind=True)
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
#Block to retrive SVC under specific owner
#--------------

owner_name = 'kamil.karpiuk'
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
#--------------

temp_table = []
def getAccountDetails(distinguishedName):
    conn.search(
        search_base='OU=DSV.COM,DC=DSV,DC=COM',
        search_filter=f'(distinguishedName={distinguishedName})', 
        attributes = [
        'samAccountName', 
        'description',
        'manager',
        'pwdLastSet'
        ])
    return conn.entries


account_details = getAccountDetails
supervisioned_accounts = getDirectReports(owner_name)
for accounts in supervisioned_accounts:
    for account in accounts.directReports.values:
        if 'ou=service account' in account.lower():
            account_details = getAccountDetails(account)

            current_date = datetime.now(timezone.utc).date()
            start_date = account_details[0].pwdLastSet.value.date()
            password_age = current_date - start_date
            if password_age.days >= 365:
                password_age = 'INACTIVE ACCOUNT'

            temp_table.append((account_details[0].samAccountName.value, account_details[0].description.value, account_details[0].manager.value, account_details[0].pwdLastSet.value.date(), password_age))
            print(temp_table)

#--------------
# Connecting to our Postgre DB and inserting data from loop
#--------------

conn = psycopg2.connect(dbname="dashboard", user=PGUSER, password=PGPASSWORD, host=PGHOST)
curr = conn.cursor()
psycopg2.extras.execute_batch(curr,"INSERT INTO service_account_reviewing (account_name, description, manager, last_password_date, password_age) VALUES (%s,%s,%s,%s,%s) ON CONFLICT (account_name) where account_name DO UPDATE SET last_password_date=EXCLUDED.last_password_date, password_age=EXCLUDED.password_age ;",temp_table)

curr.close()
conn.commit()
conn.close()

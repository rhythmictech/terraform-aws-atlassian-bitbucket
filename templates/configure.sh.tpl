
cat <<END > /opt/atlassian/data/bitbucket/shared/bitbucket.properties
setup:
  displayName: ${site_name}
  baseUrl: https://${base_hostname}
  license: ${license_key}
  sysadmin:
    username: admin
    password: ${admin_password}
    displayName: Backup Admin
    emailAddress: ${admin_email}

jdbc:
  driver: org.postgresql.Driver
  url: ${db_url}
  username: ${db_username}
  password: ${db_password}

server:
  address: 0.0.0.0
  proxy-name: ${base_hostname}
  proxy-port: 443
  scheme: https
  secure: true
END

chown bitbucket /opt/atlassian/data/bitbucket/shared/bitbucket.properties
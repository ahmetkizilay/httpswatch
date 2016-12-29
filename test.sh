#/bin/bash

function print_validity {
  INPUT=${1:-"0"}

  if [ $INPUT -gt 0 ]; then
    echo -e "\e[32m\u2714\e[39m"
  else
    echo -e "\e[31m\u2718\e[39m"
  fi
}

HTTP_URL="http://"$1
HTTPS_URL="https://"$1

HTTP_FILE_NAME=$2"/http-"$1
HTTPS_FILE_NAME=$2"/https-"$1

curl --verbose -s -o /dev/null $HTTPS_URL > $HTTPS_FILE_NAME 2> $HTTPS_FILE_NAME
curl --verbose -s -o /dev/null $HTTP_URL > $HTTP_FILE_NAME 2> $HTTP_FILE_NAME

echo checking $1

# is SSL valid

SSL_OK=$(cat $HTTPS_FILE_NAME | grep -i "^*  SSL certificate verify ok." | wc -l)

# is available over SSL
HTTPS_STATUS=$(cat $HTTPS_FILE_NAME | grep -i "^< HTTP/1.1" | sed 's/^< HTTP\/1\.1\s//')
# echo HTTPS_STATUS = $HTTPS_STATUS

# does default to SSL
AVAILABLE_OVER_HTTP=$(cat $HTTP_FILE_NAME | grep -i "^< HTTP/1.1 2" | wc -l)
if [ $AVAILABLE_OVER_HTTP -lt 1 ]; then

  REDIRECTS_HTTP=$(cat $HTTP_FILE_NAME | grep -i "^< HTTP/1.1 3" | wc -l)
  if ! [ $REDIRECTS_HTTP == "0" ]
  then
    REDIRECTION_ADDRESS=$(cat $HTTP_FILE_NAME | grep -i "^< Location:" | sed 's/^< Location: //')
    REDIRECTS_TO_HTTPS=$(echo $REDIRECTION_ADDRESS | grep -i "^https:\/\/" | wc -l)
  fi

fi

# check hsts
HAS_HSTS_HEADER=$(cat $HTTPS_FILE_NAME | grep -i "^< Strict-Transport-Security: " | wc -l)
if [ $HAS_HSTS_HEADER -gt 0 ]; then

  HSTS_HEADER=$(cat $HTTPS_FILE_NAME | grep -i "^< Strict-Transport-Security: ")

  IS_HSTS_INCLUDE_SUBDOMAINS=$(echo $HSTS_HEADER | grep "includeSubdomains" | wc -l)
  if [ $IS_HSTS_INCLUDE_SUBDOMAINS == "1" ]; then
    echo "HSTS INCLUDE SUBDOMAINS"
  fi

  MAX_AGE=$(echo $HSTS_HEADER | grep -ioh "max-age=[0-9]*" | sed 's/max-age=//')
  if ! [ "$MAX_AGE" == "" ] && [ $MAX_AGE -ge 10886400 ]; then
    MAX_AGE_LONG_ENOUGH=1
  fi

  HAS_PRELOAD=$(echo $HSTS_HEADER | grep -i "preload" | wc -l)

fi

echo -n "VALID SSL "
print_validity $SSL_OK

echo -n "DEFAULTS TO HTTPS "
print_validity $REDIRECTS_TO_HTTPS

echo -n "HSTS ENABLED"
print_validity $HAS_HSTS_HEADER

echo -n "HSTS INCLUDES SUBDOMAINS"
print_validity $IS_HSTS_INCLUDE_SUBDOMAINS

echo -n "HSTS MAX AGE IS LONG ENOUGH"
print_validity $MAX_AGE_LONG_ENOUGH

echo -n "HSTS HAS PRELOAD"
print_validity $HAS_PRELOAD

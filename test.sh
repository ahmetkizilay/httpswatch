#/bin/bash

function print_validity {
  INPUT=${1:-"0"}

  if [ $INPUT -gt 0 ]; then
    echo -en "\e[32m\u2714\e[39m"
  else
    echo -en "\e[31m\u2718\e[39m"
  fi
}

# is SSL valid
SSL_OK=$(bash ./checks/is-ssl-valid.sh $1 $2)

# is available over SSL
AVAILABLE_OVER_HTTPS=$(bash ./checks/is-https-available.sh $1 $2)

# does default to SSL
REDIRECTS_TO_HTTPS=$(bash ./checks/does-redirect-to-https.sh $1 $2)

# check hsts
HAS_HSTS_HEADER=$(bash ./checks/has-hsts-header.sh $1 $2)
if [ $HAS_HSTS_HEADER -gt 0 ]; then

  DOES_HSTS_INCLUDE_SUBDOMAINS=$(bash ./checks/does-hsts-include-subdomains.sh $1 $2)

  IS_HSTS_MAX_AGE_LONG_ENOUGH=$(bash ./checks/is-hsts-max-age-long-enough.sh $1 $2)

  DOES_HSTS_HAVE_PRELOAD=$(bash ./checks/does-hsts-have-preload.sh $1 $2)

fi


#echo -n "VALID SSL "
print_validity $SSL_OK
echo -en "\t"

#echo -n "AVAILABLE OVER HTTPS"
print_validity $AVAILABLE_OVER_HTTPS
echo -en "\t"

# echo -n "DEFAULTS TO HTTPS "
print_validity $REDIRECTS_TO_HTTPS
echo -en "\t"

# echo -n "HSTS ENABLED"
print_validity $HAS_HSTS_HEADER
echo -en "\t"

# echo -n "HSTS INCLUDES SUBDOMAINS"
print_validity $DOES_HSTS_INCLUDE_SUBDOMAINS
echo -en "\t"

# echo -n "HSTS MAX AGE IS LONG ENOUGH"
print_validity $IS_HSTS_MAX_AGE_LONG_ENOUGH
echo -en "\t"

# echo -n "HSTS HAS PRELOAD"
print_validity $DOES_HSTS_HAVE_PRELOAD
echo -en "\t"

echo $1
#!/bin/bash

cfg=${0/.sh/.conf}
[ -r "$cfg" ] || \
{
	echo "Configuration file: '$cfg' is not readable" >&2
	exit 1
}
. "$cfg"

function usage ()
{
	echo "USAGE: sms.sh <phone number> <message>" >&2
	exit $1
}

to=$(echo "$1" | sed -r 's/[^0-9]*//g')
message=$2

[ -z "$to" ] && usage 2
[ -z "$message" ] && usage 3

domain=multifon.ru
proxy=sbc.multifon.ru

uah='User-Agent: MCPC-MG-1-0-34-3490/2.0.0.5301'
xmch='X-Movial-Content: sms/text'
xmdh='X-Movial-DeliveryReport: true'
cth='Content-Type: text/plain; charset=ISO-10646-UCS-2'

headers="$uah\\n$xmch\\n$xmdh\\n$cth"

user=$sender
from=sip:$sender@$domain
to=sip:+$to@sms.$domain

[ -n "$DEBUG" ] && DEBUG=" -vvv"

# sipsak -E tcp -p $proxy -u $user -a $password -j "$headers" -MB "$message" -c $from -s $to$DEBUG

dummy=$(curl "https://emotion.megalabs.ru/api/v15/login" --data '{"msisdn":"${user}","password":"${password}"}' -c ./${user}.pechenka -b ./${user].pechenka)
if [ !-f "./${user].pechenka" ]; then
echo "Incorrect username/password"
else 
curl -c ./${user}.pechenka -b ./${user].pechenka "https://emotion.megalabs.ru/api/v15/msg" --data "<sendSMSParam><attime></attime><cpId></cpId><dlvType>0</dlvType><dispType>0</dispType><flashflag>0</flashflag><ctn>${text}</ctn><recver length=\"1\"><item>${to}</item></recver><sender>${user}</sender><serviceType></serviceType><sign></sign><smstype>1</smstype><type>0</type></sendSMSParam>"
echo "sent, please, check"
fi

#!/bin/bash

function usage ()
{
	cat <<EOF
USAGE: settings.sh <command> <phone> <password> [params]

Available commands:
	rget                – get routing mode
	rset <mode>         – set routing mode
		modes:
		GSM
		SIP
		GSM+SIP
	pwd <new password>  – change password
EOF
	
	exit $1
}

if [[ $# -lt 3 || $# -gt 4 ]]; then
	usage 1
fi

login="login=$2@multifon.ru"
password="password=$3"

case "$1" in
	rget)
		if [[ $# -gt 3 ]]; then
			usage 2
		fi
		URL=https://sm.megafon.ru/sm/client/routing
		;;
	rset)
		if [[ $# -lt 4 ]]; then
			usage 3
		fi
		URL=https://sm.megafon.ru/sm/client/routing/set
		param="routing=$4"
		;;
	pwd)
		if [[ $# -lt 4 ]]; then
			usage 3
		fi
		URL=https://sm.megafon.ru/sm/client/password/change
		param="new_password=$4"
		;;
	*)
		usage 4
esac

curl -G --data-urlencode "$login" --data-urlencode "$password" --data-urlencode "$param" "$URL"


#	http://perm.megafon.ru/services/communicate/multifon.html
#
#	Сервисные функции
#
#	Для настройки и получения текущего режима приема входящих вызовов можно использовать HTTPs запрос с подстановочными параметрами:
#--------------------------------------------------------------------------------------
# Имя параметра			Значения								Пример
#--------------------------------------------------------------------------------------
# login					Имя пользователя в услуге (SIP-URI) 	792xxxxxxxx@multifon.ru
# password				Пароль пользователя						pasSWORD123
# routing				Режим приема входящих вызовов:			0
#						0 – только на мобильный
#						1 – только SIP (в программный или
#										аппаратный SIP-телефон)
#						2 – параллельный вызов
#--------------------------------------------------------------------------------------
#
#	Формат запроса
#
#	Для получения кода текущего режима приема входящих вызовов используется запрос следующего вида:
# https://sm.megafon.ru/sm/client/routing?login=<login>&password=<password>
#
#	Для установки нового режима приема входящих вызовов используется запрос:
# https://sm.megafon.ru/sm/client/routing/set?login=<login>&password=<password>&routing=<routing>
#
#	Для смены пароля пользователя используется запрос:
# https://sm.megafon.ru/sm/client/password/change?login=7HHHXXXYYZZ@multifon.ru&password=<old_password>&new_password=<new_password>
#
#	Формат ответа сервера и коды ответов
#
#	Если запрос выполнен успешно, сервер возвращает XML документ, содержащий несколько полей: код ответа, описание кода ответа и код
# режима приема входящих вызовов (в ответе на запрос получения кода текущего режима приема входящих вызовов). Общий формат XML:
# <response>
# <result>
# <code>код ответа</code>
# <description>описание кода ответа</description>
# </result>
# <routing>код режима приема входящих  вызовов</routing>
# </response>
#	Наиболее используемые коды ответа с описаниями приведены в таблице:
#---------------------------------------------------------------------
# Код ответа	Описание кода ответа		Комментарий
#---------------------------------------------------------------------
# 101			Password contains invalid	Неправильный пароль
#					symbols or too long
# 102			Parameters incorrect		Этот пользователь не может
#												использовать настройку
#												входящих вызовов
# 200			Ok
# 404			Subscription Not Found		Пользователь не найден
#---------------------------------------------------------------------
#

# Cliente Ruby para usar la API BANK

Ruby version 2.4.2

Creara el los usuarios Emma y Jim, sus cuentas bancarias ( y bancos), y una transferencia de 20 000 a Jim.

Al crear la cuenta bancaria de Jim se le añadira un saldo de 20500 para que pueda pagar a Emma.
La cuenta de Emma se creara con un saldo de 1 euro.

Usar:
ruby show_me_the_money.rb
si quieres probar otros importes
amount=1234 ruby show_me_the_money.rb

* Todas las cifras de euros se daran en enteros, centimos incluidos:
Ej:
100.00 = 10000
2,38   = 238

Documentacion del TransferAgent

Añadir:
load "transfer_agent.rb"
Necesitamos el token del usuario cuya cuenta realiza el pago y el id de su cuenta de origen
Tambien el token y el id de la cuenta bancaria del destinatario

transfer = TransferAgent.new(origin_user_token, bank_account_origin_id, destination_user_token, bank_account_destination_id)
transfer.calculate_and_create_payment(amount)
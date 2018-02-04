# ruby_client_bank_api


Crear un usuario para obtener un token de usuario
BankApiClient.new.create_user(nombe del usuario, email, password)

obtendremos una salida tipo:
"Copia este token de usuario eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE1MTc4NjI1Nzl9.9hdyNximJIord2cDsB8wa5_bwkIOfxbQcSqqghm5rjw"
Las siguientes llamadas se hacen con el token de usuario:
user_token = "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE1MTc4NjI1Nzl9.9hdyNximJIord2cDsB8wa5_bwkIOfxbQcSqqghm5rjw"

Obtener los bancos para saber el id que necesitamos
BankApiClient.new(user_token).find_bank
nos devolvera:
[
    [0] {
                "id" => 1,
              "name" => "banco rocio",
        "created_at" => "2018-02-03T18:28:41.231Z",
        "updated_at" => "2018-02-03T18:28:41.231Z"
    },
    [1] {
                "id" => 2,
              "name" => "banco de hierro",
        "created_at" => "2018-03-03T18:35.45.231Z",
        "updated_at" => "2018-02-03T18:35:45.231Z"
    }

]

Crear la cuenta bancaria del usuario:
BankApiClient.new(user_token).create_bank_account( id del banco del usuario, iban, saldo en centimos *)

Crear un pago del usuario a otro usuario:
BankApiClient.new(user_token).create_payment( id del banco del usuario, id de la cuenta bancaria del usuario,  id de la cuetna bancaria del usuario al que pagas, importe en centimos *)


* Todas las cifras de euros se daran en enteros, centimos incluidos:
Ej:
100.00 = 10000
2,38   = 238

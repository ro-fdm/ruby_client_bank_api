require 'rest-client'
require 'awesome_print'
require 'json'

class BankApiClient
  def initialize(user_token = nil)
    @url_api = 'http://0.0.0.0:3000'
    @user_token = user_token
  end

  def headers
    { Authorization: @user_token.to_s }
  end

  def get_user_token(email, password)
    login_url = "#{@url_api}/auth/login"
    params    = { email: email.to_s,
                  password: password.to_s }
    response  = RestClient.post(login_url, params)
    user_token = JSON.parse(response)['auth_token']
  rescue => e
    errors = JSON.parse(e.response)
    ap errors
  end

  def create_user(name, email, password)
    signup_url = "#{@url_api}/signup"
    params     = { name: name.to_s,
                   email: email.to_s,
                   password: password.to_s,
                   password_confirmation: password.to_s }
    response   = RestClient.post(signup_url, params)
    user_token = JSON.parse(response)['auth_token']
  rescue => e
    errors = JSON.parse(e.response)
    ap errors
  end

  def list_banks
    banks_url = "#{@url_api}/api/v1/banks"
    response = RestClient.get(banks_url, headers)
    JSON.parse(response)
  rescue => e
    errors = JSON.parse(e.response)
    ap errors
  end

  def list_bank_payments(bank_id)
    bank_payments_url = "#{@url_api}/api/v1/banks/#{bank_id}/payments"
    response = RestClient.get(bank_payments_url, headers)
    JSON.parse(response)
  rescue => e
    errors = JSON.parse(e.response)
    ap errors
  end

  def create_bank_account(bank_id, iban, balance)
    create_ba_url = "#{@url_api}/api/v1/banks/#{bank_id}/bank_accounts"
    params_ba     = {
      bank_id: bank_id,
      bank_account:
                      {
                        iban: iban.to_s,
                        balance: balance
                      }
    }
    response = RestClient.post(create_ba_url, params_ba, headers)
    JSON.parse(response)
  rescue => e
    errors = JSON.parse(e.response)
    ap errors
  end

  def create_bank(name_bank)
    create_bank_url = "#{@url_api}/api/v1/banks"
    params = { bank: {
      name: name_bank.to_s
    } }
    response = RestClient.post(create_bank_url, params, headers)
    JSON.parse(response)
  rescue => e
    errors = JSON.parse(e.response)
    ap errors
  end

  def find_bank_account(bank_id)
    find_bank_account_url = "#{@url_api}/api/v1/bank_accounts/#{bank_id}"
    response = RestClient.get(find_bank_account_url, headers)
    JSON.parse(response)
  rescue => e
    errors = JSON.parse(e.response)
    ap errors
  end

  def create_payment(origin_id, destination_id, amount, kind = 'transfer')
    create_pay_url = "#{@url_api}/api/v1/payments"
    params_pay     = {
      payment:
                     {
                       origin_id: origin_id,
                       destination_id: destination_id,
                       amount: amount,
                       kind: kind
                     }
    }
    response = RestClient.post(create_pay_url, params_pay, headers)
    JSON.parse(response)
  rescue => e
    errors = JSON.parse(e.response)
    ap errors
  end
end

# Documentacion
# Para conseguir el token de alguien ( email, contraseña)
# user_token = BankApiClient.new.get_user_token("emma@gmail.com", "jim_password")

# Para crear un usuario (nombre, email, contraseña )
# user_token = BankApiClient.new.create_user("rocio fernandez", "hola@rocio.me", "qwerty")
# user_token = "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE1MTc4NjI1Nzl9.9hdyNximJIord2cDsB8wa5_bwkIOfxbQcSqqghm5rjw"

# Para conocer los datos de una cuenta bancaria, con su id
# BankApiClient.new(user_token).find_bank_account(4)

# Para crear un banco(nombre)
# BankApiClient.new(user_token).create_bank("Banco de Hierro")

# Para crear una cuenta bancaria ( id del banco, iban, saldo)
# BankApiClient.new(user_token).create_bank_account(1,"ES1234", 12000)

# Para crear un pago (id de la cuenta bancaria de origen, id cueneta bancaria del destinatario, importe)
# BankApiClient.new(user_token).create_payment(1, 4, 1000)

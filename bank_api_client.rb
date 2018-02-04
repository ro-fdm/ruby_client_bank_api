require 'rest-client'
require 'awesome_print'
require 'json'

class BankApiClient

	def initialize(user_token = nil)
		@url_api = "http://0.0.0.0:3000"
		@user_token = user_token
	end

	def headers
		{ Authorization: "#{@user_token}" }
	end

	def get_user_token(email, password)
		login_url = "#{@url_api}/auth/login"
		params    = { email: "#{email}",
									password: "#{password}"}
		response  = RestClient.post(login_url, params)
		user_token = JSON.parse(response)
		ap user_token
	end

	def create_user(name, email, password)
		signup_url = "#{@url_api}/signup"
		params     = { name: "#{name}",
									 email: "#{email}",
									 password: "#{password}",
									 password_confirmation: "#{password}"
									}
		response   = RestClient.post(signup_url, params)
		user_token = JSON.parse(response)["auth_token"]
		ap "#{user_token}"
	end

	def list_banks
		banks_url = "#{@url_api}/api/v1/banks"
		response = RestClient.get(banks_url, headers)
		ap JSON.parse(response)
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
		response = RestClient.post(create_ba_url, params_ba,  headers)
		ap JSON.parse(response)
	end

	def create_bank(name_bank)
		create_bank_url = "#{@url_api}/api/v1/banks"
		params = { bank:{
									name: "#{name_bank}"
								}
							}
		response = RestClient.post(create_bank_url, params, headers)
		ap JSON.parse(response)
	end

	def create_payment(bank_id, origin_id, destination_id, amount, kind: "transfer")
		create_pay_url = "#{@url_api}/api/v1/banks/#{bank_id}/payments"
		params_pay     = { 
											bank_id: bank_id,
											payment:
											{
												origin_id: origin_id,
												destination_id: destination_id,
												amount: amount,
												kind: kind
											}
										}
		response = RestClient.post(create_pay_url, params_pay,  headers)
		ap JSON.parse(response)
	end

end

#BankApiClient.new.get_user_token("hola@rocio.me", "qwerty")
#BankApiClient.new.create_user("rocio fernandez", "hola@rocio.me", "qwerty")
user_token = "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE1MTc4NjI1Nzl9.9hdyNximJIord2cDsB8wa5_bwkIOfxbQcSqqghm5rjw"
#BankApiClient.new(user_token).find_bank
BankApiClient.new(user_token).create_bank("Banco de Hierro")
#BankApiClient.new(user_token).create_bank_account(1,"ES1234", 12000)
#BankApiClient.new(user_token).create_payment(1, 4, 1, 1000)
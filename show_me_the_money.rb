require 'awesome_print'
load "bank_api_client.rb"

class ShowMeTheMoney

	def initialize
	end

	def run
		jim_token, jim_bank, jim_bank_account = create_jim_with_bank_account
		emma_bank_account = create_emma_with_bank_accont
		make_transfer(jim_token, jim_bank, jim_bank_account, emma_bank_account)
	end

	private 

	def create_jim_with_bank_account
		jim_token = BankApiClient.new.create_user("Jim", "jim@gmail.com", "jim_password" )
		jim_bank  = BankApiClient.new(jim_token).create_bank("jim bank")
		jim_bank_id = jim_bank["id"]
		jim_bank_account = BankApiClient.new(jim_token).
											create_bank_account( jim_bank_id, "ES12345", 2050000)
		jim_bank_account_id = jim_bank_account["id"]
		return jim_token, jim_bank_id, jim_bank_account_id
	end

 	def create_emma_with_bank_accont
		emma_token = BankApiClient.new.create_user("Emma", "emma@gmail.com", "jim_password" )
		emma_bank  = BankApiClient.new(emma_token).create_bank("emma bank")
		emma_bank_id = emma_bank["id"]
		emma_bank_account = BankApiClient.new(emma_token).
											create_bank_account( emma_bank_id, "ES6789", 1)
		emma_bank_account_id = emma_bank_account["id"]
		return emma_bank_account_id
 	end

 	def make_transfer(user_token, bank, origin_id, destination_id)
 		BankApiClient.new(user_token).create_payment( bank, origin_id,  destination_id, 2000000)
 	end

end

ShowMeTheMoney.new.run
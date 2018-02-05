require 'awesome_print'
load "bank_api_client.rb"
load "transfer_agent.rb"

module ShowMeTheMoney
	extend self

	def run(amount)
		#jim_token, jim_bank_account = create_jim_with_bank_account
		#emma_token, emma_bank_account = create_emma_with_bank_accont
		jim_token, jim_bank_account = get_jim_data
		emma_token, emma_bank_account = get_emma_data
		make_transfer(jim_token, jim_bank_account, emma_token, emma_bank_account, amount)
	end

	private 

	def create_jim_with_bank_account
		jim_token = BankApiClient.new.create_user("Jim", "jim@gmail.com", "jim_password" )
		jim_bank  = BankApiClient.new(jim_token).create_bank("jim bank")
		jim_bank_id = jim_bank["id"]
		jim_bank_account = BankApiClient.new(jim_token).
											create_bank_account(jim_bank_id, "ES12345", 2050000)
		jim_bank_account_id = jim_bank_account["id"]
		return jim_token, jim_bank_account_id
	end

 	def create_emma_with_bank_accont
		emma_token = BankApiClient.new.create_user("Emma", "emma@gmail.com", "jim_password" )
		emma_bank  = BankApiClient.new(emma_token).create_bank("emma bank")
		emma_bank_id = emma_bank["id"]
		emma_bank_account = BankApiClient.new(emma_token).
											create_bank_account(emma_bank_id, "ES6789", 1)
		emma_bank_account_id = emma_bank_account["id"]
		return emma_token, emma_bank_account_id
 	end

 	def get_jim_data
 		jim_token = BankApiClient.new.get_user_token( "jim@gmail.com", "jim_password")
 		return jim_token, 17
 	end

 	def get_emma_data
 		emma_token = BankApiClient.new.get_user_token( "emma@gmail.com", "jim_password")
 		return emma_token, 18
 	end

 	def make_transfer(origin_token, origin_id, destination_token, destination_id, amount)
 		transfer = TransferAgent.new(origin_token, origin_id, destination_token, destination_id)
 		transfer.calculate_and_create_payment(amount)
 	end

end

ShowMeTheMoney.run(2000000)

require 'awesome_print'
load "bank_api_client.rb"

class TransferAgent

  LIMIT_AMOUNT_INTER_BANK = 100000
  COMISION_INTER_BANK     = 500

  def initialize(origin_token, origin_id, destination_token,  destination_id)
    @origin_token = origin_token
    @origin_id = origin_id
    @destination_id = destination_id
    @destination_token = destination_token
  end

  def calculate_and_create_payment(amount)
    responses = []
    ba_origin =  find_bank_account(@origin_token, @origin_id)
    ba_destination = find_bank_account(@destination_token, @destination_id)
    
    if ba_origin["bank_id"] != ba_destination["bank_id"]
      responses = process_inter_bank_transfer(amount, responses)
    else
      ap "Esta operacion no tiene comision"
      responses << create_payment(amount)
    end

    print_response(responses)
  end

  def process_inter_bank_transfer(amount, responses)
    requests = calculate_requests(amount)
    check_comision_acceptance(requests)
    rest_amount = amount
    requests.times do
      amount_pay = calculate_amount(rest_amount)
      responses << create_payment(amount_pay)
      rest_amount -= amount_pay
    end
    responses
  end


  private

  def check_comision_acceptance(requests)
    c = (COMISION_INTER_BANK * requests)/100
    ap " El gasto en comisiones sera de #{c} €"
    ap "Estas segur@ de que quieres realizar el proceso? (s/n)"
    answer = $stdin.gets.chomp
    if answer != "s"
      exit
    end
  end

  def calculate_amount(rest_amount)
    if rest_amount < LIMIT_AMOUNT_INTER_BANK
      amount_pay = rest_amount
    else
      amount_pay = LIMIT_AMOUNT_INTER_BANK
    end
    amount_pay
  end

  def print_response(responses)
    ap responses
  end

  def find_bank_account(user_token, bank_id)
    BankApiClient.new(user_token).find_bank_account(bank_id)
  end

  def create_payment(amount)
    BankApiClient.new(@origin_token).create_payment(@origin_id, @destination_id, amount)
  end

  def calculate_requests(amount)
    (amount.to_f / LIMIT_AMOUNT_INTER_BANK).ceil
  end

  def limit_amount?
    @limit_amount
  end

end
#emma_token = BankApiClient.new.get_user_token("emma@gmail.com", "jim_password")
#jim_token  = BankApiClient.new.get_user_token("jim@gmail.com", "jim_password")
#TransferAgent.new(jim_token, 1, emma_token, 2).calculate_payment(8800)
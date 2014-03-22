require 'net/http'

module Lita
  module Handlers
    class ChileanBip < Handler

      REDIS_KEY = 'lita-chilean-bip'
      QUERY_URL = 'http://saldobip.com'
      PARSE_SELECTOR = '#resultados #datos strong'
      POST_HEADERS = {
        'Content-Type' => 'application/x-www-form-urlencoded',
        'Host' => 'saldobip.com',
        'Origin' => 'http://saldobip.com',
        'Referer' => 'http://saldobip.com/',
        'User-Agent' => 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/33.0.1750.146 Safari/537.36'
      }

      route %r{^bip\s*(\d+)}i, :bip_balance, help: { 'bip ...' => 'gets the balance for BIP card ...' }
      route %r{^my bip is (\d+)}i, :store_bip, help: { 'my bip is ...' => "stores the user's BIP card ..." }
      route %r{^bip}i, :stored_bip_balance, help: { 'bip' => "gets the balance for stored user's BIP card" }

      def bip_balance(response)
        card_number = card_number_from_response(response)
        return response.reply interpolate_message('invalid_number') unless validate_card_number card_number
        balance_for_card_number(card_number, response)
      end

      def store_bip(response)
        card_number = card_number_from_response(response)
        return response.reply interpolate_message('invalid_number') unless validate_card_number card_number
        key_user = key_from_user response.user
        redis.hset(REDIS_KEY, key_user, card_number)
        response.reply interpolate_message('card_stored', {})
      end

      def stored_bip_balance(response)
        key_user = key_from_user response.user
        card_number = redis.hget(REDIS_KEY, key_user)
        balance_for_card_number(card_number, response)
      end

      private

      def card_number_from_response(response)
        response.matches[0][0]
      end

      def key_from_user(user)
        user.id
      end

      def balance_for_card_number(card_number, response)
        html = post_query_for_card card_number
        data = parse_data_from_html html
        return response.reply interpolate_message('service_down') if data[:balance] =~ /.*mal.*/
        response.reply interpolate_message('actual_balance', data)
      end

      def validate_card_number(card_number)
        card_number =~ /\d{8}/
      end

      def post_query_for_card(card_number)
        conn = Faraday.new(:url => QUERY_URL) do |faraday|
          faraday.request  :url_encoded             # form-encode POST params
          faraday.response :logger                  # log requests to STDOUT
          faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
        end
        response = conn.post '/', { NumTarjeta: card_number, pedirSaldo: '' }, POST_HEADERS
        response.body
      end

      def parse_data_from_html(response)
        tag_data = []
        doc = Nokogiri::HTML(response)
        doc.css(PARSE_SELECTOR).each do |tag|
          tag_data << tag.content
        end
        data = tag_data.empty? ? {} : { balance: tag_data[0], date: tag_data[1] }
        data
      end

      def interpolate_message(key, data={})
        t(key) % data
      end
    end

    Lita.register_handler(ChileanBip)
  end
end

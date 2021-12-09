
require 'nokogiri'
require 'faraday'

module MoexAPI

  class MoexAPIError < StandardError
  end

  class NoSuchTickerError < MoexAPIError
  end

  class NoSuchCurrencyPair < MoexAPIError
  end

  class Client

    API_ENDPOINT = 'https://iss.moex.com'
    API_TICKER_INFO = '/iss/engines/stock/markets/%s/securities/%s.xml'
    API_CURRENCY_INFO = 'https://iss.moex.com/iss/statistics/engines/futures/markets/indicativerates/securities'

    @@_faraday_client

    def self.init
      @@_faraday_client ||= Faraday.new(API_ENDPOINT) do |client|
        client.request :url_encoded
        client.adapter Faraday.default_adapter
      end
    end

    def self.get_info_by_ticker(ticker, market = 'shares')
      response = @@_faraday_client.public_send(:get,API_TICKER_INFO % [market,ticker],{})

      if response.status != 200
        raise MoexAPIError
      end

      doc = Nokogiri.XML(response.body)
      rows = doc.xpath('/document/data/rows/row')

      if rows.length < 2
        raise NoSuchTickerError
      end

      price = rows[1]['PREVPRICE']

      price.to_f
    end

    def self.get_currency_pair(cur1 = 'USD', cur2='RUB')
      response = @@_faraday_client.public_send(:get,API_CURRENCY_INFO,{})

      if response.status != 200
        raise MoexAPIError
      end

      doc = Nokogiri.XML(response.body)
      rows = doc.xpath('/document/data/rows/row')

      res = rows.select {|el| el['secid']=="#{cur1}/#{cur2}"}

      if res.length == 0
        raise NoSuchCurrencyPair
      end

      price = res[0]['rate'].to_f
      price

    end
  end
end

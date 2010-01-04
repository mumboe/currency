# Copyright (C) 2006-2007 Kurt Stephens <ruby-currency(at)umleta.com>
# See LICENSE.txt for details.


require 'rss/rss' # Time#xmlschema


# This class parses a Money value from a String.
# Each Currency has a default Parser.
class Currency::Parser

  SYMBOLS_FOR_PATTERN = Currency::Currency::Factory::UNIQUE_SYMBOLS.collect {|symbol| symbol.split("").collect {|c| c =~ /[a-z]/i ? c : '\\'+c }.join }.join("|")
  VALID_MONEY_PATTERN = /^(([a-zA-z][a-zA-z][a-zA-z])|(#{SYMBOLS_FOR_PATTERN}))?\s*((\d{1,3},?(\d{3},?)*\d{3}(\.\d{0,})?|\d{1,3}(\.\d{0,})?|\.\d{1,}?))\s*(([a-zA-z][a-zA-z][a-zA-z])|(#{SYMBOLS_FOR_PATTERN}))?(\d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d(\.\d+)?Z)?$/

  # The default Currency to use if no Currency is specified.
  attr_accessor :currency

  # If true and a parsed string contains a ISO currency code
  # that is not the same as currency,
  # #parse() will raise IncompatibleCurrency.
  # Defaults to false.
  attr_accessor :enforce_currency

  # The default Time to use if no Time is specified in the string.
  # If :now, time is set to Time.new.
  attr_accessor :time

  @@default = nil
  # Get the default Formatter.
  def self.default
    @@default ||=
      self.new
  end


  # Set the default Formatter.
  def self.default=(x)
    @@default = x
  end
  

  def initialize(opt = { })
    @time =
      @enforce_currency =
      @currency =
      nil
    opt.each_pair{ | k, v | self.send("#{k}=", v) }
  end

  def _parse(str) # :nodoc:
    x = str
    md = nil
    time = nil
    
    convert_currency = nil
    md = VALID_MONEY_PATTERN.match(x)
    if md && !@currency
      symbol = md[3] || md[11]
      code = md[2] || md[10]
      curr = Currency::Currency.get(code ? code.upcase : nil) || (symbol ? Currency::Currency::Factory.get_currency_from_symbol(symbol) : Currency::Currency.default)
      x = md[4]
      time = Time.xmlschema(md[12]) if md[12]
      time ||= @time
      time = Time.new if time == :now
      currency = curr
    else
      currency = @currency || ::Currency::Currency.default
      currency = ::Currency::Currency.get(currency)
    end

    # Remove placeholders and symbol.
    x.gsub!(/[, ]/, '')
    symbol = currency.symbol if symbol.nil?
    x.gsub!(symbol, '') if symbol
    
    # Match: whole Currency value.
    if md = /^([-+]?\d+)\.?$/.match(x)
      x = ::Currency::Money.new_rep(md[1].to_i * currency.scale, currency, @time)
      
    # Match: fractional Currency value.
    elsif md = /^([-+]?)(\d*)\.(\d+)$/.match(x)
      sign = md[1]
      whole = md[2]
      part = md[3]
      
      if part.length != currency.scale
        currency.scale = 10**part.length if part.length > 1
        
        # Pad decimal places with additional '0'
        while part.length < currency.scale_exp
          part << '0'
        end
        
        # Truncate to Currency's decimal size. 
        part = part[0 ... currency.scale_exp]        
      end
      
      # Put the string back together:
      whole = sign + whole + part
      
      x = whole.to_i
      x = ::Currency::Money.new_rep(x, currency, time)
    else
      raise ::Currency::Exception::InvalidMoneyString, 
      [
       "#{str.inspect} #{currency} #{x.inspect}",
       :string, str,
       :currency, currency,
       :state, x,
      ]
    end

    # Do conversion.
    if convert_currency
      x = x.convert(convert_currency)
    end

    x
  end
  
  @@empty_hash = { }
  @@empty_hash.freeze

  # Parse a Money string in this Currency.
  #
  #   "123.45".money       # Using default Currency.
  #   => USD $123.45
  #
  #   "$123.45 USD".money   # Explicit Currency.
  #   => USD $123.45
  #
  #   "CAD 123.45".money
  #   => CAD $123.45
  #  
  #   "123.45 CAD".money(:USD)  # Incompatible explicit Currency.
  #     !!! "123.45 CAD" USD (Currency::Exception::IncompatibleCurrency)
  #
  def parse(str, opt = @@empty_hash)
    prs = self

    unless opt.empty? 
      prs = prs.clone
      opt.each_pair{ | k, v | prs.send("#{k}=", v) }
    end
    
    prs._parse(str)
  end

end # class



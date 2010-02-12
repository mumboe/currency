# encoding: ISO-8859-1
# Copyright (C) 2006-2007 Kurt Stephens <ruby-currency(at)umleta.com>
# See LICENSE.txt for details.


# Responsible for creating Currency::Currency objects on-demand.
class Currency::Currency::Factory
    @@default = nil

    # Returns the default Currency::Factory.
    def self.default
      @@default ||= self.new
    end
    # Sets the default Currency::Factory.
    def self.default=(x)
      @@default = x
    end


    def initialize(*opts)
      @currency_by_code = { }
      @currency_by_symbol = { }
      @currency = nil
    end


    # Lookup Currency by code.
    def get_by_code(x)
      x = ::Currency::Currency.cast_code(x)
      # $stderr.puts "get_by_code(#{x})"
      @currency_by_code[x] ||= install(load(::Currency::Currency.new(x)))
    end


    # Lookup Currency by symbol.
    def get_by_symbol(symbol)
      @currency_by_symbol[symbol] ||= install(load(::Currency::Currency.new(nil, symbol)))
    end


    # This method initializes a Currency object as
    # requested from #get_by_code or #get_by_symbol.
    #
    # This method must initialize:
    #
    #    currency.code
    #    currency.scale
    # 
    # Optionally:
    #
    #    currency.symbol
    #    currency.symbol_html
    #
    # Subclasses that provide Currency metadata should override this method.
    # For example, loading Currency metadata from a database or YAML file.
    def load(currency)
      currency.symbol       = CURRENCY_SYMBOLS[currency.code] ? CURRENCY_SYMBOLS[currency.code][:symbol] : nil
      currency.symbol_html  = CURRENCY_SYMBOLS[currency.code] ? CURRENCY_SYMBOLS[currency.code][:symbol_html] : nil
      currency.scale = 100
      currency
    end

    def self.get_currency_from_symbol(symbol)
      return Currency::Currency.get(:USD) if symbol == "$"
      return Currency::Currency.get(:GBP) if symbol == "£"
      return Currency::Currency.get(:EUR) if symbol == "€"
      CURRENCY_SYMBOLS.sort {|a,b| a.to_s <=> b.to_s}.each do |code, hash|
        return Currency::Currency.get(code) if symbol == hash[:symbol]
      end
      Currency::Currency.default
    end

    CURRENCY_SYMBOLS = {
      :AFN => {:symbol => '؋',    :symbol_html => '&#1547;'},
      :ALL => {:symbol => 'Lek',  :symbol_html => '&#76;&#101;&#107;'},
      :ANG => {:symbol => 'ƒ',    :symbol_html => '&#402;'},
      :ARS => {:symbol => '$',    :symbol_html => '&#36;'},
      :AUD => {:symbol => '$',    :symbol_html => '&#36;'},
      :AWG => {:symbol => 'ƒ',    :symbol_html => '&#402;'},
      :AZN => {:symbol => 'ман',  :symbol_html => '&#1084;&#1072;&#1085;'},
      :BAM => {:symbol => 'KM',   :symbol_html => '&#75;&#77;'},
      :BBD => {:symbol => '$',    :symbol_html => '&#36;'},
      :BGN => {:symbol => 'лв',   :symbol_html => '&#1083;&#1074;'},
      :BMD => {:symbol => '$',    :symbol_html => '&#36;'},
      :BND => {:symbol => '$',    :symbol_html => '&#36;'},
      :BOB => {:symbol => '$b',   :symbol_html => '&#36;&#98;'},
      :BRL => {:symbol => 'R$',   :symbol_html => '&#82;&#36;'},
      :BSD => {:symbol => '$',    :symbol_html => '&#36;'},
      :BWP => {:symbol => 'P',    :symbol_html => '&#80;'},
      :BYR => {:symbol => 'p.',   :symbol_html => '&#112;&#46;'},
      :BZD => {:symbol => 'BZ$',  :symbol_html => '&#66;&#90;&#36;'},
      :CAD => {:symbol => '$',    :symbol_html => '&#36;'},
      :CHF => {:symbol => 'CHF',  :symbol_html => '&#67;&#72;&#70;'},
      :CLP => {:symbol => '$',    :symbol_html => '&#36;'},
      :CNY => {:symbol => '¥',    :symbol_html => '&#165;'},
      :COP => {:symbol => '$',    :symbol_html => '&#36;'},
      :CRC => {:symbol => '₡',    :symbol_html => '&#8353;'},
      :CUP => {:symbol => '₱',    :symbol_html => '&#8369;'},
      :CZK => {:symbol => 'Kč',   :symbol_html => '&#75;&#269;'},
      :DKK => {:symbol => 'kr',   :symbol_html => '&#107;&#114;'},
      :DOP => {:symbol => 'RD$',  :symbol_html => '&#82;&#68;&#36;'},
      :EEK => {:symbol => 'kr',   :symbol_html => '&#107;&#114;'},
      :EGP => {:symbol => '£',    :symbol_html => '&#163;'},
      :EUR => {:symbol => '€',    :symbol_html => '&#8364;'},
      :FJD => {:symbol => '$',    :symbol_html => '&#36;'},
      :FKP => {:symbol => '£',    :symbol_html => '&#163;'},
      :GBP => {:symbol => '£',    :symbol_html => '&#163;'},
      :GGP => {:symbol => '£',    :symbol_html => '&#163;'},
      :GHC => {:symbol => '¢',    :symbol_html => '&#162;'},
      :GIP => {:symbol => '£',    :symbol_html => '&#163;'},
      :GTQ => {:symbol => 'Q',    :symbol_html => '&#81;'},
      :GYD => {:symbol => '$',    :symbol_html => '&#36;'},
      :HKD => {:symbol => '$',    :symbol_html => '&#36;'},
      :HNL => {:symbol => 'L',    :symbol_html => '&#76;'},
      :HRK => {:symbol => 'kn',   :symbol_html => '&#107;&#110;'},
      :HUF => {:symbol => 'Ft',   :symbol_html => '&#70;&#116;'},
      :IDR => {:symbol => 'Rp',   :symbol_html => '&#82;&#112;'},
      :ILS => {:symbol => '₪',    :symbol_html => '&#8362;'},
      :IMP => {:symbol => '£',    :symbol_html => '&#163;'},
      :INR => {:symbol => '₨',    :symbol_html => '&#8360;'},
      :IRR => {:symbol => '﷼',    :symbol_html => '&#65020;'},
      :ISK => {:symbol => 'kr',   :symbol_html => '&#107;&#114;'},
      :JEP => {:symbol => '£',    :symbol_html => '&#163;'},
      :JMD => {:symbol => 'J$',   :symbol_html => '&#74;&#36;'},
      :JPY => {:symbol => '¥',    :symbol_html => '&#165;'},
      :KGS => {:symbol => 'лв',   :symbol_html => '&#1083;&#1074;'},
      :KHR => {:symbol => '៛',    :symbol_html => '&#6107;'},
      :KPW => {:symbol => '₩',    :symbol_html => '&#8361;'},
      :KRW => {:symbol => '₩',    :symbol_html => '&#8361;'},
      :KYD => {:symbol => '$',    :symbol_html => '&#36;'},
      :KZT => {:symbol => 'лв',   :symbol_html => '&#1083;&#1074;'},
      :LAK => {:symbol => '₭',    :symbol_html => '&#8365;'},
      :LBP => {:symbol => '£',    :symbol_html => '&#163;'},
      :LKR => {:symbol => '₨',    :symbol_html => '&#8360;'},
      :LRD => {:symbol => '$',    :symbol_html => '&#36;'},
      :LTL => {:symbol => 'Lt',   :symbol_html => '&#76;&#116;'},
      :LVL => {:symbol => 'Ls',   :symbol_html => '&#76;&#115;'},
      :MKD => {:symbol => 'ден',  :symbol_html => '&#1076;&#1077;&#1085;'},
      :MNT => {:symbol => '₮',    :symbol_html => '&#8366;'},
      :MUR => {:symbol => '₨',    :symbol_html => '&#8360;'},
      :MXN => {:symbol => '$',    :symbol_html => '&#36;'},
      :MYR => {:symbol => 'RM',   :symbol_html => '&#82;&#77;'},
      :MZN => {:symbol => 'MT',   :symbol_html => '&#77;&#84;'},
      :NAD => {:symbol => '$',    :symbol_html => '&#36;'},
      :NGN => {:symbol => '₦',    :symbol_html => '&#8358;'},
      :NIO => {:symbol => 'C$',   :symbol_html => '&#67;&#36;'},
      :NOK => {:symbol => 'kr',   :symbol_html => '&#107;&#114;'},
      :NPR => {:symbol => '₨',    :symbol_html => '&#8360;'},
      :NZD => {:symbol => '$',    :symbol_html => '&#36;'},
      :OMR => {:symbol => '﷼',    :symbol_html => '&#65020;'},
      :PAB => {:symbol => 'B/.',  :symbol_html => '&#66;&#47;&#46;'},
      :PEN => {:symbol => 'S/.',  :symbol_html => '&#83;&#47;&#46;'},
      :PHP => {:symbol => 'Php',  :symbol_html => '&#80;&#104;&#112;'},
      :PKR => {:symbol => '₨',    :symbol_html => '&#8360;'},
      :PLN => {:symbol => 'zł',   :symbol_html => '&#122;&#322;'},
      :PYG => {:symbol => 'Gs',   :symbol_html => '&#71;&#115;'},
      :QAR => {:symbol => '﷼',    :symbol_html => '&#65020;'},
      :RON => {:symbol => 'lei',  :symbol_html => '&#108;&#101;&#105;'},
      :RSD => {:symbol => 'Дин.', :symbol_html => '&#1044;&#1080;&#1085;&#46;'},
      :RUB => {:symbol => 'руб',  :symbol_html => '&#1088;&#1091;&#1073;'},
      :SAR => {:symbol => '﷼',    :symbol_html => '&#65020;'},
      :SBD => {:symbol => '$',    :symbol_html => '&#36;'},
      :SCR => {:symbol => '₨',    :symbol_html => '&#8360;'},
      :SEK => {:symbol => 'kr',   :symbol_html => '&#107;&#114;'},
      :SGD => {:symbol => '$',    :symbol_html => '&#36;'},
      :SHP => {:symbol => '£',    :symbol_html => '&#163;'},
      :SOS => {:symbol => 'S',    :symbol_html => '&#83;'},
      :SRD => {:symbol => '$',    :symbol_html => '&#36;'},
      :SVC => {:symbol => '$',    :symbol_html => '&#36;'},
      :SYP => {:symbol => '£',    :symbol_html => '&#163;'},
      :THB => {:symbol => '฿',    :symbol_html => '&#3647;'},
      :TRL => {:symbol => '₤',    :symbol_html => '&#8356;'},
      :TRY => {:symbol => 'TL',   :symbol_html => '&#84;&#76;'},
      :TTD => {:symbol => 'TT$',  :symbol_html => '&#84;&#84;&#36;'},
      :TVD => {:symbol => '$',    :symbol_html => '&#36;'},
      :TWD => {:symbol => 'NT$',  :symbol_html => '&#78;&#84;&#36;'},
      :UAH => {:symbol => '₴',    :symbol_html => '&#8372;'},
      :USD => {:symbol => '$',    :symbol_html => '&#36;'},
      :UYU => {:symbol => '$U',   :symbol_html => '&#36;&#85;'},
      :UZS => {:symbol => 'лв',   :symbol_html => '&#1083;&#1074;'},
      :VEF => {:symbol => 'Bs',   :symbol_html => '&#66;&#115;'},
      :VND => {:symbol => '₫',    :symbol_html => '&#8363;'},
      :XCD => {:symbol => '$',    :symbol_html => '&#36;'},
      :YER => {:symbol => '﷼',    :symbol_html => '&#65020;'},
      :ZAR => {:symbol => 'R',    :symbol_html => '&#82;'},
      :ZWD => {:symbol => 'Z$',   :symbol_html => '&#90;&#36;'},
    }

    UNIQUE_SYMBOLS = CURRENCY_SYMBOLS.collect {|code, symbol| symbol[:symbol]}.uniq
    CODES = CURRENCY_SYMBOLS.collect {|code, symbol| code}

    # Installs a new Currency for #get_by_symbol and #get_by_code.
    def install(currency)
      raise ::Currency::Exception::UnknownCurrency unless currency
      @currency_by_symbol[currency.symbol] ||= currency unless currency.symbol.nil?
      @currency_by_code[currency.code] = currency
    end


    # Returns the default Currency.
    # Defaults to self.get_by_code(:USD).
    def currency
      @currency ||= self.get_by_code(:USD)
    end


    # Sets the default Currency.
    def currency=(x)
      @currency = x
    end


    # If selector is [A-Z][A-Z][A-Z], load the currency.
    #
    #   factory.USD
    #   => #<Currency::Currency:0xb7d0917c @formatter=nil, @scale_exp=2, @scale=100, @symbol="$", @format_left=-3, @code=:USD, @parser=nil, @format_right=-2>
    #
    def method_missing(sel, *args, &blk)
      if args.size == 0 && (! block_given?) && /^[A-Z][A-Z][A-Z]$/.match(sel.to_s)
        self.get_by_code(sel)
      else
        super
      end
    end

end # class




# various tests to verify latest revisions
require "test/test_base"
require 'currency'
module Currency

  class StringTest < TestBase
    def setup
      super
    end
  
    def test_beginning_with_code
      assert_equal "¥424,535,953.00", "CNY424,535,953".money.to_s
    end
  
    def test_beginning_with_symbol
      assert_equal "₡42,525,924.87", "₡ 42525924.87".money.to_s
    end
  
    def test_ending_with_code
      assert_equal "₱324,402,482.00", "324402482 CUP".money.to_s
    end
  
    def test_ending_with_symbol
      assert_equal "IRR 2,445.00", "2445﷼".money.to_s(:symbol => false, :code => true)
    end
  
    def test_unknown_code
      assert_equal "CFA 15,000.00", "15000CFA".money.to_s(:symbol => true, :code => true)
    end
  
    def test_invalid_symbol
      assert_raise ::Currency::Exception::InvalidMoneyString do
        "Σ424,000".money
      end
    end
  
    def test_invalid_format
      assert_raise ::Currency::Exception::InvalidMoneyString do
        "17 dollars".money
      end
    end
  
    def test_does_not_truncate_precision
      assert_equal "$425.002", "425.002".money.to_s
    end
  
    def test_pads_precision
      assert_equal "$0.50", "0.5".money.to_s
    end
  
    def test_string_number
      m = "10.12".money*100
      assert_equal "$1,012.00", m.to_s
    end
    
    def test_float_number
      m = 10.12.money*100
      assert_equal "$1,012.00", m.to_s
    end
    
    def test_bigdecimal
      assert (BigDecimal.new("1.2") - BigDecimal("1.0")) == BigDecimal("0.2")
    end
   
    def test_side_effects
      m = "1000.00".money
      s = "500.000".money
      assert_equal "$1,000.00", m.to_s
    end
    
    def test_app_string_not_money
      value = "xxxx"
      assert_raise(::Currency::Exception::InvalidMoneyString) {
        ::Currency.Money(value).to_s(:symbol => false, :code => true).split
      }
    end
    
    def test_app_money_string
      value = "1000"
      arr = ::Currency.Money(value).to_s(:symbol => false, :code => true).split
      assert_equal 'USD', arr[0]
      assert_equal '1,000.00', arr[1]
    end
    
    def test_app_money_string_with_decimals
      value = "1000.234"
      arr = ::Currency.Money(value).to_s(:symbol => false, :code => true).split
      assert_equal 'USD', arr[0]
      assert_equal '1,000.234', arr[1]
    end
    
    def test_app_money_string_with_dollar
      value = "$1000.234"
      arr = ::Currency.Money(value).to_s(:symbol => false, :code => true).split
      assert_equal 'USD', arr[0]
      assert_equal '1,000.234', arr[1]
    end
    
    def test_app_money_string_with_yuan
      value = "¥1000.234"
      arr = ::Currency.Money(value).to_s(:symbol => false, :code => true).split
      assert_equal 'CNY', arr[0]
      assert_equal '1,000.234', arr[1]
    end
    
    def test_money_string_to_f
      value = "1000.234"
      f =::Currency.Money(value).to_f
      assert_equal 1000.234, f
    end
    
    def test_money_int_to_f
      value = 1000
      f =::Currency.Money(value).to_f
      assert_equal 1000.0, f
    end
    
    def test_money_to_f
      value = "$1000.234"
      f =::Currency.Money(value).to_f
      assert_equal 1000.234, f
    end
    
    def test_money_with_1_decimal_to_f
      value = "$1000.2"
      f =::Currency.Money(value).to_f
      assert_equal 1000.2, f
    end
  end

end
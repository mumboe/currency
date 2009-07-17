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
  
  end

end
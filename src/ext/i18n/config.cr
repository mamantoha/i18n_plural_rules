module I18n
  class Config
    @plural_rules = Hash(String, Proc(Int32, Symbol)).new(->(n : Int32) { n == 1 ? :one : :other })

    def plural_rules
      @plural_rules
    end
  end
end

require "./spec_helper"

describe "plural rules" do
  context "with default pluralization rule" do
    it "pluralization translate 0" do
      I18n.translate("new_message", count: 0).should(eq("tem 0 novas mensagens"))
    end

    it "pluralization translate 1" do
      I18n.translate("new_message", count: 1).should(eq("tem uma nova mensagem"))
    end

    it "pluralization translate 2" do
      tr = I18n.translate("new_message", count: 2)
      tr.should(eq("tem 2 novas mensagens"))
    end
  end

  context "with custom plural rules" do
    custom_plural_rule = ->(n : Int32) {
      case n
      when 0 then :zero
      when 1 then :one
      else        :other
      end
    }

    before_each do
      I18n.plural_rules["en"] = custom_plural_rule
      I18n.plural_rules["pt"] = custom_plural_rule
    end

    after_each do
      I18n.plural_rules.clear
    end

    it "pluralization translate 0" do
      I18n.translate("new_message", count: 0).should(eq("não tem mensagens"))
    end

    it "pluralization translate 1" do
      I18n.translate("new_message", count: 1).should(eq("tem uma nova mensagem"))
    end

    it "pluralization translate 2" do
      tr = I18n.translate("new_message", count: 2)
      tr.should(eq("tem 2 novas mensagens"))
    end

    it "pluralization translate 0 with force_locale" do
      I18n.translate("new_message", count: 0, force_locale: "en").should(eq("you have no messages"))
    end

    it "pluralization translate 0 with with_locale" do
      (I18n.with_locale("en") { I18n.translate("new_message", count: 0) }).should(eq("you have no messages"))
    end
  end
end

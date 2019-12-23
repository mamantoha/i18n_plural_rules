require "spec"
require "i18n"
require "../src/i18n_plural_rules"

I18n.load_path += %w(spec/**)
I18n.locale = "pt"
I18n.init

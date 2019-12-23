module I18n
  module Backend
    class Yaml < I18n::Backend::Base
      def translate(locale : String, key : String, options : Hash | NamedTuple? = EMPTY_HASH, count = nil, default = nil, iter = nil) : String
        key += key_with_count(locale, count) if count

        tr = @translations[locale][key]? || default
        unless tr
          return I18n.exception_handler.call(
            MissingTranslation.new(locale, key),
            locale,
            key,
            options,
            count,
            default
          )
        end

        return tr[iter].to_s if tr && iter && tr.is_a?(YAML::Any)

        tr = tr.to_s
        tr = tr.sub(/\%{count}/, count) if count
        return tr unless options
        options.each do |attr, value|
          tr = tr.gsub(/\%{#{attr}}/, value)
        end
        tr
      end

      private def key_with_count(locale, count)
        ".#{I18n.plural_rules[locale].call(count)}"
      end
    end
  end
end

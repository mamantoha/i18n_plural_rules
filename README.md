# i18n_plural_rules

[![Build Status](https://travis-ci.org/mamantoha/i18n_plural_rules.svg?branch=master)](https://travis-ci.org/mamantoha/i18n_plural_rules)

Custom plural rules support for [i18n.cr](https://github.com/TechMagister/i18n.cr) library.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     i18n_plural_rules:
       github: mamantoha/i18n_plural_rules
   ```

2. Run `shards install`

## Usage

```crystal
require "i18n"
require "i18n_plural_rules"
```

## Pluralization

In many languages — including English — there are only two forms, a singular and a plural, for a given string, e.g. "1 message" and "2 messages". Other languages (Arabic, Japanese, Russian and many more) have different grammars that have additional or fewer plural forms. Thus, the `i18n_plural_rules` adds a flexible pluralization feature.

By default the translation denoted as `:one` is regarded as singular, and the `:other` is used as plural.

The `count` interpolation variable has a special role in that it both is interpolated to the translation and used to pick a pluralization from the translations according to the pluralization rules defined by CLDR:

```yaml
message:
  one: "%{count} message"
  other: "%{count} messages"
```

```crystal
I18n.translate("message", count: 1) # 1 message
I18n.translate("message", count: 2) # 2 messages
I18n.translate("message", count: 0) # 0 messages
```

> `count` should be passed as argument - not inside of `options`. Otherwise regular translation lookup will be applied.

The `i18n_plural_rules` shard adds a `plural_rules` method to `i18n` that can be used to add locale-specific rules.

```crystal
I18n.plural_rules["ru"] = ->(n : Int32) {
  if n == 0
    :zero
  elsif ((n % 10) == 1) && ((n % 100 != 11))
    # 1, 21, 31, 41, 51, 61...
    :one
  elsif ([2, 3, 4].includes?(n % 10) && ![12, 13, 14].includes?(n % 100))
    # 2-4, 22-24, 32-34...
    :few
  elsif ((n % 10) == 0 || ![5, 6, 7, 8, 9].includes?(n % 10) || ![11, 12, 13, 14].includes?(n % 100))
    # 0, 5-20, 25-30, 35-40...
    :many
  else
    :other
  end
}
```

```yaml
kid:
  zero: 'нет детей'
  one: '%{count} ребенок'
  few: '%{count} ребенка'
  many: '%{count} детей'
  other: '%{count} детей'
```

```crystal
I18n.locale = "ru"

I18n.translate("kid", count: 0) # нет детей
I18n.translate("kid", count: 1) # 1 ребенок
I18n.translate("kid", count: 2) # 2 ребенка
I18n.translate("kid", count: 6) # 6 детей
```

## Contributing

1. Fork it (<https://github.com/mamantoha/i18n_plural_rules/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Anton Maminov](https://github.com/mamantoha) - creator and maintainer

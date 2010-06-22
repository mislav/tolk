module Tolk
  module Import
    def self.included(base)
      base.send :extend, ClassMethods
    end

    module ClassMethods
      def import_secondary_locales
        locales = I18n.available_locales - [self.primary_locale.name.to_sym]
        phrases = Tolk::Phrase.all
        locales.each {|name| import_locale(name.to_s, phrases) }
      end

      def import_locale(locale_name, phrases)
        locale = Tolk::Locale.find_or_create_by_name(locale_name)
        data = load_translations(locale.name.to_sym)
        count = 0

        data.each do |key, value|
          phrase = phrases.detect {|p| p.key == key}

          if phrase
            translation = phrase.translations.detect {|t| t.locale_id == locale.id }
            translation ||= locale.translations.new(:phrase => phrase)
            translation.text = value
            count += 1 if (translation.new_record? or translation.changed?) and translation.save
          else
            puts %([ERROR] Key '%s' was found in "%s" locale but the %s translation is missing) %
              [key, locale_name, Tolk::Locale.primary_language_name]
          end
        end

        puts %([INFO] Imported #{count} keys from "#{locale_name}" locale)
      end
    end
  end
end

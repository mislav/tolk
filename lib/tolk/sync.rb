module Tolk
  module Sync
    def self.included(base)
      base.send :extend, ClassMethods
    end

    module ClassMethods
      def sync!
        sync_phrases filter_out_i18n_keys(load_translations)
      end

      def load_translations(name = primary_locale.name.to_sym)
        I18n.available_locales # force load
        flat_hash(I18n.backend.send(:translations)[name])
      end

      def flat_hash(data, prefix = '', result = {})
        data.each do |key, value|
          current_prefix = prefix.present? ? "#{prefix}.#{key}" : key

          if !value.is_a?(Hash) || Tolk::Locale.pluralization_data?(value)
            result[current_prefix] = value.respond_to?(:stringify_keys) ? value.stringify_keys : value
          else
            flat_hash(value, current_prefix, result)
          end
        end

        result.stringify_keys
      end

      private

      def sync_phrases(translations)
        primary_locale = self.primary_locale
        secondary_locales = self.secondary_locales

        if translations.present?
          # Handle deleted phrases
          Tolk::Phrase.destroy_all(["tolk_phrases.key NOT IN (?)", translations.keys])
        else
          Tolk::Phrase.destroy_all
        end

        phrases = Tolk::Phrase.all

        translations.each do |key, value|
          # Create phrase and primary translation if missing
          existing_phrase = phrases.detect {|p| p.key == key} || Tolk::Phrase.create!(:key => key)
          translation = existing_phrase.translations.primary || primary_locale.translations.build(:phrase_id => existing_phrase.id)
          translation.text = value

          if translation.changed? && !translation.new_record?
            # Set the primary updated flag if the primary translation has changed and it is not a new record.
            secondary_locales.each do |locale|
              if existing_translation = existing_phrase.translations.detect {|t| t.locale_id == locale.id }
                existing_translation.force_set_primary_update = true
                existing_translation.save!
              end
            end
          end

          translation.primary = true
          translation.save!
        end
      end

      def filter_out_i18n_keys(flat_hash)
        flat_hash.reject { |key, value| key.starts_with? "i18n" }
      end
    end
  end
end

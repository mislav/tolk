require 'test_helper'
require 'stringio'

class ImportTest < ActiveSupport::TestCase
  def setup
    I18n.backend.reload!
    I18n.available_locales = nil
    I18n.load_path = [Rails.root + 'test/locales/basic/se.yml']

    Tolk::Locale.primary_locale_name = 'en'
    Tolk::Locale.primary_locale(true)
  end

  test "translation for a secondary locale overrides version in the database" do
    locale = tolk_locales(:se)
    phrase = tolk_phrases(:hello_world)
    translation = phrase.translations.for(locale)
    translation.update_attribute(:text, "Obsolete Hejsan Verdon")
    translations_count = locale.translations.count
    
    out = capture_output { Tolk::Locale.import_secondary_locales }
    
    assert_equal "Hejsan Verdon", translation.reload.text
    assert_equal %([INFO] Imported 1 keys from "se" locale\n), out
    assert_equal translations_count, locale.translations.count
  end
  
  private
  
  def capture_output
    stream = StringIO.new
    old_stdout = $stdout
    old_stderr = $stderr
    $stdout = $stderr = stream
    begin
      yield
      stream.string
    ensure
      $stdout = old_stdout
      $stderr = old_stderr
    end
  end
end

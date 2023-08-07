module Translatable
  extend ActiveSupport::Concern

  module ClassMethods
    def translates(*args)
      args.map do |arg|
        define_method arg do
          send([arg, I18n.locale].join('_')).presence || send([arg, I18n.default_locale].join('_'))
        end
      end
    end
  end
end

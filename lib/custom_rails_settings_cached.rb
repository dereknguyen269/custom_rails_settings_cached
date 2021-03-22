# frozen_string_literal: true

require_relative "custom_rails_settings_cached/version"

module CustomRailsSettingsCached
  extend RailsSettings::Extend
  extend ActiveSupport::Concern

  included do
    has_many :settings, as: :thing

    def get_settings(name)
      if has_associations_with_rails_settings
        st = settings.find_by var: setting_key(name)
        st&.value
      else
        Setting[setting_key(name)]
      end
    end

    def init_setting(name, value)
      if has_associations_with_rails_settings
        st = settings.find_or_initialize_by(var: setting_key(name))
        st.value = value
        st.save
      else
        Setting[setting_key(name)] = value
      end
    end

    def setting_key(name)
      return name.to_s.underscore if has_associations_with_rails_settings
      "#{self.class.name}.#{self.id}.#{name}".underscore
    end

    def settings_as_object
      data = { partner_id: self.id }
      settings.each do |st|
        data[pretty_key(st.var)] = st.value
      end
      OpenStruct.new data
    end

    def pretty_key(key_name)
      key_name.split('.').last
    end

    def has_associations_with_rails_settings
      return @has_rails_settings unless @has_rails_settings.nil?
      associations = self.class.reflect_on_all_associations(:has_many)
      @has_rails_settings = associations.any? { |a| a.name == :settings }
    end

    if defined?(self::CUSTOM_RAILS_SETTINGS_KEYS)
      build_custom_settings_methods self::CUSTOM_RAILS_SETTINGS_KEYS
    end
  end

  module ClassMethods
    def build_custom_settings_methods(custom_settings)
      if custom_settings.is_a?(Array)
        # Exam:
        # CUSTOM_RAILS_SETTINGS_KEYS = [:google_analytics, :facebook_pixel_ads]
        custom_settings.each do |setting_key|
          if setting_key.is_a?(Symbol)
            self.define_method "#{setting_key}" do
              self.get_settings setting_key
            end
            self.define_method "#{setting_key}=" do |setting_value|
              self.init_setting(setting_key, setting_value)
            end
          else
            self.build_custom_settings_methods setting_key
          end
        end
      elsif custom_settings.is_a?(Hash)
        # Exam:
        # CUSTOM_RAILS_SETTINGS_KEYS = {
        #   google_analytics: [:enabled, :tracking_code],
        #   facebook_pixel_ads: [:enabled, :tracking_code]
        # }
        custom_settings.each do |k, v|
          if v.is_a?(Array)
            v.each do |setting_key|
              # Use: Partner.first.google_analytics_enabled
              store_setting_key = "#{k}_#{setting_key}"
              self.define_method store_setting_key do
                self.get_settings store_setting_key
              end
              # Use: Partner.first.google_analytics_enabled = true
              self.define_method "#{store_setting_key}=" do |setting_value|
                self.init_setting(store_setting_key, setting_value)
              end
            end
          elsif v.is_a?(Symbol)
            # Use: Partner.first.google_analytics
            self.define_method "#{v}" do
              self.get_settings v
            end
            self.define_method "#{v}=" do |setting_value|
              self.init_setting(v, setting_value)
            end
          end
        end
      end
    end
  end
end

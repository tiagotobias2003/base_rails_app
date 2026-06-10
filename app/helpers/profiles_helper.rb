module ProfilesHelper
  def field_classes
    "w-full rounded-lg border border-slate-300 bg-white px-3 py-2 text-sm text-slate-800 shadow-sm focus:border-brand-300 focus:outline-none focus:ring-2 focus:ring-brand-500/10 dark:border-slate-700 dark:bg-slate-900 dark:text-slate-100 dark:focus:border-brand-800"
  end

  def profile_enum_label(model, enum_name, value)
    return if value.blank?

    key = value.is_a?(Integer) ? model.public_send(enum_name.to_s.pluralize).key(value) : value.to_s

    I18n.t(
      "activerecord.enums.#{model.model_name.i18n_key}.#{enum_name}.#{key}",
      default: key.humanize
    )
  end

  def profile_enum_options(model, enum_name)
    model.public_send(enum_name.to_s.pluralize).keys.map do |key|
      [ profile_enum_label(model, enum_name, key), key ]
    end
  end
end

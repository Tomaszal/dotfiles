{
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";

  # Enable all locales
  i18n.supportedLocales = ["all"];

  # Disable natural sort order
  i18n.extraLocaleSettings.LC_COLLATE = "C";
}

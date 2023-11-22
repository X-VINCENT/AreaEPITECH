import i18n from 'i18next';
import {initReactI18next} from 'react-i18next';
import LanguageDetector from 'i18next-browser-languagedetector';
import fr from './fr';
import en from './en';

// @ts-ignore
i18n
  .use(initReactI18next)
  .use(LanguageDetector)
  .init({
    react: {
      useSuspense: false
    },
    fallbackLng: 'en',
    fallbackNS: 'common',
    debug: false,
    returnObjects: true,
    interpolation: {
      escapeValue: false,
      format: function(value: string, format: string) {
        if (value) {
          if (format === 'uppercase') return value.toUpperCase();
          if (format === 'lowercase') return value.toLowerCase();
          if (format === 'capitalize') return (value.charAt(0).toUpperCase() + value.slice(1));
          return value;
        }
      },
    },
    parseMissingKeyHandler: () => null,
    resources: {fr, en},
  })
  .catch((e) => {
    console.error(e);
  });

export default i18n;

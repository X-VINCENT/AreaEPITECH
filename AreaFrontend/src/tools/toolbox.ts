import moment from 'moment';
import 'moment/dist/locale/fr';
import i18n from "i18next";
import {useTranslation} from "react-i18next";

const capitalize = (string: string) => string.charAt(0).toUpperCase() + string.slice(1);

const lang = localStorage.getItem("language") || i18n.language;

const getElapsedTimeLabel = (date: string) => {
  // eslint-disable-next-line react-hooks/rules-of-hooks
  const {t} = useTranslation('tools');
  const currentDate = new Date();
  // @ts-ignore
  const timeDifference = currentDate - new Date(date);
  const dateFormat = lang === 'fr-FR' ? 'DD MMM, YYYY, HH:mm' : 'MMM DD, YYYY, h:mm A';
  const timeFormat = lang === 'fr-FR' ? 'HH:mm' : 'h:mm A';
  const locale = lang === 'fr-FR' ? 'fr' : 'en';

  const minutesDifference = Math.floor(timeDifference / (1000 * 60));
  const hoursDifference = Math.floor(timeDifference / (1000 * 60 * 60));
  const daysDifference = Math.floor(timeDifference / (1000 * 60 * 60 * 24));
  const weeksDifference = Math.floor(timeDifference / (1000 * 60 * 60 * 24 * 7));

  if (weeksDifference >= 1)
    return moment(date).locale(locale).format(dateFormat);
  else if (hoursDifference > 24)
    return t('tools.elapsedTimeLabel.days-difference', {
      days: t('tools.elapsedTimeLabel.day-with-count', {count: daysDifference + 1}),
      time: moment(date).locale(locale).format(timeFormat)
    });
  else if (daysDifference === 1 || (hoursDifference >= 1 && currentDate.getDate() !== new Date(date).getDate()))
    return `${t('tools.elapsedTimeLabel.yesterday')}, ${moment(date).locale(locale).format(timeFormat)}`;
  else if (hoursDifference >= 1)
    return `${t('tools.elapsedTimeLabel.today')}, ${moment(date).locale(locale).format(timeFormat)}`;
  else if (minutesDifference >= 1)
    return t('tools.elapsedTimeLabel.minutes-difference', {minutes: minutesDifference});
  else
    return t('tools.elapsedTimeLabel.just-now');
}

export {
  capitalize,
  getElapsedTimeLabel,
};

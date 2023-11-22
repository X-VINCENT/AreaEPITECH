import React, {useId} from 'react';
import './index.scss';
import DatePicker, {registerLocale} from "react-datepicker";
import i18n, {t} from "i18next";
import fr from "date-fns/locale/fr";
import en from "date-fns/locale/en-US";
registerLocale("fr-FR", fr);
registerLocale("en-US", en);

interface DateTimePickerProps {
  date: Date;
  label?: string;
  optional?: boolean;
  placeholder?: string;
  onChange: (date: Date) => void;
  [key: string]: any;
}

const DateTimePicker: React.FC<DateTimePickerProps> = ({
  date,
  label,
  optional,
  placeholder,
  onChange,
  ...props
}) => {
  const id = useId();

  return (
    <div className="DateTimePicker">
      {label
        ? <label htmlFor={id}>{`${label} ${optional ? `(${t('optional')})` : ''}`}</label>
        : null
      }
      <DatePicker
        id={id}
        selected={date}
        placeholderText={placeholder}
        onChange={onChange}
        locale={localStorage.getItem("language") || i18n.language}
        showTimeSelect
        dateFormat="Pp"
        timeFormat="p"
        timeIntervals={15}
        timeCaption="time"
        {...props}
      />
    </div>
  );
};

export default DateTimePicker;

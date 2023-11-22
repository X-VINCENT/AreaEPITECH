import React, {useId, useState} from 'react';
import './index.scss';
import {t} from "i18next";

interface TextAreaProps {
  name?: string;
  value: string;
  onChange: (newValue: string) => void;
  placeholder?: string;
  error?: string;
  disabled?: boolean;
  optional?: boolean;
  label?: string;
  bottomContent?: string;
  fixedLabel?: boolean;
}

const TextArea: React.FC<TextAreaProps> = ({
  name,
  value,
  onChange,
  placeholder,
  error,
  disabled,
  optional = false,
  label,
  bottomContent,
  fixedLabel,
}) => {
  const id = useId();
  const [isFocused, setIsFocused] = useState<boolean>(false);

  return (
    <div className={`TextArea ${error ? 'error' : ''} ${disabled ? 'disabled' : ''} ${optional ? 'optional' : ''} ${isFocused ? 'focused' : ''} ${label ? 'has-label' : ''} ${value ? 'has-value' : ''} ${fixedLabel ? 'fixed-label' : ''}`}>
      {label
        ? <label htmlFor={id}>{`${label} ${optional ? `(${t('optional')})` : ''}`}</label>
        : null
      }
      <div className="textarea-wrapper">
        <textarea
          name={name}
          id={id}
          value={value}
          onChange={(e) => onChange(e.target.value)}
          placeholder={placeholder}
          required={!optional}
          disabled={disabled}
          onFocus={() => setIsFocused(true)}
          onBlur={() => setIsFocused(false)}
        />
      </div>
      {error
        ? <span className="error">{error}</span>
        : null
      }
      {bottomContent
        ? <span className="bottom-content">{bottomContent}</span>
        : null
      }
    </div>
  );
};

export default TextArea;

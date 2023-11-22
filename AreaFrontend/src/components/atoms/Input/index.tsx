import React, {HTMLInputTypeAttribute, useId, useState} from 'react';
import './index.scss';
import {t} from "i18next";

interface InputProps {
  name?: string;
  value: string;
  onChange: (newValue: string) => void;
  placeholder?: string;
  type?: HTMLInputTypeAttribute;
  error?: string;
  disabled?: boolean;
  optional?: boolean;
  label?: string;
  bottomContent?: string;
  fixedLabel?: boolean;
  [key: string]: any;
}

const Input: React.FC<InputProps> = ({
  name,
  value,
  onChange,
  placeholder,
  type = 'text',
  error,
  disabled,
  optional,
  label,
  bottomContent,
  fixedLabel,
  ...props
}) => {
  const id = useId();
  const [isFocused, setIsFocused] = useState<boolean>(false);
  const [localType, setLocalType] = useState<HTMLInputTypeAttribute>(type);

  const toggleType = () => {
    if (disabled)
      return;
    setLocalType(prevState => prevState === 'password' ? 'text' : 'password')
  }

  return (
    <div className={`Input ${error ? 'error' : ''} ${disabled ? 'disabled' : ''} ${optional ? 'optional' : ''} ${isFocused ? 'focused' : ''} ${label ? 'has-label' : ''} ${value ? 'has-value' : ''} ${fixedLabel ? 'fixed-label' : ''}`}>
      {label
        ? <label htmlFor={id}>{`${label} ${optional ? `(${t('optional')})` : ''}`}</label>
        : null
      }
      <div className="input-wrapper">
        <input
          name={name}
          id={id}
          type={localType}
          value={value}
          onChange={(e) => onChange(e.target.value)}
          placeholder={placeholder}
          required={!optional}
          disabled={disabled}
          onFocus={() => setIsFocused(true)}
          onBlur={() => setIsFocused(false)}
          {...props}
        />
        {type === 'password' && value
          ? <button className="toggle-type" onClick={toggleType}>
              {t('capitalize', {value: localType === 'password' ? t('show') : t('hide')})}
            </button>
          : null
        }
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

export default Input;

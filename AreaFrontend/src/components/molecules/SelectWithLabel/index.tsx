import React, {useState} from 'react';
import './index.scss';
import {FontAwesomeIcon} from "@fortawesome/react-fontawesome";
import {faCaretDown} from "@fortawesome/free-solid-svg-icons";

interface Option {
  value: string | number;
  label: string;
  color: string;
}

interface SelectWithLabelProps {
  className?: string;
  disabled?: boolean;
  onChange: (value: string | number) => void;
  label: string;
  value: string | number;
  options: string[] | number[] | Option[];
}

const SelectWithLabel: React.FC<SelectWithLabelProps> = ({
  className,
  disabled,
  onChange,
  label,
  value,
  options,
}) => {
  const [isSelectOpen, setIsSelectOpen] = useState<boolean>(false);

  const handleChangeValue = (option: string | number) => {
    onChange(option);
    setIsSelectOpen(false);
  }

  return (
    <div className={`SelectWithLabel ${isSelectOpen ? 'open' : ''} ${disabled ? 'disabled' : ''} ${className}`}>
      <button
        className="current"
        onClick={() => !disabled && setIsSelectOpen(prevState => !prevState)}
        style={{
          justifyContent: label ?
            'space-between'
            : '',
          // @ts-ignore
          backgroundColor: options.find(option => option.value === value)?.color
        }}
      >
        <label className="label">{label}</label>
        {/* @ts-ignore */}
        <span className="value">{options.find(option => option.value === value)?.label || value}</span>
        <FontAwesomeIcon icon={faCaretDown} />
      </button>
      <div className="options" style={{height: isSelectOpen ? `${options.length * 48}px` : ''}}>
        {options.map((option) => (
          <button
            // @ts-ignore
            key={option.value || option}
            // @ts-ignore
            className={`option ${value === option.value || value === option ? 'selected' : ''}`}
            // @ts-ignore
            onClick={() => handleChangeValue(option.value || option)}
          >
            {/* @ts-ignore */}
            {option.label || option}
          </button>
        ))}
      </div>
    </div>
  );
};

export default SelectWithLabel;

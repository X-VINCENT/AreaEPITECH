import React, {HTMLInputTypeAttribute, useState} from 'react';
import './index.scss';
import {Button, Input} from "../../index.ts";

export interface FormField {
  placeholder?: string;
  name: string;
  type?: HTMLInputTypeAttribute;
  disabled?: boolean;
  optional?: boolean;
  label?: string;
  bottomContent?: string;
}

interface InputFormProps {
  fields: FormField[];
  errors: {[key: string]: string}
  setErrors: (errors: {[key: string]: string}) => void;
  onSubmit: (data: {[key: string]: string}) => void;
  submitText: string;
  className?: string;
}

const InputForm: React.FC<InputFormProps> = ({
  fields,
  errors,
  setErrors,
  onSubmit,
  submitText,
  className,
}) => {
  const [values, setValues] = useState<{[key: string]: string}>({});

  const onChange = (name: string, value: string) => {
    setErrors({});
    setValues(prevState => ({...prevState, [name]: value}));
  }

  const handleSubmit = (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    onSubmit(values);
  }

  return (
    <form className={`InputForm ${className ? className : ''}`} onSubmit={handleSubmit}>
      {fields.map((field, index) => (
        <Input
          key={index}
          name={field.name}
          value={values[field.name] || ''}
          onChange={newValue => onChange(field.name, newValue)}
          placeholder={field.placeholder}
          type={field.type}
          error={errors[field.name]}
          disabled={field.disabled}
          optional={field.optional}
          label={field.label}
          bottomContent={field.bottomContent}
        />
      ))}
      <Button type="submit" disabled={Object.keys(errors).length > 0 || fields.some(field => !values[field.name])}>
        {submitText}
      </Button>
    </form>
  );
};

export default InputForm;

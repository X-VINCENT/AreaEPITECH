import React from 'react';
import './index.scss';

interface ButtonProps {
  theme?: 'primary' | 'secondary';
  onClick?: () => void;
  type?: 'button' | 'submit' | 'reset';
  disabled?: boolean;
  children?: React.ReactNode;
}

const Button: React.FC<ButtonProps> = ({
  theme = 'primary',
  onClick,
  type = 'button',
  disabled,
  children,
}) => {
  return (
    <button
      className={`Button ${theme} ${disabled ? 'disabled' : ''}`}
      onClick={onClick ? onClick : undefined}
      type={type}
      disabled={disabled}
    >
      {children}
    </button>
  );
};

export default Button;

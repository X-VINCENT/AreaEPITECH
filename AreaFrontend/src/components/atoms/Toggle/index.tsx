import React from 'react';
import './index.scss';

interface ToggleProps {
  checked: boolean;
  onChange: (checked: boolean) => void;
  theme?: 'primary' | 'secondary';
}

const Toggle: React.FC<ToggleProps> = ({
  checked,
  onChange,
  theme = 'primary'
}) => {
  return (
    <button className={`Toggle ${theme} ${checked ? 'checked' : ''}`} onClick={() => onChange(!checked)}>
      <div className="toggle-circle" />
    </button>
  );
};

export default Toggle;

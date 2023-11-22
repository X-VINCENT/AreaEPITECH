import React, {useContext} from 'react';
import './index.scss';
import {ThemeContext} from "../../../providers/theme.tsx";
import {t} from "i18next";
import {Toggle} from "../../index.ts";

interface DarkModeToggleProps {
  hasLabel?: boolean;
}

const DarkModeToggle: React.FC<DarkModeToggleProps> = ({ hasLabel }) => {
  const {theme, updateTheme} = useContext(ThemeContext);

  return (
    <div className="DarkModeToggle">
      {hasLabel
        ? theme === 'dark'
          ? <span>{t('light-mode')}</span>
          : <span>{t('dark-mode')}</span>
        : null
      }
      <Toggle
        checked={theme === 'dark'}
        onChange={() => updateTheme(theme === 'dark' ? 'light' : 'dark')}
      />
    </div>
  );
};

export default DarkModeToggle;

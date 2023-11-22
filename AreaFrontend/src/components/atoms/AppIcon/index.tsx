import React from 'react';
import './index.scss';
import {t} from "i18next";

interface AppIconProps {
}

const AppIcon: React.FC<AppIconProps> = () => {
  return (
    <div className="AppIcon">
      <span className="title">{t('app_name')}</span>
      <span className="subtitle">
        {t('icon_subtitle')}
        <strong>{t('icon_subtitle_strong')}</strong>
      </span>
    </div>
  );
};

export default AppIcon;

import React from 'react';
import './index.scss';
import {t} from "i18next";

interface NavbarIconProps {
}

const NavbarIcon: React.FC<NavbarIconProps> = () => {
  return (
    <a className="NavbarIcon" href="/">
      <svg width="22" height="21" viewBox="0 0 22 21" fill="none" xmlns="http://www.w3.org/2000/svg">
        <path d="M10.1225 0.605726C10.5017 -0.088204 11.4983 -0.088204 11.8775 0.605726L13.7282 3.99222C13.9337 4.3682 14.3558 4.57151 14.7779 4.49773L18.5794 3.83321C19.3584 3.69704 19.9798 4.47619 19.6737 5.20534L18.1799 8.76371C18.0141 9.15878 18.1183 9.6156 18.4392 9.89958L21.3289 12.4574C21.9211 12.9816 21.6993 13.9532 20.9384 14.1685L17.225 15.2192C16.8127 15.3358 16.5206 15.7022 16.4986 16.1301L16.3005 19.9842C16.2599 20.7739 15.362 21.2063 14.7193 20.7457L11.5825 18.4975C11.2343 18.2479 10.7657 18.2479 10.4175 18.4975L7.28071 20.7457C6.63795 21.2063 5.74007 20.7739 5.69948 19.9842L5.50142 16.1301C5.47943 15.7022 5.18728 15.3358 4.775 15.2192L1.0616 14.1685C0.30068 13.9532 0.0789215 12.9816 0.671068 12.4574L3.56084 9.89958C3.88167 9.6156 3.98594 9.15878 3.82009 8.76371L2.32631 5.20534C2.02022 4.47619 2.64157 3.69704 3.42055 3.83321L7.2221 4.49773C7.64416 4.57151 8.06633 4.3682 8.2718 3.99222L10.1225 0.605726Z" fill="var(--color-secondary)"/>
      </svg>
      <span>{t('app_name')}</span>
    </a>
  );
};

export default NavbarIcon;
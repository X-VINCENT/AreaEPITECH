import React, {useState} from 'react';
import './index.scss';
import {NavbarIcon} from "../../index.ts";
import {useTranslation} from "react-i18next";

interface NavbarProps {
}

interface NavLink {
  name: string;
  path: string;
}

const Navbar: React.FC<NavbarProps> = () => {
  const {t} = useTranslation();
  const [isOpen, setIsOpen] = useState<boolean>(false);

  const navLinks: NavLink[] = [
    { name: t('areas'), path: '/areas' },
    { name: t('logs'), path: '/logs' },
    { name: t('account'), path: '/account' },
  ];

  const toggleOpen = () => {
    setIsOpen(prevState => !prevState)
  }

  return (
    <div className={`Navbar ${isOpen ? 'open' : ''}`}>
      <div className="navbar-container">
        <NavbarIcon />
        <div className="navbar-items">
          {navLinks.map((link, index) => (
            <a key={index} href={link.path}>{link.name}</a>
          ))}
        </div>
        <button className="menu-burger" onClick={toggleOpen}>
          <div className="line" />
          <div className="line" />
        </button>
      </div>
    </div>
  );
};

export default Navbar;

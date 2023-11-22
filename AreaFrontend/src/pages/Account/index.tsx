import React, {useContext, useEffect, useState} from 'react';
import { api } from "../../services/api.ts";
import './index.scss';
import {Button, DarkModeToggle, LanguageSelector, PageSubtitle, PageTitle, ServiceButton} from "../../components";
import AccountCard from '../../components/atoms/AccountCard/index.tsx';
import {AuthContext} from "../../providers/auth.tsx";
import {useTranslation} from "react-i18next";
import {FontAwesomeIcon} from "@fortawesome/react-fontawesome";
import {faDownload, faRightFromBracket} from "@fortawesome/free-solid-svg-icons";
import i18n from "i18next";
import {Language} from "../../components/atoms/LanguageSelector";

interface AccountProps {
}

const Account: React.FC<AccountProps> = () => {
  const {t} = useTranslation('account');
  const {user, logOut} = useContext(AuthContext);
  const [services, setServices] = useState<Service[]>([]);
  const [currentLanguage, setCurrentLanguage] = useState<string>(localStorage.getItem('language') || i18n.language);

  const languages: Language[] = [
    { code: "en-US", name: "English", flag: "/images/flags/en-US.svg" },
    { code: "fr-FR", name: "Français", flag: "/images/flags/fr-FR.svg" },
  ];

  const handleChangeLanguage = (language: string) => {
    setCurrentLanguage(language);
    localStorage.setItem('language', language);
  }

  const downloadApk = () => {
    fetch("/files/build/app-release.apk")
        .then((response) => {
          return response.blob();
        })
        .then((blob) => {
          const fileURL = window.URL.createObjectURL(blob);
          const link = document.createElement("a");
          link.href = fileURL;
          link.download = "app-release.apk";
          link.click();
          window.URL.revokeObjectURL(fileURL);
        })
        .catch((error) => {
          console.error("Error fetching the file:", error);
        });
  };

  useEffect(() => {
    api.getServices()
      .then(res => {
        setServices(res.data);
      })
      .catch(err => {
        console.error(err);
      });
  }, []);

  return (
    <div className="Account">
      <div className="account-container">
        <div className="page-header">
          <PageTitle value={t('account.title')} />
          <div className="header-container">
            <DarkModeToggle hasLabel />
            <LanguageSelector
              currentLanguage={languages.find(language => language.code === currentLanguage)!}
              languages={languages}
              setCurrentLanguage={handleChangeLanguage}
            />
            <Button onClick={downloadApk}>
              <FontAwesomeIcon icon={faDownload} />
              <span>{t('account.download-apk')}</span>
            </Button>
          </div>
        </div>
        <AccountCard />
        <div className="services">
          <PageSubtitle value={t('account.services')}></PageSubtitle>
          {services?.length
            ? <div className="services-list">
                {services
                  .sort((a, b) => a.name.localeCompare(b.name))
                  .map(service => (
                  <ServiceButton
                    key={service.key}
                    slug={service.key}
                    name={service.name}
                    logoUrl={service.logo_url}
                    isOAuth={service.is_oauth}
                    isConnected={!!user?.[`${service.key}_id`]}
                  />
                ))}
              </div>
            : <span className="empty">{t('account.no-services')}</span>
          }
        </div>
        <Button onClick={logOut}>
          <FontAwesomeIcon icon={faRightFromBracket} />
          <span>{t('logout')}</span>
        </Button>
      </div>
    </div>
  );
};

export default Account;

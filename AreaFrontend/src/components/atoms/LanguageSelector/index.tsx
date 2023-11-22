import React from 'react';
import './index.scss';
import i18n from "i18next";
import {Mat} from "../../index.ts";

export interface Language {
  code: string;
  name: string;
  flag: string;
}

interface LanguageSelectorProps {
  currentLanguage: Language;
  languages: Language[];
  setCurrentLanguage: (language: string) => void;
}

const LanguageSelector: React.FC<LanguageSelectorProps> = ({
  currentLanguage,
  languages,
  setCurrentLanguage,
}) => {
  const languageItems = languages.map((language) => ({
    element: <div className={"language"}>
      <img src={language.flag} alt={`${language.name} flag`}/>
      <span>{language.name}</span>
    </div>,
    action: () => {
      i18n.changeLanguage(language.code)
        .catch((err: Error) => console.error(err));
      setCurrentLanguage(language.code);
    }
  }));

  return (
    <div className="LanguageSelector">
      <Mat
        className={"LanguageSelector"}
        mainItem={<img src={currentLanguage.flag} alt={`${currentLanguage.name} flag`}/>}
        childrens={languageItems}
      />
    </div>
  );
};

export default LanguageSelector;

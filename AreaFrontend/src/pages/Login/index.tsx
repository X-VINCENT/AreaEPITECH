import React, {useContext, useState} from 'react';
import './index.scss';
import {AppHero, InputForm} from "../../components";
import {AuthContext} from "../../providers/auth.tsx";
import {useTranslation} from "react-i18next";

interface LoginProps {
}

const Login: React.FC<LoginProps> = () => {
  const {t} = useTranslation('errors');
  const {logIn} = useContext(AuthContext);
  const [formErrors, setFormErrors] = useState<{[key: string]: string}>({});

  const formFields = [
    {
      label: t('email'),
      name: 'email',
      type: 'email',
      placeholder: 'contact@email.com',
      required: true,
    },
    {
      label: t('password'),
      name: 'password',
      type: 'password',
      placeholder: '••••••••',
      optional: false,
    },
  ];

  const onSubmitForm = (data: {[key: string]: string}) => {
    const {email, password} = data;

    logIn(email, password)
      .catch(err => {
        switch (err.status) {
          case 401:
            setFormErrors({email: t('errors.invalid_credentials')});
            break;
          default:
            setFormErrors({email: t('errors.unknown')});
        }
      });
  }

  return (
    <div className="Login">
      <AppHero
        title={t('app_name')}
        subtitle={t('welcome_back')}
      />
      <div className="bottom-container">
        <a href="/register">{t('no-account')}</a>
        <InputForm
          fields={formFields}
          errors={formErrors}
          setErrors={setFormErrors}
          onSubmit={onSubmitForm}
          submitText={t('login')}
        />
      </div>
    </div>
  );
};

export default Login;

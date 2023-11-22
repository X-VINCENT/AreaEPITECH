import React, {useContext, useState} from 'react';
import './index.scss';
import {AppHero, InputForm} from "../../components";
import {AuthContext} from "../../providers/auth.tsx";
import {useTranslation} from "react-i18next";

interface RegisterProps {
}

const MAX_NAME_LENGTH = 64;
const MIN_PASSWORD_LENGTH = 8;

const Register: React.FC<RegisterProps> = () => {
  const {t} = useTranslation('errors');
  const {register} = useContext(AuthContext);
  const [formErrors, setFormErrors] = useState<{[key: string]: string}>({});

  const formFields = [
    {
      label: t('name'),
      name: 'name',
      type: 'name',
      placeholder: 'John Doe',
      required: true,
      bottomContent: t('max_chars', {max: MAX_NAME_LENGTH})
    },
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
      bottomContent: t('min_chars', {max: MIN_PASSWORD_LENGTH})
    },
    {
      label: t('password_confirmation'),
      name: 'c_password',
      type: 'password',
      placeholder: '••••••••',
      optional: false,
    },
  ];

  const onSubmitForm = (data: {[key: string]: string}) => {
    const {name, email, password, c_password} = data;
    let error = false;

    if (name?.length > MAX_NAME_LENGTH) {
      setFormErrors({name: t('errors.name_too_long', {max: MAX_NAME_LENGTH})});
      error = true;
    }

    if (password?.length < MIN_PASSWORD_LENGTH) {
      setFormErrors({password: t('errors.password_too_short', {min: MIN_PASSWORD_LENGTH})});
      error = true;
    }

    if (password !== c_password) {
      setFormErrors({c_password: t('errors.passwords_dont_match')});
      error = true;
    }

    if (error) return;

    register(name, email, password, c_password)
      .catch(err => {
        switch (err.status) {
          case 400:
            setFormErrors({email: t('errors.email_already_taken')});
            break;
          default:
            setFormErrors({email: t('errors.unknown')});
        }
      });
  }

  return (
    <div className="Register">
      <AppHero
        title={t('app_name')}
        subtitle={t('create_account')}
      />
      <div className="bottom-container">
        <a href="/login">{t('already_have_account')}</a>
        <InputForm
          fields={formFields}
          errors={formErrors}
          setErrors={setFormErrors}
          onSubmit={onSubmitForm}
          submitText={t('create_account')}
        />
      </div>
    </div>
  );
};

export default Register;

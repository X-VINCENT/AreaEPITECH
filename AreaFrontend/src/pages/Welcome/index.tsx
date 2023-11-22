import React, {Fragment, useEffect, useState} from 'react';
import './index.scss';
import {AppIcon, Button, DarkModeToggle, ServiceLink} from "../../components";
import {t} from "i18next";
import {useNavigate} from "react-router-dom";
import {api} from "../../services/api.ts";
import Lottie from 'lottie-react';
import bikeAnimationData from "../../assets/animations/bike.json";

interface WelcomeProps {
}

const Welcome: React.FC<WelcomeProps> = () => {
  const navigate = useNavigate();
  const [services, setServices] = useState<Service[]>([]);

  const defaultOptions = {
    loop: true,
    autoplay: true,
    animationData: bikeAnimationData,
    rendererSettings: {
      preserveAspectRatio: "xMidYMid slice"
    }
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
    <div className="Welcome">
      <DarkModeToggle />
      <AppIcon />
      <div className="animation">
        <Lottie {...defaultOptions} />
      </div>
      <div className="bottom-container">
        <div className="buttons">
          <Button onClick={() => navigate('/register')}>{t('create_account')}</Button>
          <Button theme="secondary" onClick={() => navigate('/login')}>{t('login')}</Button>
        </div>
        {services?.filter(s => s.is_oauth)?.length
          ? <Fragment>
              <span className="or">{t('uppercase', {value: t('or')})}</span>
              <div className="socials">
                {services.map(service => (
                  <ServiceLink
                    key={service.key}
                    slug={service.key}
                    name={service.name}
                    logoUrl={service.logo_url}
                  />
                ))}
              </div>
            </Fragment>
          : null
        }
      </div>
    </div>
  );
};

export default Welcome;

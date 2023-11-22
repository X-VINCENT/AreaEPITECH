import React, {Fragment, useContext, useEffect, useState} from 'react';
import './index.scss';
import {useTranslation} from "react-i18next";
import {FontAwesomeIcon} from "@fortawesome/react-fontawesome";
import {AreaTemplate, ServiceButton} from "../../components";
import {api} from "../../services/api.ts";
import {Button, PageTitle, PageSubtitle} from '../../components';
import {faPlus} from "@fortawesome/free-solid-svg-icons";
import { AuthContext } from '../../providers/auth.tsx';

interface HomeProps {
}

const Home: React.FC<HomeProps> = () => {
  const {t} = useTranslation('home');
  const {user} = useContext(AuthContext);
  const [services, setServices] = useState<Service[]>([]);
  const [actions, setActions] = useState<Action[]>([]);
  const [reactions, setReactions] = useState<Reaction[]>([]);

  const backgrounds = [
    "#C5FFC3",
    "#E6E2FF",
    "#FFD9D9",
    "#FFF7D9",
  ]

  const templates = [
    {
      name: t('home.templates.1'),
      actionId: 2,
      reactionId: 1,
    },
    {
      name: t('home.templates.2'),
      actionId: 1,
      reactionId: 7,
    },
    {
      name: t('home.templates.3'),
      actionId: 13,
      reactionId: 10,
    },
    {
      name: t('home.templates.4'),
      actionId: 11,
      reactionId: 11,
    },
    {
      name: t('home.templates.5'),
      actionId: 10,
      reactionId: 2,
    },
    {
      name: t('home.templates.6'),
      actionId: 3,
      reactionId: 2,
    },
    {
      name: t('home.templates.7'),
      actionId: 8,
      reactionId: 9,
    },
  ];

  useEffect(() => {
    api.getServices()
      .then(res => {
        setServices(res.data);
      })
      .catch(err => {
        console.error(err);
      });

    api.getActions()
      .then(res => {
        setActions(res.data);
      })
      .catch(err => {
        console.error(err);
      })

    api.getReactions()
      .then(res => {
        setReactions(res.data);
      })
      .catch(err => {
        console.error(err);
      })
  }, []);

  return (
    <div className="Home">
      <div className="page-header">
        <PageTitle value={`Hey ${user?.name}`} />
      </div>
      <div className="content">
        <Button onClick={() => location.href = '/areas'}>
          <FontAwesomeIcon icon={faPlus} />
          <span>{t('home.create')}</span>
        </Button>
        {templates?.length
          ? <Fragment>
              <PageSubtitle value={t('home.or')} />
              <section className="templates">
                <PageSubtitle value={t('home.start_with_template')} />
                <div className="list">
                  {templates.map((template, index) => (
                    <AreaTemplate
                      key={template.name}
                      name={template.name}
                      actionService={services?.find(s => s.id === actions?.find(a => a.id === template.actionId)?.service_id)}
                      reactionService={services?.find(s => s.id === reactions?.find(r => r.id === template.reactionId)?.service_id)}
                      action={actions?.find(a => a.id === template.actionId)}
                      reaction={reactions?.find(r => r.id === template.reactionId)}
                      backgroundColor={backgrounds[index % backgrounds.length]}
                      disabled={!actions?.find(a => a.id === template.actionId)?.usable || !reactions?.find(r => r.id === template.reactionId)?.usable}
                    />
                  ))}
                </div>
              </section>
            </Fragment>
          : null
        }
        <section className="services">
          <PageSubtitle value={t('home.connect_services')} />
          <div className="list">
            {services.map(service => (
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
        </section>
      </div>
    </div>
  );
};

export default Home;

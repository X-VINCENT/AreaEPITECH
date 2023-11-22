import React, {Fragment, useContext, useEffect, useState} from 'react';
import './index.scss';
import {ConfirmPopup, Image} from "../../index.ts";
import {AuthContext} from "../../../providers/auth.tsx";
import {useTranslation} from "react-i18next";
import {FontAwesomeIcon} from "@fortawesome/react-fontawesome";
import {faChevronRight} from "@fortawesome/free-solid-svg-icons";
import ContentLoader from "react-content-loader";

interface ServiceButtonProps {
  slug: string;
  name: string;
  logoUrl: string;
  isOAuth?: boolean;
  isConnected: boolean;
}

interface ConfirmData {
  title: string;
  message: string;
  confirmText: string;
  cancelText: string;
  confirm: () => void;
  cancel: () => void;
}

const ServiceButton: React.FC<ServiceButtonProps> = ({
  slug,
  name,
  logoUrl,
  isOAuth,
  isConnected,
}) => {
  const {t} = useTranslation('account');
  const {oAuthLoginLink, disconnectOAuth} = useContext(AuthContext);
  const [url, setUrl] = useState<string>('');
  const [isLoading, setIsLoading] = useState<boolean>(false);
  const [confirmData, setConfirmData] = useState<ConfirmData | null>(null);

  useEffect(() => {
    if (!isOAuth) return;
    setIsLoading(true);
    oAuthLoginLink(slug)
      .then((res: any) => {
        if (!res?.data) return;

        const {url} = res.data;
        setUrl(url);
        setIsLoading(false);
      })
      .catch((err: Error) => {
        console.error(err);
        setIsLoading(false);
      });
  }, [isOAuth, oAuthLoginLink, slug]);

  const handleDisconnect = () => {
    setConfirmData({
      title: t('account.confirm-disconnect.title', {service: name}),
      message: t('account.confirm-disconnect.message', {service: name}),
      confirmText: t('account.confirm-disconnect.confirm'),
      cancelText: t('account.confirm-disconnect.cancel'),
      confirm: () => disconnectOAuth(slug),
      cancel: () => setConfirmData(null),
    })
  }

  // eslint-disable-next-line no-empty-pattern
  const Content = ({}) => (
    <Fragment>
      <Image width={32} height={32} alt={`Logo ${name}`} src={logoUrl} />
      <div className="content">
        <span className="name">{name}</span>
        <span className={`status ${isConnected ? 'connected' : ''}`}>
        {isOAuth
          ? isConnected ? t('account.connected') : t('account.not-connected')
          : t('account.no-oauth')
        }
      </span>
      </div>
      {isOAuth
        ? <FontAwesomeIcon icon={faChevronRight} />
        : null
      }
    </Fragment>
  );

  if (!isOAuth) {
    return (
      <div className="ServiceButton">
        <Content />
      </div>
    );
  }

  if (isConnected) {
    return (
      <div className="ServiceButtonDisconnect">
        {confirmData && (
          <ConfirmPopup
            title={confirmData.title}
            message={confirmData.message}
            onConfirm={confirmData.confirm}
            onCancel={confirmData.cancel}
            confirmText={confirmData.confirmText}
            cancelText={confirmData.cancelText}
          />
        )}
        <button className="ServiceButton" onClick={handleDisconnect}>
          <Content />
        </button>
      </div>
    );
  }

  if (isLoading) {
    return (
      <div className="ServiceButton">
        <ContentLoader
          className="skeleton"
          speed={2}
          width={475}
          height={32}
          viewBox={`0 0 ${475} ${32}`}
          backgroundColor="#f3f3f3"
          foregroundColor="#ecebeb"
        >
          <rect x="0" y="0" rx="0" ry="0" width={32} height={32} />
          <rect x="48" y="0" rx="0" ry="0" width={100} height={12} />
          <rect x="48" y="20" rx="0" ry="0" width={150} height={12} />
        </ContentLoader>
      </div>
    );
  }

  return (
    <a className="ServiceButton" href={url}>
      <Content />
    </a>
  );
};

export default ServiceButton;

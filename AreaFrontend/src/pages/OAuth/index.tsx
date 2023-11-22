import React, {useContext, useEffect} from 'react';
import './index.scss';
import {useParams} from "react-router-dom";
import {AuthContext} from "../../providers/auth.tsx";

interface OAuthProps {
}

const OAuth: React.FC<OAuthProps> = () => {
  const { user } = useContext(AuthContext);
  const { oAuthLoginCallback } = useContext(AuthContext);
  const { service } = useParams();

  useEffect(() => {
    if (!service) return;
    oAuthLoginCallback(service, location.search)
      .then(() => {
        if (user)
          location.href = '/account';
        else
          location.href = '/';
      })
      .catch((err: Error) => {
        console.error(err);
      });
  }, [oAuthLoginCallback, service, user]);
  return null;
};

export default OAuth;

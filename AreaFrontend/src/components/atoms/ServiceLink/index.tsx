import React, {useContext, useEffect, useState} from 'react';
import './index.scss';
import {AuthContext} from "../../../providers/auth.tsx";
import {Oval} from "react-loader-spinner";

interface ServiceLinkProps {
  slug: string;
  name: string;
  logoUrl: string;
}

const ServiceLink: React.FC<ServiceLinkProps> = ({slug, name, logoUrl}) => {
  const {oAuthLoginLink} = useContext(AuthContext);
  const [url, setUrl] = useState<string>('');
  const [loading, setLoading] = useState<boolean>(false);

  useEffect(() => {
    setLoading(true);
    oAuthLoginLink(slug)
      .then((res: any) => {
        if (!res?.data) return;

        const {url} = res.data;
        setUrl(url);
        setLoading(false);
      })
      .catch(err => {
        console.error(err);
        setLoading(false);
      });
  }, [oAuthLoginLink, slug]);

  if (loading) {
    return (
      <Oval
        height={48}
        width={48}
        color="#4284F3"
        secondaryColor="#ccc"
      />
    );
  }

  if (!url) return null;

  return (
    <a className="ServiceLink" href={url}>
      <img src={logoUrl} alt={name} />
    </a>
  );
};

export default ServiceLink;

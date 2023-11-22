import React from 'react';
import './index.scss';

interface AppHeroProps {
  title: string;
  subtitle: string;
}

const AppHero: React.FC<AppHeroProps> = ({title, subtitle}) => {
  return (
    <div className="AppHero">
      <span className="title">{title}</span>
      <span className="subtitle">{subtitle}</span>
    </div>
  );
};

export default AppHero;

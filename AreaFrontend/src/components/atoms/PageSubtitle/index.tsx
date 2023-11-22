import React from 'react';
import './index.scss';

interface PageSubtitleProps {
  value: string;
}

const PageSubtitle: React.FC<PageSubtitleProps> = ({value}) => {
  return (
    <h2 className="PageSubtitle">
      {value}
    </h2>
  );
};

export default PageSubtitle;

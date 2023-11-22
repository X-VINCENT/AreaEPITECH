import React from 'react';
import './index.scss';

interface PageTitleProps {
  value: string;
}

const PageTitle: React.FC<PageTitleProps> = ({value}) => {
  return (
    <h1 className="PageTitle">
      {value}
    </h1>
  );
};

export default PageTitle;

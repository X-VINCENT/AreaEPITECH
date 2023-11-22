import React from 'react';
import './index.scss';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faCircleUser } from '@fortawesome/free-solid-svg-icons';

const AccountIcon: React.FC = () => {
  return (
    <div className="AccountIcon">
      <FontAwesomeIcon icon={faCircleUser} />
    </div>
  );
};

export default AccountIcon;

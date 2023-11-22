import React, { useContext } from 'react';
import './index.scss';
import AccountIcon from '../AccountIcon';
import { AuthContext } from '../../../providers/auth';

interface AccountCardProps {
}

const AccountCard: React.FC<AccountCardProps> = () => {
  const { user } = useContext(AuthContext);

  if (!user) return null;

  return (
    <div className="AccountCard">
      <AccountIcon />
      <div className="informations">
        <span className="name">{user.name}</span>
        <span className="mail">{user.email}</span>
      </div>
    </div>
  );
}

export default AccountCard;

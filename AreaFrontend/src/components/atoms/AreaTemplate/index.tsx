import React from 'react';
import './index.scss';
import {Image} from "../../index.ts";
import {FontAwesomeIcon} from "@fortawesome/react-fontawesome";
import {faAdd} from "@fortawesome/free-solid-svg-icons";
import ContentLoader from "react-content-loader";
import {Link} from "react-router-dom";

interface AreaTemplateProps {
  name: string;
  actionService?: Service;
  reactionService?: Service;
  action?: Action;
  reaction?: Reaction;
  backgroundColor: string;
  disabled?: boolean;
}

const ICON_SIZE = 32;

const AreaTemplate: React.FC<AreaTemplateProps> = ({
  name,
  actionService,
  reactionService,
  action,
  reaction,
  backgroundColor,
  disabled,
}) => {

  if (!actionService || !reactionService || !action || !reaction) {
    return (
      <ContentLoader
        speed={2}
        width={200}
        height={200}
        viewBox={`0 0 ${200} ${200}`}
        backgroundColor="#f3f3f3"
        foregroundColor="#ecebeb"
      >
        <rect x="0" y="0" rx="0" ry="0" width={200} height={200} />
      </ContentLoader>
    )
  }

  return (
    <Link
      className={`AreaTemplate ${disabled ? 'disabled' : ''}`}
      style={{ backgroundColor }}
      to={disabled ? '#' : `/areas?actionId=${action.id}&reactionId=${reaction.id}&name=${name}`}
    >
      <div className="icons">
        <Image src={actionService.logo_url} alt="Action icon" width={ICON_SIZE} height={ICON_SIZE} />
        <Image src={reactionService.logo_url} alt="Reaction icon" width={ICON_SIZE} height={ICON_SIZE} />
      </div>
      <div className="name">{name}</div>
      <div className="hovered-content">
        <FontAwesomeIcon icon={faAdd} color="white" />
      </div>
    </Link>
  );
};

export default AreaTemplate;

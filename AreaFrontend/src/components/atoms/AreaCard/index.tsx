import React from 'react';
import './index.scss';
import {FontAwesomeIcon} from "@fortawesome/react-fontawesome";
import {faGear, faPlay, faTrashAlt} from "@fortawesome/free-solid-svg-icons";
import {Image} from "../../index.ts";

interface AreaCardProps {
  id: number;
  name: string;
  background: string;
  actionIcon?: string;
  reactionIcon?: string;
  onDelete: (id: number) => void;
  onEdit: (id: number) => void;
  executeAction: (id: number) => void;
}

const ICON_SIZE = 30;

const AreaCard: React.FC<AreaCardProps> = ({
  id,
  name,
  background,
  actionIcon,
  reactionIcon,
  onDelete,
  onEdit,
  executeAction,
}) => {
  return (
    <div id={id.toString()} className="AreaCard" style={{background: background}}>
      <div className="icons">
        <Image src={actionIcon} alt="Action icon" width={ICON_SIZE} height={ICON_SIZE} />
        <Image src={reactionIcon} alt="Reaction icon" width={ICON_SIZE} height={ICON_SIZE} />
      </div>
      <div className="name">{name}</div>
      <div className="hovered-content">
        <button onClick={() => onDelete(id)}>
          <FontAwesomeIcon icon={faTrashAlt} />
        </button>
        <button onClick={() => executeAction(id)}>
          <FontAwesomeIcon icon={faPlay} />
        </button>
        <button onClick={() => onEdit(id)}>
          <FontAwesomeIcon icon={faGear} />
        </button>
      </div>
    </div>
  );
};

export default AreaCard;

import React from 'react';
import './index.scss';
import {FontAwesomeIcon} from "@fortawesome/react-fontawesome";
import {faXmark} from "@fortawesome/free-solid-svg-icons";

interface ModalProps {
  title: string;
  subtitle?: string;
  onClose: () => void;
  children: React.ReactNode;
}

const Modal: React.FC<ModalProps> = ({
  title,
  subtitle,
  onClose,
  children,
}) => {

  const handleClose = (e: React.MouseEvent<HTMLButtonElement>) => {
    e.preventDefault();
    onClose();
  }

  return (
    <div className="Modal" onClick={(e) => e.preventDefault()}>
      <div className="modal-wrapper">
        <div className="modal-header">
          {title
            ? <h1>{title}</h1>
            : null
          }
          {subtitle
            ? <h3>{subtitle}</h3>
            : null
          }
          <button className="close-btn" onClick={handleClose}>
            <FontAwesomeIcon icon={faXmark} />
          </button>
        </div>
        <div className="modal-content">
          {children}
        </div>
      </div>
    </div>
  );
};

export default Modal;

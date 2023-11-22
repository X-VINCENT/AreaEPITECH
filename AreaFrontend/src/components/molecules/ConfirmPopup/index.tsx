import React from 'react';
import './index.scss';
import {Button, Modal} from "../../index.ts";

interface ConfirmPopupProps {
  title: string;
  message: string;
  onConfirm: () => void;
  onCancel: () => void;
  confirmText: string;
  cancelText: string;
}

const ConfirmPopup: React.FC<ConfirmPopupProps> = ({
  title,
  message,
  onConfirm,
  onCancel,
  confirmText,
  cancelText,
}) => {
  return (
    <div className="ConfirmPopup">
      <Modal title={title} onClose={onCancel}>
        <div className="confirm-popup-content">
          <h2 className="popup-message">{message}</h2>
          <div className="popup-buttons">
            <Button theme="secondary" onClick={onCancel}>{cancelText}</Button>
            <Button theme="primary" onClick={onConfirm}>{confirmText}</Button>
          </div>
        </div>
      </Modal>
    </div>
  );
};

export default ConfirmPopup;

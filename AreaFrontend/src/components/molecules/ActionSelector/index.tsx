import React, {useEffect, useState} from 'react';
import './index.scss';
import {ActionConfig, Image, Modal} from "../../index.ts";
import {useTranslation} from "react-i18next";
import {FontAwesomeIcon} from "@fortawesome/react-fontawesome";
import {faGear, faLock} from "@fortawesome/free-solid-svg-icons";

interface ActionSelectorProps {
  selectedActionId?: number;
  onSelectAction: (id: number) => void;
  config: ActionReactionConfig[];
  onConfigChange: (config: ActionReactionConfig[]) => void;
  modalTitle: string;
  placeholder: string;
  actions: Action[] | Reaction[];
  services: Service[];
}

interface SelectedAction extends Action {
  service: Service;
}

const ICON_SIZE = 32;

const ActionSelector: React.FC<ActionSelectorProps> = ({
  selectedActionId,
  onSelectAction,
  config,
  onConfigChange,
  modalTitle,
  placeholder,
  actions,
  services,
}) => {
  const {t} = useTranslation('areas');
  const [isSelectorOpen, setIsSelectorOpen] = useState<boolean>(false);
  const [selectedAction, setSelectedAction] = useState<SelectedAction | null>(null);

  const backgrounds = [
    "#C5FFC3",
    "#E6E2FF",
    "#FFD9D9",
    "#FFF7D9",
  ]

  const handleCloseModal = () => {
    setIsSelectorOpen(false)
  }

  const handleOpenModal = () => {
    setIsSelectorOpen(true)
  }

  const handleSelectAction = (id: number) => {
    setIsSelectorOpen(false);
    onSelectAction(id)
  }

  useEffect(() => {
    const action = actions.find(action => action.id === selectedActionId);

    if (!action) {
      setSelectedAction(null);
      return;
    }

    const service = services?.find(service => service.id === action.service_id);

    if (!service)
      return;

    setSelectedAction({
      ...action,
      service
    });
  }, [actions, selectedActionId, services]);

  return (
    <div className="ActionSelector">
      {isSelectorOpen
        ? <Modal title={modalTitle} onClose={handleCloseModal}>
          {services?.length
            ? <div className="services-list">
              {services?.map(service => (
                <div className="service" key={service.id}>
                  <div className="service-header">
                    <Image
                      src={service.logo_url}
                      alt={`${service.name} logo`}
                      height={ICON_SIZE}
                      width={ICON_SIZE}
                    />
                    <span>{service.name}</span>
                  </div>
                  <div className="actions-list">
                    {actions?.filter(a => a.service_id === service.id)?.length
                      ? actions?.filter(a => a.service_id === service.id)?.map(action => (
                        <button
                          key={action.id}
                          className={`action ${action.id === selectedActionId ? 'selected' : ''} ${!action.usable ? 'disabled' : ''}`}
                          disabled={!action.usable}
                          onClick={() => handleSelectAction(action.id)}
                          style={{background: backgrounds[action.id % backgrounds.length]}}
                        >
                          <span>{action.name}</span>
                          <span className="description">{action.description}</span>
                          {!action.usable
                            ? <div className="disabled-content">
                                <FontAwesomeIcon icon={faLock} />
                                <span>{t('areas.action-disabled')}</span>
                              </div>
                            : null
                          }
                        </button>
                      ))
                      : <span className="no-actions">{t('areas.no-actions-for-service')}</span>
                    }
                  </div>
                </div>
              ))}
              </div>
            : <span className="no-services">{t('areas.no-services')}</span>
          }
          </Modal>
        : null
      }
      {selectedAction
        ? <div
          className="selected-action"
          style={{background: backgrounds[selectedAction.id % backgrounds.length]}}
        >
            <div className="selected-action-header">
              <Image
                src={selectedAction.service?.logo_url}
                alt={`${selectedAction?.service?.name} logo`}
                height={ICON_SIZE}
                width={ICON_SIZE}
              />
              <span className="action-name">{selectedAction.name}</span>
              <button onClick={handleOpenModal}>
                <FontAwesomeIcon icon={faGear} />
              </button>
            </div>
            {selectedAction.config_keys?.length
              ? <ActionConfig
                  configKeys={selectedAction.config_keys}
                  configValues={config}
                  onConfigChange={onConfigChange}
                />
              : null
            }
          </div>
        : <button className="action-placeholder" onClick={handleOpenModal}>
          {placeholder}
          </button>
      }
    </div>
  );
};

export default ActionSelector;

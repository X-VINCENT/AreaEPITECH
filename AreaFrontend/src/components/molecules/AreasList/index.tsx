import React, {useState} from 'react';
import './index.scss';
import {AreaCard, ConfirmPopup} from "../../index.ts";
import {useTranslation} from "react-i18next";
import ContentLoader from "react-content-loader";
import {areasApi} from "../../../services/areasApi.ts";
import {callErrorPopup, callSuccessPopup} from "../../../tools/alerts.ts";

interface AreasListProps {
  areas?: Area[];
  services?: Service[];
  actions?: Action[];
  reactions?: Reaction[];
  loading: boolean;
  onDeleteArea: (id: number) => void;
  onEditArea: (id: number) => void;
  skeletonLength?: number;
}

interface RenderAreaProps {
  area: Area
}

interface ConfirmData {
  title: string;
  message: string;
  confirmText: string;
  cancelText: string;
  confirm: () => void;
  cancel: () => void;
}

const SKELETON_AREAS_LENGTH = 5;

const AreasList: React.FC<AreasListProps> = ({
  areas,
  services,
  actions,
  reactions,
  loading,
  onDeleteArea,
  onEditArea,
  skeletonLength = SKELETON_AREAS_LENGTH
}) => {
  const {t} = useTranslation('areas');
  const [confirmData, setConfirmData] = useState<ConfirmData | null>(null);

  const confirmDeleteArea = (id: number) => {
    setConfirmData({
      title: t('areas.confirm-delete.title', {id}),
      message: t('areas.confirm-delete.message', {id}),
      confirmText: t('areas.confirm-delete.confirm'),
      cancelText: t('areas.confirm-delete.cancel'),
      confirm: () => {
        onDeleteArea(id)
        setConfirmData(null)
      },
      cancel: () => setConfirmData(null)
    });
  }

  const executeAction = (id: number) => {
    areasApi.executeAction(id)
      .then(res => {
        callSuccessPopup(res?.message)
      })
      .catch((err: any) => {
        const {body} = err;
        callErrorPopup(body?.message)
      })
  }

  const renderArea: React.FC<RenderAreaProps> = ({area}) => {
    const action = actions?.find(a => a.id === area.action_id);
    const reaction = reactions?.find(a => a.id === area.reaction_id);
    const actionService = services?.find(s => s.id === action?.service_id);
    const reactionService = services?.find(s => s.id === reaction?.service_id);

    const backgrounds = [
      "#C5FFC3",
      "#E6E2FF",
      "#FFD9D9",
      "#FFF7D9",
    ]

    return (
      <AreaCard
        key={area.id}
        id={area.id}
        name={area.name}
        background={backgrounds[area.id % backgrounds.length]}
        actionIcon={actionService?.logo_url}
        reactionIcon={reactionService?.logo_url}
        onDelete={confirmDeleteArea}
        onEdit={onEditArea}
        executeAction={executeAction}
      />
    )
  }

  return (
    <div className="AreasList">
      {confirmData && (
        <ConfirmPopup
          title={confirmData.title}
          message={confirmData.message}
          onConfirm={confirmData.confirm}
          onCancel={confirmData.cancel}
          confirmText={confirmData.confirmText}
          cancelText={confirmData.cancelText}
        />
      )}
      <div className="areas-wrapper">
        {loading
          ? [...Array(skeletonLength).keys()].map(i => (
              <ContentLoader
                key={i}
                speed={2}
                width={200}
                height={200}
                viewBox={`0 0 ${200} ${200}`}
                backgroundColor="#f3f3f3"
                foregroundColor="#ecebeb"
              >
                <rect x="0" y="0" rx="0" ry="0" width={200} height={200} />
              </ContentLoader>
            ))
          : areas?.length
              ? areas.map((area: Area) => renderArea({area}))
              : <div className="empty">
                  <span>{t('areas.no-areas')}</span>
                </div>
        }
      </div>
    </div>
  );
};

export default AreasList;

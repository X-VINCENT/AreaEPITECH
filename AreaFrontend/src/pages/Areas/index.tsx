import React, {useCallback, useEffect, useState} from 'react';
import './index.scss';
import {api} from "../../services/api.ts";
import {AreasList, Button, EditAreaPane, PageSubtitle, PageTitle} from "../../components";
import {areasApi} from "../../services/areasApi.ts";
import {useTranslation} from "react-i18next";
import {FontAwesomeIcon} from "@fortawesome/react-fontawesome";
import {faPlus} from "@fortawesome/free-solid-svg-icons";
import {callErrorPopup, callSuccessPopup} from "../../tools/alerts.ts";

interface AreasProps {
}

interface LoadingType {
  [key: string]: boolean;
}

enum EDIT_AREA_PANE {
  CLOSED = -2,
  NEW = -1,
}

const Areas: React.FC<AreasProps> = () => {
  const {t} = useTranslation('areas');
  const [areas, setAreas] = useState<Area[]>([]);
  const [services, setServices] = useState<Service[]>([]);
  const [actions, setActions] = useState<Action[]>([]);
  const [reactions, setReactions] = useState<Reaction[]>([]);
  const [editPane, setEditPane] = useState<EDIT_AREA_PANE | number>(EDIT_AREA_PANE.CLOSED);
  const [loading, setLoading] = useState<LoadingType>({
    areas: true,
    services: true,
    actions: true,
    reactions: true
  });

  useEffect(() => {
    setLoading({
      areas: true,
      services: true,
      actions: true,
      reactions: true
    });
    areasApi.getAll()
      .then(res => {
        setAreas(res.data)
        setLoading(l => ({...l, areas: false}))
      })
      .catch(error => {
        console.error(error)
        setLoading(l => ({...l, areas: false}))
      });

    api.getServices()
      .then(res => {
        setServices(res.data)
        setLoading(l => ({...l, services: false}))
      })
      .catch(error => {
        console.error(error)
        setLoading(l => ({...l, areas: false}))
      });

    api.getActions()
      .then(res => {
        setActions(res?.data)
        setLoading(l => ({...l, actions: false}))
      })
      .catch(error => {
        console.error(error)
        setLoading(l => ({...l, areas: false}))
      });

    api.getReactions()
      .then(res => {
        setReactions(res.data)
        setLoading(l => ({...l, reactions: false}));
      })
      .catch((error) => {
        console.error(error)
        setLoading(l => ({...l, areas: false}))
      });
  }, []);

  const isLoading = useCallback(() => {
    for (const key in loading) {
      if (loading[key]) {
        return true;
      }
    }

    return false;
  }, [loading]);

  useEffect(() => {
    if (isLoading())
      return;

    const query = new URLSearchParams(window.location.search);

    if (query.get('actionId') && query.get('reactionId') && query.get('name')) {
      setEditPane(EDIT_AREA_PANE.NEW);
    }
  }, [isLoading, loading]);

  const handleCreateArea = () => {
    setEditPane(EDIT_AREA_PANE.NEW)
  }

  const handleDeleteArea = (id: number) => {
    areasApi.delete(id)
      .then(() => {
        setAreas(prevState => [...prevState.filter(a => a.id !== id)])
        callSuccessPopup(t('areas.success.delete'));
      })
      .catch(error => {
        callErrorPopup(t('areas.error.delete'));
        console.error(error);
      });
  }

  const handleEditArea = (id: number) => {
    setEditPane(id);
  }

  const handleCloseEditAreaPane = () => {
    window.history.replaceState({}, '', window.location.pathname);
    setEditPane(EDIT_AREA_PANE.CLOSED);
  }

  return (
    <div className="Areas">
      {editPane > EDIT_AREA_PANE.CLOSED
        ? <EditAreaPane
            id={editPane}
            areas={areas}
            setAreas={setAreas}
            services={services}
            actions={actions}
            reactions={reactions}
            onClose={handleCloseEditAreaPane}
          />
        : null
      }
      <div className="area-container">
        <div className="page-header">
          <PageTitle value={t('areas.title')} />
          {isLoading()
            ? null
            : <Button onClick={handleCreateArea}>
                <FontAwesomeIcon icon={faPlus} />
                <span>{t('areas.create')}</span>
              </Button>
          }
        </div>
        <AreasList
          areas={areas.filter(a => a.active)}
          services={services}
          actions={actions}
          reactions={reactions}
          loading={isLoading()}
          onDeleteArea={handleDeleteArea}
          onEditArea={handleEditArea}
        />
        <PageSubtitle value={t('areas.shutdown-areas')} />
        <AreasList
          areas={areas.filter(a => !a.active)}
          services={services}
          actions={actions}
          reactions={reactions}
          loading={isLoading()}
          onDeleteArea={handleDeleteArea}
          onEditArea={handleEditArea}
          skeletonLength={3}
        />
      </div>
    </div>
  );
};

export default Areas;

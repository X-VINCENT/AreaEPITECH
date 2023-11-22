import React, {useEffect, useState} from 'react';
import './index.scss';
import {useTranslation} from "react-i18next";
import {logsApi} from "../../services/logsApi.ts";
import {PageTitle, SelectWithLabel} from "../../components";
import i18n from "i18next";
import {reactFormatter, ReactTabulator} from "react-tabulator";
import {ThreeDots} from "react-loader-spinner";
import {getElapsedTimeLabel} from "../../tools/toolbox.ts";
import {FontAwesomeIcon} from "@fortawesome/react-fontawesome";
import {faCheck, faClock, faTimes} from "@fortawesome/free-solid-svg-icons";
import {areasApi} from "../../services/areasApi.ts";

interface AreasProps {
}

const Areas: React.FC<AreasProps> = () => {
  const {t} = useTranslation('logs');
  const [logs, setLogs] = useState<Log[]>([]);
  const [areas, setAreas] = useState<Area[]>([]);
  const [filter, setFilter] = useState<string | number>('all');
  const [loading, setLoading] = useState<boolean>(false);

  useEffect(() => {
    setLoading(true);
    logsApi.getAll()
      .then(res => {
        setLogs(res.data)
        setLoading(false)
      })
      .catch(error => {
        console.error(error)
        setLoading(false)
      })
  }, []);

  useEffect(() => {
    areasApi.getAll()
      .then(res => setAreas(res.data))
      .catch(error => console.error(error))
  }, []);

  const filterOptions = [
    {value: 'pending', label: t('logs.filter.pending'), color: 'grey'},
    {value: 'success', label: t('logs.filter.success'), color: 'green'},
    {value: 'error', label: t('logs.filter.error'), color: 'red'},
    {value: 'all', label: t('logs.filter.all'), color: 'var(--primary-color)'},
  ]

  // @ts-ignore
  const dateSorter = (a: any, b: any) => new Date(a) - new Date(b);

  const DateCell = ({cell}: {cell?: any}) => getElapsedTimeLabel(cell.getValue());

  const AreaCell = ({cell}: {cell?: any}) => {
    const value = cell.getValue();
    const area = areas.find(a => a.id === value);

    if (!area) return null;

    return area.name;
  }

  const StatusCell = ({cell}: {cell?: any}) => {
    const value = cell.getValue();

    return (
      <div className="StatusCell">
        <FontAwesomeIcon
          icon={
            value === 'success'
              ? faCheck
              : cell.getValue() === 'error'
                ? faTimes
                : faClock
          }
          color={
            value === 'success'
              ? 'green'
              : cell.getValue() === 'error'
                ? 'red'
                : 'grey'
          }
        />
      </div>
    );
  }

  const columns: any[] = [
    {title: t('logs.tabulator.id'), field: 'id', width: 60, sorter: 'number', resizable: false},
    {title: t('logs.tabulator.area-id'), field: 'area_id', resizable: false,  formatter: reactFormatter(<AreaCell />)},
    {title: t('logs.tabulator.message'), field: 'message', resizable: false},
    {title: t('logs.tabulator.status'), field: 'status', width: 120, resizable: false, formatter: reactFormatter(<StatusCell />)},
    {title: t('logs.tabulator.date'), field: 'updated_at', sorter: dateSorter, resizable: false, formatter: reactFormatter(<DateCell />)},
  ];

  const options = {
    layout: "fitColumns",
    layoutColumnsOnNewData: true,
    responsiveLayout: "collapse",
    initialSort: [{column: "updated_at", dir: "desc"}],
    placeholder: t('logs.tabulator.no-data', {ns: 'components'}),
    pagination: "local",
    paginationSize: 10,
    locale: localStorage.getItem("language") || i18n.language,
    langs: {
      "fr-FR": {
        "pagination": t('logs.tabulator.pagination', {ns: 'components', returnObjects: true}),
      }
    }
  }

  return (
    <div className="Logs">
      <div className="logs-container">
        <div className="page-header">
          <PageTitle value={t('logs.title')} />
          <SelectWithLabel
            label={t('logs.status')}
            options={filterOptions}
            value={filter}
            onChange={setFilter}
          />
        </div>
        {loading
          ? <ThreeDots color="var(--color-primary)" wrapperClass="loader"/>
          : logs
            .filter(l => {
              if (!filter) return true
              if (filter === 'all') return true

              return l.status === filter
            })
            .length > 0
              ? <div className="tabulator-wrapper">
                  <ReactTabulator
                    columns={columns}
                    data={
                      logs.filter(l => {
                        if (!filter) return true
                        if (filter === 'all') return true

                        return l.status === filter
                      })
                    }
                    options={options}
                  />
                </div>
              : <div className="empty">
                  <h1>{filter === 'all' ? t('logs.no-logs') : t('logs.no-logs-with-filter')}</h1>
                </div>
        }
      </div>
    </div>
  );
};

export default Areas;

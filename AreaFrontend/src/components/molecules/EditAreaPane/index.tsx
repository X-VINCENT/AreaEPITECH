import React, {useEffect, useState} from 'react';
import './index.scss';
import {FontAwesomeIcon} from "@fortawesome/react-fontawesome";
import {faXmark} from "@fortawesome/free-solid-svg-icons";
import {useTranslation} from "react-i18next";
import {ActionSelector, Button, Input, TextArea, Toggle} from "../../index.ts";
import {areasApi} from "../../../services/areasApi.ts";
import {callErrorPopup, callSuccessPopup} from "../../../tools/alerts.ts";

interface EditAreaPaneProps {
  id: number;
  areas: Area[];
  setAreas: React.Dispatch<React.SetStateAction<Area[]>>;
  services: Service[];
  actions: Action[];
  reactions: Reaction[];
  onClose: () => void;
}

interface Field {
  id: string;
  type: string;
  placeholder?: string;
  optional?: boolean;
  disabled?: boolean;
  bottomContent?: string;
  min?: number;
  max?: number;
  maxLength?: number;
}

interface EditAreaPaneTType {
  title: {
    create: string;
    edit: string;
  };
  fields: {
    name: string;
    description: string;
    active: string;
    action_id: string;
    reaction_id: string;
    [key: string]: string;
  };
  placeholders: {
    action_id: string;
    reaction_id: string;
    [key: string]: string;
  };
  modal: {
    title: {
      action_id: string;
      reaction_id: string;
      [key: string]: string;
    };
  };
  button: {
    create: string;
    update: string;
  };
}

const EditAreaPane: React.FC<EditAreaPaneProps> = ({
  id,
  areas,
  setAreas,
  services,
  actions,
  reactions,
  onClose,
}) => {
  const {t} = useTranslation('areas');
  const query = new URLSearchParams(window.location.search);
  const [values, setValues] = useState<{[key: string]: any}>({
    name: query.get('name') || '',
    description: '',
    active: true,
    action_id: Number(query.get('actionId')) || '',
    reaction_id: Number(query.get('reactionId')) || '',
    refresh_delay: 300,
  });
  const [errors, setErrors] = useState<{[key: string]: string}>();
  const editAreaPaneT: EditAreaPaneTType = t('areas.edit-area-pane', {returnObjects: true});

  const fields: Field[] = [
    {id: "name", type: "text", placeholder: editAreaPaneT?.fields?.name, maxLength: 255},
    {id: "description", type: "textArea", placeholder: editAreaPaneT?.fields?.description, optional: true},
    {id: "active", type: "toggle"},
    {id: "refresh_delay", type: "number", min: 60, max: 86400},
    {id: "action_id", type: "action"},
    {id: "reaction_id", type: "action"},
  ];

  const handleChangeErrors = (id: string, value: any) => {
    setErrors(prevState => ({...prevState, [id]: ''}))
    void id;
    void value;
  }

  const handleChangeValue = (id: string, value: any) => {
    handleChangeErrors(id, value);
    setValues(prevState => ({...prevState, [id]: value}))
  }

  const handleCreateArea = () => {
    areasApi.create(values as Area)
      .then((res) => {
        if (!res.data) return;
        setAreas(prevState => [...prevState, res.data]);
        onClose();
        callSuccessPopup(t('areas.success.create'));
      })
      .catch(() => callErrorPopup(t('areas.errors.create')))
  }

  const handleUpdateArea = () => {
    areasApi.update(id, values as Area)
      .then((res) => {
        if (!res.data) return;
        setAreas(prevState => [
          ...prevState.filter(area => area.id !== res.data.id),
          res.data
        ])
        onClose();
        callSuccessPopup(t('areas.success.update'));
      })
      .catch(() => callErrorPopup(t('areas.errors.update')))
  }

  const handleSubmitError = () => {
    for (const field of fields) {
      const { id } = field;
      const value = values?.[id];

      if (id === 'name' && value.length > 255) {
        setErrors(prevState => ({...prevState, [id]: t('areas.error.name_length')}))
        return true;
      }

      if (id === 'refresh_delay' && (value < 60 || value > 86400)) {
        setErrors(prevState => ({...prevState, [id]: t('areas.error.refresh_delay')}))
        return true;
      }

      setErrors(prevState => ({...prevState, [id]: ''}))
    }

    return false;
  }

  const handleSubmit = () => {
    if (handleSubmitError())
      return;
    if (id === -1)
      return handleCreateArea();
    return handleUpdateArea();
  }

  useEffect(() => {
    if (id < 0)
      return;

    const area = areas?.find(area => area.id === id);

    if (!area)
      return;

    const {
      name,
      description,
      active,
      action_id,
      reaction_id,
      action_config,
      reaction_config,
      refresh_delay,
    } = area;

    setValues({
      name,
      description,
      active,
      action_id,
      reaction_id,
      action_config,
      reaction_config,
      refresh_delay,
    })
  }, [areas, id]);

  const InputType = ({
    id,
    type,
    placeholder,
    optional,
    disabled,
    bottomContent,
    min,
    max,
    maxLength,
  } : {
    id: string,
    type: string,
    placeholder?: string,
    optional?: boolean
    disabled?: boolean,
    bottomContent?: string;
    min?: number;
    max?: number;
    maxLength?: number;
  }) => {
    return (
      <div key={id} className="InputType">
        <Input
          type={type}
          name={id}
          value={values?.[id] || ''}
          label={editAreaPaneT?.fields?.[id]}
          placeholder={placeholder}
          error={errors?.[id] || ''}
          optional={optional}
          disabled={disabled}
          onChange={(value) => handleChangeValue(id, value)}
          bottomContent={bottomContent}
          fixedLabel
          min={min}
          max={max}
          maxLength={maxLength}
        />
      </div>
    )
  }

  const TextAreaType = ({
    id,
    placeholder,
    optional,
    disabled,
    bottomContent,
  } : {
    id: string,
    placeholder?: string,
    optional?: boolean
    disabled?: boolean,
    bottomContent?: string;
  }) => {
    return (
      <div key={id} className="TextAreaType">
        <TextArea
          name={id}
          value={values?.[id] || ''}
          label={editAreaPaneT?.fields?.[id]}
          placeholder={placeholder}
          error={errors?.[id] || ''}
          optional={optional}
          disabled={disabled}
          onChange={(value) => handleChangeValue(id, value)}
          bottomContent={bottomContent}
          fixedLabel
        />
      </div>
    )
  }

  const ToggleType = ({
    id
  } : {
    id: string,
  }) => {
    return (
      <div key={id} className="ToggleType">
        <span className="label">{editAreaPaneT?.fields?.[id]}</span>
        <Toggle
          checked={values?.[id]}
          onChange={(checked) => handleChangeValue(id, checked)}
        />
      </div>
    )
  }

  const ActionType = ({
    id,
  } : {
    id: string,
    type: string,
  }) => {
    return (
      <div key={id} className="ActionType">
        <span className="label">{editAreaPaneT?.fields?.[id]}</span>
        <ActionSelector
          selectedActionId={values?.[id]}
          onSelectAction={(value) => handleChangeValue(id, value)}
          config={id === 'action_id' ? values?.action_config : values?.reaction_config}
          onConfigChange={(config) => handleChangeValue(id === 'action_id' ? 'action_config' : 'reaction_config', config)}
          modalTitle={editAreaPaneT?.modal?.title?.[id]}
          placeholder={editAreaPaneT?.placeholders?.[id]}
          actions={id === 'action_id' ? actions : reactions}
          services={services}
        />
        {id === 'action_id'
          ? <div className="join-line" />
          : null
        }
      </div>
    )
  }

  const types: any = {
    text: InputType,
    number: InputType,
    textArea: TextAreaType,
    toggle: ToggleType,
    action: ActionType,
  };

  const isDisabled = () => {
    for (const key in errors) {
      if (errors[key])
        return true;
    }

    for (const field of fields) {
      const { id, optional } = field;

      if (id === 'active')
        continue;

      if (!optional && !values?.[id])
        return true;
    }

    const actionConfigKeys = actions?.find(action => action.id === values?.action_id)?.config_keys;
    const reactionConfigKeys = reactions?.find(reaction => reaction.id === values?.reaction_id)?.config_keys;

    if (actionConfigKeys?.length) {
      for (const key of actionConfigKeys) {
        if (!values?.action_config?.[key.id])
          return true;
      }
    }

    if (reactionConfigKeys?.length) {
      for (const key of reactionConfigKeys) {
        if (!values?.reaction_config?.[key.id])
          return true;
      }
    }

    return false;
  }

  return (
    <div className="EditAreaPane">
      <div className="wrapper">
        <header className="header">
          <h1>
            {id === -1
              ? editAreaPaneT?.title?.create
              : t('areas.edit-area-pane.title.edit', {id})
            }
          </h1>
          <button className="close-btn" onClick={onClose}>
            <FontAwesomeIcon icon={faXmark} />
          </button>
        </header>
        <div className="content">
          <div className="fields">
            {fields?.map(field => {
              const Component = types[field.type] || types.input;

              return Component({...field})
            })}
          </div>
          <Button
            theme="secondary"
            onClick={handleSubmit}
            disabled={isDisabled()}
          >
            {id === -1
              ? editAreaPaneT?.button?.create
              : editAreaPaneT?.button?.update
            }
          </Button>
        </div>
      </div>
    </div>
  );
};

export default EditAreaPane;

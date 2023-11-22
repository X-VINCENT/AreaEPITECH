import React from 'react';
import './index.scss';
import {DateTimePicker, Input} from "../../index.ts";
import {useTranslation} from "react-i18next";

interface ActionConfigProps {
  configKeys: ConfigKey[];
  configValues: ActionReactionConfig[];
  onConfigChange: (config: ActionReactionConfig[]) => void;
}

const ActionConfig: React.FC<ActionConfigProps> = ({
  configKeys,
  configValues,
  onConfigChange,
}) => {
  const {t} = useTranslation('areas');
  const configKeysT: {[key: string]: string}[] = t('areas.config-keys', {returnObjects: true})

  const handleChangeValue = (id: string, value: ConfigKeyType) => {
    const formattedValue = configKeys.find(configKey => configKey.id === id)?.type === 'number' ? Number(value) : value;

    onConfigChange({...configValues, [id]: formattedValue})
  }

  const InputType = ({
    id,
    type,
  } : {
    id: string,
    type: ConfigKeyType,
  }) => {
    return (
      <div key={id} className="InputType">
        <Input
          name={id}
          type={type === 'number' ? 'number' : 'text'}
          // @ts-ignore
          value={configValues?.[id] || ''}
          // @ts-ignore
          label={configKeysT[id] || id}
          // @ts-ignore
          placeholder={configKeysT[id]}
          onChange={(value) => handleChangeValue(id, value as ConfigKeyType)}
          fixedLabel
        />
      </div>
    )
  }

  const DateTimeType = ({
    id,
  } : {
    id: string,
  }) => {
    return (
      <div key={id} className="DateTimeType">
        <DateTimePicker
          // @ts-ignore
          date={configValues?.[id] && new Date(configValues?.[id])}
          // @ts-ignore
          label={configKeysT[id] || id}
          onChange={(value: any) => handleChangeValue(id, value)}
        />
      </div>
    )
  }

  const types = {
    string: InputType,
    number: InputType,
    dateTime: DateTimeType,
  }

  return (
    <div className="ActionConfig">
      {configKeys.map(configKey => {
        const Component = types[configKey.type] || InputType;

        return Component({ ...configKey });
      })}
    </div>
  );
};

export default ActionConfig;

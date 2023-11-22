type ConfigKeyType = 'string' | 'number' | 'dateTime';

interface ConfigKey {
  id: string;
  type: ConfigKeyType;
  optional?: boolean;
  maxLength?: number;
}

interface Action {
  id: number;
  key: string;
  name: string;
  description: string | null;
  service_id: number;
  config_keys: ConfigKey[];
  usable: boolean;
  created_at: string;
  updated_at: string;
}

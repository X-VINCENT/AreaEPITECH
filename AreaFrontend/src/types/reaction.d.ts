interface Reaction {
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

interface ActionReactionConfig {
  [key: string]: ConfigKeyType;
}

interface Area {
  id: number;
  user_id: number;
  name: string;
  description: string | null;
  active: boolean;
  action_id: number;
  reaction_id: number;
  action_config: ActionReactionConfig[];
  reaction_config: ActionReactionConfig[];
  refresh_delay: number;
  created_at?: string;
  updated_at?: string;
}

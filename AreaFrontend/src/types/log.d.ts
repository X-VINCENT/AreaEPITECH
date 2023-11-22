interface Log {
  id: number;
  area_id: number;
  status: 'pending' | 'success' | 'error';
  created_at?: string;
  updated_at?: string;
}

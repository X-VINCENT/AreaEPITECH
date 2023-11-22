export interface User {
  id: number;
  name: string;
  email: string;
  roles: string;
  [key: string]: string;
  created_at: string;
  updated_at: string;
}

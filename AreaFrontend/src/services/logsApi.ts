import { api, AuthCallResponse } from './api';

export interface GetAreasResponse extends AuthCallResponse {
  data: Log[];
}

export const logsApi = {
  getAll: async (): Promise<GetAreasResponse> => {
    return api.authCall('areas/logs');
  },
}

import { api, AuthCallResponse } from './api';

export interface GetAreasResponse extends AuthCallResponse {
  data: Area[];
}

export interface CreateAreaResponse extends AuthCallResponse {
  data: Area;
}

export interface UpdateAreaResponse extends AuthCallResponse {
  data: Area;
}

export const areasApi = {
  getAll: async (): Promise<GetAreasResponse> => {
    return api.authCall('areas');
  },

  create: async (area: Area): Promise<CreateAreaResponse> => {
    return api.authCall(`areas`, { method: 'POST', body: JSON.stringify(area)})
  },

  update: async (id: number, area: Area): Promise<UpdateAreaResponse> => {
    return api.authCall(`areas/${id}`, { method: 'PUT', body: JSON.stringify(area)})
  },

  delete: async (id: number): Promise<AuthCallResponse> => {
    return api.authCall(`areas/${id}`, { method: 'DELETE' });
  },

  executeAction: async (id: number): Promise<AuthCallResponse> => {
    return api.authCall(`areas/${id}/execute`, { method: 'GET' });
  }
}

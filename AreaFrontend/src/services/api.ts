import {API_URL, TOKEN_LOCALSTORAGE_KEY} from '../providers/auth.tsx';

export interface AuthCallInit {
  method?: 'GET' | 'POST' | 'PUT' | 'DELETE';
  body?: string;
  headers?: Headers;
}

export interface AuthCallResponse {
  success: "0" | "1";
  data: any;
  message: string;
}

export interface GetServicesResponse extends AuthCallResponse {
  data: Service[];
}

export interface GetAreasResponse extends AuthCallResponse {
  data: Area[];
}

export interface GetActionsResponse extends AuthCallResponse {
  data: Action[];
}

export interface GetReactionsResponse extends AuthCallResponse {
  data: Reaction[];
}

export const api = {
  authCall: async (url: string, init?: AuthCallInit):  Promise<AuthCallResponse> => {
    const accessToken = localStorage.getItem(TOKEN_LOCALSTORAGE_KEY);

    const localInit = init ? {...init} : {};

    const myHeaders = localInit.headers || new Headers();
    if (!myHeaders.get('Accept')) {
      myHeaders.append('Accept', 'application/json');
    }
    myHeaders.append('Content-Type', 'application/json');
    if (accessToken)
      myHeaders.append('Authorization', `Bearer ${accessToken}`);
    localInit.headers = myHeaders;

    const res = await fetch(`${API_URL}/${url}`, localInit);

    if (res.ok) {
      try {
        return res.json();
      } catch (e) {
        console.error(url, e)
        return Promise.reject(e);
      }
    }

    const errResponse = {
      ok: res.ok,
      status: res.status,
      statusText: res.statusText,
      body: null,
    }
    try {
      const body = await res.text();
      if (body)
        errResponse.body = JSON.parse(body);
    } catch (e) {
      console.error(url, e)
    }

    return Promise.reject(errResponse);
  },

  getServices: async (): Promise<GetServicesResponse> => {
    return api.authCall('services');
  },

  getActions: async (): Promise<GetActionsResponse> => {
    return api.authCall('actions');
  },

  getReactions: async (): Promise<GetReactionsResponse> => {
    return api.authCall('reactions');
  },
}

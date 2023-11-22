import React, { createContext, useState, useEffect, PropsWithChildren } from 'react';
import {User} from "../types/user";
import {api} from "../services/api.ts";

export const API_URL = 'http://localhost:8000/api';
export const TOKEN_LOCALSTORAGE_KEY = 'access_token';
export const USER_LOCALSTORAGE_KEY = 'user';

interface AuthContextProps {
  user: User | null;
  loading: boolean;
  register: (name: string, email: string, password: string, c_password: string) => Promise<void>;
  logIn: (email: string, password: string) => Promise<void>;
  logOut: () => void;
  oAuthLoginLink: (service: string) => Promise<any>;
  oAuthLoginCallback: (service: string, searchParams: string) => Promise<void>;
  disconnectOAuth: (service: string) => Promise<void>;
}

export const AuthContext = createContext<AuthContextProps>({
  user: null,
  loading: true,
  register: async () => undefined,
  logIn: async () => undefined,
  logOut: () => undefined,
  oAuthLoginLink: async () => undefined,
  oAuthLoginCallback: async () => undefined,
  disconnectOAuth: async () => undefined,
});

const AuthProvider: React.FC<PropsWithChildren> = ({ children }) => {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState<boolean>(true);

  const register: AuthContextProps['register'] = async (
    name,
    email,
    password,
    c_password,
  ) => {
    const body = JSON.stringify({
      name,
      email,
      password,
      c_password,
    });

    const res = await api.authCall('register', {
      method: 'POST',
      body,
    });

    fillUserAndTokenWithData(res.data);
  };

  const logIn: AuthContextProps['logIn'] = async (email, password) => {
    const body = JSON.stringify({
      email,
      password,
    });

    const res = await api.authCall('login', {
      method: 'POST',
      body,
    });

    fillUserAndTokenWithData(res.data);
  };

  const logOut: AuthContextProps['logOut'] = () => {
    setUser(null);
    localStorage.removeItem(TOKEN_LOCALSTORAGE_KEY);
    localStorage.removeItem(USER_LOCALSTORAGE_KEY);
  };

  const oAuthLoginLink: AuthContextProps['oAuthLoginLink'] = async (
    service,
  ) => {
    return api.authCall(`auth/${service}`);
  }

  const oAuthLoginCallback: AuthContextProps['oAuthLoginCallback'] = async (
    service,
    searchParams,
  ) => {
    const res = await api.authCall(`auth/${service}/callback${searchParams}`);

    fillUserAndTokenWithData(res.data);
  }

  const fillUserAndTokenWithData = (data: any) => {
    if (!data?.user || !data?.token)
      throw new Error('Invalid data received');
    setUser(data.user);
    localStorage.setItem(TOKEN_LOCALSTORAGE_KEY, data.token);
    localStorage.setItem(USER_LOCALSTORAGE_KEY, JSON.stringify(data.user));
  }

  const disconnectOAuth: AuthContextProps['disconnectOAuth'] = async (
    service,
  ) => {
    if (!user)
      throw new Error('User not found');

    const res = await api.authCall(`auth/${service}/disconnect`);

    if (!res?.data?.user)
      throw new Error('Invalid data received');

    setUser(res?.data?.user);
    localStorage.setItem(USER_LOCALSTORAGE_KEY, JSON.stringify(res?.data?.user));
  }

  const autoLogin = async () => {
    setLoading(true);

    const accessToken = localStorage.getItem(TOKEN_LOCALSTORAGE_KEY);
    const user = localStorage.getItem(USER_LOCALSTORAGE_KEY);

    if (accessToken && user)
      setUser(JSON.parse(user));

    setLoading(false);
  };

  useEffect(() => {
    //logOut();
    autoLogin()
      .catch(e => console.error(e));
  }, []);

  const authContextValue: AuthContextProps = {
    user,
    loading,
    register,
    logIn,
    logOut,
    oAuthLoginLink,
    oAuthLoginCallback,
    disconnectOAuth,
  };

  return (
    <AuthContext.Provider value={authContextValue}>
      {children}
    </AuthContext.Provider>
  );
};

export default AuthProvider;

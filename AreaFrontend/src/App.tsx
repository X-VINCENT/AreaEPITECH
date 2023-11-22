import React, {Fragment, useContext} from "react";
import './App.scss';
import "./translations/i18n";
import {ToastContainer} from "react-toastify";
import {Route, Routes, BrowserRouter, Navigate} from "react-router-dom";
import {AuthContext} from "./providers/auth.tsx";
import {
  AccountPage,
  AreasPage,
  HomePage,
  LoadingPage,
  LoginPage,
  LogsPage,
  OAuthPage,
  RegisterPage,
  WelcomePage
} from "./pages";
import {Navbar} from "./components";
import {ThemeContext} from "./providers/theme.tsx";

interface AppProps {
}

export interface RouteType {
  title?: string;
  path: string;
  element: React.ReactNode;
  auth?: boolean;
  oAuth?: boolean;
  navbar?: boolean;
}

const App: React.FC<AppProps> = () => {
  const {theme} = useContext(ThemeContext);
  const {user, loading} = useContext(AuthContext);

  const routes: RouteType[] = [
    { title: 'Welcome', path: '/welcome', element: <WelcomePage /> },
    { title: 'Login', path: '/login', element: <LoginPage /> },
    { title: 'Register', path: "/register", element: <RegisterPage /> },
    { title: 'OAuth2 Services', path: "/oauth/:service", element: <OAuthPage />, oAuth: true },
    { title: 'Home', path: '/', element: <HomePage />, auth: true, navbar: true },
    { title: 'Areas', path: '/areas', element: <AreasPage />, auth: true, navbar: true },
    { title: 'Logs', path: '/logs', element: <LogsPage />, auth: true, navbar: true },
    { title: 'Account' , path: '/account', element: <AccountPage />, auth: true, navbar: true},
    { path: "*", element: <Navigate to="/" /> },
  ];

  return (
    <div className={`App ${theme}`}>
      <ToastContainer />
      <BrowserRouter>
        <Routes>
          {routes.map((route, index) => (
            <Route
              key={index}
              path={route.path}
              element={
                loading
                  ? <LoadingPage />
                  : route.auth
                    ? !user
                      ? <Navigate to="/welcome" />
                      : <RenderRoute route={route} />
                    : user && !route.oAuth
                      ? <Navigate to="/" />
                      : <RenderRoute route={route} />
              }
            />
          ))}
        </Routes>
      </BrowserRouter>
    </div>
  )
}

const RenderRoute: React.FC<{route: RouteType}> = ({route}) => {
  return (
    <Fragment>
      {route.navbar && <Navbar />}
      {route.element}
    </Fragment>
  );
}

export default App;

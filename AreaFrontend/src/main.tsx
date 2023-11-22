import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App.tsx'
import "react-datepicker/dist/react-datepicker.css";
import 'react-tabulator/lib/styles.css';
import 'react-tabulator/css/semantic-ui/tabulator_semantic-ui.min.css';
import './index.scss'
import AuthProvider from './providers/auth.tsx';
import ThemeProvider from "./providers/theme.tsx";

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <ThemeProvider>
      <AuthProvider>
        <App />
      </AuthProvider>
    </ThemeProvider>
  </React.StrictMode>,
)

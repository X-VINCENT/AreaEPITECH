import React, {useState, useEffect, PropsWithChildren, createContext} from 'react';

const THEME_LOCALSTORAGE_KEY = 'theme';

type ThemeType = "light" | "dark";

interface ThemeContextProps {
  theme: ThemeType;
  updateTheme: (theme: ThemeType) => void;
}

export const ThemeContext = createContext<ThemeContextProps>({
  theme: 'light',
  updateTheme: () => {},
});

const ThemeProvider: React.FC<PropsWithChildren> = ({ children }) => {
  const [theme, setTheme] = useState<ThemeType>('light');

  const updateTheme = async (theme: ThemeType) => {
    localStorage.setItem(THEME_LOCALSTORAGE_KEY, theme);
    setTheme(theme);
  }

  const getTheme = () => {
    const theme = localStorage.getItem(THEME_LOCALSTORAGE_KEY);
    if (!theme)
      return;
    setTheme(theme as ThemeType);
  }

  useEffect(() => {
    getTheme();
  }, []);

  const themeContextValue: ThemeContextProps = {
    theme,
    updateTheme,
  };

  return (
    <ThemeContext.Provider value={themeContextValue}>
      {children}
    </ThemeContext.Provider>
  );
};

export default ThemeProvider;

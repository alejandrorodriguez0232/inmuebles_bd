import React from 'react';
import PropertyForm from './components/PropertyForm';
import { CssBaseline, ThemeProvider, createTheme } from '@mui/material';

const theme = createTheme({
  palette: {
    primary: {
      main: '#1976d2',
    },
    secondary: {
      main: '#dc004e',
    },
  },
});

function App() {
  const handleSubmit = (formData) => {
    console.log('Datos del formulario:', formData);
    // Aquí podrías enviar los datos a tu API
  };

  return (
    <ThemeProvider theme={theme}>
      <CssBaseline />
      <div className="App">
        <PropertyForm onSubmit={handleSubmit} />
      </div>
    </ThemeProvider>
  );
}

export default App;
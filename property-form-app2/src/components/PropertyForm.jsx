import React, { useState } from 'react';
import { 
  Box,
  Button,
  Container,
  FormControl,
  InputLabel,
  MenuItem,
  Select,
  TextField,
  Typography,
  Paper,
  Grid
} from '@mui/material';

function PropertyForm({ onSubmit }) {
  const [formData, setFormData] = useState({
    propertyType: 'Casa',
    title: '',
    description: '',
    price: '',
    bedrooms: 1,
    bathrooms: 1,
    area: '',
    address: '',
    internetType: 'No Disponible',
    hasParking: false
  });

  const propertyTypes = ['Casa', 'Apartamento', 'Terreno', 'Local Comercial'];
  const internetOptions = ['Fibra Óptica', '4G LTE', 'ADSL', 'No Disponible'];

  const handleChange = (e) => {
    const { name, value, type, checked } = e.target;
    setFormData({
      ...formData,
      [name]: type === 'checkbox' ? checked : value
    });
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    onSubmit(formData);
    alert('Formulario enviado: ' + JSON.stringify(formData, null, 2));
  };

  return (
    <Container maxWidth="md" sx={{ mt: 4, mb: 4 }}>
      <Paper elevation={3} sx={{ p: 4 }}>
        <Typography variant="h4" component="h1" gutterBottom align="center">
          Publicar Nuevo Inmueble
        </Typography>
        
        <Box component="form" onSubmit={handleSubmit} sx={{ mt: 3 }}>
          <Grid container spacing={3}>
            {/* Tipo de propiedad */}
            <Grid item xs={12} sm={6}>
              <FormControl fullWidth>
                <InputLabel>Tipo de Propiedad</InputLabel>
                <Select
                  name="propertyType"
                  value={formData.propertyType}
                  onChange={handleChange}
                  label="Tipo de Propiedad"
                  required
                >
                  {propertyTypes.map(type => (
                    <MenuItem key={type} value={type}>{type}</MenuItem>
                  ))}
                </Select>
              </FormControl>
            </Grid>
            
            {/* Título */}
            <Grid item xs={12} sm={6}>
              <TextField
                name="title"
                label="Título"
                value={formData.title}
                onChange={handleChange}
                fullWidth
                required
              />
            </Grid>
            
            {/* Descripción */}
            <Grid item xs={12}>
              <TextField
                name="description"
                label="Descripción"
                value={formData.description}
                onChange={handleChange}
                fullWidth
                multiline
                rows={4}
                required
              />
            </Grid>
            
            {/* Precio */}
            <Grid item xs={12} sm={4}>
              <TextField
                name="price"
                label="Precio ($)"
                type="number"
                value={formData.price}
                onChange={handleChange}
                fullWidth
                required
              />
            </Grid>
            
            {/* Habitaciones */}
            <Grid item xs={12} sm={4}>
              <TextField
                name="bedrooms"
                label="Habitaciones"
                type="number"
                value={formData.bedrooms}
                onChange={handleChange}
                fullWidth
                required
                inputProps={{ min: 1 }}
              />
            </Grid>
            
            {/* Baños */}
            <Grid item xs={12} sm={4}>
              <TextField
                name="bathrooms"
                label="Baños"
                type="number"
                value={formData.bathrooms}
                onChange={handleChange}
                fullWidth
                required
                inputProps={{ min: 1 }}
              />
            </Grid>
            
            {/* Área */}
            <Grid item xs={12} sm={6}>
              <TextField
                name="area"
                label="Área (m²)"
                type="number"
                value={formData.area}
                onChange={handleChange}
                fullWidth
                required
              />
            </Grid>
            
            {/* Dirección */}
            <Grid item xs={12} sm={6}>
              <TextField
                name="address"
                label="Dirección"
                value={formData.address}
                onChange={handleChange}
                fullWidth
                required
              />
            </Grid>
            
            {/* Tipo de Internet */}
            {/* Ejemplo de campo nuevo*/}
            <Grid item xs={12} sm={6}>
              <FormControl fullWidth>
                <InputLabel>Tipo de conexión a Internet</InputLabel>
                <Select
                  name="internetType"
                  value={formData.internetType}
                  onChange={handleChange}
                  label="Tipo de conexión a Internet"
                  required
                >
                  {internetOptions.map(option => (
                    <MenuItem key={option} value={option}>{option}</MenuItem>
                  ))}
                </Select>
              </FormControl>
            </Grid>
            
            {/* Estacionamiento */}
            <Grid item xs={12} sm={6} sx={{ display: 'flex', alignItems: 'center' }}>
              <FormControl fullWidth>
                <InputLabel>Estacionamiento</InputLabel>
                <Select
                  name="hasParking"
                  value={formData.hasParking ? 'Sí' : 'No'}
                  onChange={(e) => setFormData({...formData, hasParking: e.target.value === 'Sí'})}
                  label="Estacionamiento"
                >
                  <MenuItem value="Sí">Sí</MenuItem>
                  <MenuItem value="No">No</MenuItem>
                </Select>
              </FormControl>
            </Grid>
            
            {/* Botón de enviar */}
            <Grid item xs={12}>
              <Button 
                type="submit" 
                variant="contained" 
                color="primary" 
                fullWidth
                size="large"
                sx={{ mt: 2 }}
              >
                Publicar Inmueble
              </Button>
            </Grid>
          </Grid>
        </Box>
      </Paper>
    </Container>
  );
}

export default PropertyForm;
const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
require('dotenv').config();

// Definición básica del modelo User (simplificado)
const userSchema = new mongoose.Schema({
  email: { type: String, required: true, unique: true },
  name: { type: String, required: true },
  password: { type: String, required: true },
  userType: { type: Number, default: 1 },  // 1 para admin
  projects: { type: Array, default: [] }
});

const User = mongoose.model('User', userSchema);

async function createUser(userData) {
  try {
    // Generar hash de la contraseña
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(userData.password, salt);
    
    // Crear el usuario con la contraseña hasheada
    const user = new User({
      email: userData.email,
      name: userData.name,
      password: hashedPassword,
      userType: userData.userType || 1
    });
    
    // Conectar a la base de datos
    await mongoose.connect(process.env.DB_URL || 'mongodb://localhost:27017/interaction');
    console.log('Conectado a MongoDB');
    
    // Guardar el usuario
    await user.save();
    console.log(`Usuario creado: ${userData.email}`);
    
    // Desconectar
    await mongoose.disconnect();
  } catch (error) {
    console.error('Error al crear usuario:', error);
  }
}

// Crear un usuario administrador
createUser({
  email: 'admin@example.com',
  name: 'Admin',
  password: 'password123',
  userType: 1
});
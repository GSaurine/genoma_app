const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const userRepository = require('../repositories/utilizadores.repository');

exports.register = async (data) => {
    const hashedPassword = await bcrypt.hash(data.password, 10);

    // Normaliza campos do Flutter para o backend
    const nome = data.nome || data.name;
    const perfil_id = data.perfil_id; 

    return await userRepository.create({
        nome,
        email: data.email,
        perfil_id,
        password_hash: hashedPassword
    });
};

exports.login = async ({ email, password }) => {
    const user = await userRepository.findByEmail(email);

    if (!user) throw new Error('Utilizador não encontrado');

    console.log('DEBUG Login:', { email, passwordLength: password?.length, hashLength: user.password_hash?.length, hashType: typeof user.password_hash });

    const validPassword = await bcrypt.compare(password, user.password_hash);

    if (!validPassword) throw new Error('Password inválida');

    const token = jwt.sign(
        {
            id: user.id,
            role: user.perfil_nome || 'user'
        },
        process.env.JWT_SECRET,
        { expiresIn: '8h' }
    );

    return token;
};

exports.getUserById = async (id) => {
    return await userRepository.findById(id);
};
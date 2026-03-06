const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const userRepository = require('../repositories/utilizadores.repository');

exports.register = async (data) => {
    const hashedPassword = await bcrypt.hash(data.password, 10);

    return await userRepository.create({
        ...data,
        password_hash: hashedPassword
    });
};

exports.login = async ({ email, password }) => {
    const user = await userRepository.findByEmail(email);

    if (!user) throw new Error('Utilizador não encontrado');

    const validPassword = await bcrypt.compare(password, user.password_hash);

    if (!validPassword) throw new Error('Password inválida');

    const token = jwt.sign(
        {
            id: user.id,
            role: user.perfil_id
        },
        process.env.JWT_SECRET,
        { expiresIn: '8h' }
    );

    return token;
};
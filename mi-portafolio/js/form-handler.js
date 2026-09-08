document.addEventListener('DOMContentLoaded', () => {
    const formulario = document.querySelector('#formulario-contacto');
    if (!formulario) return;

    const campoNombre = document.querySelector('#nombre');
    const campoCorreo = document.querySelector('#correo');
    const campoMensaje = document.querySelector('#mensaje');
    const mensajeEnvio = document.querySelector('#mensaje-envio');

    const regexCorreo = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

    function mostrarError(campo, texto) {
        const contenedorError = campo.parentElement.querySelector('.campo__error');
        if (contenedorError) contenedorError.textContent = texto;
    }

    function limpiarError(campo) {
        mostrarError(campo, '');
    }

    function validarCampo(campo) {
        if (campo === campoNombre) {
            if (campo.value.trim().length < 2) {
                mostrarError(campo, 'Ingresa tu nombre.');
                return false;
            }
        }

        if (campo === campoCorreo) {
            if (!regexCorreo.test(campo.value.trim())) {
                mostrarError(campo, 'Ingresa un correo válido.');
                return false;
            }
        }

        if (campo === campoMensaje) {
            if (campo.value.trim().length < 10) {
                mostrarError(campo, 'El mensaje debe tener al menos 10 caracteres.');
                return false;
            }
        }

        limpiarError(campo);
        return true;
    }

    [campoNombre, campoCorreo, campoMensaje].forEach((campo) => {
        campo.addEventListener('blur', () => validarCampo(campo));
        campo.addEventListener('input', () => limpiarError(campo));
    });

    formulario.addEventListener('submit', (evento) => {
        evento.preventDefault();

        const nombreValido = validarCampo(campoNombre);
        const correoValido = validarCampo(campoCorreo);
        const mensajeValido = validarCampo(campoMensaje);

        if (!nombreValido || !correoValido || !mensajeValido) {
            return;
        }

        mensajeEnvio.textContent = `Gracias, ${campoNombre.value.trim()}. Tu mensaje quedó registrado (envío simulado).`;
        mensajeEnvio.classList.add('visible', 'exito');
        formulario.reset();

        setTimeout(() => {
            mensajeEnvio.classList.remove('visible', 'exito');
        }, 5000);
    });
});
